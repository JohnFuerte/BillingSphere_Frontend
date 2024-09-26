import 'package:billingsphere/views/NI_widgets/NI_cstmWidget.dart';
import 'package:flutter/material.dart';

class NICustomRowTextField extends StatelessWidget {
  final String labelText1;
  final String labelText2;

  NICustomRowTextField({required this.labelText1, required this.labelText2});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: NICustomTextField(labelText: labelText1)),
        Expanded(child: NICustomTextField(labelText: labelText2))
      ],
    );
  }
}
