import 'package:flutter/material.dart';

import '../voucher _entry.dart/voucher_button_widget.dart';

class Mobile_DailyCashRecord extends StatefulWidget {
  const Mobile_DailyCashRecord({Key? key}) : super(key: key);

  @override
  State<Mobile_DailyCashRecord> createState() => _Mobile_DailyCashRecordState();
}

class _Mobile_DailyCashRecordState extends State<Mobile_DailyCashRecord> {
  late List<TableRow> tables;
  int selectedRowIndex = -1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tables = [
      TableRow(
        children: [
          TableCell(
            child: Text(
              "Sr.",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TableCell(
            child: Text(
              "Date",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TableCell(
            child: Text(
              "Cashier",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TableCell(
            child: Text(
              "Actual",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TableCell(
            child: Text(
              "System",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TableCell(
            child: Text(
              "Diff",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    ];
  }

  void addTableRow() {
    setState(() {
      tables.add(
        TableRow(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          children: [
            TableCell(child: Text("")),
            TableCell(child: Text("")),
            TableCell(child: Text("")),
            TableCell(child: Text("")),
            TableCell(child: Text("")),
            TableCell(child: Text("")),
          ],
        ),
      );
    });
  }

  void handleRowTap(int rowIndex) {
    setState(() {
      selectedRowIndex = rowIndex;
    });
  }

  void navigateToEditPage() {
    if (selectedRowIndex != -1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditPage(
            selectedRowIndex: selectedRowIndex,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 25,
          width: MediaQuery.of(context).size.width,
          child: Text(
            "Daily Cash Record Master",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.blueAccent[400],
          ),
        ),
        Column(
          children: [
            Card(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Search",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.black,
                                height: 20,
                                child: TextField(
                                  style: TextStyle(color: Colors.white),
                                  cursorHeight: 10,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          0.0), // Adjust the border radius as needed
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0.0),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                              flex: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.76,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 2,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Table(
                                  columnWidths: {
                                    0: FlexColumnWidth(1),
                                    1: FlexColumnWidth(2),
                                    2: FlexColumnWidth(4),
                                    3: FlexColumnWidth(2),
                                    4: FlexColumnWidth(2),
                                    5: FlexColumnWidth(2),
                                  },
                                  border: TableBorder.all(
                                    color: Colors.grey,
                                  ),
                                  children: tables
                                      .asMap()
                                      .entries
                                      .map(
                                        (entry) => TableRow(
                                          decoration: BoxDecoration(
                                            color: selectedRowIndex == entry.key
                                                ? Colors.blue
                                                : Colors.white,
                                          ),
                                          children: [
                                            TableCell(
                                              child: GestureDetector(
                                                onTap: () {
                                                  handleRowTap(entry.key);
                                                },
                                                child: Text(
                                                  entry.key == 0
                                                      ? "Sr."
                                                      : (entry.key).toString(),
                                                  style: TextStyle(
                                                    color: entry.key == 0
                                                        ? Colors.deepPurple
                                                        : Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: GestureDetector(
                                                onTap: () {
                                                  handleRowTap(entry.key);
                                                },
                                                child: Text(
                                                  entry.key == 0
                                                      ? "Date"
                                                      : "Date${entry.key}",
                                                  style: TextStyle(
                                                    color: entry.key == 0
                                                        ? Colors.deepPurple
                                                        : Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: GestureDetector(
                                                onTap: () {
                                                  handleRowTap(entry.key);
                                                },
                                                child: Text(
                                                  entry.key == 0
                                                      ? "Cashier"
                                                      : "Cashier ${entry.key}",
                                                  style: TextStyle(
                                                    color: entry.key == 0
                                                        ? Colors.deepPurple
                                                        : Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: GestureDetector(
                                                onTap: () {
                                                  handleRowTap(entry.key);
                                                },
                                                child: Text(
                                                  entry.key == 0
                                                      ? "Actual"
                                                      : "Actual ${entry.key}",
                                                  style: TextStyle(
                                                    color: entry.key == 0
                                                        ? Colors.deepPurple
                                                        : Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: GestureDetector(
                                                onTap: () {
                                                  handleRowTap(entry.key);
                                                },
                                                child: Text(
                                                  entry.key == 0
                                                      ? "System"
                                                      : "System ${entry.key}",
                                                  style: TextStyle(
                                                    color: entry.key == 0
                                                        ? Colors.deepPurple
                                                        : Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: GestureDetector(
                                                onTap: () {
                                                  handleRowTap(entry.key);
                                                },
                                                child: Text(
                                                  entry.key == 0
                                                      ? "Diff"
                                                      : "Diff ${entry.key}",
                                                  style: TextStyle(
                                                    color: entry.key == 0
                                                        ? Colors.deepPurple
                                                        : Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 1.2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Buttons(
                                      text: "New",
                                      color: Colors.black,
                                      onPressed: () {}),
                                  Buttons(
                                    text: "Edit",
                                    color: Colors.black,
                                    onPressed: navigateToEditPage,
                                  ),
                                  Buttons(
                                    text: "Add",
                                    color: Colors.black,
                                    onPressed: addTableRow,
                                  ),
                                  Buttons(
                                      text: "Delete",
                                      color: Colors.black,
                                      onPressed: () {}),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class EditPage extends StatelessWidget {
  final int selectedRowIndex;

  const EditPage({
    Key? key,
    required this.selectedRowIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Editing row $selectedRowIndex'),
            ElevatedButton(
              onPressed: () {
                // Implement your save logic here
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
