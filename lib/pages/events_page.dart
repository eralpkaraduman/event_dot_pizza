import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';
import '../pages/settings_page.dart';
import '../widgets/event_list_item.dart';
import '../providers/events.dart';
import '../models/location.dart';

class EventsPage extends StatefulWidget {
  static const routeName = "events";
  @override
  _EventsPageState createState() => _EventsPageState();
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

  @override
  Widget build(BuildContext context) {
    print('EventsPage:Build');
    final EdgeInsets safePadding = MediaQuery.of(context).padding;
    final eventsProvider = Provider.of<Events>(context);
    final events = _selectedIndex == 0
        ? eventsProvider.events
        : eventsProvider.todayEvents;

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
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          Location location = await eventsProvider.refresh();
          setState(() => _lastLoadedLocation = location);
        },
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(0, 10.0, 0, safePadding.bottom),
          itemCount: events.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, index) => EventListItem(
            event: events[index],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
