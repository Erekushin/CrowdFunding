import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';

class GeregeTextField extends StatelessWidget {
  const GeregeTextField({
    Key? key,
    required this.controller,
    this.label,
    this.suffinIcon,
    this.onPressedIcon,
    this.keyboardType,
    this.obscureText,
    this.labelSize,
    // required this.validator,
  }) : super(key: key);

  final String? label;
  final IconButton? suffinIcon;
  final VoidCallback? onPressedIcon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final double? labelSize;
  // final Function validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      controller: controller,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType ?? TextInputType.text,
      // validator: (String? value) {
      //   validator == null ? validator : print(value);
      //   return null;
      // },

      // validator: (val) => validator,

      decoration: InputDecoration(
        // contentPadding:
        //     const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
        contentPadding: const EdgeInsets.all(20),
        labelText: label!.translationWord() ?? '',
        labelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 1,
            color: Colors.black.withOpacity(0.2),
          ),
        ),
        suffixIcon: suffinIcon == null
            ? null
            : IconButton(
                icon: suffinIcon!,
                onPressed: onPressedIcon,
              ),
      ),
    );
  }
}
