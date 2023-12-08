import 'dart:io';

import '../models/key_algorithm.dart';

(String, String, List<String>) genarateCommand({
  required String keyStorageDir,
  required String commonName,
  required String organization,
  required String department,
  required String city,
  required String province,
  required String countryCode,
  required KeyAlgorithm keyAlgorithm,
  required String storePassword,
  required String keyPassword,
  required int validity,
}) {
  // final int validity = (int.tryParse(_validity.text) ?? 1) * 256;
  String command = 'keytool';
  String fileName = '$keyStorageDir/keystore-$commonName.jks';
  final List<String> arguments = '-genkey -v'
          ' -keystore $fileName'
          ' -keyalg ${keyAlgorithm.algorithm}'
          ' -keysize ${keyAlgorithm.keySize}'
          ' -validity $validity'
          ' -alias $organization'
          ' -storepass $storePassword'
          ' -keypass $keyPassword'
          ' -dname'
      .split(' ');
  final dname = 'CN=$commonName,'
      'OU=$department,'
      'O=$organization,'
      'L=$city,'
      'ST=$province,'
      'C=$countryCode';

  arguments.add(dname);

  return (command, fileName, arguments);
}

void setupKeyProperties({
  required String projectDir,
  required String keyStorageDir,
  required String storePassword,
  required String keyPassword,
  required String commonName,
}) async {
  // key.properties File
  final keyPropertiesFile = File('$projectDir/android/key.properties');

  if (await keyPropertiesFile.exists()) {
    await keyPropertiesFile.delete();
  }

  await keyPropertiesFile.create(recursive: true);

  final keyFile = keyPropertiesFile.openWrite();
  List<String> lines = [
    'storePassword=$storePassword',
    'keyPassword=$keyPassword',
    'keyAlias=$commonName',
    'storeFile=$keyStorageDir/keystore-$commonName.jks',
  ];
  for (String line in lines) {
    keyFile.writeln(line);
  }

  keyFile.close();

  // build.gradle File
  final buildGradleFile = File('$projectDir/android/app/build.gradle');

  if (!await buildGradleFile.exists()) {
    throw Exception('$projectDir/android/app/build.gradle not found');
  }

  final buildLines = await buildGradleFile.readAsLines();

  int index = buildLines
      .indexWhere((line) => line.trim() == '// keytool: inserted lines >>>');

  if (index == -1) {
    index = buildLines.indexWhere((line) => line.trim() == 'android {');

    if (index == -1) {
      throw Exception('Expected line "android {" was not found');
    }

    lines = [
      '// keytool: inserted lines >>>',
      'def keystoreProperties = new Properties()',
      'def keystorePropertiesFile = rootProject.file(\'key.properties\')',
      'if (keystorePropertiesFile.exists()) {',
      '    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))',
      '}',
      '// keytool: inserted lines <<<',
      '',
    ];

    for (String line in lines) {
      buildLines.insert(index, line);
      index++;
    }

    index = buildLines.indexWhere((line) => line.trim() == 'buildTypes {');

    if (index == -1) {
      throw Exception('Expected line "buildTypes {" was not found');
    }

    lines = [
      '    // keytool: inserted lines >>>',
      '    signingConfigs {',
      '       release {',
      '           keyAlias keystoreProperties[\'keyAlias\']',
      '           keyPassword keystoreProperties[\'keyPassword\']',
      '           storeFile keystoreProperties[\'storeFile\'] ? file(keystoreProperties[\'storeFile\']) : null',
      '           storePassword keystoreProperties[\'storePassword\']',
      '       }',
      '     }',
      '    // keytool: inserted lines <<<',
      '',
    ];

    for (String line in lines) {
      buildLines.insert(index, line);
      index++;
    }

    index = buildLines.indexWhere(
        (line) => line.trim() == 'signingConfig signingConfigs.debug');

    if (index != -1) {
      buildLines.removeAt(index);

      lines = [
        '            // keytool: changed lines >>>',
        '            signingConfig signingConfigs.release',
        '            // signingConfig signingConfigs.debug',
        '            // keytool: changed lines <<<'
      ];
      for (String line in lines) {
        buildLines.insert(index, line);
        index++;
      }
    }

    await buildGradleFile.writeAsString(buildLines.join('\n'));
  }
}
