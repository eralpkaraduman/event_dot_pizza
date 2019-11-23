import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../pages/settings_page.dart';
import '../widgets/event_list_item.dart';
import '../providers/events.dart';
import '../models/location.dart';
import '../models/event.dart';

class EventsPage extends StatefulWidget {
  static const routeName = "events";
  @override
  _EventsPageState createState() => _EventsPageState();
}

class EventListWidget extends StatelessWidget {
  final int selectedIndex;
  static const DATE_FORMAT = 'EEE, MMM d';
  EventListWidget(this.selectedIndex);

  List<Event> getEventsByTabIndex(context) {
    final events = Provider.of<Events>(context).events;

    if (this.selectedIndex == 1) {
      return events;
    }

    return events
        .where((event) => event.formattedLocalDateTime
            .contains(DateFormat(DATE_FORMAT).format(DateTime.now())))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets safePadding = MediaQuery.of(context).padding;

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(0, 10.0, 0, safePadding.bottom),
      itemCount: getEventsByTabIndex(context).length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, index) => EventListItem(
        event: getEventsByTabIndex(context)[index],
      ),
    );
  }
}

class _EventsPageState extends State<EventsPage> {
  final _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  Location _lastLoadedLocation;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _triggerRefresh();
  }

  void _triggerRefresh() => SchedulerBinding.instance
      .addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());

  final List<Widget> _eventListViews = [EventListWidget(0), EventListWidget(1)];

  @override
  Widget build(BuildContext context) {
    print('EventsPage:Build');
    final eventsProvider = Provider.of<Events>(context);

    if (_lastLoadedLocation != null) {
      if (eventsProvider.location.equalsTo(_lastLoadedLocation) == false) {
        print('EventsPage:CityChangeDetected');
        _triggerRefresh();
      }
    }

    final BottomNavigationBar bottomNavigationBar = new BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('All'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          title: Text('Today'),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Theme.of(context).accentColor,
      onTap: (index) => setState(() => _selectedIndex = index),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Event.Pizza 🍕'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () =>
                Navigator.pushNamed(context, SettingsPage.routeName),
          )
        ],
      ),
      body: Consumer<Events>(
        builder: (context, eventsProvider, _) => RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            Location location = await eventsProvider.refresh();
            setState(() => _lastLoadedLocation = location);
          },
          child: _eventListViews[_selectedIndex],
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
