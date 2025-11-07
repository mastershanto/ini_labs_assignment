import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ini_labs_assignment/Features/user_details/presentations/screens/user_input_screen.dart';
import 'package:ini_labs_assignment/Features/user_details/presentations/state_holders/theme_controller.dart';
import 'controllers.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetBuilder<ThemeController>(
          init: ThemeController(),
          initState: (_) {
            ControllerBinder().dependencies();
          },
          builder: (themeController) {
            return GetMaterialApp(
              title: 'GitHub Search',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeController.isDarkMode
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: const UserInputScreen(),
            );
          },
        );
      },
    );
  }
}
