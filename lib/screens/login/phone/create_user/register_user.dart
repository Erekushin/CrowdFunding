import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/widget/gerege_button.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:gerege_app_v2/controller/create_user_controller.dart';
import 'package:get/get.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';

class Registeruser extends StatelessWidget {
  const Registeruser({
    Key? key,
    required this.click,
  }) : super(key: key);

  final Function click;

  static final CreateUserController _createUserController =
      Get.put(CreateUserController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          const SizedBox(height: 50),
          TextFormField(
            readOnly: true,
            autofocus: false,
            keyboardType: TextInputType.number,
            controller: _createUserController.searchController,
            decoration: InputDecoration(
              fillColor: Colors.grey.withOpacity(0.2),
              filled: true,
              labelText: ''.translationWord(),
              labelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              contentPadding: const EdgeInsets.all(20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            autofocus: false,
            keyboardType: TextInputType.number,
            controller: _createUserController.otpCodeController,
            decoration: InputDecoration(
              labelText: 'otp_tr'.translationWord(),
              labelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              contentPadding: const EdgeInsets.all(20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            autofocus: false,
            keyboardType: TextInputType.text,
            controller: _createUserController.passwordController,
            decoration: InputDecoration(
              labelText: 'password_tr'.translationWord(),
              labelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              contentPadding: const EdgeInsets.all(20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          GeregeButtonWidget(
            radius: 10.0,
            elevation: 0.0,
            minWidth: GlobalVariables.gWidth,
            backgroundColor: CoreColor().backgroundYellow,
            borderColor: CoreColor().backgroundYellow,
            text: Text(
              'otp_send_tr'.translationWord(),
              style: const TextStyle(),
            ),
            onPressed: () async {
              if (_createUserController.searchController!.text != "" &&
                  _createUserController.otpCodeController!.text != "" &&
                  _createUserController.passwordController!.text != "") {
                // await _createUserController.register(context).then((data) {
                //   if (data.statusCode == 200) {
                //     click('as');
                //   } else {
                //     Get.snackbar(
                //       'warning_tr'.translationWord(),
                //       data.body['message'],
                //       colorText: Colors.white,
                //       backgroundColor: Colors.grey.withOpacity(0.2),
                //     );
                //   }
                // });
              } else {
                Get.snackbar(
                  'warning_tr'.translationWord(),
                  "Талбаруудыг бөглөнө үү",
                  colorText: Colors.white,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
