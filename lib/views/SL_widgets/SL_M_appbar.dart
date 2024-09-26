import 'package:flutter/material.dart';

class SLMCustomAppBar extends StatelessWidget {
  const SLMCustomAppBar({super.key, this.text});
  final text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      color: const Color.fromARGB(255, 33, 44, 243),
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.01),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
    );
  }
}
