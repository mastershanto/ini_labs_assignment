import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ini_labs_assignment/Features/user_details/presentations/screens/home_screen.dart';
import 'package:ini_labs_assignment/Features/user_details/presentations/state_holders/theme_controller.dart';
import 'package:ini_labs_assignment/Features/user_details/presentations/state_holders/user_controller.dart';
import 'package:ini_labs_assignment/Features/user_details/presentations/widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class UserInputScreen extends StatefulWidget {
  const UserInputScreen({super.key});

  @override
  State<UserInputScreen> createState() => _UserInputScreenState();
}

class _UserInputScreenState extends State<UserInputScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserController userController = Get.find<UserController>();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _handleSearch() async {
    if (_formKey.currentState!.validate()) {
      await userController.fetchUser(_usernameController.text.trim());

      if (userController.user != null) {
        Get.to(() => const HomeScreen());
      } else if (userController.errorMessage.isNotEmpty) {
        Get.snackbar(
          'Error',
          userController.errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(16.w),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Search'),
        actions: [
          GetBuilder<ThemeController>(
            builder: (controller) => IconButton(
              icon: Icon(
                controller.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: controller.toggleTheme,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.code,
                    size: 100.sp,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    'Welcome to GitHub Search',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Enter a GitHub username to explore repositories',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 48.h),
                  CustomTextField(
                    controller: _usernameController,
                    hintText: 'Enter GitHub username',
                    labelText: 'Username',
                    prefixIcon: Icons.person,
                    keyboardType: TextInputType.text,
                    onSubmitted: (_) => _handleSearch(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a username';
                      }
                      if (value.trim().length < 3) {
                        return 'Username must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),
                  GetBuilder<UserController>(
                    builder: (controller) => CustomButton(
                      text: 'Search',
                      onPressed: _handleSearch,
                      isLoading: controller.isLoading,
                      icon: Icons.search,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).primaryColor,
                          size: 24.sp,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Try searching for: torvalds, octocat, google',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
