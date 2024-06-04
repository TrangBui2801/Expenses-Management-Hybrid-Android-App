// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class CustomTextView extends StatelessWidget {
  final String label;
  final String value;
  final int minLines;
  CustomTextView(this.label, this.value, this.minLines);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 10),
          width: MediaQuery.of(context).size.width - 32,
          height: 50.0 * minLines + 10.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue.shade500, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        Positioned(
            left: 22,
            top: 0,
            child: Container(
              padding: EdgeInsets.only(bottom: 4, left: 8, right: 4),
              color: Colors.white,
              child: Text(
                label,
                style: TextStyle(color: Colors.blue.shade500, fontSize: 12),
              ),
            )),
      ],
    );
  }
}
