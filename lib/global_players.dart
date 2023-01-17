import 'package:gerege_app_v2/helpers/working_local.dart';

import 'helpers/frontHelper.dart';

enum BioSupportState {
  unknown,
  supported,
  unsupported,
}

class GlobalPlayers {
  static WorkingFiles workingWithFile = WorkingFiles();
  static WorkingBioMatrix workingBioMatrix = WorkingBioMatrix();
  static FrontHelper frontHelper = FrontHelper();
}

class Sizes {
  static double iconSize = 22;
}
