import 'package:flutter/material.dart';

class DSideBUtton extends StatelessWidget {
  final text;
  final VoidCallback onTapped;
  const DSideBUtton({super.key, this.text, required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 30,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: InkWell(
        onTap: onTapped,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
          softWrap: false,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
