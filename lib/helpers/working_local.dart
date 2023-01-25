import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import '../dialogs/snacks.dart';
import 'backHelper.dart';
import 'gvariables.dart';

class WorkingFiles {
  final storage = const FlutterSecureStorage();
  final _accountNameController =
      TextEditingController(text: 'flutter_secure_storage_service');
  IOSOptions _getIOSOptions() => IOSOptions(
        accountName: _getAccountName(),
      );
  String? _getAccountName() =>
      _accountNameController.text.isEmpty ? null : _accountNameController.text;
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
        // sharedPreferencesName: 'Test2',
        // preferencesKeyPrefix: 'Test'
      );

  Future<void> readAll() async {
    final all = await storage.readAll(
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    GlobalVariables.fingerLoginfo(all);
  }

  Future<void> deleteAll() async {
    await storage.deleteAll(
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    readAll();
  }

  Future<void> addNewItem(String k, String v) async {
    final String key = k;
    final String value = v;

    await storage.write(
      key: key,
      value: value,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    readAll();
  }

  void cleanUserInfo() {
    GlobalVariables.userInfo = {
      "id": "",
      "civil_id": "",
      "reg_no": "",
      "family_name": "",
      "last_name": "",
      "first_name": "",
      "username": "",
      "root_account": "",
      "email": "",
      "phone_no": "",
      "gender": 1,
      "birth_date": "",
      "is_foreign": 0,
      "aimag_code": "",
      "aimag_name": "",
      "sum_code": "",
      "sum_name": "",
      "bag_code": "",
      "bag_name": "",
      "address": "",
      "profile_image": "",
      "country_code": "",
      "country_name": "",
      "nationality": "",
      "country_name_en": "",
      "c_level": 0,
      "created_date": "",
      "updated_date": "",
      "is_confirmed_phone_no": 0,
      "is_confirmed_email": 1
    };
  }
}

class WorkingBioMatrix {
  final crowdlog = logger(WorkingBioMatrix);
  final LocalAuthentication localauth = LocalAuthentication();
  List<BiometricType>? availableBiometrics = <BiometricType>[];
  bool biomatrixSupported = false;
  void checkSupportState() {
    localauth.isDeviceSupported().then((bool isSupported) {
      biomatrixSupported = isSupported;
    });
  }

  Future<bool> checkBiometrics(bool moun) async {
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await localauth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      crowdlog.e(e);
    }
    if (!moun) {
      canCheckBiometrics = false;
    }
    if (canCheckBiometrics) {
      try {
        availableBiometrics = await localauth.getAvailableBiometrics();
      } on PlatformException catch (e) {
        canCheckBiometrics = false;
        crowdlog.e(e);
      }
      if (availableBiometrics!.isNotEmpty &&
          (availableBiometrics!.contains(BiometricType.strong) ||
              availableBiometrics!.contains(BiometricType.fingerprint))) {
        try {
          final bool didAuthenticate = await localauth.authenticate(
              localizedReason: 'Please authenticate');
          canCheckBiometrics = didAuthenticate;
        } on PlatformException catch (e) {
          canCheckBiometrics = false;
          crowdlog.e('${e.code} ${e.details} ${e.message}');
          errorSnack('Ямар нэгэн алдаа гарлаа алдаа гарлаа');
        }
      }
    }
    return canCheckBiometrics;
  }
}
