import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:private_notes/util/config.dart';

class EncryptService {
  final String myKey = Config.SECURE_KEY;

  String encrypt(text) {
    final key = Key.fromBase64(myKey);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final encrypted = encrypter.encrypt(text, iv: iv);

    final macBytes = utf8.encode(iv.base64 + encrypted.base64);
    final mac = Hmac(sha256, base64.decode(myKey)).convert(macBytes);

    final data = {
      "iv": iv.base64,
      "value": encrypted.base64,
      "mac": mac.toString(),
      "tag": ''
    };

    return base64.encode(utf8.encode(json.encode(data)));
  }

  String decrypt(encryptedText) {
    final jsonString = utf8.decode(base64.decode(encryptedText));
    final payload = json.decode(jsonString);

    final key = Key.fromBase64(myKey);
    final iv = IV.fromBase64(payload['iv']);
    final encrypted = Encrypted.fromBase64(payload['value']);

    final macBytes = utf8.encode(payload['iv'] + payload['value']);
    final mac = Hmac(sha256, base64.decode(myKey)).convert(macBytes);

    if (payload['mac'] != mac.toString()) {
      throw Exception('The MAC is invalid.');
    }

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }
}
