import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';

Widget txtField2(TextEditingController txtCont, String hinttxt, Function func) {
  return Container(
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.only(
      left: 15,
    ),
    decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.15),
        borderRadius: const BorderRadius.all(Radius.circular(15))),
    child: TextField(
      onChanged: (value) {
        func();
      },
      controller: txtCont,
      style: GoogleFonts.sourceSansPro(
          height: 2,
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: Colors.black54),
      decoration: InputDecoration(
        suffixIcon: const Icon(
          FontAwesomeIcons.pen,
          color: Colors.grey,
          size: 15,
        ),
        hintStyle: const TextStyle(color: Colors.black54),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(4),
        hintText: hinttxt,
      ),
    ),
  );
}

Widget txtFormField2(
    TextEditingController txtCont, String hinttxt, String valid(val)) {
  return Container(
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.only(
      left: 15,
    ),
    decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.15),
        borderRadius: const BorderRadius.all(Radius.circular(15))),
    child: TextFormField(
      validator: (val) => valid(val),
      controller: txtCont,
      style: GoogleFonts.sourceSansPro(
          height: 2,
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: Colors.black54),
      decoration: InputDecoration(
        suffixIcon: const Icon(
          FontAwesomeIcons.pen,
          color: Colors.grey,
          size: 15,
        ),
        hintStyle: const TextStyle(color: Colors.black54),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(4),
        hintText: hinttxt,
      ),
    ),
  );
}
