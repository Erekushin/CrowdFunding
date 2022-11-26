import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/screens/home/wallet/cart_screen.dart';
import 'package:gerege_app_v2/style/color.dart';

import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io' show Platform;

class CallWebView extends StatefulWidget {
  final String title;
  final String initialUrl;
  final bool exitButton;

  const CallWebView({
    Key? key,
    required this.title,
    required this.initialUrl,
    required this.exitButton,
  }) : super(key: key);

  @override
  _CallWebViewState createState() => _CallWebViewState();
}

class _CallWebViewState extends State<CallWebView> {
  double progress = 0;
  bool _loadedPage = false;
  WebViewController? _webViewController;
  var storage = GetStorage();
  String os = Platform.operatingSystem; //in your code

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  // 5150 2354 1595 7108
  // 202607
  // 967

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: null,
        body: Builder(builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              WebView(
                initialUrl: widget.initialUrl,
                javascriptMode: JavascriptMode.unrestricted,
                zoomEnabled: false,
                javascriptChannels: {
                  JavascriptChannel(

                      ///callMobileFunction бол web дуудаж байгаа window event нэр
                      name: 'callMobileFunction',
                      onMessageReceived: (JavascriptMessage message) {
                        ///ирсэн  messege event -ын дагуу function уудыг дуудаж утгуудыг буцаана
                        var data = json.decode(message.message);

                        if (data['type'] == 'getUserData') {
                          ///хэрэглэгчийн мэдээлэл буцаах
                          setUserData('userData', '');
                        } else if (data['type'] == 'errorFunction') {
                          ///алдааны мэдээлэл буцаах
                          print('errorFunction mobile');
                          nativeFunction(data);
                        }
                      }),
                },
                userAgent:
                    "Mozilla/5.0 (Linux; Android 4.1.1; Galaxy Nexus Build/JRO03C) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.166 Mobile Safari/535.19",
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                  controller.clearCache();
                },
                onPageFinished: (url) {
                  setState(() {
                    print('ene loader boluilaj');
                    print(os);
                    if (os != "android") {
                      _loadedPage = true;
                    }
                  });
                },
                onProgress: (int progress) {
                  print('wtd profsafasfasfasf');
                  print(progress);
                  if (os == "android") {
                    if (progress == 100) {
                      _loadedPage = true;
                    }
                  }
                },
              ),
              widget.exitButton == false
                  ? Container()
                  : Container(
                      margin: const EdgeInsets.only(right: 10, top: 10),
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 40,
                        ),
                      ),
                    ),
              _loadedPage == false
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: CoreColor().backgroundBlue,
                      ),
                    )
                  : Container(),
            ],
          );
        }),
      ),
    );
  }

  ///[runJavascriptReturningResult] нь web нь function- уудыг дууддаг
  setUserData(String type, String pin) {
    if (type == 'userData') {
      _webViewController!.runJavascriptReturningResult(
          'setUserData(${json.encode(storage.read("userInformation"))})');
    } else if (type == "pinCode") {
      print('sadsadasdasda pincode');
      _webViewController!.runJavascriptReturningResult('pinCode("$pin")');
    }
  }

  ///[nativeFunction] вэб -с дуудах
  nativeFunction(data) {
    print('data nativeFunction, $data');
    if (data['data'] == 'logout') {
      // Get.to(() => const LoginPage());
      Get.snackbar(
        'warning_tr'.translationWord(),
        data['message'],
        backgroundColor: Colors.white60,
        colorText: Colors.black,
      );
    } else if (data['data'] == "back") {
      print('get back duudsn boldogogooggooggo');
      Get.back();
    } else if (data['data'] == "pinCode") {
      print('pin code call');
      // pinCodeModal();
      final TextEditingController controller1 = TextEditingController();

      // PinCodeWidget(
      //   buttonText: 'payment_code_tr',
      //   clickEvent: () {
      //     setState(() {
      //       String pinCode = controller1.text;
      //       var bytes = utf8.encode(pinCode);
      //       var passwordGenerate = md5.convert(bytes);
      //       setUserData('pinCode', passwordGenerate.toString());
      //       Get.back();
      //     });
      //   },
      //   controller1: controller1,
      //   context: context,
      // );
    } else if (data['data'] == "refreshToken") {
      print('refresh token');
    } else if (data['data'] == "backtolist") {
      print('get back duudsn boldogogooggooggo');
      Get.to(() => const CartScreen());
    }
  }

// pinCodeModal() {
//   setState(() {
//     _controller1.text = "";
//     _controller2.text = "";
//     _controller3.text = "";
//     _controller4.text = "";
//   });
//   return showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     // enableDrag: false,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(25),
//     ),
//     builder: (context) {
//       return PinCodeWidget(
//         title: "pin_code_tr",
//         buttonText: 'payment_code_tr',
//         clickEvent: () {
//           setState(() {
//             String pinCode = _controller1.text +
//                 _controller2.text +
//                 _controller3.text +
//                 _controller4.text;
//             var bytes = utf8.encode(pinCode);
//             var passwordGenerate = md5.convert(bytes);
//             setUserData('pinCode', passwordGenerate.toString());
//             Get.back();
//           });
//         },
//         controller1: _controller1,
//         controller2: _controller2,
//         controller3: _controller3,
//         controller4: _controller4,
//       );
//     },
//   );
// }
}
