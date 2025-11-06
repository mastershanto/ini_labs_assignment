import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ini_labs_assignment/Features/user_details/presentations/screens/home_screen.dart';
import 'package:ini_labs_assignment/core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(
        title: 'iNi Labs Assignment',
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
