import 'package:flutter/material.dart';

Widget generalBtn(Color clr, Color textColor, String title, Function func) {
  return InkWell(
    onTap: () {
      func();
    },
    child: Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)), color: clr),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
              color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    ),
  );
}
