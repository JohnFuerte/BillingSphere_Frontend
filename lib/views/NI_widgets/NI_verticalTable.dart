import 'package:flutter/material.dart';

class NIEditableVerticalTable extends StatefulWidget {
  final double columnWidthWhenLess;
  final double columnWidthWhenMore;

  NIEditableVerticalTable({
    super.key,
    required this.columnWidthWhenLess,
    required this.columnWidthWhenMore,
  });

  @override
  _NIEditableTableState createState() => _NIEditableTableState();
}

class _NIEditableTableState extends State<NIEditableVerticalTable> {
  List<List<String>> tableData = [
    ['DATE', 'DEALER', 'SUB DEALER', 'RETAIL', 'MRP'],
    ['', '', '', '', ''],
  ];

  void addNewRow() {
    setState(() {
      tableData.add(List.filled(tableData[0].length, ''));
    });
  }

  double calculateColumnWidth() {
    // If the number of rows is more than 3, use columnWidthWhenMore, else use columnWidthWhenLess
    return tableData.length > 3
        ? widget.columnWidthWhenMore
        : widget.columnWidthWhenLess;
  }

  @override
  Widget build(BuildContext context) {
    double columnWidth = calculateColumnWidth();

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Expanded(
        child: Table(
          defaultColumnWidth: FixedColumnWidth(columnWidth),
          border: TableBorder.all(
            color: Colors.black,
            style: BorderStyle.solid,
            width: 1,
          ),
          children: [
            for (int colIndex = 0; colIndex < tableData[0].length; colIndex++)
              TableRow(
                children: [
                  TableCell(
                    child: Container(
                      padding: const EdgeInsets.all(2.0),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Text(
                            tableData[0][colIndex],
                            style: const TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  for (int rowIndex = 1;
                      rowIndex < tableData.length;
                      rowIndex++)
                    TableCell(
                      child: Container(
                        padding: const EdgeInsets.all(2.0),
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: TextField(
                                maxLines: null, // Allow unlimited lines
                                onChanged: (value) {
                                  setState(() {
                                    tableData[rowIndex][colIndex] = value;
                                  });
                                  if (rowIndex == tableData.length - 1 &&
                                      tableData[rowIndex]
                                          .every((cell) => cell.isNotEmpty)) {
                                    addNewRow();
                                  }
                                },
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                )),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
