import 'package:flutter/material.dart';

import '../../common/functinos/table_row_functions.dart';
import '../../common/singletons/app_settings.dart';
import '../../common/widgets/spin_box_field.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  static const routeName = '/settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _appSettings = AppSettings.instance;
  final _validityController = TextEditingController();
  final _numberCharController = TextEditingController();

  bool singlePassword = false;

  @override
  void initState() {
    super.initState();
    _validityController.text = _appSettings.validaty.toString();
    _numberCharController.text = _appSettings.numberChar.toString();
  }

  @override
  void dispose() {
    _validityController.dispose();
    _numberCharController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 24,
        ),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: IntrinsicColumnWidth(flex: 1),
            1: IntrinsicColumnWidth(flex: 3),
          },
          children: [
            tableRowWidget(
              label: 'Validity in Years:',
              widget: SpinBoxField(
                labelText: 'labelText',
                value: _appSettings.validaty,
                controller: _validityController,
                maxValue: 100,
                minValue: 1,
                onChanged: (value) => _appSettings.validaty = value,
              ),
            ),
            tableRowWidget(
              label: 'Use a single password:',
              widget: ListenableBuilder(
                listenable: _appSettings.isSinglePass$,
                builder: (context, _) {
                  return Checkbox(
                    value: _appSettings.isSinglePass,
                    onChanged: (value) {
                      _appSettings.isSinglePass = !_appSettings.isSinglePass;
                    },
                  );
                },
              ),
            ),
            tableRowWidget(
              label: 'Theme Mode:',
              widget: ListenableBuilder(
                listenable: _appSettings.themeMode$,
                builder: (context, _) {
                  return DropdownButton<ThemeMode>(
                    value: _appSettings.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        _appSettings.themeMode = value;
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('Light'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Dark'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('System'),
                      ),
                    ],
                  );
                },
              ),
            ),
            tableRowWidget(
              label: '# of characters in the Random Password Generator:',
              widget: SpinBoxField(
                labelText: 'labelText',
                value: _appSettings.numberChar,
                controller: _numberCharController,
                maxValue: 48,
                minValue: 1,
                onChanged: (value) => _appSettings.numberChar = value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
