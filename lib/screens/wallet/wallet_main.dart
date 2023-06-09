import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:CrowdFund/dialogs/snacks.dart';
import 'package:CrowdFund/helpers/working_string.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../global_players.dart';
import '../../helpers/backHelper.dart';
import '../../helpers/gvariables.dart';
import '../../helpers/helperfuncs.dart';
import '../../helpers/working_net.dart';
import '../../style/color.dart';
import '../../widget/fundamental/btn.dart';
import '../profile/profile.dart';

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
  getTransactionList() async {}

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
        warningSnack(e.toString());
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
      GlobalPlayers.frontHelper.requestErrorSnackbar(data, 0, () {
        invoiceList.value = data.body['result'];
        setState(() {
          loader = false;
        });
      }, () {});
    });
  }

  invoiceCancel(id) async {
    var dataBody = {"id": id};
    Services()
        .postRequest(json.encode(dataBody),
            '${CoreUrl.crowdfund}wallet/invoice/cancel', true, '')
        .then((data) {
      GlobalPlayers.frontHelper.requestErrorSnackbar(data, 0, () {
        getInvoiceList();
      }, () {});
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
                      indicatorColor: CoreColor.mainPurple,
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
          generalBtn(CoreColor.mainPurple, CoreColor.mainPurple,
              'continue_btn_tr'.translationWord(), () {
            setState(() {
              if (selectedCard.isNotEmpty && _amountController.text != '') {
                if (int.parse(_amountController.text.replaceAll(',', '')) <=
                    499) {
                  warningSnack('500 -c их дүн оруулна уу');
                } else {
                  hmacEncryp(selectedCard.value);
                }
              } else {
                warningSnack('field_tr');
              }
            });
          }),
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
      GlobalPlayers.frontHelper.requestErrorSnackbar(data, 0, () {
        Get.back();
        Get.back();
        warningSnack(data.body['message']);
        GlobalVariables.accountBalance.value =
            GlobalVariables.accountBalance.value +
                int.parse(_amountController.text.replaceAll(',', ''));
      }, () {
        Navigator.of(Get.overlayContext!).pop();
      });
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
      GlobalPlayers.frontHelper.requestErrorSnackbar(data, 0, () {
        setState(() {
          accountList.value = data.body['result'];
          if (accountList.isNotEmpty) {
            selectedAccount.value = accountList[0];
          }
        });
      }, () {});
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
                  generalBtn(CoreColor.mainPurple, CoreColor.mainPurple,
                      'withdraw_tr'.translationWord(), () {
                    setState(() {
                      if (selectedAccount.isNotEmpty &&
                          _amountController.text != '') {
                        if (int.parse(
                                _amountController.text.replaceAll(',', '')) <=
                            499) {
                          warningSnack('500 -c их дүн оруулна уу');
                        } else {
                          withDrawMoney();
                        }
                      } else {
                        warningSnack('field_tr');
                      }
                    });
                  }),
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
      GlobalPlayers.frontHelper.requestErrorSnackbar(data, 0, () {
        Get.back();
        Get.back();
        successSnack(data.body['message'].toString());
        GlobalVariables.accountBalance.value =
            GlobalVariables.accountBalance.value -
                int.parse(_amountController.text.replaceAll(',', ''));
      }, () {
        Navigator.of(Get.overlayContext!).pop();
      });
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

  GlobalKey<ScaffoldState> menuSidebarKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            height: GlobalVariables.gHeight * .18,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Get.to(() => const Profile());
                  },
                  child: Stack(
                    //profile pic
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: CircleAvatar(
                            backgroundColor: CoreColor.backlightGrey,
                            backgroundImage: const NetworkImage(
                                'https://i.pinimg.com/564x/66/1e/3c/661e3c81c896137ea8b88f54dfebf55c.jpg'),
                            radius: 20),
                      ),
                      Positioned(
                          top: 30,
                          left: 30,
                          child: Container(
                              width: 22,
                              height: 22,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.3),
                                      blurRadius: 5,
                                      offset: const Offset(1, 1),
                                    )
                                  ]),
                              child: const Icon(
                                FontAwesomeIcons.bars,
                                size: 12,
                                color: Colors.white,
                              )))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          FontAwesomeIcons.rotateRight,
                          color: Colors.black,
                          size: Sizes.iconSize,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          FontAwesomeIcons.magnifyingGlass,
                          color: Colors.black,
                          size: Sizes.iconSize,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            //mongo
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: Obx(
              () => Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 10),
                width: 400,
                child: RichText(
                    text: TextSpan(
                        children: [
                      const TextSpan(
                        text: '₮',
                      ),
                      TextSpan(
                        text: _formatNumber(GlobalVariables.accountBalance.value
                            .toString()
                            .replaceAll(',', '')),
                      )
                    ],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 30,
                        ))),
              ),
            ),
          ),
          SizedBox(
            width: GlobalVariables.gWidth,
            child: Wrap(
              direction: Axis.horizontal,
              children: [
                const SizedBox(
                  width: 20,
                ),
                actionBtn('Receive', Icons.arrow_downward, () async {
                  await getWalletAccounts();
                  setState(() {
                    chargeModal();
                  });
                }),
                actionBtn('Send', Icons.arrow_upward, () async {
                  await getBankAccounts();
                  setState(() {
                    withdrawModal();
                  });
                }),
                actionBtn('fund', Icons.add_moderator, () async {
                  await getWalletAccounts();
                  setState(() {
                    chargeModal();
                  });
                }),
                actionBtn('borrow', FontAwesomeIcons.satelliteDish, () async {
                  await getWalletAccounts();
                  setState(() {
                    chargeModal();
                  });
                }),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          Expanded(
            child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 35,
                      child: TabBar(
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: Colors.black,
                          tabs: [
                            Tab(
                              child: Text(
                                'Fundings',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Tab(
                              child: Text('Transactions',
                                  style: TextStyle(color: Colors.black)),
                            )
                          ]),
                    ),
                    Expanded(
                        child: TabBarView(
                            children: [const Text('assets'), transation()]))
                  ],
                )),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
  //#region.............WIDGETS...............

  Widget actionBtn(String title, IconData icon, Function func) {
    return SizedBox(
      width: 70,
      height: 100,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => func(),
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: CoreColor.mainPurple),
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
              ),
            )
          ]),
    );
  }

  Widget transation() {
    return ListView.builder(
        //gvilgee list
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(0),
        itemCount: transactionDocument.length,
        itemBuilder: (BuildContext context, int index) {
          return transactionDocument.isEmpty
              ? const SizedBox()
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
                    margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
                    decoration: BoxDecoration(
                      color: CoreColor().backgroundWhite,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey.withOpacity(0.1),
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
                          color: CoreColor().backgroundBlue.withOpacity(0.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transactionDocument[index]['service_name'],
                            style: const TextStyle(
                              // fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            time(transactionDocument[index]['created_date']),
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
        });
  }
  //#endregion...............................
}
