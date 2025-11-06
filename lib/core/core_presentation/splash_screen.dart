import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ini_labs_assignment/Features/user_details/presentations/screens/user_input_screen.dart';
// import '../../ui_utility/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    moveToNextScreen();
  }

  void moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 1)).then((_) {
      Get.off(() => const UserInputScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            Spacer(),
            Icon(Icons.flutter_dash, size: 120),
            Spacer(),
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Version 1.0'),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
