import 'package:flutter/material.dart';

class HiddenPassword extends StatefulWidget {
  final TextEditingController controller;

  final String? Function(String?)? validator;
  const HiddenPassword({super.key, required this.controller, this.validator});

  @override
  State<HiddenPassword> createState() => _HiddenppasswordState();
}

class _HiddenppasswordState extends State<HiddenPassword> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      // height: 50,
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        obscureText: _obscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 216, 151, 253), width: 2),
          ),
          labelText: 'Password',
          filled: true,
          fillColor: Colors.white,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
            ),
          ),
        ),
      ),
    );
  }
}
