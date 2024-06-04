// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isNumber;
  final int minLines;
  final bool isRequired;
  const CustomTextField(this.label, this.hint, this.controller, this.isNumber,
      this.minLines, this.isRequired);
  const CustomTextField.nonRequired(String label, String hint,
      TextEditingController controller, bool isNumber, int minLines)
      : this(label, hint, controller, isNumber, minLines, false);
  const CustomTextField.number(String label, String hint,
      TextEditingController controller, bool isNumber, int minLines)
      : this(label, hint, controller, isNumber, minLines, false);

  @override
  Widget build(BuildContext context) {
    TextInputType inputType;
    List<TextInputFormatter> formatter;
    if (isNumber) {
      inputType = TextInputType.number;
      formatter = <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly];
    } else {
      formatter = [];
      inputType = TextInputType.text;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
          child: TextFormField(
            keyboardType: inputType,
            maxLines: null,
            minLines: minLines,
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
            ),
            inputFormatters: formatter,
            validator: (value) {
              if (isRequired) {
                if (value == null || value.isEmpty) {
                  return '$label cannot be blank';
                }
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
