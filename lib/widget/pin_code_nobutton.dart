import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/style/color.dart';

class PinCodeNoButtom {
  final TextEditingController controller1;
  final TextEditingController controller2;
  final TextEditingController controller3;
  final TextEditingController controller4;
  final Function(String) checkEvent;
  final String? title;

  // final VoidCallback onPressed;
  final BuildContext context;

  PinCodeNoButtom(
      {required this.controller1,
      required this.controller2,
      required this.controller3,
      required this.controller4,
      required this.checkEvent,
      required this.context,
      this.title}) {
    showPinCodeAsk(context);
  }

  final List<String> _pin = ['', '', '', ''];
  String _cursorText = "_";
  StateSetter? _myState;

  changeCursor() {
    debugPrint("OK");
    if (_cursorText == '_') {
      _cursorText = '';
    } else {
      _cursorText = '_';
    }
    debugPrint("_cursorText $_cursorText");
    if (_myState != null) _myState!(() {});
  }

  List<Widget> drawList(StateSetter myState) {
    List<Widget> ret = [];
    ret.add(
      SizedBox(
        width: 0,
        child: TextFormField(
          // readOnly: type1.value,
          autofocus: true,
          obscureText: true,
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.center,
          controller: controller1,
          textInputAction: TextInputAction.next,
          onChanged: (val) {
            debugPrint("val $val");
            switch (controller1.text.length) {
              case 0:
                _pin[0] = _pin[1] = _pin[2] = _pin[3] = "";
                break;
              case 1:
                _pin[0] = "*";
                _pin[1] = _pin[2] = _pin[3] = "";
                break;
              case 2:
                _pin[0] = _pin[1] = "*";
                _pin[2] = _pin[3] = "";
                break;
              case 3:
                _pin[0] = _pin[1] = _pin[2] = "*";
                _pin[3] = "";
                break;
              case 4:
                _pin[0] = _pin[1] = _pin[2] = _pin[3] = "*";
                checkEvent(val);
                break;
            }
            myState(() {});
          },
          keyboardType: TextInputType.number,
          maxLength: 4,
          cursorColor: Colors.pink,
        ),
      ),
    );

    for (int i = 0; i < 4; i++) {
      ret.add(Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color: controller1.text.length == i
                    ? CoreColor().backgroundBlue
                    : Colors.grey),
            borderRadius: BorderRadius.circular(15.0),
          ),
          alignment: Alignment.center,
          child: Container(
              child: controller1.text.length == i
                  ? AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                      child: Text(
                        _cursorText,
                        style: const TextStyle(fontSize: 17),
                      ),
                    )
                  : Text(_pin[i]))));
    }

    return ret;
  }

  showPinCodeAsk(BuildContext context) {
    // Timer? timer;
    // timer = new Timer.periodic(Duration(milliseconds: 500), (t) {
    //   debugPrint("timer $t");
    //   changeCursor();
    // });
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (context, myState) {
            _myState = myState;
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                height: 170,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(children: [
                  const SizedBox(height: 30),
                  //Verify phone number Text Widget
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title ?? 'transaction_pin_code_ask_tr'.translationWord(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "MBold",
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: drawList(myState),
                    ),
                  ),
                  const SizedBox(height: 30),
                ]),
              ),
            );
          });
        });
  }
}
