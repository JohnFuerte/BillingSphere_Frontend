import 'package:flutter/material.dart';

class Mobile_LedgerDashboard extends StatefulWidget {
  const Mobile_LedgerDashboard({Key? key}) : super(key: key);

  @override
  State<Mobile_LedgerDashboard> createState() => _Mobile_LedgerDashboardState();
}

class _Mobile_LedgerDashboardState extends State<Mobile_LedgerDashboard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          openDialog();
        },
        child: const Text("Ledger Dashboard [POP UP]"),
      ),
    );
  }

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => const Phone_LedgerDashboard(),
      );
}

class Phone_LedgerDashboard extends StatefulWidget {
  const Phone_LedgerDashboard({Key? key}) : super(key: key);

  @override
  State<Phone_LedgerDashboard> createState() => _Phone_LedgerDashboardState();
}

class _Phone_LedgerDashboardState extends State<Phone_LedgerDashboard> {
  List<Map<String, String>> tableData = [
    {
      "Date": "Date 1",
      "V. No": "V. No 1",
      "Particulars": "Particulars 1",
      "Debit": "Debit 1",
      "Credit": "Credit 1",
    },
    {
      "Date": "Date 2",
      "V. No": "V. No 2",
      "Particulars": "Particulars 2",
      "Debit": "Debit 2",
      "Credit": "Credit 2",
    },
    {
      "Date": "Date 3",
      "V. No": "V. No 3",
      "Particulars": "Particulars 3",
      "Debit": "Debit 3",
      "Credit": "Credit 3",
    },
    {
      "Date": "Date 4",
      "V. No": "V. No 4",
      "Particulars": "Particulars 4",
      "Debit": "Debit 4",
      "Credit": "Credit 4",
    },
    {
      "Date": "Date 5",
      "V. No": "V. No 5",
      "Particulars": "Particulars 5",
      "Debit": "Debit 5",
      "Credit": "Credit 5",
    },
    // Add more rows as needed
  ];

  List<Map<String, String>> tableData2 = [
    {
      "Month": "Month 1",
      "Sales": "Sales 1",
      "Return": "Return 1",
      "Receipt": "Receipt 1",
      "Payment": "Payment 1",
    },
    {
      "Month": "Month 2",
      "Sales": "Sales 2",
      "Return": "Return 2",
      "Receipt": "Receipt 2",
      "Payment": "Payment 2",
    },
    {
      "Month": "Month 3",
      "Sales": "Sales 3",
      "Return": "Return 3",
      "Receipt": "Receipt 3",
      "Payment": "Payment 3",
    },
    {
      "Month": "Month 4",
      "Sales": "Sales 4",
      "Return": "Return 4",
      "Receipt": "Receipt 4",
      "Payment": "Payment 4",
    },
    {
      "Month": "Month 5",
      "Sales": "Sales 5",
      "Return": "Return 5",
      "Receipt": "Receipt 5",
      "Payment": "Payment 5",
    },
  ];
  List<Map<String, String>> tableData3 = [
    {
      "Particulars": "Particulars 1",
      "Amount": "Amount 1",
      "Qty": "Qty 1",
    },
    {
      "Particulars": "Particulars 2",
      "Amount": "Amount 2",
      "Qty": "Qty 2",
    },
    {
      "Particulars": "Particulars 3",
      "Amount": "Amount 3",
      "Qty": "Qty 3",
    },
    {
      "Particulars": "Particulars 4",
      "Amount": "Amount 4",
      "Qty": "Qty 4",
    },
    {
      "Particulars": "Particulars 5",
      "Amount": "Amount 5",
      "Qty": "Qty 5",
    },
  ];

  int? selected12MRadio;
  int? selected9MRadio;
  int? selected6MRadio;
  int? selected3MRadio;
  int? selectedDaysRadio;
  int? selected12M2Radio;
  int? selected9M2Radio;
  int? selected6M2Radio;
  int? selected3M2Radio;
  int? selectedDays2Radio;
  int? selectedGroupRadio;
  int? selectedBrandRadio;
  int? selectedItemRadio;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width * 0.7,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.blueAccent[400],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(flex: 1),
                    const Text(
                      "Ledger Dashboard",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      icon: const Icon(Icons.cancel_presentation),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.8,
                          color: Colors.lightBlue,
                          child: const Text(
                            "Basic Information",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, left: 4, bottom: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: const Row(
                              children: [
                                Text(
                                  "Ledger Name",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "MUNNABHAI",
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.51,
                            child: const Row(
                              children: [
                                Text(
                                  "Address",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "Room No. 382\nM Building\nBhuj Kutch",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 10),
                          child: Row(
                            children: [
                              Text(
                                "Cont. No",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 8),
                          child: Row(
                            children: [
                              Text(
                                "Email",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 8),
                          child: Row(
                            children: [
                              Text(
                                "GSTIN",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: const Row(
                              children: [
                                Text(
                                  "Balance",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "180379.9 Dr",
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: const Row(
                              children: [
                                Text(
                                  "Last Sales",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "RJ/2585",
                                      style: TextStyle(
                                        color: Colors.indigo,
                                        fontSize: 10,
                                      ),
                                    ),
                                    Text(
                                      "On 16/5/2022 638 Days ago)\n[Amount = 3655.02]",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 8),
                          child: Row(
                            children: [
                              Text(
                                "Last Receipt",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 2,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20,
                            width: MediaQuery.of(context).size.width * 2,
                            color: Colors.lightBlue,
                            child: const Text(
                              "Accounting Transaction",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Table(
                                columnWidths: {
                                  0: const FlexColumnWidth(1),
                                  1: const FlexColumnWidth(1),
                                  2: const FlexColumnWidth(4),
                                  3: const FlexColumnWidth(1),
                                  4: const FlexColumnWidth(1),
                                },
                                border: TableBorder.all(
                                  color: Colors.black,
                                ),
                                children: [
                                  const TableRow(
                                    children: [
                                      TableCell(
                                        child: Text(
                                          "Date",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.deepPurple,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          "V. No",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.deepPurple,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          "Particulars",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.deepPurple,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          "Debit",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.deepPurple,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          "Credit",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.deepPurple,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Loop through the list and create TableRow for each map
                                  for (var row in tableData)
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Text(
                                            row["Date"]!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            row["V. No"]!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            row["Particulars"]!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            row["Debit"]!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            row["Credit"]!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 2,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20,
                            width: MediaQuery.of(context).size.width * 2,
                            color: Colors.lightBlue,
                            child: const Text(
                              "Sales Summary",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.5,
                                    child: Radio(
                                      value: 1,
                                      groupValue: selected12MRadio,
                                      onChanged: (value) {
                                        setState(() {
                                          selected12MRadio = value as int?;
                                        });
                                      },
                                    ),
                                  ),
                                  const Text(
                                    "12 Months",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.5,
                                    child: Radio(
                                      value: 1,
                                      groupValue: selected9MRadio,
                                      onChanged: (value) {
                                        setState(() {
                                          selected9MRadio = value as int?;
                                        });
                                      },
                                    ),
                                  ),
                                  const Text(
                                    "9 Months",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.5,
                                    child: Radio(
                                      value: 1,
                                      groupValue: selected6MRadio,
                                      onChanged: (value) {
                                        setState(() {
                                          selected6MRadio = value as int?;
                                        });
                                      },
                                    ),
                                  ),
                                  const Text(
                                    "6 Months",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.5,
                                    child: Radio(
                                      value: 1,
                                      groupValue: selected3MRadio,
                                      onChanged: (value) {
                                        setState(() {
                                          selected3MRadio = value as int?;
                                        });
                                      },
                                    ),
                                  ),
                                  const Text(
                                    "3 Months",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.5,
                                    child: Radio(
                                      value: 1,
                                      groupValue: selectedDaysRadio,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedDaysRadio = value as int?;
                                        });
                                      },
                                    ),
                                  ),
                                  const Text(
                                    "? Days",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4, right: 12),
                            child: Table(
                                border: TableBorder.all(
                                  color: Colors.black,
                                ),
                                children: [
                                  const TableRow(
                                    children: [
                                      TableCell(
                                        child: Text(
                                          "Month",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.deepPurple,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          "Sales",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.deepPurple,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          "Return",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.deepPurple,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          "Receipt",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.deepPurple,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          "Payment",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.deepPurple,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Loop through the list and create TableRow for each map
                                  for (var row in tableData2)
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Text(
                                            row["Month"]!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            row["Sales"]!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            row["Return"]!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            row["Receipt"]!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            row["Payment"]!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 2,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20,
                            width: MediaQuery.of(context).size.width * 2,
                            color: Colors.lightBlue,
                            child: const Text(
                              "Item Transaction Summary",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.5,
                                    child: Radio(
                                      value: 1,
                                      groupValue: selectedGroupRadio,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedGroupRadio = value as int?;
                                        });
                                      },
                                    ),
                                  ),
                                  const Text(
                                    "Groupwise",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.5,
                                    child: Radio(
                                      value: 1,
                                      groupValue: selectedBrandRadio,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedBrandRadio = value as int?;
                                        });
                                      },
                                    ),
                                  ),
                                  const Text(
                                    "Brandwise",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.5,
                                    child: Radio(
                                      value: 1,
                                      groupValue: selectedItemRadio,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedItemRadio = value as int?;
                                        });
                                      },
                                    ),
                                  ),
                                  const Text(
                                    "Itemwise",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.5,
                                    child: Radio(
                                      value: 1,
                                      groupValue: selected12M2Radio,
                                      onChanged: (value) {
                                        setState(() {
                                          selected12M2Radio = value as int?;
                                        });
                                      },
                                    ),
                                  ),
                                  const Text(
                                    "12 Months",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.5,
                                    child: Radio(
                                      value: 1,
                                      groupValue: selected9M2Radio,
                                      onChanged: (value) {
                                        setState(() {
                                          selected9M2Radio = value as int?;
                                        });
                                      },
                                    ),
                                  ),
                                  const Text(
                                    "9 Months",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.5,
                                    child: Radio(
                                      value: 1,
                                      groupValue: selected6M2Radio,
                                      onChanged: (value) {
                                        setState(() {
                                          selected6M2Radio = value as int?;
                                        });
                                      },
                                    ),
                                  ),
                                  const Text(
                                    "6 Months",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.5,
                                    child: Radio(
                                      value: 1,
                                      groupValue: selected3M2Radio,
                                      onChanged: (value) {
                                        setState(() {
                                          selected3M2Radio = value as int?;
                                        });
                                      },
                                    ),
                                  ),
                                  const Text(
                                    "3 Months",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.5,
                                    child: Radio(
                                      value: 1,
                                      groupValue: selectedDays2Radio,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedDays2Radio = value as int?;
                                        });
                                      },
                                    ),
                                  ),
                                  const Text(
                                    "? Days",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Table(
                                columnWidths: {
                                  0: const FlexColumnWidth(4),
                                  1: const FlexColumnWidth(1),
                                  2: const FlexColumnWidth(1),
                                },
                                border: TableBorder.all(
                                  color: Colors.black,
                                ),
                                children: [
                                  const TableRow(
                                    children: [
                                      TableCell(
                                        child: Text(
                                          "Particulars",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.deepPurple,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          "Amount",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.deepPurple,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          "Qty",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.deepPurple,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Loop through the list and create TableRow for each map
                                  for (var row in tableData3)
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Text(
                                            row["Particulars"]!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            row["Amount"]!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            row["Qty"]!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ]),
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
      ),
    );
  }
}
