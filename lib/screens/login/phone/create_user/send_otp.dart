import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/widget/gerege_button.dart';
import 'package:gerege_app_v2/widget/gerege_textfield.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:gerege_app_v2/controller/create_user_controller.dart';
import 'package:get/get.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';

class SendOtp extends StatefulWidget {
  const SendOtp({Key? key, this.onPressed}) : super(key: key);

  final Function(int)? onPressed;

  @override
  State<SendOtp> createState() => _SendOtp();
}

class _SendOtp extends State<SendOtp> with TickerProviderStateMixin {
  static final CreateUserController _createUserController =
      Get.put(CreateUserController());
  late TabController tabController;
  int selectedIndex = 0;
  int screenChange = 0;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    tabController.addListener(() {
      setState(() {
        if (tabController.indexIsChanging) {
        } else {
          setState(() {
            selectedIndex = tabController.index;
          });
        }
      });
    });
    super.initState();
    // Рш();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: 50),
            Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.0),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: TabBar(
                  indicatorColor: CoreColor().backgroundButton,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  controller: tabController,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontFamily: "MRegular",
                  ),
                  tabs: [
                    Tab(
                      text: 'email_tr'.translationWord(),
                    ),
                    Tab(
                      text: 'phone_num_tr'.translationWord(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Row(
            //   children: [

            //   ],
            // ),
            selectedIndex == 0
                ? GeregeTextField(
                    controller: _createUserController.searchController!,
                    label: 'email_tr',
                    keyboardType: TextInputType.emailAddress,
                  )
                : Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                              color: Colors.black.withOpacity(0.2), width: 1),
                        ),
                        width: 90,
                        child: const Text(
                          '+976',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _createUserController.searchController!,
                          autofocus: false,
                          keyboardType: TextInputType.number,
                          maxLength: 8,
                          validator: (String? val) =>
                              GlobalValidator().phoneValid(val),
                          decoration: InputDecoration(
                            counterText: '',
                            labelText: 'phone_num_tr'.translationWord(),
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            contentPadding: const EdgeInsets.all(20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 30),
            GeregeButtonWidget(
              radius: 10.0,
              elevation: 0.0,
              minWidth: GlobalVariables.gWidth,
              backgroundColor: CoreColor().backgroundBlue,
              borderColor: CoreColor().backgroundBlue,
              text: Text(
                'otp_send_tr'.translationWord(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await _createUserController.otpSend(context).then(
                    (data) {
                      print("0000000000000000000000000000000000");
                      print(data.body);
                      if (data.statusCode == 200) {
                        setState(() {
                          screenChange = 1;
                        });
                        widget.onPressed!(screenChange);
                      } else {
                        Get.snackbar(
                          'warning_tr'.translationWord(),
                          data.body['message'],
                          colorText: Colors.white,
                          backgroundColor: Colors.grey.withOpacity(0.2),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
