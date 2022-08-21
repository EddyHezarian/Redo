import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeServices extends GetxController {

  final _box = GetStorage();
  final _key = 'isDArkMode';

  ThemeMode get theme => _loadthemeFromBox() ? ThemeMode.dark : ThemeMode.light;
  bool _loadthemeFromBox() => _box.read(_key) ?? false;
  void saveThemeFromBox(bool isDarkmode) => _box.write(_key, isDarkmode);

  void changeTheme(ThemeData theme) => Get.changeTheme(theme);

  void switchTheme(ThemeMode themeMode ) {
    Get.changeThemeMode(themeMode);

  }
}
