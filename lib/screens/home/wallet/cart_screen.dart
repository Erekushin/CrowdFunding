import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:gerege_app_v2/widget/gerege_button.dart';
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

  @override
  void initState() {
    super.initState();
    // getCartList();
  }

  // getCartList() {
  //   var bodyData = {};
  //   Services()
  //       .postRequest(
  //           json.encode(bodyData), '${CoreUrl.serviceUrl}/txn/card/list', true)
  //       .then((data) {
  //     var res = json.decode(data.body);
  //     if (res['code'] == 200) {
  //       setState(() {
  //         cartList.value = res['result']['items'];
  //         print(cartList);
  //       });
  //     }
  //   });
  // }

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
          'cart_tr'.translationWord(),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          cartListWidget(),
        ],
      ),
    );
  }

  Widget cartListWidget() {
    return Column(
      children: [
        for (var items in cartList)
          // SizedBox(

          //   child: Stack(
          //     children: [
          //       Positioned(
          //         child: Image.network(
          //           CoreUrl.fileServer + items['bank']['img'],
          //           fit: BoxFit.fitWidth,
          //         ),
          //       ),
          //       Positioned.fill(
          //         top: 50,
          //         child: Text(
          //           '${items['card_number']}',
          //           style: const TextStyle(
          //             color: Colors.white,
          //             fontSize: 16,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            height: 120,
            margin: const EdgeInsets.all(20),
            width: GlobalVariables.gWidth,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              // image: DecorationImage(
              //   fit: BoxFit.fill,
              //   image: NetworkImage(
              //     CoreUrl.fileServer + items['bank']['img'],
              //   ),
              // ),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 22),
                  child: Text(
                    '${items['card_holder']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${items['card_number']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 5),
        InkWell(
          onTap: () {
            addCart();
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
      ],
    );
  }

  addCart() {
    numberController.text = "";
    nameController.text = "";
    return showModalBottomSheet(
      isDismissible: false,
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      builder: (context) {
        return SizedBox(
          height: GlobalVariables.gHeight,
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                  const SizedBox(width: 100),
                  Text(
                    'add_cart_tr'.translationWord(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: "MBold",
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),
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
                      'cart_holder_tr'.translationWord(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: TextField(
                        autofocus: false,
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: 'cart_holder_tr'.translationWord(),
                          hintStyle: const TextStyle(
                            color: Colors.black,
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
                      'cart_num_tr'.translationWord(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: TextField(
                        controller: numberController,
                        autofocus: false,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: 'cart_num_tr'.translationWord(),
                          hintStyle: const TextStyle(
                            color: Colors.black,
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
                  'add_tr'.translationWord(),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    if (nameController.text != '' &&
                        numberController.text != '') {
                      print('ene bolje');
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
      },
    );
  }
}
