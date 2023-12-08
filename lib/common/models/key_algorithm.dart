import 'package:flutter/material.dart';

class KeyAlgorithm extends ChangeNotifier {
  String algorithm;
  int keySize;

  KeyAlgorithm({
    this.algorithm = 'RSA',
    this.keySize = 2048,
  });

  String get label {
    return (algorithm == 'RSA') ? '$algorithm $keySize' : 'P-256';
  }

  void setToLabel(String key) {
    switch (key) {
      case 'RSA 2048':
        algorithm = 'RSA';
        keySize = 2048;
      case 'RSA 4096':
        algorithm = 'RSA';
        keySize = 4096;
      case 'P-256':
        algorithm = 'EC';
        keySize = 256;
      default:
        algorithm = 'RSA';
        keySize = 2048;
    }
    notifyListeners();
  }
}
