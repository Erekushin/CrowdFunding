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

class CoreUrl {
  // static const String serviceUrl = 'https://go-backend.gerege.mn/template/';
  static const String fileServer = 'https://app-backend.gerege.mn/file/?file=';

  static const String crowdfund = 'https://backend-crowdfund.gerege.mn/';
}

class Sizes {
  static double iconSize = 22;
}
