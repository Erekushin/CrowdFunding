import 'package:flutter/material.dart';

class GeregeButtonWidget extends StatelessWidget {
  const GeregeButtonWidget({
    Key? key,
    required this.backgroundColor,
    required this.minWidth,
    required this.borderColor,
    required this.text,
    required this.onPressed,
    required this.radius,
    this.height,
    this.elevation,
  }) : super(key: key);

  final Color? backgroundColor;
  final Color borderColor;
  final Widget text;
  final double minWidth;
  final double radius;
  final VoidCallback onPressed;
  final double? height;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: borderColor),
      ),
      color: backgroundColor,
      minWidth: minWidth,
      height: height ?? 60,
      onPressed: onPressed,
      child: text,
    );
  }
}
