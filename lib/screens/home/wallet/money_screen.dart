import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/core_url.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/screens/wallet/bank_accounts_screen.dart';
import 'package:gerege_app_v2/screens/home/wallet/recieve_screen.dart';
import 'package:gerege_app_v2/services/get_service.dart';
import 'package:gerege_app_v2/style/color.dart';

import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MoneyScreen extends StatefulWidget {
  const MoneyScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NMoneyScreenState();
}

class _NMoneyScreenState extends State<MoneyScreen> {
  List buttonList = [
    {
      "id": 0,
      "name": "receive_tr",
    },
    {
      "id": 1,
      "name": "bank_accounts_tr",
    },
  ];
  RxList cartList = [].obs;
  String selectionCart = '';
  final TextEditingController accountNumber = TextEditingController();
  final TextEditingController money = TextEditingController();
  List bankList = [];

  @override
  void initState() {
    super.initState();
    getBankAccounts();
  }

  /// [getBankAccounts] bank account list
  getBankAccounts() async {
    Services()
        .getRequest('${CoreUrl.crowdfund}wallet/bank/account', true, '')
        .then((data) {
      if (data.body['message'] == "success") {
        setState(() {
          cartList.value = data.body['result'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoreColor().btnBlue,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
        backgroundColor: CoreColor().btnBlue,
        centerTitle: true,
        title: Text(
          'money_tr'.translationWord(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: GlobalVariables.useTablet // ?? tablet response
          ? Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: barcodeWidget(),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      actionWidget(),
                    ],
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  barcodeWidget(),
                  actionWidget(),
                ],
              ),
            ),
    );
  }

  Widget barcodeWidget() {
    return Container(
      width: GlobalVariables.gWidth,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              "Pay merchant",
              style: TextStyle(
                color: CoreColor().btnBlue,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: BarcodeWidget(
              barcode: Barcode.code128(),
              data: GlobalVariables.civilId,
              drawText: false,
              height: 60,
              width: GlobalVariables.gWidth,
            ),
          ),
          const SizedBox(height: 20),
          QrImage(
            data: GlobalVariables.civilId,
            version: QrVersions.auto,
            size: 200,
            errorCorrectionLevel: QrErrorCorrectLevel.Q,
            gapless: false,
          ),
          const SizedBox(height: 20),
          const Divider(
            color: Colors.grey,
            height: 2,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField(
                  iconEnabledColor: Colors.grey,
                  iconDisabledColor: Colors.grey,
                  decoration: InputDecoration(
                    fillColor: CoreColor().backgroundBlue,
                    hintText: "",
                    hintStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    enabledBorder: InputBorder.none,
                  ),
                  value: cartList.isEmpty ? null : cartList[0],
                  isExpanded: true,
                  hint: Text(
                    cartList.isEmpty ? "Данс бүртгэнэ үү" : selectionCart,
                    style: const TextStyle(
                      color: Colors.black,
                      // fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  items: cartList.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        "${value['account_number']}",
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              // ClipOval(
              //   child: Material(
              //     color: Colors.grey.withOpacity(0.2), // Button color
              //     child: InkWell(
              //       splashColor: Colors.grey, // Splash color
              //       onTap: () {
              //         setState(() {
              //           getBankList();
              //         });
              //       },
              //       child: const SizedBox(
              //         width: 40,
              //         height: 40,
              //         child: Icon(Icons.add),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Default payment method',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget actionWidget() {
    return Container(
      width: GlobalVariables.gWidth,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(
        children: [
          for (var item in buttonList)
            Center(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      if (item['id'] == 0) {
                        Get.to(() => const RecieveScreen());
                      } else {
                        Get.to(() => const BankAccountsScreen());
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.monetization_on,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${item['name']}'.translationWord(),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Divider(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            )
        ],
      ),
    );
  }
}
