import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.titleStyle,
    this.showBackArrow = true,
    this.leadingIcon,
    this.actions,
    this.leadingOnPressed,
    this.backgroundColors,
    this.centerTitle = false,
    this.isSuffix = false,
    // this.onTapBackButton,
  });

  final String? title;
  final TextStyle? titleStyle;
  final bool showBackArrow;
  final Widget? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final Color? backgroundColors;
  final bool centerTitle;
  final bool isSuffix;
  // final VoidCallback? onTapBackButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(title ?? ""), actions:actions?? [
        
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 16.sp);
}
