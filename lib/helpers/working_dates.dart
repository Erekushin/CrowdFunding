countRemainingDays(String endDateStr) {
  String remainingDays = '';
  DateTime now = DateTime.now();
  DateTime endDate = DateTime.parse(endDateStr);
  remainingDays = endDate.difference(now).inDays.toString();
  return remainingDays;
}
