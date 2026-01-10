import 'package:shared_preferences/shared_preferences.dart';

class BmrData {
  // Use a consistent key for storage
  static const String _bmrKey = 'saved_bmr_value';
  static double? bmr;

  // Save the calculated BMR
  static Future<void> saveBmrData(double value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setDouble(_bmrKey, value);
    bmr = value;
  }

  // Retrieve the saved BMR
  static Future<void> getBmrData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    double? savedValue = sharedPreferences.getDouble(_bmrKey);

    if (savedValue != null) {
      bmr = savedValue;
    }
  }

  // Clear the data
  static Future<void> clearBmrData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_bmrKey); // Specific remove is safer than clear()
    bmr = null;
  }
}
