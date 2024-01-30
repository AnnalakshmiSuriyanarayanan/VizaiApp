// data.dart

class DataHolder {
  static int data = 50;
  static List<dynamic> users = [];
  static int batteryValue = 0; // Change the type to int
  static void updateBatteryValue() {
    batteryValue =
        int.tryParse(users.isNotEmpty ? users[0]['Id'].toString() : '') ?? 0;
  }
}
