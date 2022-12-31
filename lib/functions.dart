import 'dart:convert' show utf8;
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'constant.dart';

bool checkPasswordMatch(String password1, String password2) {
  return password1 == password2;
}

String hash(password) {
  return sha256.convert(utf8.encode(password)).toString();
}

bool checkPassword(String password) {
  return password.contains(
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'));
}

encryptWithAES(String plainText) {
  final key = Key.fromUtf8('my 32 length key................');
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));
  var encrypted = encrypter.encrypt(plainText, iv: iv);
  return encrypted;
}

decryptWithAES(Encrypted encryptedText) {
  final key = Key.fromUtf8('my 32 length key................');
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));
  var decrypted = encrypter.decrypt(encryptedText, iv: iv);
  return decrypted;
}
