import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerege_app_v2/helpers/core_url.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/screens/home/wallet/transfer_screen.dart';
import 'package:gerege_app_v2/services/get_service.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:gerege_app_v2/widget/gerege_button.dart';

import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen>
    with TickerProviderStateMixin {
  static const _locale = 'mn';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(double.parse(s));
  RxDouble chargeAmount = 0.0.obs;
  final TextEditingController _amountController = TextEditingController();
  RxList cardList = [].obs;
  RxList accountList = [].obs;
  String selectionBankId = "";
  String selectionBankAccount = "";
  late TabController tabController;
  RxInt selectedIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 2, //1,
      vsync: this,
    );
    tabController.addListener(() {
      setState(() {
        selectedIndex.value = tabController.index;
      });
    });
  }

  /// [getBankAccounts] bank account list
  getBankAccounts() async {
    Services()
        .getRequest('${CoreUrl.serviceUrl}wallet/bank/account', true, '')
        .then((data) {
      if (data.body['message'] == "success") {
        setState(() {
          accountList.value = data.body['result'];
        });
      }
    });
  }

  hmacEncryp(selectedId) {
    var hmackey = utf8.encode("Bm2#3Z8]HID(&Wt");
    String hmacValue = selectedId +
        _amountController.text.replaceAll(',', '') +
        chargeAmount.value.round().toString();
    var hmacSha256 = Hmac(sha256, hmackey); // HMAC-SHA256
    var digest = hmacSha256.convert(utf8.encode(hmacValue));
    var bodyData = {
      "type": "charge",
      "hash": digest.toString(),
      "card_token_id": int.parse(selectedId),
      "device_type": Platform.isAndroid == true ? 'android' : "ios",
      "amount": chargeAmount.value.round(),
      "charge_percent": 1,
      "charge_amount": int.parse(_amountController.text.replaceAll(',', '')),
    };
    // cardPay(bodyData);
  }

  withDrawMoney() async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    var bodyData = {
      "bank_account_id": selectionBankId,
      "account_number": selectionBankAccount,
      "amount": int.parse(_amountController.text.replaceAll(',', ''))
    };
    print(bodyData);

    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.serviceUrl}/wallet/withdraw', true, '')
        .then((data) {
      // var res = json.decode(data.body);
      print(data.body);
      if (data.body['message'] == "success") {
        // Get.back();
        Get.back();
        Get.back();
        Get.snackbar(
          'success_tr'.translationWord(),
          data.body['message'].toString().translationWord(),
          colorText: Colors.black,
          backgroundColor: Colors.white,
        );
        // Get.to(() => const MainTab(indexTab: 1));
        print('basdadasd asd asd asd asd asdas ');
        GlobalVariables.accountBalance.value =
            GlobalVariables.accountBalance.value -
                int.parse(_amountController.text.replaceAll(',', ''));
      } else {
        // Get.back();
        Navigator.of(Get.overlayContext!).pop();
        // Get.back();
        Get.snackbar(
          'warning_tr'.translationWord(),
          data.body['message'],
          colorText: Colors.white,
          backgroundColor: CoreColor().backgroundYellow.withOpacity(0.2),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          TextButton(
            child: Text(
              'transaction_tr'.translationWord(),
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Get.to(() => const TransferScreen());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 100),
          const Center(
            child: Icon(
              Icons.monetization_on,
              size: 80,
              color: Colors.yellow,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'remainder_tr'.translationWord(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatNumber(GlobalVariables.accountBalance.value
                        .toString()
                        .replaceAll(',', '')),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: const Text(
                      '₮',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const Spacer(),
          Container(
            alignment: Alignment.bottomCenter,
            child: GeregeButtonWidget(
              radius: 10.0,
              elevation: 0.0,
              minWidth: GlobalVariables.gWidth / 1.6,
              backgroundColor: CoreColor().btnBlue,
              borderColor: CoreColor().btnBlue,
              text: Text(
                'topup_tr'.translationWord(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              onPressed: () async {
                // await getCartList();
                setState(() {
                  print('top uooda');
                  topUpModal();
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.bottomCenter,
            child: GeregeButtonWidget(
              radius: 10.0,
              elevation: 0.0,
              minWidth: GlobalVariables.gWidth / 1.6,
              backgroundColor: CoreColor().btnGrey,
              borderColor: CoreColor().btnGrey,
              text: Text(
                'withdraw_tr'.translationWord(),
                style: TextStyle(
                  color: CoreColor().btnBlue,
                  fontSize: 16,
                ),
              ),
              onPressed: () async {
                await getBankAccounts();
                setState(() {
                  withdrawModal();
                });
              },
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  topUpModal() {
    _amountController.text = "";
    chargeAmount.value = 0;
    return showModalBottomSheet(
      // isDismissible: false,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      enableDrag: false,
      builder: (context) {
        return SizedBox(
          height: GlobalVariables.gHeight - 200,
          child: Obx(
            () => Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.0),
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.5), width: 2)),
                    ),
                    child: TabBar(
                      indicatorColor: CoreColor().backgroundButton,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      controller: tabController,
                      tabs: [
                        Tab(
                          text: 'cart_tr'.translationWord(),
                        ),
                        Tab(
                          text: 'account_tr'.translationWord(),
                        ),
                      ],
                    ),
                  ),
                ),
                selectedIndex.value == 0
                    ? Expanded(
                        child: topupCart(),
                      )
                    : Expanded(
                        child: accountListWidget(),
                      )
              ],
            ),
          ),
        );
      },
    );
  }

  topupCart() {
    return Column(
      children: [
        const SizedBox(height: 50),
        const Text(
          'Top up',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: "MBold",
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 60),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: const Divider(
            color: Colors.grey,
            height: 2,
          ),
        ),
        Row(
          children: [
            Container(
              width: 120,
              margin: const EdgeInsets.only(left: 20, right: 10),
              child: Text(
                'cart_tr'.translationWord(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: DropdownButtonFormField(
                iconEnabledColor: Colors.grey,
                iconDisabledColor: Colors.grey,
                decoration: InputDecoration(
                  fillColor: CoreColor().backgroundBlue,
                  hintText: "",
                  enabledBorder: InputBorder.none,
                ),
                isExpanded: true,
                hint: const Text(
                  'Select bank',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                  ),
                ),
                items: cardList.map((value) {
                  return DropdownMenuItem(
                      value: value,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.account_balance,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "${value['card_number']}",
                          ),
                        ],
                      ));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    var data = json.decode(json.encode(value));
                    // selectionBankId = data['bank']['id'].toString();
                    // selectionBankAccount =
                    //     data['bank']['account_number'].toString();
                    // print(data['bank']);
                  });
                },
              ),
            )
          ],
        ),
        const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: const Divider(
            color: Colors.grey,
            height: 2,
          ),
        ),
        Row(
          children: [
            Container(
              width: 90,
              margin: const EdgeInsets.only(left: 20),
              child: Text(
                'amount_tr'.translationWord(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.start,
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    setState(() {
                      if (val != '') {
                        chargeAmount.value =
                            rechargeFee(double.parse(val.replaceAll(',', '')));
                        val = _formatNumber(val.replaceAll(',', ''));
                        _amountController.value = TextEditingValue(
                          text: val,
                          selection:
                              TextSelection.collapsed(offset: val.length),
                        );
                      }
                    });
                  },
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: 'amount_tr'.translationWord(),
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                    contentPadding: const EdgeInsets.all(20),
                    border: InputBorder.none,
                  ),
                ),
              ),
            )
          ],
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: const Divider(
            color: Colors.grey,
            height: 2,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Text(
                'fee_tr'.translationWord() + ': ',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const Text(
                '1%',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Text(
                'charge_amount_tr'.translationWord() + ': ',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Obx(
                () => Text(
                  "${chargeAmount.value.ceil()}",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 200),
        GeregeButtonWidget(
          radius: 10.0,
          elevation: 0.0,
          minWidth: GlobalVariables.gWidth / 1.6,
          backgroundColor: CoreColor().btnBlue,
          borderColor: CoreColor().btnBlue,
          text: Text(
            'continue_btn_tr'.translationWord(),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            setState(() {
              if (selectionBankId != '' && _amountController.text != '') {
                if (int.parse(_amountController.text.replaceAll(',', '')) ==
                    0) {
                  Get.snackbar(
                    'warning_tr'.translationWord(),
                    '0 -c их дүн оруулна уу'.translationWord(),
                    colorText: Colors.black,
                    backgroundColor: Colors.white,
                  );
                } else {
                  print(selectionBankId);
                  hmacEncryp(selectionBankId);
                }
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
        ),
      ],
    );
  }

  accountListWidget() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30, right: 20, left: 20),
          decoration: BoxDecoration(
            color: CoreColor().backgroundWhite,
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Container(
            padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Банк',
                  style: TextStyle(),
                ),
                const Text(
                  'Худалдаа хөгжлийн банк',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "MBold",
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.3),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Дансны хуулга',
                  style: TextStyle(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '404279568',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "MBold",
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Clipboard.setData(
                            const ClipboardData(text: "404279568"));
                      },
                      child: Text(
                        'copy_tr'.translationWord(),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.3),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Хүлээн авагч',
                  style: TextStyle(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Gerege',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "MBold",
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Clipboard.setData(const ClipboardData(text: "Gerege"));
                      },
                      child: Text(
                        'copy_tr'.translationWord(),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.3),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Гүйлгээний утга',
                  style: TextStyle(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      GlobalVariables.phoneNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "MBold",
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(
                            text: GlobalVariables.phoneNumber.toString(),
                          ),
                        );
                      },
                      child: Text(
                        'copy_tr'.translationWord(),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          height: 130,
          width: GlobalVariables.gWidth,
          margin: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red,
                Colors.red.withOpacity(0.7),
              ],
              begin: const FractionalOffset(0.0, 1.0),
              end: const FractionalOffset(0.0, 0.0),
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 1,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'warning_tr'.translationWord(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: "MBold",
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  'account_warning_tr'.translationWord(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  withdrawModal() {
    _amountController.text = "";
    return showModalBottomSheet(
      // isDismissible: false,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      enableDrag: false,
      builder: (context) {
        return SizedBox(
          height: GlobalVariables.gHeight - 200,
          child: Obx(
            () => Column(
              children: [
                const SizedBox(height: 50),
                Text(
                  'withdraw_tr'.translationWord(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: "MBold",
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 60),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: const Divider(
                    color: Colors.grey,
                    height: 2,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 120,
                      margin: const EdgeInsets.only(left: 20, right: 10),
                      child: Text(
                        'bank_number_tr'.translationWord(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                        iconEnabledColor: Colors.grey,
                        iconDisabledColor: Colors.grey,
                        decoration: InputDecoration(
                          fillColor: CoreColor().backgroundBlue,
                          hintText: "",
                          enabledBorder: InputBorder.none,
                        ),
                        isExpanded: true,
                        hint: Text(
                          'select_bank'.translationWord(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                          ),
                        ),
                        items: accountList.map((value) {
                          return DropdownMenuItem(
                              value: value,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.account_balance,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "${value['account_number']}",
                                  ),
                                ],
                              ));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            var data = json.decode(json.encode(value));
                            print(data);
                            selectionBankId = data['bank']['id'].toString();
                            selectionBankAccount =
                                data['account_number'].toString();
                          });
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: const Divider(
                    color: Colors.grey,
                    height: 2,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 90,
                      margin: const EdgeInsets.only(left: 20),
                      child: Text(
                        'amount_tr'.translationWord(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.start,
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            setState(() {
                              if (val != '') {
                                chargeAmount.value = rechargeFee(
                                    double.parse(val.replaceAll(',', '')));
                                val = _formatNumber(val.replaceAll(',', ''));
                                _amountController.value = TextEditingValue(
                                  text: val,
                                  selection: TextSelection.collapsed(
                                      offset: val.length),
                                );
                              }
                            });
                          },
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: 'amount_tr'.translationWord(),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                            contentPadding: const EdgeInsets.all(20),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: const Divider(
                    color: Colors.grey,
                    height: 2,
                  ),
                ),
                const SizedBox(height: 200),
                GeregeButtonWidget(
                  radius: 10.0,
                  elevation: 0.0,
                  minWidth: GlobalVariables.gWidth / 1.6,
                  backgroundColor: CoreColor().btnBlue,
                  borderColor: CoreColor().btnBlue,
                  text: Text(
                    'withdraw_tr'.translationWord(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      if (selectionBankId != '' &&
                          _amountController.text != '') {
                        if (int.parse(
                                _amountController.text.replaceAll(',', '')) ==
                            0) {
                          Get.snackbar(
                            'warning_tr'.translationWord(),
                            '0 -c их дүн оруулна уу'.translationWord(),
                            colorText: Colors.black,
                            backgroundColor: Colors.white,
                          );
                        } else {
                          print(selectionBankId);
                          withDrawMoney();
                        }
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  rechargeFee(double amount) {
    double sum = 0;
    sum = amount + (amount / 99).floor() + 1;
    return sum;
  }
}
