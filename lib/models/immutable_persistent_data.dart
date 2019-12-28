import '../models/location.dart';
import './persistent_data.dart';

class ImmutablePersistentData {
  ImmutablePersistentData(
    this._themeBrightnessIndex,
    this._location,
    this._eventbriteAccessToken,
    this._meetupAccessToken,
  );

  String _meetupAccessToken;
  String get meetupAccessToken => _meetupAccessToken;

  String _eventbriteAccessToken;
  String get eventbriteAccessToken => _eventbriteAccessToken;

  Location _location;
  Location get location => _location;

  int _themeBrightnessIndex;
  int get themeBrightnessIndex => _themeBrightnessIndex;

  bool expired = false;

  static Future<ImmutablePersistentData> loadFromPrefs() async {
    return ImmutablePersistentData(
      await PersistentData.getThemeBrightnessIndex(),
      await PersistentData.getLocation(),
      await PersistentData.getEventbriteAccessToken(),
      await PersistentData.getMeetupAccessToken(),
    );
  }
}
