import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
}
