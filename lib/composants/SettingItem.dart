import 'package:flutter/material.dart';

import '../style.dart';


class SettingItem extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final IconData trailingIcon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? iconSize;
  final TextStyle? titleStyle;

  SettingItem({
    Key? key,
    required this.leadingIcon,
    required this.title,
    required this.trailingIcon,
    required this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.iconSize = 24.0,
    this.titleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: KColors.primary.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              children: [
                // Leading icon (left)
                Icon(
                  leadingIcon,
                  color: iconColor ?? KColors.primary,
                  size: iconSize,
                ),
                const SizedBox(width: 16.0),

                // Title (middle)
                Expanded(
                  child: Text(
                    title,
                    style: titleStyle ?? KTypography.h5(context),
                  ),
                ),

                // Trailing icon (right)
                Icon(
                  trailingIcon,
                  color: KColors.primary,
                  size: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}