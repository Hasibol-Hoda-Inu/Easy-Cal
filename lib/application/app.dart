import 'package:easy_cal/application/app_theme_data.dart';
import 'package:easy_cal/features/auth/presentation/screen/login.dart';
import 'package:easy_cal/homeScreen.dart';
import 'package:flutter/material.dart';

class EasyCal extends StatelessWidget {
  const EasyCal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.lightThemeData,
      darkTheme: AppThemeData.darkThemeData,
      themeMode: ThemeMode.light,
      home: Login(),
    );
  }
}
