import 'package:flutter/material.dart';

import '../sumit_responsive.dart';
import '../voucher _entry.dart/voucher_list_widget.dart';
import 'gst_payment_mobile.dart';

class Responsive_GSTPayment extends StatefulWidget {
  const Responsive_GSTPayment({Key? key}) : super(key: key);

  @override
  State<Responsive_GSTPayment> createState() => _Responsive_GSTPaymentState();
}

class _Responsive_GSTPaymentState extends State<Responsive_GSTPayment> {
  late List<TableRow> tables;
  int selectedRowIndex = -1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tables = [
      const TableRow(
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
              "V. No",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TableCell(
            child: Text(
              "Type",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TableCell(
            child: Text(
              "CGST",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TableCell(
            child: Text(
              "IGST",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TableCell(
            child: Text(
              "IGST",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TableCell(
            child: Text(
              "Cess",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TableCell(
            child: Text(
              "Interest",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TableCell(
            child: Text(
              "Penalty",
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
        const TableRow(
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
            TableCell(child: Text("")),
            TableCell(child: Text("")),
            TableCell(child: Text("")),
            TableCell(child: Text("")),
          ],
        ),
      );
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

  void handleRowTap(int rowIndex) {
    setState(() {
      selectedRowIndex = rowIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        mobile: Mobile_GSTPayment(),
        tablet: Container(),
        desktop: Column(
          children: [
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.blueAccent[400],
              ),
              child: const Text(
                "GST PAYMENT/ ADJUSTMENT MASTER",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            Row(
              children: [
                Column(
                  children: [
                    Card(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.9,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Center(
                          child: Card(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.9,
                              width: MediaQuery.of(context).size.width * 0.6,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: 30,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, right: 8),
                                          child: Row(
                                            children: [
                                              const Expanded(
                                                flex: 1,
                                                child: Text(
                                                  "Search",
                                                  style: TextStyle(
                                                    color: Colors.deepPurple,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Container(
                                                  color: Colors.black,
                                                  height: 20,
                                                  child: TextField(
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                    cursorHeight: 10,
                                                    decoration: InputDecoration(
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                0.0), // Adjust the border radius as needed
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0.0),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .grey),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.78,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: SingleChildScrollView(
                                          child: Table(
                                            border: TableBorder.all(
                                              color: Colors.grey,
                                            ),
                                            children: tables
                                                .asMap()
                                                .entries
                                                .map(
                                                  (entry) => TableRow(
                                                    decoration: BoxDecoration(
                                                      color: selectedRowIndex ==
                                                              entry.key
                                                          ? Colors.blue
                                                          : Colors.white,
                                                    ),
                                                    children: [
                                                      TableCell(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            handleRowTap(
                                                                entry.key);
                                                          },
                                                          child: Text(
                                                            entry.key == 0
                                                                ? "Sr."
                                                                : (entry.key)
                                                                    .toString(),
                                                            style: TextStyle(
                                                              color: entry.key ==
                                                                      0
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            handleRowTap(
                                                                entry.key);
                                                          },
                                                          child: Text(
                                                            entry.key == 0
                                                                ? "Date"
                                                                : "Date${entry.key}",
                                                            style: TextStyle(
                                                              color: entry.key ==
                                                                      0
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            handleRowTap(
                                                                entry.key);
                                                          },
                                                          child: Text(
                                                            entry.key == 0
                                                                ? "V.No"
                                                                : "V.No ${entry.key}",
                                                            style: TextStyle(
                                                              color: entry.key ==
                                                                      0
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            handleRowTap(
                                                                entry.key);
                                                          },
                                                          child: Text(
                                                            entry.key == 0
                                                                ? "Type"
                                                                : "Type ${entry.key}",
                                                            style: TextStyle(
                                                              color: entry.key ==
                                                                      0
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            handleRowTap(
                                                                entry.key);
                                                          },
                                                          child: Text(
                                                            entry.key == 0
                                                                ? "CGST"
                                                                : "CGST ${entry.key}",
                                                            style: TextStyle(
                                                              color: entry.key ==
                                                                      0
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            handleRowTap(
                                                                entry.key);
                                                          },
                                                          child: Text(
                                                            entry.key == 0
                                                                ? "IGST"
                                                                : "IGST ${entry.key}",
                                                            style: TextStyle(
                                                              color: entry.key ==
                                                                      0
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            handleRowTap(
                                                                entry.key);
                                                          },
                                                          child: Text(
                                                            entry.key == 0
                                                                ? "IGST"
                                                                : "IGST ${entry.key}",
                                                            style: TextStyle(
                                                              color: entry.key ==
                                                                      0
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            handleRowTap(
                                                                entry.key);
                                                          },
                                                          child: Text(
                                                            entry.key == 0
                                                                ? "Cess"
                                                                : "Cess ${entry.key}",
                                                            style: TextStyle(
                                                              color: entry.key ==
                                                                      0
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            handleRowTap(
                                                                entry.key);
                                                          },
                                                          child: Text(
                                                            entry.key == 0
                                                                ? "Interest"
                                                                : "Interest ${entry.key}",
                                                            style: TextStyle(
                                                              color: entry.key ==
                                                                      0
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            handleRowTap(
                                                                entry.key);
                                                          },
                                                          child: Text(
                                                            entry.key == 0
                                                                ? "Penalty"
                                                                : "Penalty ${entry.key}",
                                                            style: TextStyle(
                                                              color: entry.key ==
                                                                      0
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
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
                                      const Text(
                                        "NO RECORDS",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width * 0.085,
                  child: Column(
                    children: [
                      CustomList(
                        Skey: "F3",
                        name: "New",
                        onTap: () {},
                      ),
                      CustomList(
                        Skey: "F4",
                        name: "Edit",
                        onTap: navigateToEditPage,
                      ),
                      CustomList(Skey: "A", name: "Add", onTap: addTableRow),
                      CustomList(
                        Skey: "D",
                        name: "Delete",
                        onTap: () {},
                      ),
                      CustomList(
                        Skey: "X",
                        name: "Excel",
                        onTap: () {},
                      ),
                      CustomList(
                        Skey: "",
                        name: "",
                        onTap: () {},
                      ),
                      CustomList(
                        Skey: "",
                        name: "",
                        onTap: () {},
                      ),
                      CustomList(
                        Skey: "M",
                        name: "Update",
                        onTap: () {},
                      ),
                      CustomList(
                        Skey: "",
                        name: "",
                        onTap: () {},
                      ),
                      CustomList(
                        Skey: "",
                        name: "",
                        onTap: () {},
                      ),
                      CustomList(
                        Skey: "",
                        name: "",
                        onTap: () {},
                      ),
                      CustomList(
                        Skey: "",
                        name: "",
                        onTap: () {},
                      ),
                      CustomList(
                        Skey: "",
                        name: "",
                        onTap: () {},
                      ),
                      CustomList(
                        Skey: "",
                        name: "",
                        onTap: () {},
                      ),
                    ],
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
        title: const Text('Edit Page'),
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
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
