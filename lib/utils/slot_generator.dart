import 'package:intl/intl.dart';

class SlotGenerator {
  /// this function returns the next immediate available slot time
  /// the time gap between slots is hardcoded as 10 minutes here
  DateTime generate(DateTime now) {
    List<String> slotList = List<String>();
    slotList.add("select a slot");
    DateTime updated = DateTime.now();
    int tempMin = now.minute + 30 + (10 - now.minute % 10);
    int tempHours = now.hour;
    if (tempMin == 60) {
      tempMin = 00;
      tempHours = tempHours + 1;
    }
    updated = new DateTime(now.year, now.month, now.day, tempHours, tempMin);
    return updated;
  }
}
