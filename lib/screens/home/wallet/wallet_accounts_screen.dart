import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/core_url.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/services/get_service.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:gerege_app_v2/widget/back_bar.dart';
import 'package:get/route_manager.dart';

class WalletAccountsScreen extends StatefulWidget {
  const WalletAccountsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WalletAccountsScreenState();
}

class _WalletAccountsScreenState extends State<WalletAccountsScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List accountList = [];

  @override
  void initState() {
    super.initState();
    getWalletAccounts();
  }

  /// [getWalletAccounts] wallet account list
  getWalletAccounts() async {
    Services()
        .getRequest('${CoreUrl.serviceUrl}wallet/account/balance', true, '')
        .then((data) {
      if (data.body['message'] == "success") {
        setState(() {
          accountList = data.body['result'];
          print(accountList);
        });
      }
    });
  }

  /// [addBankAccount] bank account add
  addGeregeAccount() {
    var bodyData = {};
    print(bodyData);

    Services()
        .postRequest(bodyData, '${CoreUrl.serviceUrl}wallet/account', true, '')
        .then((data) {
      // var res = json.decode(data.body);
      print('burtgel res');
      var res = data.body;
      if (res['message'] == 'success') {
        Get.snackbar(
          'success_tr'.translationWord(),
          res['message'].toString(),
          backgroundColor: Colors.white60,
          colorText: Colors.black,
        );
        getWalletAccounts();
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

  defaultAccount(id) {
    var bodyData = {};

    Services()
        .postRequest(
            bodyData,
            '${CoreUrl.serviceUrl}wallet/account/default?account_no=$id',
            true,
            '')
        .then((data) {
      // var res = json.decode(data.body);
      print('defaultAccount');
      var res = data.body;
      if (res['message'] == 'success') {
        Get.snackbar(
          'success_tr'.translationWord(),
          res['message'].toString(),
          backgroundColor: Colors.white60,
          colorText: Colors.black,
        );
        getWalletAccounts();
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
      backgroundColor: CoreColor().backgroundBlue,
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      drawerEdgeDragWidth: 0.0,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(65), // Set this height
        child: BackAppBar(titleText: 'gerege_account_tr'),
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
            // InkWell(
            //   onTap: () {
            //     setState(() {
            //       print('click');
            //       addGeregeAccount();
            //     });
            //   },
            //   child: Container(
            //     height: 60,
            //     width: GlobalVariables.gWidth,
            //     margin: const EdgeInsets.only(top: 10, right: 25, left: 25),
            //     decoration: const BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.all(Radius.circular(8.0)),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.grey,
            //           offset: Offset(0.0, 1.0),
            //           blurRadius: 1.0,
            //         ),
            //       ],
            //     ),
            //     child: const Icon(
            //       Icons.add_circle_outline,
            //       size: 50,
            //       color: Colors.grey,
            //     ),
            //   ),
            // ),
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
              setState(() {
                print('sda');
                print(accountList[index]);
              });
            },
            child: Container(
              height: 200,
              width: GlobalVariables.gWidth - 50,
              margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                gradient: LinearGradient(
                  colors: [
                    CoreColor().backgroundBlue,
                    CoreColor().backgroundBlue.withOpacity(0.7),
                  ],
                  begin: const FractionalOffset(0.0, 1.0),
                  end: const FractionalOffset(0.0, 0.0),
                  stops: const [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Container(
                      //   padding: const EdgeInsets.only(top: 10, right: 10),
                      //   alignment: Alignment.topRight,
                      //   child: InkWell(
                      //     onTap: () {
                      //       setState(() {
                      //         print('delete');
                      //         deleteGeregeAccount(
                      //             accountList[index]['account_no']);
                      //       });
                      //     },
                      //     child: Icon(
                      //       Icons.delete,
                      //       size: 25,
                      //       color: Colors.white.withOpacity(0.5),
                      //     ),
                      //   ),
                      // ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, right: 10),
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              defaultAccount(accountList[index]['account_no']);
                            });
                          },
                          child: Icon(
                            Icons.star,
                            size: 25,
                            color: accountList[index]['is_default'] == 1
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Text(
                      "ГЭРЭГЭ СИСТЕМС".toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "MBold",
                        fontSize: 18,
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
                          accountList[index]['label'].toString().toUpperCase(),
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
                      accountList[index]['account_no'].toString().toUpperCase(),
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
}
