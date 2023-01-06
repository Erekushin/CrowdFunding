import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/services/get_service.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/get.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({Key? key}) : super(key: key);

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var otpController = TextEditingController();
  bool emailRead = true;
  bool phoneRead = true;

  @override
  void initState() {
    emailController.text = GlobalVariables.email.value;
    phoneController.text = GlobalVariables.phoneNumber;
    super.initState();
  }

  otpSend() {
    String url = '';
    Services().getRequest(url, false, '').then((data) {
      if (data.statusCode == 200) {
      } else {
        Get.snackbar(
          'warning_tr'.translationWord(),
          data.body['message'],
          colorText: Colors.white,
          backgroundColor: Colors.red.withOpacity(0.2),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CoreColor().backgroundBtnBlue,
        title: const Text('Баталгаажуулалт'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text("Имейл"),
              const SizedBox(height: 10),
              TextFormField(
                autofocus: false,
                readOnly: emailRead,
                keyboardType: TextInputType.text,
                controller: emailController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  suffixIcon: emailRead == true
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              emailRead = false;
                            });
                          },
                          icon: const Icon(
                            Icons.edit,
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              emailRead = true;
                            });
                          },
                          icon: const Icon(
                            Icons.send,
                          ),
                        ),
                  prefixIcon: GlobalVariables.isConfirmedEmail == 1
                      ? const Icon(
                          Icons.done_all_outlined,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        ),
                  filled: true,
                  labelText: '',
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
              const Text("Утас"),
              const SizedBox(height: 10),
              TextFormField(
                autofocus: false,
                readOnly: phoneRead,
                keyboardType: TextInputType.number,
                controller: phoneController,
                maxLength: 8,
                decoration: InputDecoration(
                  counterText: '',
                  fillColor: Colors.white,
                  suffixIcon: phoneRead == true
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              phoneRead = false;
                            });
                          },
                          icon: const Icon(
                            Icons.edit,
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              phoneRead = true;
                            });
                          },
                          icon: const Icon(
                            Icons.send,
                          ),
                        ),
                  prefixIcon: GlobalVariables.isConfirmedPhone == 1
                      ? const Icon(
                          Icons.done_all_outlined,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        ),
                  filled: true,
                  labelText: '',
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
              )
            ],
          ),
        ),
      ),
    );
  }

  optDialog() {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.all(20),
      title: "Баталгаажуулалт",
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(color: Colors.black),
      textConfirm: "Баталгаажуулах",
      textCancel: "Буцах",
      cancelTextColor: Colors.black,
      confirmTextColor: Colors.white,
      buttonColor: CoreColor().backgroundBtnBlue,
      barrierDismissible: false,
      radius: 10,
      content: SizedBox(
        width: GlobalVariables.gWidth - 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Нэг удаагийн код '),
            const SizedBox(height: 20),
            TextFormField(
              autofocus: false,
              keyboardType: TextInputType.text,
              controller: otpController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: '',
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
          ],
        ),
      ),
    );
  }
}
