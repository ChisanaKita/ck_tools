import 'package:ck_console/ck_console.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CachedPreference {
  static final CachedPreference _instance = CachedPreference._internal();

  late SharedPreferences _sharedPreferences;

  factory CachedPreference() {
    return _instance;
  }

  CachedPreference._internal();

  static CachedPreference instance() {
    return _instance;
  }

  Future<bool> initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return Future.value(true);
  }

  Future<void> initKeysData() {
    String keyString = "User keys print-out: \n";

    for (var element in UserPrefKeys.values) {
      if (!CachedPreference().checkPrefs(element)) {
        CachedPreference().setPrefs(
          key: element,
          value: _generateKeyDefaultValue(element),
        );
      }
      keyString += "${element.name}|${element.type} \n";
    }

    CkConsole.log(runtimeType, keyString);

    return Future(() => null);
  }

  dynamic _generateKeyDefaultValue(UserPrefKeys key) {
    if (key.type == int) {
      return -1;
    }
    if (key.type == double) {
      return -1.0;
    }
    if (key.type == bool) {
      return false;
    }
    if (key.type == String) {
      return "";
    }
    if (key.type == DateTime) {
      return DateTime.now();
    }
    if (key.type == List<String>) {
      return [];
    }
    throw Exception('Unsupported type (${key.type})');
  }

  SharedPreferences get sharedPreference => _sharedPreferences;

  void setPrefs({required UserPrefKeys key, required dynamic value}) {
    CkConsole.log(runtimeType, "Saving Pref: ${key.name} with value: $value (${value.runtimeType})");
    switch (key.type) {
      case const (int):
        _sharedPreferences.setInt(key.name, value);
        break;
      case const (double):
        _sharedPreferences.setDouble(key.name, value);
        break;
      case const (bool):
        _sharedPreferences.setBool(key.name, value);
        break;
      case const (String):
        _sharedPreferences.setString(key.name, value);
        break;
      case const (DateTime):
        _sharedPreferences.setString(key.name, DateFormat("yyyy-MM-ddTHH:mm:ss").format(value));
        break;
      case const (List<String>):
        //  If value is default value:
        if ((value is List)) {
          if (value.isEmpty) {
            _sharedPreferences.setStringList(key.name, []);
          } else {
            if (value is List<String>) {
              _sharedPreferences.setStringList(key.name, value);
            } else {
              throw UnsupportedError("Type: ${value.runtimeType} is not supported");
            }
          }
        } else {
          List<String> temp = getPrefs(key)!;
          temp.add(value);
          _sharedPreferences.setStringList(key.name, temp);
        }
        break;
      default:
        throw Exception('Unsupported type for setting key value (${value.runtimeType})');
    }
  }

  dynamic getPrefs(UserPrefKeys key) {
    if (!_sharedPreferences.containsKey(key.name)) {
      throw Exception('No such key named: ${key.name} was found.');
    }
    switch (key.type) {
      case const (int):
        return _sharedPreferences.getInt(key.name)!;
      case const (double):
        return _sharedPreferences.getDouble(key.name)!;
      case const (bool):
        return _sharedPreferences.getBool(key.name)!;
      case const (String):
        return _sharedPreferences.getString(key.name)!;
      case DateTime _:
        return DateTime.parse(_sharedPreferences.getString(key.name)!);
      case const (List<String>):
        return _sharedPreferences.getStringList(key.name)!;
      default:
        throw Exception('Unsupported type for getting key: ${key.name} with type: (${key.type.runtimeType})');
    }
  }

  bool checkPrefs(UserPrefKeys key) {
    return _sharedPreferences.containsKey(key.name);
  }

  void resetUserPref(UserPrefKeys key) {
    CachedPreference().setPrefs(
      key: key,
      value: _generateKeyDefaultValue(key),
    );
  }

  void clearUserPrefs() {
    _sharedPreferences.clear();
  }
}

enum UserPrefKeys {
  userLoginState("User:LoggedIn", bool),
  userInternalId("User:UserID", int),
  userIsStaff("User:isStaff", bool),
  userLocale("User:UserLocale", String),
  userLastSelectedProductDate("User:lastProductDate", DateTime),
  userLastLoadedProductDate("User:lastLoadedDate", DateTime),
  userUnfinishedOrderID("User:unfinishedOrder", String),
  userCartState("User:cart", String),
  userCachedAccID("Auth:UserID", String),
  userCachedAccPwd("Auth:UserPwd", String),
  userNotification("User:Notification", bool),
  userNotificationHistory("Notification:History", List<String>),
  userLastNotificationID("Notification:LastID", int),
  userLastNotification("Notification:Last", bool),
  userLastNotificationPayload("Notification:Payload", String),
  canUseAppBadger("App:supportBadger", bool),
  appBadgerCount("App:messageCount", int),
  appTutorialState("App:tutorial", bool),
  ;

  const UserPrefKeys(this.name, this.type);

  final String name;
  final Type type;
}
