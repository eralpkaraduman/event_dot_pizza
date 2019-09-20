import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rxdart/rxdart.dart';
import 'package:provider/provider.dart';
import '../platforms/meetup_platform_api.dart';
import '../models/location.dart';
import '../providers/session.dart';

class CitySelectionPage extends StatefulWidget {
  static const routeName = "citySelection";

  @override
  _CitySelectionPageState createState() => _CitySelectionPageState();
}

class _CitySelectionPageState extends State<CitySelectionPage> {
  void handleOnCityInputChanged(String text) {}
  final cityInputOnChange = new BehaviorSubject<String>();
  List<Location> locations = [];

  void updateCityList(String query) async {
    try {
      List<Location> locs = await MeetupPlatformApi.findLocations(query);
      this.setState(() => locations = locs);
    } catch (e) {
      throw "Failed to update city options";
    }
  }

  @override
  void initState() {
    cityInputOnChange
        .debounce((_) => TimerStream(true, const Duration(milliseconds: 650)))
        .where((text) => text.trim().length > 1)
        .listen(this.updateCityList);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('CitySelectionPage:Build');
    final EdgeInsets safePadding = MediaQuery.of(context).padding;
    Session session = Provider.of<Session>(context, listen: false);

    // Put the selected city at the end of the list if it's not already in the list
    final List<Location> renderLocs = [...locations];
    if (session.location != null &&
        renderLocs.indexWhere((loc) => loc.equalsTo(session.location)) == -1) {
      renderLocs.add(session.location);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your City'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration:
                    InputDecoration(hintText: 'Type the name of your city'),
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                autocorrect: false,
                onChanged: (text) => cityInputOnChange.add(text),
              ),
            ),
            // for (var loc in locations) Text("${loc.city}, ${loc.country}"),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(0, 10.0, 0, safePadding.bottom),
                itemCount: renderLocs.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, index) => CityListItem(
                  location: renderLocs[index],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CityListItem extends StatelessWidget {
  final Location location;
  const CityListItem({Key key, @required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Session session = Provider.of<Session>(context, listen: true);
    bool selected = location.equalsTo(session.location);
    return ListTile(
      title: Text(location.city),
      subtitle: Text(location.country),
      onTap: () => session.location = location,
      selected: selected,
      trailing: selected ? Icon(Icons.pin_drop) : null,
    );
  }
}
