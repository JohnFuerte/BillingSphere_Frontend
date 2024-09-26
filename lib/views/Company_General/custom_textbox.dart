import 'package:flutter/material.dart';

class CustomTextFormFieldRow extends StatelessWidget {
  final String labelText;
  final double containerWidth;
  final double firstFlex;
  final double secondFlex;
  final bool readOnly;
  final TextEditingController? controller;
  final onSaved;
  final bool? isEditable;

  const CustomTextFormFieldRow({
    super.key,
    required this.labelText,
    required this.containerWidth,
    required this.firstFlex,
    required this.secondFlex,
    this.controller,
    required this.readOnly,
    this.onSaved,
    this.isEditable,
  });

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 25,
      width: w * containerWidth,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: firstFlex.toInt(),
              child: isEditable == true
                  ? RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.purple.shade600,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: labelText),
                          const TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Color.fromARGB(255, 4, 4, 244),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Text(
                      labelText,
                      style: TextStyle(
                          fontSize: 16, color: Colors.purple.shade600),
                    )),
          Expanded(
            flex: secondFlex.toInt(),
            child: TextFormField(
              readOnly: readOnly,
              controller: controller,
              onSaved: onSaved,
              maxLines: 1,
              cursorHeight: 23,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 8, left: 8),
                enabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.zero),
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.zero),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
