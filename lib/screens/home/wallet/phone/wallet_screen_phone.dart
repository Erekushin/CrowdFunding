import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/screens/home/wallet/money_screen.dart';
import 'package:gerege_app_v2/screens/home/wallet/wallet_info.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';

class WalletScreenPhone extends StatelessWidget {
  static const _locale = 'mn';
  static bool loader = false;

  const WalletScreenPhone({super.key});
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(double.parse(s));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
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
                Get.to(() => const MoneyScreen());
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ImageIcon(
                    AssetImage(
                      "assets/icons/money.png",
                    ),
                    size: 60,
                    color: Colors.white,
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
                Get.to(() => const WalletInfoScreen());
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ImageIcon(
                    AssetImage(
                      "assets/icons/wallettool.png",
                    ),
                    size: 60,
                    color: Colors.white,
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
                          _formatNumber(GlobalVariables.accountBalance.value
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
    );
  }
}
