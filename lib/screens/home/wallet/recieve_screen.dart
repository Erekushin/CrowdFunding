import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/gextensions.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/route_manager.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RecieveScreen extends StatefulWidget {
  const RecieveScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecieveScreenState();
}

class _RecieveScreenState extends State<RecieveScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoreColor().backgroundBlue,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
        backgroundColor: CoreColor().backgroundBlue,
        centerTitle: true,
        title: Text(
          'receive_tr'.translationWord(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        actions: const [],
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        width: GlobalVariables.gWidth,
        // height: GlobalVariables.gHeight / 1.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "${GlobalVariables.lastName.capitalizeCustom()} ${GlobalVariables.firstName.capitalizeCustom()}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              QrImage(
                data: GlobalVariables.civilId,
                version: QrVersions.auto,
                size: 200,
                // embeddedImage: image.image,
                errorCorrectionLevel: QrErrorCorrectLevel.M,
                gapless: false,
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: const Size(70, 70),
                  color: Colors.transparent,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Set amount',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Save Image',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'More settings',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: const Divider(
                  color: Colors.grey,
                  height: 2,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        // if (item['id'] == 0) {
                        Get.to(() => const RecieveScreen());
                        // }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Receipts Manager',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Divider(
                      color: Colors.white.withOpacity(0.4),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
