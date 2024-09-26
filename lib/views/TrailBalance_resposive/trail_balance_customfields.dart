import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

Widget trailBalanceCustomContainer({
  required BuildContext context,
  String? text,
  Widget? destinationRoute,
  Icon? prefixIcon,
   bool showText = true, 
}) {
  return InkWell(
    onTap: () {
      if (destinationRoute != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => destinationRoute),
        );
      }
    },
    child: Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.black),
      ),
      child: Row(
        children: [
          10.widthBox,
          if (prefixIcon != null) prefixIcon,
          10.widthBox,
          Center(
            child:showText && text != null
                ? Text(
                    text,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF05036B), fontSize: 16),
                  )
                : SizedBox(), // Making text optional
          ),
        ],
      ),
    ),
  );
}