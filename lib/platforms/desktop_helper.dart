import 'package:flutter/widgets.dart';

class DesktopHelper {
  getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 550 ? false : true;
  }
}
