import 'package:flutter/material.dart';

TableRow tableRowForm({
  required String label,
  required TextEditingController controller,
  String? Function(String?)? validator,
}) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Text(
          label,
          textAlign: TextAlign.right,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: TextFormField(
          validator: validator,
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.blue,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 184, 184, 184),
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: true,
            // fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          ),
        ),
      ),
    ],
  );
}

TableRow tableRowWidget({
  required String label,
  required Widget widget,
}) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Text(
          label,
          textAlign: TextAlign.right,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Align(
          alignment: Alignment.centerLeft,
          child: widget,
        ),
      ),
    ],
  );
}
