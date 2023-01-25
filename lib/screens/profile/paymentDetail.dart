import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import '../../controller/entrance.dart';
import '../../global_players.dart';
import '../../helpers/backHelper.dart';
import '../../helpers/gvariables.dart';
import '../../helpers/working_net.dart';
import '../../style/color.dart';
import '../../widget/fundamental/btn.dart';
import '../../widget/web_view.dart';
import 'profile.dart';

class PaymentDetail extends StatefulWidget {
  const PaymentDetail({super.key});

  @override
  State<PaymentDetail> createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {
  final crowdlog = logger(PaymentDetail);
  int proBtnInx = Get.arguments as int;
  var auth = Get.find<EntranceCont>();

  @override
  void initState() {
    super.initState();
    getCartList();
    getBankAccounts();
  }

  //#region banc accs
  // removeAccountWidget(accountList[index]);
  List accountList = [];
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
  //#endregion

//#region Card
  RxList cartList = [].obs;
  var nameController = TextEditingController();
  var numberController = TextEditingController();
  late String invoice;
  late String redirectUrl;
  RxDouble chargeAmount = 0.0.obs;
  getCartList() {
    Services()
        .getRequest('${CoreUrl.crowdfund}wallet/card', true, '')
        .then((data) {
      GlobalPlayers.frontHelper.requestErrorSnackbar(data, 0, () {
        setState(() {
          if (data.body['result'].length != 0) {
            cartList.value = data.body['result']['items'];
          }
        });
      }, () {});
    });
  }

  cardDelete(id) {
    var bodyData = {
      "id": id.toString(),
    };
    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.crowdfund}wallet/card/delete', true, '')
        .then((data) {
      GlobalPlayers.frontHelper.requestErrorSnackbar(data, 0, () {
        getCartList();
      }, () {});
    });
  }

  createInvoice() {
    var bodyData = {};
    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.crowdfund}wallet/card/invoice', true, '')
        .then((data) {
      crowdlog.wtf(
          '---CREATE INVOICE---: sent data $bodyData:.................returned data ${data.body.toString()}');
      GlobalPlayers.frontHelper.requestErrorSnackbar(data, 0, () {
        invoice = data.body['result']['invoice'];
        redirectUrl = data.body["result"]["redirect_url"] +
            "/mn/" +
            data.body['result']['invoice'];
        Get.to(
          () => CallWebView(
            title: 'Карт холбох',
            initialUrl: redirectUrl,
            exitButton: true,
          ),
        );
      }, () {});
    });
  }

  //#endregion
  TextEditingController a = TextEditingController();
  double optionBtnsHeight = 0;
  GlobalKey<ScaffoldState> menuSidebarKeyPay = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return profileTop(
        menuSidebarKeyPay,
        optionBtnsHeight,
        proBtnInx,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Payment Details',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Text('Your Saved Cards',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CoreColor.mainPurple)),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cartList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 200,
                        width: GlobalVariables.gWidth - 50,
                        margin:
                            const EdgeInsets.only(top: 10, right: 20, left: 20),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                          image: DecorationImage(
                            image: NetworkImage(
                                "${CoreUrl.fileServer}${cartList[index]['bank']['img']}"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 10, right: 10),
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    cardDelete(cartList[index]['id']);
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
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 60),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: GlobalVariables.gWidth * .5,
                                    child: Text(
                                      cartList[index]['card_holder']
                                          .toString()
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                              margin:
                                  const EdgeInsets.only(left: 20, bottom: 20),
                              child: Text(
                                cartList[index]['card_number']
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
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            generalBtn(CoreColor.mainPurple, Colors.white, 'Add Card', () {
              createInvoice();
            }),
            Text('Your Saved Accounts',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CoreColor.mainPurple)),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: accountList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(
                          top: 10, right: 20, left: 20, bottom: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "${CoreUrl.fileServer}${accountList[index]['bank']['logo']}"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    accountList[index]['account_number']
                                        .toString()
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    accountList[index]['bank']['name']
                                        .toString()
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black.withOpacity(.4),
                                        width: 1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
                                child: IconButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {},
                                  icon: Icon(
                                    FontAwesomeIcons.pen,
                                    size: 18,
                                    color: Colors.black.withOpacity(.5),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                                255, 187, 12, 0)
                                            .withOpacity(.4),
                                        width: 1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
                                child: IconButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {},
                                  icon: Icon(
                                    FontAwesomeIcons.trash,
                                    size: 18,
                                    color: const Color.fromARGB(255, 196, 14, 1)
                                        .withOpacity(.5),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            ),
            generalBtn(
                CoreColor.mainPurple, Colors.white, 'Add Account', () {}),
          ],
        ), () {
      setState(() {
        optionBtnsHeight == 0 ? optionBtnsHeight = 450 : optionBtnsHeight = 0;
      });
    });
  }
}
