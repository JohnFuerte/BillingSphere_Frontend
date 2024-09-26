import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../sumit_screen/voucher _entry.dart/voucher_list_widget.dart';

class TrailBalance extends StatefulWidget {
  @override
  _TrailBalanceState createState() => _TrailBalanceState();
}

class _TrailBalanceState extends State<TrailBalance> {
  int _selectedRowIndex = -1;

  void _onRowSelected(int index) {
    setState(() {
      _selectedRowIndex = index;
    });
  }

  void _onRowDoubleTapped(int index) {
    List<Function?> routes = [
      // () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp())),
      // () => Navigator.push(context, MaterialPageRoute(builder: (context) => trial())),
      // () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp())),
      // () => Navigator.push(context, MaterialPageRoute(builder: (context) => trial())),
      // () => null,
      // () => Navigator.push(context, MaterialPageRoute(builder: (context) => trial())),
      // () => Navigator.push(context, MaterialPageRoute(builder: (context) => trial())),
      // () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp())),
      // () => null,
    ];

    // Check if the index is within the range of routes
    if (index >= 0 && index < routes.length) {
      // Navigate to the corresponding route for the selected row
      routes[index]?.call();
    }
  }

  // List Of the data
  List<Map<String, dynamic>> rowDataList = [
    {
      'Name': 'Current Assets',
      'CI.Debit': '0',
      'CI.Credit': '0',
      'sub': '',
      'isBold': true,
    },
    {
      'Name': '',
      'CI.Debit': '0',
      'CI.Credit': '0',
      'sub': 'Bank Account',
      'isBold': true,
    },
    {
      'Name': '',
      'CI.Debit': '0',
      'CI.Credit': '0',
      'sub': 'Cash-In-Hand',
      'isBold': true,
    },
    {
      'Name': '',
      'CI.Debit': '0',
      'CI.Credit': '0',
      'sub': 'Customers',
      'isBold': true,
    },
    {
      'Name': '',
      'CI.Debit': '',
      'CI.Credit': '',
      'sub': '',
      'isBold': false,
    },
    {
      'Name': 'Current Liabilities',
      'CI.Debit': '0',
      'CI.Credit': '0',
      'sub': '',
      'isBold': true,
    },
    {
      'Name': '',
      'CI.Debit': '0',
      'CI.Credit': '0',
      'sub': 'Duties & Taxes',
      'isBold': true,
    },
    {
      'Name': '',
      'CI.Debit': '',
      'CI.Credit': '',
      'sub': '',
      'isBold': false,
    },
    {
      'Name': 'Sales Account',
      'CI.Debit': '0',
      'CI.Credit': '0',
      'sub': '',
      'isBold': true,
    },
    {
      'Name': '',
      'CI.Debit': '0',
      'CI.Credit': '0',
      'sub': 'Tax Sales',
      'isBold': false,
    },
    {
      'Name': '',
      'CI.Debit': '',
      'CI.Credit': '',
      'sub': '',
      'isBold': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trail Balance',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.88,
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(300),
                  1: FlexColumnWidth(100),
                  2: FlexColumnWidth(100),
                  3: FlexColumnWidth(100),
                },
                border: TableBorder.all(),
                children: [
                  const TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Name',
                            style: TextStyle(
                              color: Color(0xFF05036B),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'CI.Debit',
                            style: TextStyle(
                              color: Color(0xFF05036B),
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'CI.Credit',
                            style: TextStyle(
                              color: Color(0xFF05036B),
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                  for (int i = 0; i < rowDataList.length; i++)
                    TableRow(
                      decoration: BoxDecoration(
                        color: i == _selectedRowIndex
                            ? const Color.fromARGB(255, 16, 13, 207)
                            : null,
                      ),
                      children: [
                        TableCell(
                          child: InkWell(
                            onTap: () => _onRowSelected(i),
                            onDoubleTap: () => _onRowDoubleTapped(i),
                            child: Padding(
                              padding: rowDataList[i].containsKey('sub') &&
                                      rowDataList[i]['sub'] != ''
                                  ? const EdgeInsets.only(
                                      left: 30.0, top: 8.0, bottom: 8.0)
                                  : const EdgeInsets.all(8.0),
                              child: Text(
                                rowDataList[i].containsKey('sub') &&
                                        rowDataList[i]['sub'] != ''
                                    ? rowDataList[i]['sub'] ?? ''
                                    : rowDataList[i]['Name'] ?? '',
                                style: TextStyle(
                                  color: i == _selectedRowIndex
                                      ? Colors.amber
                                      : Colors.black,
                                  fontWeight: rowDataList[i]['isBold']
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: InkWell(
                            onTap: () => _onRowSelected(i),
                            onDoubleTap: () => _onRowDoubleTapped(i),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                rowDataList[i]['CI.Debit'] ?? '',
                                style: TextStyle(
                                  color: i == _selectedRowIndex
                                      ? Colors.amber
                                      : Colors.black,
                                  fontWeight: rowDataList[i]['isBold']
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: InkWell(
                            onTap: () => _onRowSelected(i),
                            onDoubleTap: () => _onRowDoubleTapped(i),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                rowDataList[i]['CI.Credit'] ?? '',
                                style: TextStyle(
                                  color: i == _selectedRowIndex
                                      ? Colors.amber
                                      : Colors.black,
                                  fontWeight: rowDataList[i]['isBold']
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                textAlign: TextAlign.right,
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
          Spacer(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.099,
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
                  onTap: () {},
                ),
                CustomList(Skey: "", name: "", onTap: () {}),
                CustomList(Skey: "", name: "", onTap: () {}),
                CustomList(Skey: "X", name: "Export-Excel", onTap: () {}),
                CustomList(Skey: "", name: "", onTap: () {}),
                CustomList(
                    Skey: "P",
                    name: "Print",
                    onTap: () {
                      // Navigator.of(context).pushReplacement(
                      //   MaterialPageRoute(
                      //     builder: (context) => DailyCashReceipt(
                      //       dailyCashID: activeid,
                      //       title: 'Print Daily Cash Receipt',
                      //     ),
                      //   ),
                      // );
                    }),
                CustomList(Skey: "M", name: "MultiUpdate", onTap: () {}),
                CustomList(Skey: "", name: "", onTap: () {}),
                CustomList(Skey: "", name: "", onTap: () {}),
                CustomList(Skey: "", name: "", onTap: () {}),
                CustomList(Skey: "", name: "", onTap: () {}),
                CustomList(Skey: "", name: "", onTap: () {}),
                CustomList(Skey: "", name: "", onTap: () {}),
                CustomList(Skey: "", name: "", onTap: () {}),
                CustomList(Skey: "", name: "", onTap: () {}),
                CustomList(Skey: "", name: "", onTap: () {}),
                CustomList(Skey: "", name: "", onTap: () {}),
                CustomList(Skey: "", name: "", onTap: () {}),
                CustomList(Skey: "", name: "", onTap: () {}),
                CustomList(Skey: "", name: "", onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
