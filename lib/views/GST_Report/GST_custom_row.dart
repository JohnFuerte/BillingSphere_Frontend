import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTable extends StatelessWidget {
  final List<CustomTableRow> rows;

  const CustomTable({Key? key, required this.rows}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(4),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
        4: FlexColumnWidth(2),
        5: FlexColumnWidth(2),
        6: FlexColumnWidth(2),
        7: FlexColumnWidth(2),
        8: FlexColumnWidth(2),
        9: FlexColumnWidth(2),
        10: FlexColumnWidth(2),
        11: FlexColumnWidth(2),
        12: FlexColumnWidth(2),
      },
      border: TableBorder.all(color: Colors.black),
      children: rows.map((row) => row.buildTableRow()).toList(),
    );
  }
}

class CustomTableRow {
  final List<String> cellTexts;
  final List<TextAlign> alignments;
  final List<Color> colors;
  final List<FontWeight> fontWeights;
  final double fontSize;

  CustomTableRow({
    required this.cellTexts,
    required this.alignments,
    required this.colors,
    required this.fontWeights,
    this.fontSize = 16.0,
  });

  TableRow buildTableRow() {
    return TableRow(
      children: List.generate(cellTexts.length, (index) {
        return TableCell(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              cellTexts[index],
              style: GoogleFonts.poppins(
                color: colors[index],
                fontSize: fontSize,
                fontWeight: fontWeights[index],
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: alignments[index],
            ),
          ),
        );
      }),
    );
  }
}
