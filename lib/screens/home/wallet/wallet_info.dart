import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/screens/home/wallet/cart_screen.dart';
import 'package:gerege_app_v2/screens/home/wallet/pay_config_screen.dart';
import 'package:gerege_app_v2/screens/home/wallet/transaction.dart';
import 'package:gerege_app_v2/screens/home/wallet/transfer_screen.dart';
import 'package:gerege_app_v2/screens/home/wallet/wallet_accounts_screen.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';

class WalletInfoScreen extends StatefulWidget {
  const WalletInfoScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WalletInfoScreenState();
}

class _WalletInfoScreenState extends State<WalletInfoScreen> {
  static const _locale = 'mn';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(double.parse(s));

  @override
  void initState() {
    super.initState();
  }

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
          'money_tr'.translationWord(),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => const TransferScreen());
            },
            child: const Text(
              'Transaction',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          listWidget(),
        ],
      ),
    );
  }

  Widget listWidget() {
    return Column(
      children: [
        Container(
          width: GlobalVariables.gWidth,
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => const TransactionScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.monetization_on,
                          color: Colors.yellow,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'remainder_tr'.translationWord(),
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
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
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              Container(
                                alignment: Alignment.bottomCenter,
                                child: const Text(
                                  '₮',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.only(left: 30),
                child: Divider(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
              const SizedBox(height: 5),
              InkWell(
                onTap: () {
                  print('cart change');
                  Get.to(() => const CartScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.card_membership,
                          color: CoreColor().btnBlue,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'cart_tr'.translationWord(),
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.only(left: 30),
                child: Divider(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
              const SizedBox(height: 5),
              InkWell(
                onTap: () {
                  print('cart change');
                  Get.to(() => const WalletAccountsScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance,
                          color: CoreColor().btnBlue,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'gerege_account_tr'.translationWord(),
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: GlobalVariables.gWidth,
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: InkWell(
            onTap: () {
              Get.to(() => const PayConfigScreen());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: CoreColor().btnBlue,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'pay_config_tr'.translationWord(),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
