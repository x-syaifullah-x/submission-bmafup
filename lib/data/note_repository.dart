import 'package:shared_preferences/shared_preferences.dart';

class NoteRepository {
  NoteRepository._(this._prefs);

  static NoteRepository? _instance;

  static NoteRepository getInstance() {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = NoteRepository._(SharedPreferences.getInstance());
      return _instance!;
    }
  }

  final Future<SharedPreferences> _prefs;

  Future<bool> save(String key, String data) async {
    SharedPreferences prefs = await _prefs;
    return prefs.setString(key, data);
  }

  Future<String?> getData(String key) async {
    SharedPreferences prefs = await _prefs;
    return prefs.getString(key);
  }
}
