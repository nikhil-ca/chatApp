
import 'package:encrypt/encrypt.dart';

class EncryptionService{
  final Encrypter _encrypter = Encrypter(AES(Key.fromLength(32)));
  final _iv = IV.fromLength(16);

    encrypt(String msg){
   final encrypted = _encrypter.encrypt(msg, iv: _iv).base64;
   return encrypted.toString();
  }

  String decrypt(encryptedText){
      final encrypted = Encrypted.fromBase64(encryptedText);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }
}