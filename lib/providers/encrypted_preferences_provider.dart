import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptedPreferencesProvider {
  final _storage = FlutterSecureStorage();

  Future<void> saveData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> getData(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }
}
