import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task2/db/data_base.dart';

import 'package:task2/theme/theme_controller.dart';
import 'package:task2/theme/theme_scheme.dart';
import 'package:task2/views/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbService.initDb();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final themeServices = Get.put(ThemeServices());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Themes.lightTheme,
      themeMode: themeServices.theme,
      darkTheme: Themes.darkTheme,
      home: const SplashScreen(),
    );
  }
}
