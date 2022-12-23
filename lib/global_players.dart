import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'helpers/working_file.dart';

enum BioSupportState {
  unknown,
  supported,
  unsupported,
}

class GlobalPlayers {
  static WorkingFiles workingWithFile = WorkingFiles();
}
