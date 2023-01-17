import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

Widget txtField2(
  TextEditingController txtCont,
  String hinttxt,
) {
  return Container(
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.only(
      left: 15,
    ),
    decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.15),
        borderRadius: const BorderRadius.all(Radius.circular(15))),
    child: TextField(
      onChanged: (value) {},
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

Widget titledTextField(TextEditingController cont, String title, String label,
    IconData suffixIcon, Function func) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 10,
      ),
      Container(
        padding: const EdgeInsets.only(
          left: 15,
        ),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(.5)),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: TextField(
          controller: cont,
          onChanged: (value) {},
          style: GoogleFonts.sourceSansPro(
              height: 2,
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.black54),
          decoration: InputDecoration(
            suffixIcon: Icon(
              suffixIcon,
              color: Colors.grey,
              size: 15,
            ),
            hintStyle: const TextStyle(color: Colors.black54),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(4),
            hintText: label,
          ),
        ),
      ),
      const SizedBox(
        height: 30,
      )
    ],
  );
}

class TxtFieldPass extends StatefulWidget {
  TxtFieldPass({super.key, required this.txtCont, required this.hinttxt});
  TextEditingController txtCont;
  String hinttxt;
  @override
  State<TxtFieldPass> createState() => _TxtFieldPassState();
}

class _TxtFieldPassState extends State<TxtFieldPass> {
  bool obsurbpass = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(
        left: 15,
      ),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(.15),
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: TextField(
        obscureText: obsurbpass,
        onChanged: (value) {},
        controller: widget.txtCont,
        style: GoogleFonts.sourceSansPro(
            height: 2,
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.black54),
        decoration: InputDecoration(
          suffixIcon: InkWell(
            onTap: () {
              setState(() {
                obsurbpass = !obsurbpass;
              });
            },
            child: const Icon(
              FontAwesomeIcons.eye,
              color: Colors.grey,
              size: 15,
            ),
          ),
          hintStyle: const TextStyle(color: Colors.black54),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(4),
          hintText: widget.hinttxt,
        ),
      ),
    );
  }
}
