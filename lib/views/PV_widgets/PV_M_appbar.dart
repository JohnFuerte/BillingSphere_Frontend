import 'package:flutter/material.dart';

class PVMCustomAppBar extends StatelessWidget {
  const PVMCustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.08,
            color: const Color(0xff70402a),
            child: const Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text(
                'Tax Purchase',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
