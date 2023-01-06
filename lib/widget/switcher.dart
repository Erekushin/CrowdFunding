import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/style/color.dart';

import '../helpers/backHelper.dart';

class MySwitcher extends StatefulWidget {
  const MySwitcher({Key? key, required this.switcherValue, required this.func})
      : super(key: key);
  final bool switcherValue;
  final Function func;
  @override
  // ignore: library_private_types_in_public_api
  _MySwitcher createState() => _MySwitcher();
}

class _MySwitcher extends State<MySwitcher> with TickerProviderStateMixin {
  final crowdlog = logger(_MySwitcher);
  final _duration = const Duration(milliseconds: 1);
  late Animation<Alignment> animation;
  late AnimationController _animationController;
  late bool switcherValue;
  _onTap() {
    widget.func();
    setState(
      () {
        if (switcherValue) {
          crowdlog.i('untraah daralt');
          switcherValue = false;
          _animationController.reverse();
        } else {
          crowdlog.i('idvehjvvleh daralt');
          switcherValue = true;
          _animationController.forward();
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    switcherValue = widget.switcherValue;
    _animationController =
        AnimationController(vsync: this, duration: _duration);
    animation = AlignmentTween(
            begin: switcherValue ? Alignment.centerRight : Alignment.centerLeft,
            end: switcherValue ? Alignment.centerLeft : Alignment.centerRight)
        .animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Center(
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              _onTap();
            },
            child: Container(
              width: GlobalVariables.gWidth / 7.89,
              height: GlobalVariables.gHeight / 40,
              decoration: BoxDecoration(
                color: switcherValue ? CoreColor.mainGreen : Colors.grey,
                borderRadius: const BorderRadius.all(
                  Radius.circular(99),
                ),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 100),
                alignment: switcherValue
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: AnimatedContainer(
                  margin: const EdgeInsets.all(2),
                  duration: const Duration(milliseconds: 100),
                  width: GlobalVariables.gHeight / 64.18,
                  height: GlobalVariables.gHeight / 64.18,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
