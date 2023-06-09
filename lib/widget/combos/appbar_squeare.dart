import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../screens/funding/projects.dart';

// ignore: must_be_immutable
class AppbarSquare extends StatefulWidget implements PreferredSizeWidget {
  AppbarSquare(
      {Key? key,
      required this.title,
      required this.titleColor,
      required this.leadingIcon,
      required this.height,
      required this.menuAction,
      required this.color})
      : super(key: key);
  String title;
  Color titleColor;
  double height;
  Widget leadingIcon;
  final VoidCallback menuAction;
  Color color;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 100);
  @override
  State<AppbarSquare> createState() => _AppbarSquareState();
}

class _AppbarSquareState extends State<AppbarSquare> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderOnForeground: false,
      child: Container(
        padding: const EdgeInsets.all(15),
        height: widget.height,
        decoration: BoxDecoration(
            color: widget.color,
            border: Border.all(color: widget.color, width: 0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                Get.to(() => const Projects());
              },
              child: Text(
                widget.title,
                maxLines: 4,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.sourceSansPro(
                    height: 1,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: widget.titleColor),
              ),
            ),
            InkWell(
              onTap: () {
                widget.menuAction();
              },
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.2),
                    shape: BoxShape.circle),
                child: widget.leadingIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
