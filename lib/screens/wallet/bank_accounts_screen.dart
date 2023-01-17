import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerege_app_v2/helpers/core_url.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/route_manager.dart';

import '../../helpers/services.dart';
import '../../widget/combos/appbar_squeare.dart';
import '../../widget/fundamental/btn.dart';

class BankAccountsScreen extends StatefulWidget {
  const BankAccountsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BankAccountsScreenState();
}

class _BankAccountsScreenState extends State<BankAccountsScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List bankList = [];
  List accountList = [];
  final TextEditingController accountNumber = TextEditingController();
  final TextEditingController money = TextEditingController();
  var bankId;

  @override
  void initState() {
    super.initState();
    getBankAccounts();
  }

  ///[removeAccount] bank account remove
  ///
  removeAccount(id) {
    var bodyData = {
      "id": id.toString(),
    };

    Services()
        .postRequest(bodyData, '${CoreUrl.crowdfund}wallet/bank/account/delete',
            true, '')
        .then((data) {
      // var res = json.decode(data.body);
      var res = data.body;
      if (res['message'] == 'success') {
        setState(() {
          Navigator.pop(context);
          Get.snackbar(
            'success_tr'.translationWord(),
            data.body['message'].toString(),
            colorText: Colors.black,
            backgroundColor: Colors.white,
          );
          getBankAccounts();
        });
      } else {
        Get.snackbar(
          'warning_tr'.translationWord(),
          res['message'].toString(),
          backgroundColor: Colors.white60,
          colorText: Colors.black,
        );
      }
    });
  }
  // removeAccount(item) {
  //   String url = '${CoreUrl.serviceUrl}/wallet/bank/account?id=$item';
  //   print(url);
  //   // print(item);
  //   Services().deleteRequest(url, true, '').then((data) {
  //     print('delete');
  //     print(data.body);
  //     if (data.statusCode == 200) {
  //       setState(() {
  //         Navigator.pop(context);
  //         Get.snackbar(
  //             'success_tr'.translationWord(), data.body['message'].toString(),
  //             colorText: Colors.black, backgroundColor: Colors.white);
  //         getBankAccounts();
  //       });
  //     } else {
  //       Get.snackbar(
  //         'warning_tr'.translationWord(),
  //         data.body['message'],
  //         colorText: Colors.white,
  //         backgroundColor: Colors.red.withOpacity(0.2),
  //       );
  //     }
  //   });
  // }

  /// [getBankAccounts] bank account list
  getBankList() async {
    Services()
        .getRequest('${CoreUrl.crowdfund}wallet/bank', true, '')
        .then((data) {
      if (data.body['message'] == "success") {
        setState(() {
          bankList = data.body['result'];
          addBankAccountWidget();
        });
      }
    });
  }

  /// [getBankAccounts] bank account list
  getBankAccounts() async {
    Services()
        .getRequest('${CoreUrl.crowdfund}wallet/bank/account', true, '')
        .then((data) {
      if (data.body['message'] == "success") {
        setState(() {
          accountList = data.body['result'];
        });
      }
    });
  }

  /// [addBankAccount] bank account add
  addBankAccount() {
    var bodyData = {
      "bank_id": bankId['id'].toString(),
      "account_number": accountNumber.text,
      "account_name": GlobalVariables.firstName
    };

    Services()
        .postRequest(
            bodyData, '${CoreUrl.crowdfund}wallet/bank/account', true, '')
        .then((data) {
      var res = data.body;
      if (data.statusCode == 200) {
        Get.snackbar(
          'success_tr'.translationWord(),
          res['message'].toString(),
          backgroundColor: Colors.white60,
          colorText: Colors.black,
        );
        Navigator.pop(context);
        getBankAccounts();
      } else {
        Get.snackbar(
          'warning_tr'.translationWord(),
          res['message'].toString(),
          backgroundColor: Colors.white60,
          colorText: Colors.black,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoreColor.hlprOrange,
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      drawerEdgeDragWidth: 0.0,
      appBar: AppbarSquare(
        title: 'Банкны данснууд',
        titleColor: Colors.white,
        leadingIcon: const SizedBox(),
        height: GlobalVariables.gWidth * .4,
        menuAction: () {
          Get.back();
        },
        color: CoreColor.hlprOrange,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        height: GlobalVariables.gHeight,
        width: GlobalVariables.gWidth,
        decoration: BoxDecoration(
          color: CoreColor().backgroundGrey,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
          ),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                print('zov huudas');
                setState(() {
                  getBankList();
                });
              },
              child: Container(
                height: 60,
                width: GlobalVariables.gWidth,
                margin: const EdgeInsets.only(top: 10, right: 25, left: 25),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0),
                      blurRadius: 1.0,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add_circle_outline,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: cartList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget cartList() {
    return ListView.builder(
        itemCount: accountList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {});
              print('dsdsdsd');
            },
            child: Container(
              height: 200,
              width: GlobalVariables.gWidth - 50,
              margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                image: DecorationImage(
                  image: NetworkImage(
                      "${CoreUrl.crowdfund}${accountList[index]['bank']['img']}"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10, right: 10),
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          removeAccountWidget(accountList[index]);
                        });
                      },
                      child: Icon(
                        Icons.delete,
                        size: 25,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          accountList[index]['account_name']
                              .toString()
                              .toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          '**/**',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    margin: const EdgeInsets.only(left: 20, bottom: 20),
                    child: Text(
                      accountList[index]['account_number']
                          .toString()
                          .toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  removeAccountWidget(data) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      builder: (context) {
        return SizedBox(
          height: GlobalVariables.keyboardIsVisible(context)
              ? GlobalVariables.gHeight / 1
              : GlobalVariables.gHeight / 2,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Банкны данс устгах',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: "MBold",
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: GlobalVariables.gWidth - 50,
                  margin: const EdgeInsets.only(left: 0, right: 0),
                  child: TextField(
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      hintText: "${data['bank']['name']}",
                      hintStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "MBold",
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(
                            color: CoreColor().backgroundBlue, width: 1.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(
                            color: CoreColor().backgroundBlue, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(
                            color: CoreColor().backgroundBlue, width: 1.0),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: GlobalVariables.gWidth - 50,
                  margin: const EdgeInsets.only(left: 0, right: 0),
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      hintText: "${data['account_number']}",
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "MBold",
                        color: Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(
                            color: CoreColor().backgroundBlue, width: 1.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(
                            color: CoreColor().backgroundBlue, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(
                            color: CoreColor().backgroundBlue, width: 1.0),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              generalBtn(CoreColor.mainPurple, CoreColor.mainPurple,
                  'delete_tr'.translationWord(), () {
                setState(() {
                  // ren(data['id']);
                  removeAccount(data['id']);
                });
              }),
            ],
          ),
        );
      },
    );
  }

  addBankAccountWidget() {
    bankId = null;
    accountNumber.text = '';
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      builder: (context) {
        return SizedBox(
          height: GlobalVariables.keyboardIsVisible(context)
              ? GlobalVariables.gHeight / 1.3
              : GlobalVariables.gHeight / 1.3,
          child: Stack(
            alignment: Alignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // const SizedBox(height: 20),
              Positioned(
                top: 20,
                left: 20,
                child: Text(
                  'add_account_tr'.translationWord(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "MBold",
                  ),
                ),
              ),
              // const SizedBox(height: 30),
              Positioned(
                top: 50,
                // left: 15,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: GlobalVariables.gWidth - 50,
                    margin: const EdgeInsets.only(left: 0, right: 0),
                    child: DropdownButtonFormField(
                      iconEnabledColor: CoreColor().backgroundBlue,
                      iconDisabledColor: CoreColor().backgroundBlue,
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        hintText: "",
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                              color: CoreColor().backgroundBlue, width: 1.0),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                              color: CoreColor().backgroundBlue, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                              color: CoreColor().backgroundBlue, width: 1.0),
                        ),
                      ),
                      isExpanded: true,
                      hint: Text('select_bank_tr'.translationWord()),
                      items: bankList.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text("${value['name']}"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // categoryValue = value.toString();
                        bankId = value;
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 130,
                // left: 15,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: GlobalVariables.gWidth - 50,
                    margin: const EdgeInsets.only(left: 0, right: 0),
                    child: TextFormField(
                      controller: accountNumber,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        hintText: "bank_number_tr".translationWord(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                              color: CoreColor().backgroundBlue, width: 1.0),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                              color: CoreColor().backgroundBlue, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                              color: CoreColor().backgroundBlue, width: 1.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 210,
                // left: 15,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: GlobalVariables.gWidth - 50,
                    margin: const EdgeInsets.only(left: 0, right: 0),
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        hintText: GlobalVariables.firstName,
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "MBold",
                          color: Colors.black,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                              color: CoreColor().backgroundBlue, width: 1.0),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                              color: CoreColor().backgroundBlue, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                              color: CoreColor().backgroundBlue, width: 1.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                // left: 0,
                // right: 0,
                child: Container(
                  width: GlobalVariables.gWidth,
                  height: 50,
                  alignment: Alignment.center,
                  child: generalBtn(CoreColor.mainPurple, CoreColor.mainPurple,
                      'save_tr'.translationWord(), () {
                    if (bankId != null && accountNumber.text != '') {
                      addBankAccount();
                    } else {
                      Get.snackbar(
                        'warning_tr'.translationWord(),
                        'field_tr'.translationWord(),
                        colorText: Colors.black,
                        backgroundColor: Colors.white,
                      );
                    }
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
