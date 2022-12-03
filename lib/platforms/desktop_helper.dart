import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:sunmi_barcode_scanner/sunmi_barcode_scanner.dart';

class DesktopHelper {
  var sunmiBarcodeScanner = SunmiBarcodeScanner();

  getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 550 ? false : true;
  }

  getModelVersion() async {
    String modelVersion;
    try {
      modelVersion = (await sunmiBarcodeScanner.getScannerModel()).toString();
      GlobalVariables.usePos = modelVersion;
    } on PlatformException {
      modelVersion = 'Failed to get model version.';
    }
  }
}
