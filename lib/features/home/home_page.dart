import 'dart:developer';
import 'dart:io';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../common/functinos/file_edit_functions.dart';
import '../../common/functinos/table_row_functions.dart';
import '../../common/models/key_algorithm.dart';
import '../../common/singletons/app_settings.dart';
import '../../common/validate/keytool_validate.dart';
import '../../common/widgets/passwor_text_form_field.dart';
import '../../common/widgets/spin_box_field.dart';
import '../settings/settings_page.dart';
import 'home_page_controller.dart';
import 'home_page_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = HomePageController();
  final _formKey = GlobalKey<FormState>();
  final _formKeyDir = GlobalKey<FormState>();

  final _commonName = TextEditingController();
  final _organization = TextEditingController();
  final _department = TextEditingController();
  final _city = TextEditingController();
  final _province = TextEditingController();
  final _validityYears = TextEditingController();
  final _storePassword = TextEditingController();
  final _keyPassword = TextEditingController();
  String _countryCode = 'BR';
  final _keyAlgorithm = KeyAlgorithm();

  final _appSettings = AppSettings.instance;

  @override
  initState() {
    super.initState();
    _controller.init();
    _validityYears.text = _appSettings.validaty.toString();
  }

  @override
  void dispose() {
    _commonName.dispose();
    _organization.dispose();
    _department.dispose();
    _city.dispose();
    _province.dispose();
    _validityYears.dispose();
    _keyAlgorithm.dispose();
    _storePassword.dispose();
    _keyPassword.dispose();

    super.dispose();
  }

  void _generateKey() async {
    final bool valit =
        _formKey.currentState != null && _formKey.currentState!.validate();

    if (valit) {
      String command;
      String fileName;
      List<String> arguments;

      if (_appSettings.isSinglePass) {
        _keyPassword.text = _storePassword.text;
      }

      int validity = (int.tryParse(_validityYears.text) ?? 1) * 256;

      (command, fileName, arguments) = genarateCommand(
        keyStorageDir: _controller.keyStorageDir,
        commonName: _commonName.text,
        organization: _organization.text,
        department: _department.text,
        city: _city.text,
        province: _province.text,
        countryCode: _countryCode,
        keyAlgorithm: _keyAlgorithm,
        storePassword: _storePassword.text,
        keyPassword: _keyPassword.text,
        validity: validity,
      );

      final file = File(fileName);
      if (await file.exists()) {
        await file.delete();
      }

      await _controller.execute(command, arguments);
      final process = _controller.process;
      if (process.exitCode != 0) {
        log('      command: $command ${arguments.join(' ')}');
        log('comand stdout: ${process.stdout}');
        log('    exit code: ${process.exitCode}');
        log('       stderr: ${process.stderr}');
      } else {
        _showResultDialog();
      }
    }
  }

  void _showResultDialog() {
    final process = _controller.process;
    String message = process.stdout.isEmpty ? process.stderr : process.stdout;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Created Successfully'),
        content: Text(message),
        actions: [
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            label: const Text('Close'),
          )
        ],
      ),
    );
  }

  void _getKeyStorageDir() async {
    _controller.keyStorageDir = await _getDirName(_controller.keyStorageDir);
  }

  void _getProjectDir() async {
    _controller.projectDir = await _getDirName(_controller.projectDir);
  }

  Future<String> _getDirName(String dirName) async {
    try {
      String? result = await FilePicker.platform.getDirectoryPath(
        initialDirectory: dirName,
      );
      if (result != null) {
        return result;
      } else {
        log('No directories selected.');
      }
    } catch (err) {
      log('Error selecting directory: $err');
    }
    return dirName;
  }

  _newKey() {
    _commonName.text = '';
    _validityYears.text = _appSettings.validaty.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate Datails'),
        elevation: 10,
        actions: [
          IconButton(
            onPressed: _newKey,
            icon: const Icon(Icons.new_label),
          ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, SettingsPage.routeName),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 24,
        ),
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            if (_controller.state is HomePageStateLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (_controller.state is HomePageStateSuccess) {
              return ListView(
                children: [
                  Form(
                    key: _formKey,
                    child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const {
                        0: IntrinsicColumnWidth(flex: 1),
                        1: IntrinsicColumnWidth(flex: 4),
                      },
                      children: [
                        tableRowForm(
                          label: 'Common Name:',
                          controller: _commonName,
                          validator: KeyToolValidate.commonNameValidate,
                        ),
                        tableRowForm(
                          label: 'Organization:',
                          controller: _organization,
                        ),
                        tableRowForm(
                          label: 'Department:',
                          controller: _department,
                        ),
                        tableRowForm(
                          label: 'City:',
                          controller: _city,
                        ),
                        tableRowForm(
                          label: 'State/Province:',
                          controller: _province,
                        ),
                        tableRowWidget(
                          label: 'Country:',
                          widget: CountryListPick(
                            theme: CountryTheme(
                              isDownIcon: true,
                              isShowCode: false,
                              isShowFlag: true,
                              isShowTitle: true,
                              showEnglishName: true,
                            ),
                            initialSelection: '+55',
                            onChanged: (code) {
                              if (code != null) {
                                _countryCode = code.code ?? 'US';
                              }
                            },
                            useUiOverlay: true,
                            useSafeArea: true,
                          ),
                        ),
                        tableRowWidget(
                          label: 'Key Size:',
                          widget: ListenableBuilder(
                            listenable: _keyAlgorithm,
                            builder: (context, _) {
                              return DropdownButton<String>(
                                value: _keyAlgorithm.label,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'RSA 2048',
                                    child: Text('RSA 2048'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'RSA 4096',
                                    child: Text('RSA 4096'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'P-256',
                                    child: Text('P-256 (elliptic curve)'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    _keyAlgorithm.setToLabel(value);
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        tableRowWidget(
                          label: 'Validity (years):',
                          widget: SpinBoxField(
                            labelText: 'labelText',
                            value: int.tryParse(_validityYears.text) ?? 10,
                            maxValue: 100,
                            minValue: 1,
                            controller: _validityYears,
                          ),
                        ),
                        tableRowWidget(
                          label: _appSettings.isSinglePass
                              ? 'Store/Key Password'
                              : 'Store Password:',
                          widget: PasswordTextFormField(
                            controller: _storePassword,
                            labelText: '',
                            validator: KeyToolValidate.passwordValidate,
                          ),
                        ),
                        if (!_appSettings.isSinglePass)
                          tableRowWidget(
                            label: 'Key Password:',
                            widget: PasswordTextFormField(
                              enable: !_appSettings.isSinglePass,
                              controller: _keyPassword,
                              labelText: '',
                              validator: KeyToolValidate.passwordValidate,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Directories',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKeyDir,
                    child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const {
                        0: IntrinsicColumnWidth(flex: 1),
                        1: IntrinsicColumnWidth(flex: 4),
                      },
                      children: [
                        tableRowWidget(
                          label: 'Key Storage:',
                          widget: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                              ),
                            ),
                            onPressed: _getKeyStorageDir,
                            child: ListTile(
                              title: Text(_controller.keyStorageDir),
                              trailing: const Icon(Icons.folder_outlined),
                            ),
                          ),
                        ),
                        tableRowWidget(
                          label: 'Project:',
                          widget: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                              ),
                            ),
                            onPressed: _getProjectDir,
                            child: ListTile(
                              title: Text(_controller.projectDir),
                              trailing: const Icon(Icons.folder_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: ButtonBar(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _generateKey,
                          label: const Text('Create Key'),
                          icon: const Icon(
                            Icons.key,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => setupKeyProperties(
                            projectDir: _controller.projectDir,
                            keyStorageDir: _controller.keyStorageDir,
                            storePassword: _storePassword.text,
                            keyPassword: _keyPassword.text,
                            commonName: _commonName.text,
                          ),
                          label: const Text('Insert key in Project'),
                          icon: const Icon(
                            Icons.task,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text('Sorry! An error has occurred.'),
              );
            }
          },
        ),
      ),
    );
  }
}
