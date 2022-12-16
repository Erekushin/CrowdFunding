import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';

import '../style/color.dart';

Widget isEmptyData(String text) {
  print('empty rvv orson');
  return Container(
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.description_outlined,
          color: CoreColor().backgroundBlue,
          size: 55,
        ),
        const SizedBox(height: 10),
        Text(
          text.translationWord(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        )
      ],
    ),
  );
}
