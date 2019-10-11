import 'package:event_dot_pizza/pages/city_selection_page.dart';
import 'package:event_dot_pizza/pages/connect_platforms_page.dart';
import 'package:event_dot_pizza/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/async_version_text.dart';
import '../models/settingItem.dart';
import '../providers/session.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = "settings";

  @override
  Widget build(BuildContext context) {
    print('Settings:Updated');
    Session session = Provider.of<Session>(context, listen: true);

    final List<SettingItem> settings = [
      SettingItem(
        name: 'Connect Platforms',
        route: ConnectPlatformsPage.routeName,
      ),
      SettingItem(
        name: 'Select City',
        route: CitySelectionPage.routeName,
        subtitle: session.location != null
            ? Text('${session.location.city}, ${session.location.country}')
            : null,
      ),
      SettingItem(
        name: 'About',
        route: AboutPage.routeName,
        subtitle: AsyncVersionText(),
      ),
    ];

    final EdgeInsets safePadding = MediaQuery.of(context).padding;
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(0, 10.0, 0, safePadding.bottom),
        itemCount: settings.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, index) {
          SettingItem setting = settings[index];
          return ListTile(
            title: Text(setting.name),
            subtitle: setting.subtitle != null ? setting.subtitle : null,
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => Navigator.of(context).pushNamed(setting.route),
          );
        },
      ),
    );
  }
}
