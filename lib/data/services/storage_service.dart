import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  String deepLinkURL = '';
  final _storage = const FlutterSecureStorage();

  Future<StorageService> init() async {
    // await GetStorage.init();
    return this;
  }

  void write(String key, dynamic value) {
    _storage.write(key: key, value: value);
  }

  dynamic read(String key) async {
    var value = await _storage.read(key: key);
    return value;
  }

  void clearAll() {
    _storage.deleteAll();
  }
}
