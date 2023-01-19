import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gerege_app_v2/global_players.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

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

  void cleanUserInfo() {}
}

class WorkingBioMatrix {
  final crowdlog = logger(WorkingBioMatrix);
  bool? _canCheckBiometrics;
  final LocalAuthentication auth = LocalAuthentication();
  List<BiometricType>? _availableBiometrics;
  BioSupportState bioSupportState = BioSupportState.unknown;

  void checkSupportState() {
    auth.isDeviceSupported().then(
          (bool isSupported) => bioSupportState = isSupported
              ? BioSupportState.supported
              : BioSupportState.unsupported,
        );
  }

  Future<void> checkBiometrics(bool moun, Function successFunc) async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      crowdlog.e(e);
    }
    if (!moun) {
      return;
    }

    _canCheckBiometrics = canCheckBiometrics;
    if (_canCheckBiometrics ?? false) {
      _getAvailableBiometrics(moun, successFunc);
    }
  }

  Future<void> _getAvailableBiometrics(bool moun, Function successFunc) async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      crowdlog.e(e);
    }
    if (!moun) {
      return;
    }

    _availableBiometrics = availableBiometrics;
    if (_availableBiometrics!.isNotEmpty) {
      if (_availableBiometrics!.contains(BiometricType.strong) ||
          _availableBiometrics!.contains(BiometricType.fingerprint)) {
        try {
          final bool didAuthenticate = await auth.authenticate(
              localizedReason: 'Please authenticate to show account balance');

          if (didAuthenticate) {
            successFunc();
          }
        } on PlatformException catch (e) {
          crowdlog.e(e.code);
          Get.snackbar(
            '',
            e.toString(),
            colorText: Colors.black,
            backgroundColor: Colors.white,
          );
        }
      }
    }
  }
}
