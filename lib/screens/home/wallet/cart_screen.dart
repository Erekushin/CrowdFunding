import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/core_url.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/screens/home/wallet/wallet_info.dart';
import 'package:gerege_app_v2/services/get_service.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:gerege_app_v2/widget/web_view.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  RxList cartList = [].obs;
  var nameController = TextEditingController();
  var numberController = TextEditingController();
  late String invoice;
  late String redirectUrl;
  RxDouble chargeAmount = 0.0.obs;

  @override
  void initState() {
    super.initState();
    getCartList();
  }

  getCartList() {
    Services()
        .getRequest('${CoreUrl.serviceUrl}wallet/card', true, '')
        .then((data) {
      if (data.statusCode == 200) {
        setState(() {
          if (data.body['result'].length != 0) {
            cartList.value = data.body['result']['items'];
          }
        });
      }
    });
  }

  cardDelete(id) {
    var bodyData = {
      "id": id.toString(),
    };
    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.serviceUrl}wallet/card/delete', true, '')
        .then((data) {
      if (data.statusCode == 200) {
        // Get.back();
        Get.snackbar(
          'warning_tr'.translationWord(),
          data.body['message'],
          colorText: Colors.black,
          backgroundColor: Colors.white,
        );
        getCartList();
      } else {
        Get.snackbar(
          'warning_tr'.translationWord(),
          data.body['message'].toString(),
          colorText: Colors.black,
          backgroundColor: Colors.white,
        );
      }
    });
  }

  createInvoice() {
    var bodyData = {};
    Services()
        .postRequest(json.encode(bodyData),
            '${CoreUrl.serviceUrl}wallet/card/invoice', true, '')
        .then((data) {
      if (data.statusCode == 200) {
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
      } else {
        Get.snackbar(
          'warning_tr'.translationWord(),
          data.body['message'],
          backgroundColor: Colors.white60,
          colorText: Colors.black,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoreColor().btnGrey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.to(() => const WalletInfoScreen());
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
          'cart_tr'.translationWord(),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              createInvoice();
            },
            child: Container(
              height: 60,
              margin: const EdgeInsets.only(left: 20, right: 20),
              width: GlobalVariables.gWidth,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Colors.white,
              ),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'add_cart_tr'.translationWord(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: cartListWidget(),
          ),
        ],
      ),
    );
  }

  Widget cartListWidget() {
    return ListView.builder(
        itemCount: cartList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              height: 200,
              width: GlobalVariables.gWidth - 50,
              margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                image: DecorationImage(
                  image: NetworkImage(
                      "${CoreUrl.fileServer}${cartList[index]['bank']['img']}"),
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
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          cartList[index]['card_holder']
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
                      cartList[index]['card_number'].toString().toUpperCase(),
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
