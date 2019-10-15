import 'package:flutter/material.dart';

class SettingItem {
  String name;
  Function onTap;
  Widget subtitle, trailing;

  SettingItem({
    @required this.name,
    @required this.onTap,
    this.subtitle,
    this.trailing,
  });
}
