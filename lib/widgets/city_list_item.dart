import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/location.dart';
import '../providers/session.dart';

typedef void TapCallback(Location location);

class CityListItem extends StatelessWidget {
  const CityListItem({Key key, @required this.location, @required this.onTap})
      : super(key: key);

  final TapCallback onTap;
  final Location location;

  @override
  Widget build(BuildContext context) {
    Session session = Provider.of<Session>(context, listen: false);
    bool selected = location.equalsTo(session.location);
    return ListTile(
      title: Text(location.city),
      subtitle: Text(location.country),
      onTap: () => onTap(location),
      selected: selected,
      trailing: selected ? Icon(Icons.pin_drop) : null,
    );
  }
}
