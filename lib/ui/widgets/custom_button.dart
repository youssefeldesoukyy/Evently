import 'package:evently/ui/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color backgroundColor;
  final String text;
  final Function() onClick;
  final Color textColor;
  final Widget? icon;
  final Color? borderColor;

  const CustomButton(
      {super.key,
        this.backgroundColor = AppColors.blue,
        required this.text,
        required this.onClick,
        this.icon,
        this.borderColor,
        this.textColor = AppColors.white});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) icon!,
            Text(text,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: textColor)),
          ],
        ));
  }
}