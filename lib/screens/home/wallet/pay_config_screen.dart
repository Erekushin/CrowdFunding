import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/style/color.dart';

import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';

class PayConfigScreen extends StatefulWidget {
  const PayConfigScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PayConfigScreenState();
}

class _PayConfigScreenState extends State<PayConfigScreen> {
  RxBool isSwitched = false.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoreColor().btnGrey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        elevation: 0.0,
        backgroundColor: CoreColor().btnGrey,
        centerTitle: true,
        title: Text(
          'pay_config_tr'.translationWord(),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          listWidget(),
        ],
      ),
    );
  }

  Widget listWidget() {
    return Column(
      children: [
        Container(
          width: GlobalVariables.gWidth,
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            children: [
              InkWell(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'transaction_pin_tr'.translationWord(),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.only(left: 30),
                child: Divider(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
              // const SizedBox(height: 5),
              // InkWell(
              //   onTap: () {},
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: const [
              //       Text(
              //         'Change password',
              //         style: TextStyle(
              //           color: Colors.black,
              //         ),
              //       ),
              //       Icon(
              //         Icons.arrow_forward_ios,
              //         color: Colors.grey,
              //       )
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: GlobalVariables.gWidth,
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: InkWell(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Face ID / Biometrics',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Transform.scale(
                  scale: 1.2,
                  child: Switch(
                    onChanged: (val) {
                      setState(() {
                        isSwitched.value = val;
                      });
                    },
                    value: isSwitched.value,
                    activeColor: Colors.white,
                    activeTrackColor: CoreColor().btnBlue,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
