import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gerege_app_v2/helpers/core_url.dart';
import 'package:gerege_app_v2/helpers/working_string.dart';
import 'package:gerege_app_v2/style/color.dart';
import 'package:gerege_app_v2/widget/gerege_button.dart';
import 'package:get/get.dart';
import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:image_picker/image_picker.dart';

import '../../../helpers/services.dart';

class CoreInfoScreen extends StatefulWidget {
  const CoreInfoScreen({Key? key}) : super(key: key);

  @override
  State<CoreInfoScreen> createState() => _CoreInfoScreenState();
}

class _CoreInfoScreenState extends State<CoreInfoScreen> {
  RxList serviceList = [].obs;
  bool passwordScreen = true;

  XFile? imageSend;
  final ImagePicker _picker = ImagePicker();
  var lastNameController = TextEditingController();
  var firstNameController = TextEditingController();
  var genderController = TextEditingController();
  var birthController = TextEditingController();

  var addressController = TextEditingController();
  var descAddressController = TextEditingController();

  @override
  void initState() {
    lastNameController.text = GlobalVariables.lastName;
    firstNameController.text = GlobalVariables.firstName;
    genderController.text = GlobalVariables.gender == 1 ? "Эрэгтэй" : "Эмэгтэй";
    birthController.text = GlobalVariables.birthDate;

    addressController.text =
        "${GlobalVariables.aimagName} ${GlobalVariables.sumName} ${GlobalVariables.bagName}";

    descAddressController.text = GlobalVariables.address;

    super.initState();
  }

  _imgFromCameraProfile() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 40);
    setState(() {
      imageSend = image;
      if (imageSend?.path != null) {
        final bytes = File(imageSend!.path).readAsBytesSync();
        String img64 = base64Encode(bytes);
        var body = {
          "id": GlobalVariables.id,
          "profile_image": img64,
        };
        updateUser(body);
      }
    });
  }

  _imgFromGalleryProfile() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 40);
    setState(() {
      imageSend = image;
      if (imageSend?.path != null) {
        final bytes = File(imageSend!.path).readAsBytesSync();
        String img64 = base64Encode(bytes);
        var body = {
          "id": GlobalVariables.id,
          "profile_image": img64,
        };
        updateUser(body);
      }
    });
  }

  updateUser(body) {
    Services()
        .putRequest(json.encode(body), '${CoreUrl.crowdfund}user', true, '')
        .then((data) {
      if (data.statusCode == 200) {
        GlobalVariables.updateUserInformation();
        Get.snackbar(
          'success_tr'.translationWord(),
          data.body['message'],
          colorText: Colors.white,
          backgroundColor: Colors.red.withOpacity(0.2),
        );
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

  void _showPickerProfile(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text(
                      'Gallery',
                    ),
                    onTap: () {
                      _imgFromGalleryProfile();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text(
                    'Camera',
                  ),
                  onTap: () {
                    _imgFromCameraProfile();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CoreColor().backgroundBtnBlue,
        title: const Text('Үндсэн мэдээлэл'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            coreInfo(),
            addressInfo(),
          ],
        ),
      ),
    );
  }

  Widget addressInfo() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
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
        children: [
          textfieldDetail('Хаяг', addressController, true),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Хаягийн дэлгэрэнгүй',
              style: TextStyle(),
            ),
          ),
          TextField(
            autofocus: false,
            controller: descAddressController,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              labelText: '',
              labelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              contentPadding: const EdgeInsets.all(20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          GeregeButtonWidget(
            radius: 10.0,
            elevation: 0.0,
            minWidth: GlobalVariables.gWidth / 1.6,
            backgroundColor: CoreColor().backgroundBtnBlue,
            borderColor: CoreColor().backgroundBtnBlue,
            text: const Text(
              'Хадгалах',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              setState(() {
                if (addressController.text != '') {
                  var bodyData = {
                    "id": GlobalVariables.id,
                    "address": descAddressController.text.trim()
                  };
                  updateUser(bodyData);
                } else {
                  Get.snackbar(
                    'warning_tr'.translationWord(),
                    'Дэлгэрэнгүй хаяг оруулна уу !',
                    colorText: Colors.white,
                    backgroundColor: Colors.red.withOpacity(0.2),
                  );
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget coreInfo() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
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
        children: [
          const SizedBox(height: 10),
          Obx(
            () => GlobalVariables.profileImage.value == ""
                ? InkWell(
                    onTap: () {
                      setState(() {
                        _showPickerProfile(context);
                      });
                    },
                    child: Center(
                      child: Icon(
                        Icons.account_circle_outlined,
                        color: Colors.black.withOpacity(0.5),
                        size: 100,
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      setState(() {
                        _showPickerProfile(context);
                      });
                    },
                    child: ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(48), // Image radius
                        child: Image.memory(
                          const Base64Decoder().convert(GlobalVariables
                              .profileImage.value
                              .replaceAll('data:image/jpeg;base64,', '')),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: textfieldDetail('Овог', lastNameController, true)),
              const SizedBox(width: 20),
              Expanded(
                  child: textfieldDetail('Нэр', firstNameController, true)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: textfieldDetail(
                  'Хүйс',
                  genderController,
                  true,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                  child: textfieldDetail('Төрсөн өдөр', birthController, true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget textfieldDetail(
      String text, TextEditingController controller, bool read) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text),
        const SizedBox(height: 10),
        TextFormField(
          readOnly: read,
          autofocus: false,
          keyboardType: TextInputType.number,
          controller: controller,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            labelText: '',
            labelStyle: const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
            contentPadding: const EdgeInsets.all(20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                width: 1,
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
