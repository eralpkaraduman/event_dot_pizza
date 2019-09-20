import 'package:event_dot_pizza/pages/city_selection_page.dart';
import 'package:event_dot_pizza/pages/connect_platforms_page.dart';
import 'package:flutter/material.dart';

const Map<String, String> _settingRoutes = {
  'Connect Platforms': ConnectPlatformsPage.routeName,
  'Select City': CitySelectionPage.routeName
};

class SettingsPage extends StatelessWidget {
  static const routeName = "settings";

  @override
  Widget build(BuildContext context) {
    print('Settings:Updated');
    final EdgeInsets safePadding = MediaQuery.of(context).padding;
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(0, 10.0, 0, safePadding.bottom),
        itemCount: _settingRoutes.keys.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
        ),
        itemBuilder: (_, index) {
          MapEntry _setting = _settingRoutes.entries.elementAt(index);
          return ListTile(
            title: Text(_setting.key),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => Navigator.of(context).pushNamed(_setting.value),
          );
        },
      ),
    );
  }
}
