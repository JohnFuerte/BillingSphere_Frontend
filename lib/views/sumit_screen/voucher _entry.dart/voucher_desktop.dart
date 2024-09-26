import 'package:flutter/material.dart';

import 'voucher_list_widget.dart';
import 'voucher_button_widget.dart';

class VoucherEntryDesktop extends StatefulWidget {
  const VoucherEntryDesktop({super.key});

  @override
  State<VoucherEntryDesktop> createState() => _VoucherEntryDesktopState();
}

class _VoucherEntryDesktopState extends State<VoucherEntryDesktop> {
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
              "Dr/Cr",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TableCell(
            child: Text(
              "Ledger Name",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TableCell(
            child: Text(
              "Remark",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TableCell(
            child: Text(
              "Debit",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TableCell(
            child: Text(
              "Credit",
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 25,
                  width: MediaQuery.of(context).size.width * 0.1,
                  decoration: const BoxDecoration(
                    color: Colors.brown,
                  ),
                  child: const Text(
                    "Journal",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  height: 25,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: const BoxDecoration(
                    color: Colors.purple,
                  ),
                  child: const Text(
                    "Voucher Entry",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.9,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Row(
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Text(
                                    "No :",
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    height: 15,
                                    child: TextField(
                                      cursorHeight: 7,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              0.0), // Adjust the border radius as needed
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(
                                  flex: 1,
                                ),
                                const Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Copy Template (Alt+T)",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.indigo),
                                          ),
                                          Text(
                                            "Ouick Voucher (Alt+Q)",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.indigo),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "GST Voucher",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.indigo),
                                        ),
                                        Text(
                                          "GST Payment/ Adjustment",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.indigo),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(flex: 5),
                                const Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Ledger Name :",
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    height: 15,
                                    child: TextField(
                                      cursorHeight: 7,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              0.0), // Adjust the border radius as needed
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                                bottom: BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                                right: BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Table(
                                columnWidths: {
                                  0: const FlexColumnWidth(1),
                                  1: const FlexColumnWidth(4),
                                  2: const FlexColumnWidth(4),
                                  3: const FlexColumnWidth(2),
                                  4: const FlexColumnWidth(2),
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
                                                    ? "Dr/Cr"
                                                    : "Dr/Cr ${entry.key}",
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
                                                    ? "Ledger Name"
                                                    : "Ledger Name${entry.key}",
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
                                                    ? "Remark"
                                                    : "Remark ${entry.key}",
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
                                                    ? "Debit"
                                                    : "Debit ${entry.key}",
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
                                                    ? "Credit"
                                                    : "Credit ${entry.key}",
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
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, top: 8, bottom: 45),
                            child: Row(
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Narration :",
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: SizedBox(
                                    height: 70,
                                    child: TextField(
                                      cursorHeight: 15,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              0.0), // Adjust the border radius as needed
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(
                                  flex: 6,
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                child: Buttons(
                                  text: "Save [F4]",
                                  color: Colors.black,
                                  onPressed: () {},
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Buttons(
                                  text: "Add",
                                  color: Colors.black,
                                  onPressed: addTableRow,
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Buttons(
                                  text: "Cancel",
                                  color: Colors.black,
                                  onPressed: () {},
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Buttons(
                                  text: "Delete",
                                  color: Colors.black,
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomList(
                          Skey: "F2",
                          name: "List",
                          onTap: () {},
                        ),
                        CustomList(
                          Skey: "P",
                          name: "Print",
                          onTap: () {},
                        ),
                        CustomList(Skey: "F5", name: "Payment", onTap: () {}),
                        CustomList(
                          Skey: "F6",
                          name: "Receipt",
                          onTap: () {},
                        ),
                        CustomList(
                          Skey: "F7",
                          name: "Journal",
                          onTap: () {},
                        ),
                        CustomList(
                          Skey: "F8",
                          name: "Contra",
                          onTap: () {},
                        ),
                        CustomList(
                          Skey: "F5",
                          name: "C/Note",
                          onTap: () {},
                        ),
                        CustomList(
                          Skey: "F6",
                          name: "D/Note",
                          onTap: () {},
                        ),
                        CustomList(
                          Skey: "F7",
                          name: "GST Exp.",
                          onTap: () {},
                        ),
                        CustomList(
                          Skey: "F4",
                          name: "Edit",
                          onTap: navigateToEditPage,
                        ),
                        CustomList(
                          Skey: "Pg Up",
                          name: "Previous",
                          onTap: () {},
                        ),
                        CustomList(
                          Skey: "Pg Dn",
                          name: "Next",
                          onTap: () {},
                        ),
                        CustomList(
                          Skey: "F12",
                          name: "Audit Trail",
                          onTap: () {},
                        ),
                        CustomList(
                          Skey: "F10",
                          name: "Change Vch.",
                          onTap: () {},
                        ),
                        CustomList(
                          Skey: "D",
                          name: "Goto Ledger Name",
                          onTap: () {},
                        ),
                        CustomList(
                          Skey: "",
                          name: "",
                          onTap: () {},
                        ),
                        CustomList(
                          Skey: "G",
                          name: "Attach. Img",
                          onTap: () {},
                        ),
                        CustomList(
                          Skey: "",
                          name: "",
                          onTap: () {},
                        ),
                        CustomList(
                          Skey: "G",
                          name: "Vch Setup",
                          onTap: () {},
                        ),
                        CustomList(
                          Skey: "T",
                          name: "Print Setup",
                          onTap: () {},
                        ),
                      ],
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
