import 'dart:math';

String randomPassword(int length) {
  String characteres =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\$@#%^&*()-_=+{}[]|;:,.<>/?';

  String password = '';
  Random random = Random();
  for (int i = 0; i < length; i++) {
    password += characteres[random.nextInt(characteres.length)];
  }

  return password;
}
