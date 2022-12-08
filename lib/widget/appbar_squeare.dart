import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../helpers/gvariables.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class AppbarSquare extends StatefulWidget implements PreferredSizeWidget {
  AppbarSquare(
      {Key? key,
      required this.title,
      required this.menuAction,
      required this.color})
      : super(key: key);
  String title;
  final VoidCallback menuAction;
  Color color;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<AppbarSquare> createState() => _AppbarSquareState();
}

class _AppbarSquareState extends State<AppbarSquare> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      borderOnForeground: false,
      child: Container(
        padding: const EdgeInsets.all(15),
        height: GlobalVariables.height * .2,
        decoration: BoxDecoration(
            color: widget.color,
            border: Border.all(color: const Color(0xFF00AB44), width: 0)),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  widget.menuAction();
                },
                child: const Icon(
                  FontAwesomeIcons.bars,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              Text(
                widget.title,
                maxLines: 4,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.sourceSansPro(
                    height: 1,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
