import 'package:hive/hive.dart';

const String keyAppThemeDark = 'keyAppThemeDark';

class Session {
  Session._();

  static var userBox = Hive.box('userBox');

  /// Getter for Dark Mode
  static bool? getIsAppThemeDark() => (userBox.get(keyAppThemeDark));

  /// Setter for Dark Mode
  static setIsThemeModeDark(bool value) {
    userBox.put(keyAppThemeDark, value);
  }

  /// Generic method to save local data
  static saveLocalData(String key, dynamic value) {
    userBox.put(key, value);
  }
}
