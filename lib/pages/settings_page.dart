import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/city_selection_page.dart';
import '../pages/connect_platforms_page.dart';
import '../pages/about_page.dart';
import '../widgets/async_version_text.dart';
import '../models/settingItem.dart';
import '../providers/session.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = "settings";

  @override
  Widget build(BuildContext context) {
    print('Settings:Updated');
    final session = Provider.of<Session>(context);
    bool isDarkThemeOn = session.themeBrightness == Brightness.dark;

    final List<SettingItem> settings = [
      SettingItem(
        name: 'Connect Platforms',
        onTap: () =>
            Navigator.of(context).pushNamed(ConnectPlatformsPage.routeName),
      ),
      SettingItem(
        name: 'Select City',
        onTap: () =>
            Navigator.of(context).pushNamed(CitySelectionPage.routeName),
        subtitle: session.location != null
            ? Text('${session.location.city}, ${session.location.country}')
            : null,
      ),
      SettingItem(
        name: 'About',
        onTap: () => Navigator.of(context).pushNamed(AboutPage.routeName),
        subtitle: AsyncVersionText(),
      ),
      SettingItem(
        name: 'Dark Theme',
        onTap: () => session.setThemeBrightness(
            isDarkThemeOn ? Brightness.light : Brightness.dark),
        trailing: Switch.adaptive(
          activeColor: Theme.of(context).toggleableActiveColor,
          value: isDarkThemeOn,
          onChanged: (dark) => session
              .setThemeBrightness(dark ? Brightness.dark : Brightness.light),
        ),
      )
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
            trailing: setting.trailing ?? Icon(Icons.keyboard_arrow_right),
            onTap: setting.onTap,
          );
        },
      ),
    );
  }
}
