import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late final SharedPreferences _prefs;

  static const String _themeKey = 'theme_mode';
  static const String _loggedInKey = 'logged_in';
  static const String _profileNameKey = 'profile_name';
  static const String _profileEmailKey = 'profile_email';
  static const String _profilePhotoKey = 'profile_photo';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String? getThemeMode() {
    return _prefs.getString(_themeKey);
  }

  static Future<void> setThemeMode(String mode) async {
    await _prefs.setString(_themeKey, mode);
  }

  static bool getLoggedIn() {
    return _prefs.getBool(_loggedInKey) ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(_loggedInKey, value);
  }

  static String? getProfileName() {
    return _prefs.getString(_profileNameKey);
  }

  static String? getProfileEmail() {
    return _prefs.getString(_profileEmailKey);
  }

  static String? getProfilePhoto() {
    return _prefs.getString(_profilePhotoKey);
  }

  static Future<void> saveProfile({
    required String name,
    required String email,
    required String photoUrl,
  }) async {
    await _prefs.setString(_profileNameKey, name);
    await _prefs.setString(_profileEmailKey, email);
    await _prefs.setString(_profilePhotoKey, photoUrl);
  }
}
