import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PMDesktopAppbar extends StatelessWidget {
  const PMDesktopAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0, top: 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              CupertinoIcons.arrow_left,
              color: Colors.black,
              size: 15,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 25,
              color: const Color(0xff79442F),
              child: const Text(
                'Payment',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.82,
              height: 25,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 151, 111, 25),
              ),
              child: const Text(
                'Voucher Entry',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
