import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rxdart/rxdart.dart';
import 'package:provider/provider.dart';
import '../platforms/meetup_platform_api.dart';
import '../models/location.dart';
import '../providers/session.dart';
import '../widgets/city_list_item.dart';

class CitySelectionPage extends StatefulWidget {
  static const routeName = "citySelection";

  @override
  _CitySelectionPageState createState() => _CitySelectionPageState();
}

class _CitySelectionPageState extends State<CitySelectionPage> {
  void handleOnCityInputChanged(String text) {}
  bool _loading = false;
  final cityInputOnChange = new BehaviorSubject<String>();
  List<Location> locations = [];
  final TextEditingController inputController = TextEditingController();

  void updateCityList(String query) async {
    setState(() => _loading = true);
    try {
      List<Location> locs = await MeetupPlatformApi.findLocations(query);
      this.setState(() => locations = locs);
    } catch (e) {
      throw "Failed to update city options";
    }
    setState(() => _loading = false);
  }

  @override
  void initState() {
    cityInputOnChange
        .debounce((_) => TimerStream(true, const Duration(milliseconds: 650)))
        .where((text) => text.trim().length > 1)
        .listen(this.updateCityList);

    super.initState();
  }

  void _onCitySelected(Location location) {
    Provider.of<Session>(context, listen: false).setLocation(location);
    Navigator.pop(context);
  }

  void _clearInput() {
    inputController.clear();
    setState(() => locations = []);
  }

  @override
  Widget build(BuildContext context) {
    print('CitySelectionPage:Build');
    final EdgeInsets safePadding = MediaQuery.of(context).padding;
    final session = Provider.of<Session>(context, listen: false);

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
                child: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                          hintText: 'Type the name of your city'),
                      autofocus: true,
                      controller: inputController,
                      textCapitalization: TextCapitalization.words,
                      autocorrect: false,
                      onChanged: (text) => cityInputOnChange.add(text),
                    ),
                    AnimatedCrossFade(
                      duration: Duration(milliseconds: 600),
                      crossFadeState: _loading
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: Container(
                          width: 40,
                          height: 40,
                          padding: EdgeInsets.all(5),
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          )),
                      secondChild: SizedBox(
                        width: 40,
                        height: 40,
                        child: Visibility(
                          visible: inputController.text.length > 0,
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            color: Theme.of(context).accentColor,
                            icon: Icon(Icons.clear),
                            onPressed: _clearInput,
                          ),
                        ),
                      ),
                    )
                  ],
                )),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(0, 10.0, 0, safePadding.bottom),
                itemCount: renderLocs.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, index) => CityListItem(
                  onTap: _onCitySelected,
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
