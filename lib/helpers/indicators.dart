progressProcent(int? amount, int? balance) {
  double procent;
  procent = balance! / (amount! / 100).floor();
  return procent;
}
