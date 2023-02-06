import 'package:shared_preferences/shared_preferences.dart';
class SharedPrefs{
  static SharedPreferences? prefs;
  static SharedPreferences? prefKeys;
  static setKeys(List<String> keys)async => prefKeys!.setStringList('keys', keys);
  static setPreferences(List<String> items, String key)async => prefs!.setStringList(key, items);
  static List<String>? getKeys() => prefKeys!.getStringList('keys');
  static deletePreferenceKey(String key) => prefs!.remove(key);
  static getPreferences(List<String> keys){
    Set<List<String>> tempSet = {};
    for(int i = 0; i < keys.length; i++){
      tempSet.add(prefs!.getStringList(keys[i])!);
    }
    return tempSet;
  }
}