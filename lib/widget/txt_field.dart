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
