import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryCell extends StatelessWidget {
  final String categoryName, total;
  const CategoryCell(
      {super.key, required this.categoryName, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HeaderCell(
          flex: 5,
          text: categoryName,
          fontWeight: FontWeight.w600,
          bordor: Border.all(),
          textColor: Colors.purple.shade400,
        ),
        HeaderCell(
          flex: 2,
          text: "",
          bordor: Border.all(),
        ),
        HeaderCell(
          flex: 2,
          text: "",
          bordor: Border.all(),
        ),
        HeaderCell(
          flex: 1,
          text: "",
          bordor: Border.all(),
        ),
        HeaderCell(
          flex: 1,
          text: "",
          bordor: Border.all(),
        ),
        HeaderCell(
          flex: 2,
          text: "",
          bordor: Border.all(),
        ),
        HeaderCell(
          flex: 2,
          text: "",
          bordor: Border.all(),
        ),
        HeaderCell(
          flex: 2,
          text: total,
          fontWeight: FontWeight.w600,
          align: TextAlign.right,
          bordor: Border.all(),
          textColor: Colors.purple.shade400,
        ),
      ],
    );
  }
}

class HeaderCell extends StatelessWidget {
  final int flex;
  final String text;
  final TextAlign? align;
  final Color? textColor;
  final FontWeight? fontWeight;
  final Border? bordor;
  const HeaderCell(
      {super.key,
      required this.flex,
      required this.text,
      this.align,
      this.textColor,
      this.bordor,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
              border: bordor ?? Border.all(color: Colors.transparent)),
          child: Text(
            text,
            textAlign: align,
            overflow: TextOverflow.ellipsis,
            style:
                GoogleFonts.poppins(color: textColor, fontWeight: fontWeight),
          ),
        ));
  }
}

class RowCell extends StatelessWidget {
  final int flex;
  final String? text;
  final TextAlign? align;
  final Color? textColor;
  final FontWeight? fontWeight;
  final Border? bordor;
  final Color? containercolor;
  final Widget? child;
  const RowCell(
      {super.key,
      required this.flex,
      this.text,
      this.align,
      this.textColor,
      this.fontWeight,
      this.bordor,
      this.containercolor,
      this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex,
        child: Container(
          padding: const EdgeInsets.only(left: 17, top: 8, bottom: 8, right: 8),
          decoration: BoxDecoration(
              color: containercolor, border: bordor ?? Border.all()),
          child: child ??
              Text(
                text ?? "",
                textAlign: align,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                    color: textColor ?? Colors.black,
                    fontWeight: fontWeight ?? FontWeight.w600),
              ),
        ));
  }
}

class HeaderCell2 extends StatelessWidget {
  final String text;
  final TextAlign? align;
  final Color? textColor;
  final FontWeight? fontWeight;
  final Border? bordor;
  const HeaderCell2(
      {super.key,
      required this.text,
      this.align,
      this.textColor,
      this.bordor,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: bordor ?? Border.all(color: Colors.transparent)),
      child: Text(
        text,
        textAlign: align,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.poppins(
            color: textColor ?? Colors.black, fontWeight: fontWeight),
      ),
    );
  }
}
