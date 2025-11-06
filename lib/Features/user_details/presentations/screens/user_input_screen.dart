import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ini_labs_assignment/Features/user_details/presentations/screens/home_screen.dart';
import 'package:ini_labs_assignment/Features/user_details/presentations/widgets/custom_appbar.dart';
import 'package:ini_labs_assignment/Features/user_details/presentations/widgets/custom_text_field.dart';

class UserInputScreen extends StatefulWidget {
  const UserInputScreen({super.key});

  @override
  State<UserInputScreen> createState() => _UserInputScreenState();
}

class _UserInputScreenState extends State<UserInputScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "GitHub User Search"),
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
                    Icons.person_search,
                    size: 100.sp,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    'GitHub Profile Search',
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
                    prefixIcon: Icons.code,
                    suffixIcon: Icons.search,
                    onSuffixIconTap: () {
                      Get.to(() => HomeScreen());
                    },
                    keyboardType: TextInputType.text,
                    onSubmitted: (value) {},
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
