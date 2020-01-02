import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/settings_page.dart';
import '../widgets/event_list_item.dart';
import '../widgets/event_list_overlay.dart';
import '../providers/events.dart';
import '../providers/session.dart';
import './welcome_page.dart';
import '../main.dart' show App;

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

class _EventsPageState extends State<EventsPage> with WidgetsBindingObserver {
  final _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  int _selectedTabIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _afterInitState());
    super.initState();
  }

  void _afterInitState() {
    Provider.of<Session>(context).addListener(() {
      if (Provider.of<Session>(context).shouldShowOnboarding) {
        if (!App.navigationStack.containsNamedRoute(WelcomePage.routeName)) {
          Navigator.of(context).pushNamed(WelcomePage.routeName);
        }
      }
    });
    _refreshIfNeeded();
  }

  void _afterBuild() {
    _refreshIfNeeded();
  }

  void _refreshIfNeeded() {
    if (Provider.of<Events>(context, listen: false).needsRefresh) {
      _refreshIndicatorKey?.currentState?.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _afterBuild());
    final eventsProvider = Provider.of<Events>(context);
    final eventLists = [eventsProvider.events, eventsProvider.todayEvents];
    final ready = Provider.of<Session>(context, listen: false).ready;
    final numberOfEvents = eventLists[_selectedTabIndex].length;
    final bool shouldShowNoEventsOverlay =
        !eventsProvider.needsRefresh && numberOfEvents == 0;
    final EdgeInsets safePadding = MediaQuery.of(context).padding;
    final listEdgeInsets = EdgeInsets.fromLTRB(0, 10.0, 0, safePadding.bottom);
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
        onRefresh: () async => eventsProvider.refreshEvents(),
        child: Stack(
          children: <Widget>[
            if (!ready) ...[
              EventListOverlay(
                icon: Icons.info_outline,
                title: 'Something Is Missing',
                message: 'Seems like you haven\'t completed the setup.',
                buttonTitle: 'Complete Setup',
                onButtonPressed: () => Navigator.of(context).pushNamed(
                  WelcomePage.routeName,
                ),
              ),
            ] else ...[
              if (shouldShowNoEventsOverlay) ...[
                EventListOverlay(
                  icon: Icons.calendar_today,
                  title: 'No Events Found 😢',
                  message: noEventsOverlayMessages[_selectedTabIndex],
                ),
              ],
              IndexedStack(
                index: _selectedTabIndex,
                sizing: StackFit.expand,
                children: eventLists
                    .map(
                      (eventList) => Scrollbar(
                        child: ListView.separated(
                          padding: listEdgeInsets,
                          itemCount: eventList.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, index) =>
                              EventListItem(event: eventList[index]),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ]
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
