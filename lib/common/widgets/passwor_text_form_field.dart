import 'package:flutter/material.dart';
import 'package:tux_keytool/common/singletons/app_settings.dart';

import '../functinos/random_functions.dart';

class PasswordTextFormField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool? enable;

  const PasswordTextFormField({
    super.key,
    required this.labelText,
    required this.controller,
    this.textInputAction = TextInputAction.next,
    this.hintText,
    this.validator,
    this.enable = true,
  });

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool isHidden = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      child: TextFormField(
        enabled: widget.enable,
        controller: widget.controller,
        obscureText: isHidden,
        textInputAction: widget.textInputAction,
        validator: widget.validator,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          labelText: widget.labelText.toUpperCase(),
          hintText: widget.hintText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Focus(
            descendantsAreFocusable: false,
            canRequestFocus: false,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    widget.controller.text =
                        randomPassword(AppSettings.instance.numberChar);
                  },
                  icon: Image.asset(
                    'assets/images/random_dice.png',
                    width: 32,
                    height: 32,
                    fit: BoxFit.fitWidth,
                  ),

                  //  Icon(Icons.casino),
                ),
                IconButton(
                  icon:
                      Icon(isHidden ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      isHidden = !isHidden;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
