import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/core_url.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:gerege_app_v2/screens/home/me/foreign_passport.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:get/get.dart';

import '../../../helpers/services.dart';
import '../../../widget/fundamental/btn.dart';
import '../../content_home/home.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({Key? key}) : super(key: key);

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  RxList documentList = [].obs;
  bool passwordScreen = true;

  @override
  void initState() {
    super.initState();
    getDocumentList();
  }

  getDocumentList() {
    String url = '${CoreUrl.crowdfund}document';
    Services().getRequest(url, true, '').then((data) {
      if (data.statusCode == 200) {
        setState(() {
          documentList.value = data.body['result']['items'];
        });
      } else {
        Get.snackbar(
          'warning_tr'.translationWord(),
          data.body['message'],
          colorText: Colors.white,
          backgroundColor: Colors.red.withOpacity(0.2),
        );
      }
    });
  }

  back() {
    // Get.offAll(() => const MainTab(indexTab: 0));
    Get.to(() => const ContentHome());
  }

  deleteDocument(item) {
    String url = '${CoreUrl.crowdfund}document?id=${item['id']}';
    Services().deleteRequest(url, true, '').then((data) {
      if (data.statusCode == 200) {
        setState(() {
          Get.back();
          getDocumentList();
        });
      } else {
        Get.snackbar(
          'warning_tr'.translationWord(),
          data.body['message'],
          colorText: Colors.white,
          backgroundColor: Colors.red.withOpacity(0.2),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => back(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: CoreColor().backgroundBlue,
          title: const Text('Бичиг баримт'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              // Get.back();
              // Get.offAll(() => const MainTab(indexTab: 0));
              Get.to(() => const ContentHome());
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: const Text(
                "Таны бичиг баримтууд",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Get.to(() => const ForeignPassScreen());
              },
              child: Container(
                width: GlobalVariables.gWidth,
                height: 60,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  border: Border.all(
                    width: 1,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.grey,
                  size: 60,
                ),
              ),
            ),
            Expanded(
              child: docListWidget(),
            )
          ],
        ),
      ),
    );
  }

  Widget docListWidget() {
    return ListView.builder(
      itemCount: documentList.length,
      itemBuilder: (BuildContext context, int index) {
        return Obx(
          () => InkWell(
            onTap: () {
              setState(() {
                deleteAlert(documentList[index]);
              });
            },
            child: Container(
              width: GlobalVariables.gWidth,
              height: 180,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                border: Border.all(
                  width: 1,
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  docType("Овог:", "${documentList[index]['last_name']}"),
                  docType("Нэр:", "${documentList[index]['first_name']}"),
                  docType(
                      "Төрсөн огноо:", "${documentList[index]['birth_date']}"),
                  docType("Пасспортын дугаар:",
                      "${documentList[index]['document_number']}"),
                  docType("Пассортыг төрөл:",
                      "${documentList[index]['type_name']}"),
                  docType("Олгосон огноо:",
                      "${documentList[index]['date_of_issue']}"),
                  docType("Дуусах огноо:",
                      "${documentList[index]['date_of_expire']}"),
                ],
              ),
            ),
          ),
        );
        // ListTile(
        //   leading: const Icon(Icons.list),
        //   trailing: const Text(
        //     "GFG",
        //     style: TextStyle(color: Colors.green, fontSize: 15),
        //   ),
        //   title: Text("List item $index"),
        // );
      },
    );
  }

  Widget docType(title, value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 20),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        )
      ],
    );
  }

  deleteAlert(item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Баримт бичиг устгах'),
        content: Text(
            'Та ${item['document_number']} дугаартай бичиг баримтыг устгах гэж байна.'),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              generalBtn(CoreColor().backgroundGreen,
                  CoreColor().backgroundGreen, 'Буцах', () {
                Get.back();
              }),
              generalBtn(CoreColor().backgroundGreen,
                  CoreColor().backgroundGreen, 'Устгах', () {
                deleteDocument(item);
              }),
              const SizedBox(width: 10),
            ],
          )
        ],
      ),
    );
  }
}
