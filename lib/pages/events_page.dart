import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';
import '../pages/settings_page.dart';
import '../widgets/event_list_item.dart';
import '../widgets/no_events_overlay.dart';
import '../providers/meetup_platform_session.dart';
import '../providers/eventbrite_platform_session.dart';
import '../providers/session.dart';
import '../providers/events.dart';
import '../models/event.dart';
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

const noEventsOverlayMessages = [
  'No free pizza for you anytime soon!',
  'No free pizza for you today!'
];

class _EventsPageState extends State<EventsPage> {
  final _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  int _selectedTabIndex = 0;

  void _triggerRefresh() => SchedulerBinding.instance
      .addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());

  Widget listSeperatorBuilder(_, __) => const Divider(height: 1);

  Widget renderList(List<Event> list) {
    final EdgeInsets safePadding = MediaQuery.of(context).padding;
    final listEdgeInsets = EdgeInsets.fromLTRB(0, 10.0, 0, safePadding.bottom);

    return Scrollbar(
      child: ListView.separated(
        padding: listEdgeInsets,
        itemCount: list.length,
        separatorBuilder: listSeperatorBuilder,
        itemBuilder: (_, index) => EventListItem(event: list[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('EventsPage:Build');
    final location = Provider.of<Session>(context).location;
    final eventsProvider = Provider.of<Events>(context);
    final eventLists = [eventsProvider.events, eventsProvider.todayEvents];
    final notRefreshing = !eventsProvider.refreshing;
    final numberOfEvents = eventLists[_selectedTabIndex].length;

    _triggerRefresh();

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
          await Provider.of<MeetupPlatformSession>(context)
              .refreshEvents(location);
          await Provider.of<EventbritePlatformSession>(context)
              .refreshEvents(location);
        },
        child: Stack(
          children: <Widget>[
            Visibility(
              visible: notRefreshing && numberOfEvents == 0,
              child: NoEventsOverlay(
                message: noEventsOverlayMessages[_selectedTabIndex],
              ),
            ),
            IndexedStack(
              index: _selectedTabIndex,
              sizing: StackFit.expand,
              children: eventLists.map(renderList).toList(),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavigationBarItems,
        currentIndex: _selectedTabIndex,
        selectedItemColor: Theme.of(context).accentColor,
        onTap: (index) => setState(() => _selectedTabIndex = index),
      ),
    );
  }
}
