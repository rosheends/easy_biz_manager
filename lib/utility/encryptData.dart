import 'package:encrypt/encrypt.dart';

class EncryptDecryptData {
  String encryptPwd(String pwd) {

    final key = Key.fromSecureRandom(32);
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(pwd, iv: iv);

    return encrypted.base64;
  }

  String decryptPwd(Encrypted encryptedPwd) {

    final key = Key.fromSecureRandom(32);
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key));

    final decrypted = encrypter.decrypt(encryptedPwd, iv: iv);

    return decrypted;
  }
}
