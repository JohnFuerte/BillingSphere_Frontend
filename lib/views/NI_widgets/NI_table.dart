import 'package:billingsphere/views/NI_widgets/NI_verticalTable.dart';
import 'package:flutter/material.dart';

class NIEditableTable extends StatefulWidget {
  @override
  _NIEditableTableState createState() => _NIEditableTableState();
}

class _NIEditableTableState extends State<NIEditableTable> {
  List<List<String>> tableData = [
    ['DATE', 'DEALER', 'SUB DEAL..', 'RETAIL', 'MRP'],
    ['', '', '', '', ''],
  ];

  void addNewRow() {
    setState(() {
      tableData.add(['', '', '', '', '']);
    });
  }

  List<List<TextEditingController>> controllersList = [];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double columnWidth = screenWidth * 0.08;

    if (screenWidth < 1000) {
      return Center(
        child: NIEditableVerticalTable(
          columnWidthWhenLess: MediaQuery.of(context).size.width * .11,
          columnWidthWhenMore: MediaQuery.of(context).size.width * .07,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(10),
      child: Table(
        defaultColumnWidth: FixedColumnWidth(columnWidth),
        border: TableBorder.all(
          color: Colors.black,
          style: BorderStyle.solid,
          width: 1,
        ),
        children: [
          TableRow(
            children: [
              for (var header in tableData.first) buildHeaderCell(header),
            ],
          ),
          TableRow(
            children: [
              for (int index = 0; index < tableData.first.length; index++)
                buildEditableCell(index)
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeaderCell(String text) {
    return Column(
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Colors.deepPurple,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildEditableCell(int index) {
    return SizedBox(
      height: 30,
      child: Column(
        children: [
          SizedBox(
            height: 30,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: controllersList.isNotEmpty
                    ? controllersList.last[index]
                    : null,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  if (index == controllersList.last.length - 1 &&
                      controllersList.last
                          .every((controller) => controller.text.isNotEmpty)) {
                    // Add a new row when all text fields in the current row are filled
                    addNewRow();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
