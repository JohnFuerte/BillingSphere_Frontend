import 'package:flutter/material.dart';

class PVCustomAppBar extends StatelessWidget {
  const PVCustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 6,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.82,
            height: MediaQuery.of(context).size.height * 0.03,
            color: Color.fromARGB(255, 208, 196, 30),
            child: const Text(
              'List of Purchase Voucher',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
