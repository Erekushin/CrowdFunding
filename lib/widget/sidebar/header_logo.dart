import 'package:flutter/material.dart';
import 'package:gerege_app_v2/style/color.dart';

import '../../helpers/gvariables.dart';

class HeaderLogoWidget extends StatelessWidget {
  const HeaderLogoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CoreColor().backgroundBlue,
      ),
      height: GlobalVariables.useTablet ? 140 : 200,
      width: GlobalVariables.gWidth,
      child: Stack(
        children: [
          SizedBox(
            width: GlobalVariables.gWidth,
            child: Column(
              children: [
                SizedBox(height: GlobalVariables.useTablet ? 30 : 60),
                SizedBox(
                  height: 90,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(
                      "assets/images/gerege_logo_white.png",
                      fit: GlobalVariables.useTablet
                          ? BoxFit.none
                          : BoxFit.cover,
                      height: GlobalVariables.gHeight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
