import 'package:flutter/material.dart';
import 'package:gerege_app_v2/style/color.dart';

class GeregeButtonWidget extends StatelessWidget {
  const GeregeButtonWidget({
    Key? key,
    this.backgroundColor,
    required this.minWidth,
    this.borderColor,
    required this.text,
    required this.onPressed,
    this.radius,
    this.height,
    this.elevation,
  }) : super(key: key);

  final Color? backgroundColor;
  final Color? borderColor;
  final Widget text;
  final double minWidth;
  final double? radius;
  final VoidCallback onPressed;
  final double? height;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? 10),
        side: BorderSide(
          color: borderColor ?? CoreColor().backgroundBlue,
        ),
      ),
      color: backgroundColor ?? CoreColor().backgroundBlue,
      minWidth: minWidth,
      height: height ?? 60,
      onPressed: onPressed,
      child: text,
    );
  }
}
