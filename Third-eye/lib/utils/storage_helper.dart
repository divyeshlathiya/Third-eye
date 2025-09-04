import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {
  // Create storage instance
  static const _storage = FlutterSecureStorage();

  static Future<void> saveToken(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> getToken(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> deleteToken(String key) async {
    await _storage.delete(key: key);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  static Future<void> saveData(String s, email) async {}
}
