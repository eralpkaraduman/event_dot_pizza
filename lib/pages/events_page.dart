import 'package:event_dot_pizza/models/event.dart';
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

const List<BottomNavigationBarItem> bottomNavigationBarItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.watch_later),
    title: Text('Anytime'),
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.calendar_today),
    title: Text('Today'),
  ),
];

final Widget emptyListView = Container(
  decoration: BoxDecoration(color: Colors.white),
  child: Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.calendar_today, size: 100, color: Colors.grey),
      Text(
        'No events',
        textDirection: TextDirection.ltr,
        style: TextStyle(
          fontSize: 32,
          color: Colors.grey,
        ),
      ),
      Text('No events were found!', style: TextStyle(color: Colors.grey)),
    ]),
  ),
);

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

  Widget listSeperatorBuilder(_, __) => const Divider(height: 1);

  Widget renderList(List<Event> list) {
    final EdgeInsets safePadding = MediaQuery.of(context).padding;
    final listEdgeInsets = EdgeInsets.fromLTRB(0, 10.0, 0, safePadding.bottom);

    if (list.length > 0) {
      return Scrollbar(
        child: ListView.separated(
          padding: listEdgeInsets,
          itemCount: list.length,
          separatorBuilder: listSeperatorBuilder,
          itemBuilder: (_, index) => EventListItem(event: list[index]),
        ),
      );
    }

    return emptyListView;
  }

  @override
  Widget build(BuildContext context) {
    print('EventsPage:Build');
    final eventsProvider = Provider.of<Events>(context);
    final eventLists = [eventsProvider.events, eventsProvider.todayEvents];

    if (_lastLoadedLocation != null) {
      if (eventsProvider.location.equalsTo(_lastLoadedLocation) == false) {
        print('EventsPage:CityChangeDetected');
        _triggerRefresh();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Event.Pizza 🍕'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(
              context,
              SettingsPage.routeName,
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          Location location = await eventsProvider.refresh();
          setState(() => _lastLoadedLocation = location);
        },
        child: IndexedStack(
          index: _selectedIndex,
          sizing: StackFit.expand,
          children: eventLists.map(renderList).toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavigationBarItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).accentColor,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
