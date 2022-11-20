import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/core_url.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/screens/home/wallet/money_screen.dart';
import 'package:gerege_app_v2/screens/home/wallet/wallet_info.dart';
import 'package:gerege_app_v2/services/get_service.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:gerege_app_v2/widget/gerege_button.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  int selectedIndex = 0;
  RxBool hideMoney = true.obs;
  RxList transactionList = [].obs;
  RxList transactionDocument = [].obs;
  RxList invoiceList = [].obs;
  static const _locale = 'mn';
  bool loader = false;
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(double.parse(s));
  var storage = GetStorage();

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );

    tabController.addListener(() {
      setState(() {
        if (tabController.indexIsChanging) {
          print(
              "tab is animating. from active (getting the index) to inactive(getting the index) ");
        } else {
          print(tabController.index);
          selectedIndex = tabController.index;
        }
      });
    });

    getAccountBalance();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  ///[getAccountBalance] wallet balance default account
  getAccountBalance() async {
    Services()
        .getRequest('${CoreUrl.serviceUrl}wallet/account/balance', true, '')
        .then((data) {
      print(data.body);
      if (data.body['message'] == "success") {
        List result =
            data.body['result'].where((x) => x['is_default'] == 1).toList();
        GlobalVariables.accountBalance.value = result[0]['balance'];
      } else {
        GlobalVariables.accountBalance.value = 0;
      }
    });
  }

  moneyFormat(String price) {
    if (price.length >= 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoreColor().btnGrey,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            height: 140,
            // padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: CoreColor().backgroundBlue,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      print('money');
                      Get.to(() => const MoneyScreen());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.money,
                          color: Colors.white,
                          size: 60,
                        ),
                        Text(
                          'money_tr'.translationWord(),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      print('wallet');
                      Get.to(() => const WalletInfoScreen());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.wallet,
                          color: Colors.white,
                          size: 60,
                        ),
                        Text(
                          'wallet_tr'.translationWord(),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _formatNumber(GlobalVariables
                                    .accountBalance.value
                                    .toString()
                                    .replaceAll(',', '')),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
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
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: GlobalVariables.gHeight,
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
                      child: TabBar(
                        indicatorColor: CoreColor().backgroundButton,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        controller: tabController,
                        labelStyle: const TextStyle(
                          fontSize: 13,
                          fontFamily: "MRegular",
                        ),
                        tabs: [
                          Tab(
                            text: 'transaction_tr'.translationWord(),
                          ),
                          Tab(
                            text: 'invoices_tr'.translationWord(),
                          ),
                          Tab(
                            text: 'documents_tr'.translationWord(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  selectedIndex == 0
                      ? Expanded(
                          child: loader == true
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: CoreColor().backgroundBtnBlue,
                                  ),
                                )
                              : Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: documentListWidget(),
                                ),
                        )
                      : selectedIndex == 1
                          ? Expanded(
                              child: loader == true
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: CoreColor().backgroundBtnBlue,
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: getInvoiceListWidget(),
                                    ),
                            )
                          : Expanded(
                              child: loader == true
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: CoreColor().backgroundBtnBlue,
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: transactionListWidget(),
                                    ),
                            )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget isEmptyData(String text) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            color: CoreColor().backgroundBlue,
            size: 55,
          ),
          const SizedBox(height: 10),
          Text(
            text.translationWord(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          )
        ],
      ),
    );
  }

  transactionListWidget() {
    return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        itemCount: transactionList.length,
        itemBuilder: (BuildContext context, int index) {
          return transactionList.isEmpty
              ? isEmptyData("doc_empty_tr")
              : InkWell(
                  onTap: () {
                    transactionDetail(transactionList[index]);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
                    decoration: BoxDecoration(
                      color: CoreColor().backgroundWhite,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(0.1),
                      //     spreadRadius: 2,
                      //     blurRadius: 1,
                      //     offset:
                      //         const Offset(0, 1), // changes position of shadow
                      //   ),
                      // ],
                      border: Border.all(
                        width: 1,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: transactionList[index]['tran_type'] == "C"
                              ? CoreColor().backgroundRedOp
                              : CoreColor().backgroundGreenOp,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Icon(
                          transactionList[index]['tran_type'] == "C"
                              ? Icons.arrow_upward
                              : Icons.arrow_downward_outlined,
                          color: transactionList[index]['tran_type'] == "C"
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                      trailing: Text(
                        transactionList[index]['tran_type'] == "C"
                            ? "-${_formatNumber(transactionList[index]['amount'].toString().replaceAll(',', ''))}₮"
                            : "+${_formatNumber(transactionList[index]['amount'].toString().replaceAll(',', ''))}₮",
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
                            transactionList[index]['tran_type'] == "C"
                                ? "expense_tr".translationWord()
                                : "income_tr".translationWord(),
                            style: const TextStyle(
                              // fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            time(transactionList[index]['created_date']),
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

  Widget getInvoiceListWidget() {
    return Obx(
      () => ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: invoiceList.length,
          itemBuilder: (BuildContext context, int index) {
            return invoiceList.isEmpty
                ? isEmptyData("doc_empty_tr")
                : InkWell(
                    onTap: () {
                      print(invoiceList[index]);
                      invoiceDetail(invoiceList[index]);
                    },
                    child: Container(
                      margin:
                          const EdgeInsets.only(top: 10, right: 20, left: 20),
                      decoration: BoxDecoration(
                        color: CoreColor().backgroundWhite,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(
                          width: 1,
                          color: Colors.grey.withOpacity(0.1),
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color:
                                invoiceList[index]['list_type'] == 'RECEIVE' &&
                                        invoiceList[index]['status'] == "NEW"
                                    ? CoreColor().backgroundRedOp
                                    : CoreColor().backgroundGreenOp,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Icon(
                            invoiceList[index]['list_type'] == 'SEND'
                                ? Icons.send
                                : invoiceList[index]['status'] == "PAID"
                                    ? Icons.check
                                    : Icons.arrow_downward_rounded,
                            color: invoiceList[index]['list_type'] == 'SEND'
                                ? Colors.green
                                : invoiceList[index]['status'] == 'NEW'
                                    ? Colors.red
                                    : Colors.green,
                          ),
                        ),
                        trailing: Text(
                          "${_formatNumber(invoiceList[index]['total_amount'].toString().replaceAll(',', ''))}₮",
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
                            Row(
                              children: [
                                Text(
                                  invoiceList[index]['list_type'] == "RECEIVE"
                                      ? invoiceList[index]['src_user']
                                                  ['last_name']
                                              .toString()
                                              .capitalizeCustom() +
                                          " " +
                                          invoiceList[index]['src_user']
                                                  ['first_name']
                                              .toString()
                                              .capitalizeCustom()
                                      : invoiceList[index]['dest_user']
                                                  ['last_name']
                                              .toString()
                                              .capitalizeCustom() +
                                          " " +
                                          invoiceList[index]['dest_user']
                                                  ['first_name']
                                              .toString()
                                              .capitalizeCustom(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            invoiceList[index]['list_type'] == "RECEIVE"
                                ? invoiceList[index]['status'] == "PAID"
                                    ? Row(
                                        children: [
                                          Text(
                                            time(
                                                invoiceList[index]['due_date']),
                                            style: const TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                          const Text(
                                            " - Илгээсэн мөнгө",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Text(
                                            time(
                                                invoiceList[index]['due_date']),
                                            style: const TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                          const Text(
                                            " - Ирсэн нэхэмжлэх",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      )
                                : Row(
                                    children: [
                                      Text(
                                        time(invoiceList[index]['due_date']),
                                        style: const TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                      invoiceList[index]['list_type'] ==
                                                  "SEND" &&
                                              invoiceList[index]['status'] ==
                                                  "PAID"
                                          ? const Text(
                                              " - Ирсэн мөнгө",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.green,
                                              ),
                                            )
                                          : const Text(
                                              " - Илгээсэн нэхэмжлэх",
                                              style: TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                    ],
                                  )
                          ],
                        ),
                      ),
                    ),
                  );
          }),
    );
  }

  String time(date) {
    var dateValue = DateFormat("yyyy-MM-ddTHH:mm:ss").parseUTC(date);
    String formattedDate = DateFormat("yyyy/MM/dd").format(dateValue);
    return formattedDate;
  }

  String time2(date) {
    var dateValue = DateFormat("yyyy-MM-dd HH:mm:ss").parseUTC(date);
    String formattedDate = DateFormat("yyyy/MM/dd").format(dateValue);
    return formattedDate;
  }

  Widget documentListWidget() {
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: transactionDocument.length,
        itemBuilder: (BuildContext context, int index) {
          return transactionDocument.isEmpty
              ? isEmptyData("doc_empty_tr")
              : InkWell(
                  onTap: () {
                    setState(() {
                      print(
                          "https://insurance.gerege.mn/barimt/?invoice_id=${transactionDocument[index]['invoice_id']}&type=1&request_user_id=${GlobalVariables.id}&app_id=6601");
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
                            time2(transactionDocument[index]['created_date']),
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

  transactionDetail(detail) {
    print("dotorodsadn asjdn asj : $detail");
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: false,
      builder: (context) {
        return SizedBox(
          height: GlobalVariables.gHeight / 2.2,
          child: Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: detail['tran_type'] == "C"
                        ? CoreColor().backgroundRedOp
                        : CoreColor().backgroundGreenOp,
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Icon(
                    detail['tran_type'] == "C"
                        ? Icons.arrow_upward
                        : Icons.arrow_downward_outlined,
                    size: 40,
                    color:
                        detail['tran_type'] == "C" ? Colors.red : Colors.green,
                  ),
                ),

                const SizedBox(height: 20),
                detail['tran_type'] == "D"
                    ? Text(
                        'income_tr'.translationWord(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: "MBold",
                          fontSize: 18,
                        ),
                      )
                    : Text(
                        'expense_tr'.translationWord(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: "MBold",
                          fontSize: 18,
                        ),
                      ),
                //   const SizedBox(height: 10),
                Text(
                  time(detail['created_date']),
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  height: 2,
                  color: Colors.grey.withOpacity(0.2),
                ),
                const SizedBox(height: 10),
                Text(
                  detail['bank_name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${moneyFormat(detail['amount'].toString())}₮",
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 35,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 2,
                  color: Colors.grey.withOpacity(0.2),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  invoiceDetail(detail) {
    print("dotorodsadn asjdn asj : $detail");
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: false,
      builder: (context) {
        return SizedBox(
          height: GlobalVariables.gHeight / 1.5,
          child: Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                // detail['list_type'] == "SEND" && detail['status'] == "PAID"
                //     ? Text(
                //         'paid_tr'.translationWord(),
                //         textAlign: TextAlign.center,
                //         style: const TextStyle(
                //           color: Colors.black,
                //           fontWeight: FontWeight.bold,
                //           fontFamily: "MBold",
                //           fontSize: 18,
                //         ),
                //       )

                //     // 'Нэхэмжлэл хүлээлгийн \n төлөвт байна'
                //     : detail['status'] == "NEW"
                //         ? Text(
                //             'invoice_note_tr'.translationWord(),
                //             textAlign: TextAlign.center,
                //             style: const TextStyle(
                //               color: Colors.black,
                //               fontWeight: FontWeight.bold,
                //               fontFamily: "MBold",
                //               fontSize: 18,
                //             ),
                //           )
                //         : Text(
                //             'paid_tr'.translationWord(),
                //             textAlign: TextAlign.center,
                //             style: const TextStyle(
                //               color: Colors.black,
                //               fontWeight: FontWeight.bold,
                //               fontFamily: "MBold",
                //               fontSize: 18,
                //             ),
                //           ),
                // const SizedBox(height: 10),
                // Text(
                //   time(detail['due_date']),
                //   style: const TextStyle(
                //     fontSize: 12,
                //   ),
                // ),
                // const SizedBox(height: 40),
                // Container(
                //   height: 2,
                //   color: Colors.grey.withOpacity(0.2),
                // ),
                const SizedBox(height: 30),
                detail['list_type'] == "SEND" && detail['status'] == "PAID"
                    ? Container(
                        alignment: Alignment.center,
                        child: Text(
                          'paid_tr'.translationWord(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "MBold",
                            fontSize: 18,
                          ),
                        ),
                      )

                    // 'Нэхэмжлэл хүлээлгийн \n төлөвт байна'
                    : detail['status'] == "NEW"
                        ? Container(
                            alignment: Alignment.center,
                            child: Text(
                              'invoice_note_tr'.translationWord(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: "MBold",
                                fontSize: 18,
                              ),
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            child: Text(
                              'paid_tr'.translationWord(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: "MBold",
                                fontSize: 18,
                              ),
                            ),
                          ),
                const SizedBox(height: 10),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    detail['list_type'] == "SEND" && detail['status'] == "PAID"
                        ? Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: CoreColor().backgroundGreenOp,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: CoreColor().backgroundRedOp,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: const Icon(
                              Icons.arrow_downward_outlined,
                              color: Colors.red,
                            ),
                          ),
                    const SizedBox(width: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const Spacer(),
                        Text(
                          "${moneyFormat(detail['total_amount'].toString())}₮",
                          style: const TextStyle(
                            // fontWeight: FontWeight.w400,
                            fontSize: 35,
                          ),
                        ),
                        Text(
                          time(detail['due_date']),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 30),
                Container(
                  height: 2,
                  color: Colors.grey.withOpacity(0.2),
                ),
                const SizedBox(height: 10),
                detail['list_type'] == "RECEIVE"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(35.0),
                          //   child: detail['src_user']['picture'] == ""
                          //       ? Container(
                          //           color: Colors.grey.withOpacity(0.5),
                          //           width: 60,
                          //           height: 60,
                          //         )
                          //       : Image.network(
                          //           CoreUrl.fileServer +
                          //               detail['src_user']['picture'],
                          //           height: 60.0,
                          //           width: 60.0,
                          //         ),
                          // ),
                          Container(
                            color: Colors.grey.withOpacity(0.5),
                            width: 60,
                            height: 60,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            "${detail['src_user']['last_name'] + " " + detail['src_user']['first_name']}"
                                .toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            color: Colors.grey.withOpacity(0.5),
                            width: 60,
                            height: 60,
                          ),
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(35.0),
                          //   child: CoreUrl.fileServer +
                          //               detail['dest_user']['picture'] ==
                          //           ""
                          //       ? Container(
                          //           color: Colors.grey.withOpacity(0.5),
                          //           width: 60,
                          //           height: 60,
                          //         )
                          //       : Image.network(
                          //           CoreUrl.fileServer +
                          //               detail['dest_user']['picture'],
                          //           height: 60.0,
                          //           width: 60.0,
                          //         ),
                          // ),
                          const SizedBox(width: 20),
                          Text(
                            "${detail['dest_user']['last_name'] + " " + detail['dest_user']['first_name']}"
                                .toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Text(
                      'note_tr'.translationWord() + ": ",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${detail['description']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "MBold",
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                detail['status'] == "PAID" || detail['list_type'] == 'SEND'
                    ? Container()
                    : Container(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GeregeButtonWidget(
                              height: 50,
                              radius: 15.0,
                              minWidth: GlobalVariables.gWidth / 3,
                              backgroundColor: Colors.red,
                              borderColor: Colors.red,
                              text: Text(
                                'cancel_tr'.translationWord(),
                                style: const TextStyle(),
                              ),
                              onPressed: () {
                                setState(() {
                                  Get.back();
                                });
                              },
                            ),
                            const SizedBox(width: 20),
                            GeregeButtonWidget(
                              height: 50,
                              radius: 15.0,
                              minWidth: GlobalVariables.gWidth / 3,
                              backgroundColor: Colors.green,
                              borderColor: Colors.green,
                              text: Text(
                                'payment_code_tr'.translationWord(),
                                style: const TextStyle(),
                              ),
                              onPressed: () {
                                setState(() {
                                  // print(detail['id']);
                                  pinCodeAskModal(detail['id']);
                                });
                              },
                            ),
                          ],
                        ),
                      )
              ],
            ),
          ),
        );
      },
    );
  }

  pinCodeAskModal(invoiceID) {
    final TextEditingController controller1 = TextEditingController();
    final TextEditingController controller2 = TextEditingController();
    final TextEditingController controller3 = TextEditingController();
    final TextEditingController controller4 = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text(
              'passwordCodeWarning_tr'.translationWord(),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: SizedBox(
              width: GlobalVariables.gWidth,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        alignment: Alignment.center,
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          controller: controller1,
                          textInputAction: TextInputAction.next,
                          onChanged: (_) {
                            if (controller1.text.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          cursorColor: Colors.pink,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 10, right: 8, top: 10),
                            border: InputBorder.none,
                            helperStyle: TextStyle(
                              color: Colors.transparent,
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        alignment: Alignment.center,
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          textInputAction: TextInputAction.next,
                          controller: controller2,
                          onChanged: (_) {
                            if (controller2.text.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          cursorColor: Colors.pink,
                          decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 10, right: 8, top: 10),
                              border: InputBorder.none,
                              helperStyle:
                                  TextStyle(color: Colors.transparent)),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        alignment: Alignment.center,
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          controller: controller3,
                          textInputAction: TextInputAction.next,
                          onChanged: (_) {
                            if (controller3.text.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          cursorColor: Colors.pink,
                          decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 10, right: 8, top: 10),
                              border: InputBorder.none,
                              helperStyle:
                                  TextStyle(color: Colors.transparent)),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        alignment: Alignment.center,
                        child: TextFormField(
                          cursorColor: Colors.pink,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          controller: controller4,
                          textInputAction: TextInputAction.done,
                          onChanged: (_) {
                            if (controller4.text.length == 1) {
                              print('shalgayda');
                              // payInvoice(
                              //   invoiceID,
                              //   controller1.text +
                              //       controller2.text +
                              //       controller3.text +
                              //       controller4.text,
                              // );
                            }
                          },
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 10, right: 8, top: 10),
                              border: InputBorder.none,
                              helperStyle:
                                  TextStyle(color: Colors.transparent)),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: const [],
          );
        });
  }
}
