import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../helpers/core_url.dart';
import '../../helpers/gvariables.dart';
import '../../helpers/helperfuncs.dart';
import '../../helpers/logging.dart';
import '../../services/get_service.dart';
import '../../style/color.dart';
import '../../widget/appbar_squeare.dart';
import '../../widget/empty.dart';
import '../../widget/gerege_button.dart';
import '../home/wallet/invoice_screen.dart';
import 'bank_accounts_screen.dart';
import 'cart_screen.dart';

class WalletMain extends StatefulWidget {
  const WalletMain({super.key});

  @override
  State<WalletMain> createState() => _WalletMainState();
}

class _WalletMainState extends State<WalletMain> with TickerProviderStateMixin {
  final crowdlog = logger(_WalletMainState);

  bool loader = false;
  RxList invoiceList = [].obs;
  RxList transactionList = [].obs;
  RxList transactionDocument = [].obs;
  static const _locale = 'mn';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(double.parse(s));

//#region...........FUNCTIONS..............

  ///[getAccountBalance] wallet balance default account
  getAccountBalance() async {
    Services()
        .getRequest('${CoreUrl.crowdfund}wallet/account/balance', true, '')
        .then((data) {
      crowdlog.wtf('---LOGIN---:returned data ${data.body.toString()}');
      try {
        if (data.body['message'] == "success") {
          List result =
              data.body['result'].where((x) => x['is_default'] == 1).toList();
          GlobalVariables.accountBalance.value = result[0]['balance'];
        } else {
          GlobalVariables.accountBalance.value = 0;
        }
      } catch (e) {
        Get.snackbar(
          'warning_tr'.translationWord(),
          e.toString(),
          backgroundColor: Colors.white60,
          colorText: Colors.black,
        );
      }
    });
  }

  ///[getInvoiceList] get invoice list
  getInvoiceList() async {
    loader = true;

    Services()
        .getRequest('${CoreUrl.crowdfund}wallet/invoice', true, '')
        .then((data) {
      crowdlog.wtf('----INVOICE LIST---${data.body.toString()}');
      if (data.statusCode == 200) {
        invoiceList.value = data.body['result'];
        setState(() {
          loader = false;
        });
      } else {
        Get.snackbar(
          'warning_tr'.translationWord(),
          data.body['message'],
          colorText: Colors.black,
          backgroundColor: Colors.white,
        );
      }
    });
  }

  invoiceCancel(id) async {
    var dataBody = {"id": id};
    Services()
        .postRequest(json.encode(dataBody),
            '${CoreUrl.crowdfund}wallet/invoice/cancel', true, '')
        .then((data) {
      if (data.statusCode == 200) {
        Get.snackbar(
          'warning_tr'.translationWord(),
          data.body['message'],
          colorText: Colors.black,
          backgroundColor: Colors.white,
        );
        getInvoiceList();
      } else {
        Get.snackbar(
          'warning_tr'.translationWord(),
          data.body['message'],
          colorText: Colors.black,
          backgroundColor: Colors.white,
        );
      }
    });
  }

  /// [getWalletAccounts] wallet account list
  getWalletAccounts() async {
    Services()
        .getRequest('${CoreUrl.crowdfund}wallet/account/balance', true, '')
        .then((data) {
      if (data.body['message'] == "success") {
        setState(() {
          GlobalVariables.accountNoList = data.body['result'];
        });
      }
    });
  }

  //#region..........ЦЭНЭГЛЭХ..................
  RxDouble chargeAmount = 0.0.obs;
  late TabController tabContCharge;
  RxInt selectedIndexCharge = 0.obs;
  final TextEditingController _amountController = TextEditingController();
  chargeModal() {
    _amountController.text = "";
    chargeAmount.value = 0;
    return showModalBottomSheet(
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
          height: GlobalVariables.useTablet
              ? GlobalVariables.gHeight - 100
              : GlobalVariables.gHeight - 200,
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
                      indicatorColor: CoreColor.mainGreen,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      controller: tabContCharge,
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
                selectedIndexCharge.value == 0
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

//#region...........card section of CHARGE...............
  RxMap selectedCard = {}.obs;
  RxList cartList = [].obs;
  topupCart() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 50),
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
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: const SizedBox(
                      child: Text(
                        "Карт холбоогүй байна",
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    isExpanded: true,
                    value: selectedCard.value,
                    icon: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: const Icon(
                        Icons.keyboard_arrow_down_sharp,
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    onChanged: (value) {
                      setState(() {
                        selectedCard.value = value!;
                      });
                    },
                    items: cartList.map<DropdownMenuItem>(
                      (value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                "${value['card_number']}",
                              ),
                              Text(
                                "${value['bank']['name']}",
                              ),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  ),
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
                    "${chargeAmount.value.floor()}",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GlobalVariables.useTablet
              ? const SizedBox(height: 80)
              : const SizedBox(height: 200),
          GeregeButtonWidget(
            radius: 10.0,
            elevation: 0.0,
            minWidth: GlobalVariables.gWidth / 1.6,
            backgroundColor: CoreColor.mainGreen,
            borderColor: CoreColor().btnBlue,
            text: Text(
              'continue_btn_tr'.translationWord(),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              setState(() {
                if (selectedCard.isNotEmpty && _amountController.text != '') {
                  if (int.parse(_amountController.text.replaceAll(',', '')) <=
                      499) {
                    Get.snackbar(
                      'warning_tr'.translationWord(),
                      '500 -c их дүн оруулна уу'.translationWord(),
                      colorText: Colors.black,
                      backgroundColor: Colors.white,
                    );
                  } else {
                    hmacEncryp(selectedCard.value);
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
    );
  }

  rechargeFee(double amount) {
    double sum = 0;
    sum = amount + (amount / 99);
    return sum;
  }

  hmacEncryp(selected) {
    var hmackey = utf8.encode("Bm2#3Z8]HID(&Wt");

    String hmacValue = selected['id'].toString() +
        _amountController.text.replaceAll(',', '') +
        chargeAmount.value.floor().toString();

    var hmacSha256 = Hmac(sha256, hmackey); // HMAC-SHA256
    var digest = hmacSha256.convert(utf8.encode(hmacValue));
    var bodyData = {
      // "type": "charge",
      "hash": digest.toString(),
      "card_token_id": selected['id'].toString(),
      "card_no": selected['card_number'],
      "device_type": Platform.isAndroid == true ? 'android' : "ios",
      "amount": chargeAmount.value.floor(),
      "charge_percent": 1,
      "charge_amount": int.parse(_amountController.text.replaceAll(',', '')),
    };
    cardPay(bodyData);
  }

  cardPay(bodyData) {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.crowdfund}wallet/card/deposit', true, '')
        .then((data) {
      crowdlog.wtf(
          '---CARD PAY---: sent data $bodyData:.................returned data ${data.body.toString()}');
      if (data.statusCode == 200) {
        Get.back();
        Get.back();
        Get.snackbar(
          'warning_tr'.translationWord(),
          data.body['message'],
          colorText: Colors.black,
          backgroundColor: Colors.white,
        );
        GlobalVariables.accountBalance.value =
            GlobalVariables.accountBalance.value +
                int.parse(_amountController.text.replaceAll(',', ''));
      } else {
        Navigator.of(Get.overlayContext!).pop();

        Get.snackbar(
          'warning_tr'.translationWord(),
          data.body['message'],
          colorText: Colors.black,
          backgroundColor: Colors.white,
        );
      }
    });
  }

  //#endregion..........................
//#region...........account section of CHARGE.............
  accountListWidget() {
    return SingleChildScrollView(
      child: Column(
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
                        '404230754',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "MBold",
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Clipboard.setData(
                              const ClipboardData(text: "404230754"));
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
                          Clipboard.setData(
                              const ClipboardData(text: "Gerege"));
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
                        "TB-${GlobalVariables.accountNoList[0]['account_no']}",
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
                              text:
                                  "TB-${GlobalVariables.accountNoList[0]['account_no']}",
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
      ),
    );
  }
//#endregion........................
  //#endregion........................................

//#region..........ТАТАХ.............
  RxList accountList = [].obs;
  RxMap selectedAccount = {}.obs;

  /// [getBankAccounts] bank account list
  getBankAccounts() async {
    Services()
        .getRequest('${CoreUrl.crowdfund}wallet/bank/account', true, '')
        .then((data) {
      if (data.statusCode == 200) {
        setState(() {
          accountList.value = data.body['result'];
          if (accountList.isNotEmpty) {
            selectedAccount.value = accountList[0];
          }
        });
      }
    });
  }

  withdrawModal() {
    _amountController.text = "";
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
          height: GlobalVariables.useTablet
              ? GlobalVariables.gHeight - 100
              : GlobalVariables.gHeight - 200,
          child: Obx(
            () => SingleChildScrollView(
              child: Column(
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
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            hint: const SizedBox(
                              child: Text(
                                "Данс холбоогүй байна",
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            isExpanded: true,
                            value: selectedAccount.value,
                            icon: Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: const Icon(
                                Icons.keyboard_arrow_down_sharp,
                              ),
                            ),
                            style: const TextStyle(color: Colors.black),
                            onChanged: (value) {
                              setState(() {
                                selectedAccount.value = value!;
                              });
                            },
                            items: accountList.map<DropdownMenuItem>(
                              (value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      Text(
                                        "${value['account_number']}",
                                      ),
                                      Text(
                                        "${value['bank']['name']}",
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ).toList(),
                          ),
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
                  // bank hoorondiin shimtgel n TDB bol 100 busad n 200
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      "Банк хоорондын шимтгэл нь ХХБ бол \n100 бусад банк 200 төгрөгний шимтгэл авна",
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      softWrap: false,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  GlobalVariables.useTablet
                      ? const SizedBox(height: 50)
                      : const SizedBox(height: 160),
                  GeregeButtonWidget(
                    radius: 10.0,
                    elevation: 0.0,
                    minWidth: GlobalVariables.gWidth / 1.6,
                    backgroundColor: CoreColor.mainGreen,
                    borderColor: CoreColor.mainGreen,
                    text: Text(
                      'withdraw_tr'.translationWord(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        if (selectedAccount.isNotEmpty &&
                            _amountController.text != '') {
                          if (int.parse(
                                  _amountController.text.replaceAll(',', '')) <=
                              499) {
                            Get.snackbar(
                              'warning_tr'.translationWord(),
                              '500 -c их дүн оруулна уу'.translationWord(),
                              colorText: Colors.black,
                              backgroundColor: Colors.white,
                            );
                          } else {
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
          ),
        );
      },
    );
  }

  withDrawMoney() async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    var bodyData = {
      "bank_account_id": selectedAccount['id'].toString(),
      "account_number":
          GlobalVariables.accountNoList[0]['account_no'].toString(),
      "amount": int.parse(_amountController.text.replaceAll(',', ''))
    };

    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.crowdfund}wallet/withdraw', true, '')
        .then((data) {
      if (data.statusCode == 200) {
        // Get.back();
        Get.back();
        Get.back();
        Get.snackbar(
          'success_tr'.translationWord(),
          data.body['message'].toString().translationWord(),
          colorText: Colors.black,
          backgroundColor: Colors.white,
        );

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
//#endregion.....................

//#endregion......................
  @override
  void initState() {
    super.initState();

    tabContCharge = TabController(
      initialIndex: 0,
      length: 2, //1,
      vsync: this,
    );
    tabContCharge.addListener(() {
      setState(() {
        selectedIndexCharge.value = tabContCharge.index;
      });
    });

    getAccountBalance();
  }

  @override
  void dispose() {
    tabContCharge.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarSquare(
        height: GlobalVariables.gWidth * .4,
        leadingIcon: const Icon(
          FontAwesomeIcons.chevronLeft,
          color: Colors.white,
          size: 18,
        ),
        menuAction: () {
          Get.back();
        },
        titleColor: Colors.white,
        color: CoreColor.mainGreen,
        title: 'Хэтэвч',
      ),
      body: Column(
        children: [
          SizedBox(
            //gvilgee
            height: GlobalVariables.gHeight * .3 + 15,
            child: Stack(
              children: [
                Container(
                  height: GlobalVariables.gHeight * .3,
                  decoration: BoxDecoration(
                    color: CoreColor().btnGrey,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        // height: 30,
                        padding: const EdgeInsets.only(left: 20, right: 20),
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
                            child: SizedBox(
                              height: 200,
                              child: ListView.builder(
                                  //gvilgee list
                                  padding: const EdgeInsets.all(0),
                                  itemCount: transactionDocument.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return transactionDocument.isEmpty
                                        ? isEmptyData("doc_empty_tr")
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                // Get.to(
                                                //   () => CallWebView(
                                                //     title: "Баримт",
                                                //     initialUrl:
                                                //         "https://insurance.gerege.mn/barimt/?invoice_id=${transactionDocument[index]['invoice_id']}&type=1&request_user_id=${GlobalVariables.id}&app_id=6601",
                                                //     exitButton: false,
                                                //   ),
                                                // );
                                              });
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10, right: 20, left: 20),
                                              decoration: BoxDecoration(
                                                color:
                                                    CoreColor().backgroundWhite,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                                border: Border.all(
                                                  width: 1,
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                ),
                                                // boxShadow: [
                                                //   BoxShadow(
                                                //     color: Colors.grey.withOpacity(0.1),
                                                //     spreadRadius: 2,
                                                //     blurRadius: 1,
                                                //     offset:
                                                //         const Offset(0, 1), // changes position of shadow
                                                //   ),
                                                // ],
                                              ),
                                              child: ListTile(
                                                leading: Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: CoreColor()
                                                        .backgroundBlue
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10.0)),
                                                  ),
                                                ),
                                                trailing: Text(
                                                  // "${moneyFormat(transactionDocument[index]['amount'].toString())}₮",
                                                  // "${transactionDocument[index]['amount']}₮",
                                                  "${_formatNumber(transactionDocument[index]['amount'] == null ? "0" : transactionDocument[index]['amount'].toString().replaceAll(',', ''))}₮",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "MBold",
                                                  ),
                                                ),
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      transactionDocument[index]
                                                          ['service_name'],
                                                      style: const TextStyle(
                                                        // fontWeight: FontWeight.w500,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      time(transactionDocument[
                                                              index]
                                                          ['created_date']),
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                  }),
                            )),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CoreColor.mainGreen,
                    ),
                    width: 30,
                    height: 30,
                    child: const Icon(
                      FontAwesomeIcons.chevronDown,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            //wallet
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  color: CoreColor.mainGreen.withOpacity(.2)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 20),
                      const Text(
                        'Хэтэвч:',
                        style: TextStyle(fontSize: 20),
                      ),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              width: 200,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  _formatNumber(GlobalVariables
                                      .accountBalance.value
                                      .toString()
                                      .replaceAll(',', '')),
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      height: 1),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: const Text(
                                '₮',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      whiteBtn('картууд', FontAwesomeIcons.creditCard, () {
                        Get.to(() => const CartScreen());
                      }),
                      whiteBtn('Банкны данс', FontAwesomeIcons.buildingColumns,
                          () {
                        Get.to(() => const BankAccountsScreen());
                      }),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              actionBtn('цэнэглэх', CoreColor.mainGreen, () async {
                await getWalletAccounts();
                setState(() {
                  chargeModal();
                });
              }),
              actionBtn('татах', CoreColor.hlprOrange, () async {
                await getBankAccounts();
                setState(() {
                  withdrawModal();
                });
              }),
            ],
          )
        ],
      ),
    );
  }
  //#region.............WIDGETS...............

  Widget whiteBtn(String title, IconData icon, Function func) {
    return InkWell(
      onTap: () => func(),
      child: Container(
          padding:
              const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.all(Radius.circular(15))),
          child: Row(children: [
            Icon(
              icon,
              size: 15,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(title)
          ])),
    );
  }

  Widget actionBtn(String title, Color clr, Function func) {
    return InkWell(
      onTap: () => func(),
      child: Container(
        padding:
            const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
        width: GlobalVariables.gWidth * .5,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: clr),
        child: Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }

  //#endregion...............................
}
