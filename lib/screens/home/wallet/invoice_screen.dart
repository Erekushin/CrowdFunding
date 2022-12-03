import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerege_app_v2/helpers/core_url.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/services/get_service.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:gerege_app_v2/widget/back_bar.dart';
import 'package:gerege_app_v2/widget/gerege_button.dart';
import 'package:gerege_app_v2/widget/pin_code_nobutton.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({Key? key}) : super(key: key);

  @override
  State createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  RxBool isSwitched = false.obs;
  var priceController = TextEditingController();
  var numberController = TextEditingController();
  var usernameController = TextEditingController();
  var descController = TextEditingController();
  String destUserId = "";
  String destAccountNo = '';
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? controller;
  RxBool qrScreen = false.obs;

  static const _locale = 'mn';

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;

  @override
  void initState() {
    super.initState();
    priceController.text = '0';
    qrScreen.value = false;
  }

  moneyFormat(String price) {
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      return value;
    }
  }

  findUser(text, type) async {
    Services()
        .getRequest(
            '${CoreUrl.serviceUrl}user/find-phone?search_text=$text', true, '')
        .then((data) {
      if (data.body['message'] == "success") {
        if (type == false) {
          numberController.text = data.body['result']['phone_no'];
        }
        usernameController.text = data.body['result']['first_name'];
        destUserId = data.body['result']['id'].toString();
      } else {
        Get.snackbar(
          'warning_tr'.translationWord(),
          data.body['message'].toString(),
          colorText: Colors.black,
          backgroundColor: Colors.white,
        );
      }
    });
  }

  invoiceScreen(pincode) async {
    var bodyData = {
      "dest_user_id": destUserId,
      "amount": int.parse(priceController.text.replaceAll(',', '')),
      "description": descController.text,
    };

    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.serviceUrl}wallet/invoice', true, '')
        .then((data) {
      // var res = json.decode(data.body);
      if (data.body['message'] == "success") {
        priceController.text = '0';
        numberController.text = '';
        usernameController.text = '';
        descController.text = '';
        Get.back();
        Get.snackbar(
          'success_tr'.translationWord(),
          data.body['message'].toString(),
          colorText: Colors.black,
          backgroundColor: Colors.white,
        );
      } else {
        Get.snackbar(
          'warning_tr'.translationWord(),
          data.body['message'].toString(),
          colorText: Colors.black,
          backgroundColor: Colors.white,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        return false;
      },
      child: Scaffold(
        backgroundColor: CoreColor().backgroundBlue,
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        drawerEdgeDragWidth: 0.0,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(65), // Set this height
          child: BackAppBar(
            titleText: 'invoice_tr',
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            qrScreen.value == false
                ? Expanded(
                    child: Container(
                      width: GlobalVariables.gWidth,
                      decoration: BoxDecoration(
                        color: CoreColor().backgroundGrey,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          SizedBox(
                            height: 60,
                            width: GlobalVariables.gWidth - 50,
                            child: TextField(
                              style: TextStyle(
                                color: CoreColor().backgroundBlue,
                                fontWeight: FontWeight.bold,
                                fontFamily: "MBold",
                                fontSize: 45,
                              ),
                              maxLength: 10,
                              controller: priceController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[1-9]{1,}.*'),
                                ),
                              ],
                              onChanged: (string) {
                                if (string != '') {
                                  string =
                                      _formatNumber(string.replaceAll(',', ''));
                                  priceController.value = TextEditingValue(
                                    text: string,
                                    selection: TextSelection.collapsed(
                                        offset: string.length),
                                  );
                                }
                              },
                              cursorWidth: 0,
                              cursorColor: Colors.transparent,
                              decoration: InputDecoration(
                                suffixText: _currency,
                                suffixStyle: TextStyle(
                                  fontSize: 30,
                                  color: Colors.grey.withOpacity(0.4),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "MBold",
                                ),
                                hintText: '0',
                                counterText: '',
                                hintStyle: TextStyle(
                                  color: CoreColor().backgroundBlue,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "MBold",
                                  fontSize: 50,
                                ),
                                fillColor: Colors.transparent,
                                filled: true,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ),
                            // height: 60,
                            width: GlobalVariables.gWidth - 50,
                            child: TextField(
                              controller: numberController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 8,
                              cursorWidth: 1,
                              minLines: 1,
                              maxLines: 1,
                              onChanged: (val) {
                                setState(() {
                                  if (val.length == 8) {
                                    findUser(numberController.text, true);
                                  } else {
                                    usernameController.text = '';
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                // contentPadding:
                                //     const EdgeInsets.symmetric(vertical: 20.0),
                                counterText: "",
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      qrScreen.value = true;
                                    });
                                  },
                                  child: Icon(
                                    Icons.qr_code_scanner_rounded,
                                    color: CoreColor().backgroundBlue,
                                    size: 35,
                                  ),
                                ),
                                hintText: 'phone_num_tr'.translationWord(),
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                fillColor: CoreColor().backgroundWhite,
                                filled: true,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: GlobalVariables.gWidth - 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              border: Border.all(
                                width: 1,
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ),
                            child: TextField(
                              readOnly: true,
                              controller: usernameController,
                              cursorColor: CoreColor().backgroundBlue,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              cursorWidth: 1,
                              minLines: 1,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                // contentPadding:
                                //     const EdgeInsets.symmetric(vertical: 20.0),
                                hintText: 'recipient_tr'.translationWord(),
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                fillColor: CoreColor().backgroundWhite,
                                filled: true,
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            // padding: const EdgeInsets.only(left: 20, right: 20),
                            width: GlobalVariables.gWidth - 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              border: Border.all(
                                width: 1,
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ),
                            child: TextField(
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              keyboardType: TextInputType.multiline,
                              // maxLines: 3,
                              controller: descController,
                              cursorColor: CoreColor().backgroundBlue,
                              cursorWidth: 1,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                // contentPadding:
                                //     const EdgeInsets.symmetric(vertical: 20.0),
                                hintText: 'transfer_desc_tr'.translationWord(),
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                fillColor: CoreColor().backgroundWhite,
                                filled: true,
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GeregeButtonWidget(
                            radius: 15.0,
                            height: 50,
                            minWidth: GlobalVariables.gWidth - 50,
                            backgroundColor: CoreColor().backgroundButton,
                            borderColor: CoreColor().backgroundButton,
                            text: Text(
                              'transaction_send_tr'.translationWord(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                if (priceController.text != "0" &&
                                    numberController.text != '' &&
                                    usernameController.text != '') {
                                  // pinCodeAskModal();
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  _controller1.text = '';
                                  _controller2.text = '';
                                  _controller3.text = '';
                                  _controller4.text = '';
                                  // showPinCodeAsk();
                                  PinCodeNoButtom(
                                      controller1: _controller1,
                                      controller2: _controller2,
                                      controller3: _controller3,
                                      controller4: _controller4,
                                      checkEvent: (val) async {
                                        invoiceScreen(
                                          _controller1.text +
                                              _controller2.text +
                                              _controller3.text +
                                              _controller4.text,
                                        );
                                      },
                                      context: context);

                                  ///end send hiine de
                                } else {
                                  Get.snackbar(
                                    'warning_tr'.translationWord(),
                                    'field_tr'.translationWord(),
                                    colorText: Colors.black,
                                    backgroundColor: Colors.white,
                                  );
                                }
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    flex: 4,
                    child: _buildQrView(context),
                  ),
          ],
        ),
      ),
    );
  }

  ///[showPinCodeAsk] гүйлгээний нууц үг асуух
  showPinCodeAsk() {
    final FocusNode focus1 = FocusNode();
    final FocusNode focus2 = FocusNode();
    final FocusNode focus3 = FocusNode();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      builder: (context) {
        return SizedBox(
          height: GlobalVariables.keyboardIsVisible(context)
              ? GlobalVariables.gHeight / 1.7
              : GlobalVariables.gHeight / 4,
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView(
                      children: [
                        const SizedBox(height: 40),
                        //Verify phone number Text Widget
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'transaction_pin_code_ask_tr'.translationWord(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: "MBold",
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              alignment: Alignment.center,
                              child: TextFormField(
                                obscureText: true,
                                focusNode: focus1,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.center,
                                controller: _controller1,
                                textInputAction: TextInputAction.next,
                                onChanged: (_) {
                                  if (_controller1.text.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                cursorColor: Colors.pink,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      left: 10, right: 8, top: 10),
                                  border: InputBorder.none,
                                  helperStyle: TextStyle(
                                    color: Colors.transparent,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              alignment: Alignment.center,
                              child: TextFormField(
                                obscureText: true,
                                focusNode: focus2,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.center,
                                textInputAction: TextInputAction.next,
                                controller: _controller2,
                                onChanged: (_) {
                                  if (_controller2.text.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  } else if (_controller2.text == '') {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                cursorColor: Colors.pink,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 10, right: 8, top: 10),
                                    border: InputBorder.none,
                                    helperStyle:
                                        TextStyle(color: Colors.transparent)),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              alignment: Alignment.center,
                              child: TextFormField(
                                obscureText: true,
                                focusNode: focus3,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.center,
                                controller: _controller3,
                                textInputAction: TextInputAction.next,
                                onChanged: (_) {
                                  if (_controller3.text.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  } else if (_controller3.text == '') {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                cursorColor: Colors.pink,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 10, right: 8, top: 10),
                                    border: InputBorder.none,
                                    helperStyle:
                                        TextStyle(color: Colors.transparent)),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              alignment: Alignment.center,
                              child: TextFormField(
                                obscureText: true,
                                cursorColor: Colors.pink,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.center,
                                controller: _controller4,
                                textInputAction: TextInputAction.done,
                                onChanged: (_) {
                                  if (_controller4.text.length == 1) {
                                    // FocusScope.of(context).nextFocus();

                                    // sendTransaction(
                                    //   _controller1.text +
                                    //       _controller2.text +
                                    //       _controller3.text +
                                    //       _controller4.text,
                                    // );
                                  } else if (_controller4.text == '') {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 10, right: 8, top: 10),
                                    border: InputBorder.none,
                                    helperStyle:
                                        TextStyle(color: Colors.transparent)),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

// ene qr unshigchiig ngodhor solino odoo
  Widget _buildQrView(BuildContext context) {
    if (controller != null && mounted) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    } else {}
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: CoreColor().backgroundBlue,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        if (scanData.code != '') {
          controller.pauseCamera();
          print('scan hiisen data l end irne de, ${scanData.code}');
          numberController.text = scanData.code.toString();
          // findUser(scanData.code.toString(), false);
          qrScreen.value = false;
        }
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}
