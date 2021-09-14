import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService{
  final _storage = FlutterSecureStorage();

  Future WriteSecureData(String key, dynamic value) async{
    try{
      var writeData = await _storage.write(key: key, value: value.toString());
      return writeData;
    }
    catch(exception){
      throw exception;
    }
  }

  Future<String?> ReadSecureData(String key) async{
    try{
      var readData = await _storage.read(key: key);
      return readData;
    }
    catch(exception){
      throw exception;
    }
  }

  Future DeleteSecureData(String key) async{
    try{
      var deleteData = await _storage.delete(key: key);
      return deleteData;
    }
    catch(exception){
      throw exception;
    }
  }

}