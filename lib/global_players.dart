import 'helpers/frontHelper.dart';
import 'helpers/working_file.dart';

enum BioSupportState {
  unknown,
  supported,
  unsupported,
}

class GlobalPlayers {
  static WorkingFiles workingWithFile = WorkingFiles();
  static FrontHelper frontHelper = FrontHelper();
}

class Sizes {
  static double iconSize = 22;
}
