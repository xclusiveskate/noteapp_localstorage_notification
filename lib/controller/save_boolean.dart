import 'package:shared_preferences/shared_preferences.dart';

import '../constatnts/constant.dart';

class SaveBool {
  static saveIsListView() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('isListView', false);
  }

  static Future<bool?> getIsListView() async {
    final pref = await SharedPreferences.getInstance();
    isListView = pref.getBool('isListView') ?? false;
    return isListView;
  }
}
