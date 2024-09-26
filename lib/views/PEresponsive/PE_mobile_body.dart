import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// final formatter = DateFormat.yMd();

class PEMyMobileBody extends StatefulWidget {
  const PEMyMobileBody({super.key});

  @override
  State<PEMyMobileBody> createState() => _PEMyMobileBodyState();
}

class _PEMyMobileBodyState extends State<PEMyMobileBody> {
  final formatter = DateFormat.yMd();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _dateController2 = TextEditingController();

  void _presentDatePICKER() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final _pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );

    if (_pickedDate != null) {
      setState(() {
        _dateController.text = formatter.format(_pickedDate);
      });
    }
  }

  void _showDataPICKER() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final _pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );
    if (_pickedDate != null) {
      setState(() {
        _dateController2.text = formatter.format(_pickedDate);
      });
    }
  }

  // void _showDataPICKER() async {
  //   final now = DateTime.now();
  //   final firstDate = DateTime(now.year - 1, now.month, now.day);
  //   final _pickedDate = await showDatePicker(
  //     context: context,
  //     firstDate: firstDate,
  //     lastDate: now,
  //   );

  //   setState(() {
  //     _pickedDateData = _pickedDate;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final List<String> items = List.generate(20, (index) => '${index + 1}');
    // final List<String> items2 = List.generate(5, (index) => '${index + 1}');

    List<String> header2Titles = [
      'Sr',
      'Sundry Name',
      'Amount',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.08,
                color: const Color(0xff70402a),
                child: const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    'Tax Purchase',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.82,
                height: MediaQuery.of(context).size.height * 0.08,
                color: const Color(0xffa07d40),
                child: const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    'Purchase Entry',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
     
     
     
     
     
     
     
     
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.10,
                            child: const Text(
                              'No',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              height: 25,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(0),
                                color: Colors.black,
                              ),
                              child: TextFormField(
                                style: const TextStyle(
                                  color: Colors.white,
                                  height: 1,
                                  fontSize: 17,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.10,
                            child: const Text(
                              'Date',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              height: 25,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: TextFormField(
                                controller: _dateController,
                                style: const TextStyle(
                                  height: 1,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Select Date',
                                  border: InputBorder.none,
                                ),
                                onTap: () {
                                  _presentDatePICKER();
                                },
                              ),
                            ),
                          ),

                          // Flexible(
                          //   child: Container(
                          //     width: MediaQuery.of(context).size.width * 0.60,
                          //     height: 30,
                          //     decoration: BoxDecoration(
                          //       border: Border.all(color: Colors.black),
                          //       borderRadius: BorderRadius.circular(0),
                          //     ),
                          //     child: TextFormField(
                          //       style: const TextStyle(
                          //           height: 1,
                          //           fontSize: 15,
                          //           fontWeight: FontWeight.bold),
                          //       decoration: InputDecoration(
                          //         hintText: _pickedDateData == null
                          //             ? '12/12/2023'
                          //             : formatter.format(_pickedDateData!),
                          //         border: InputBorder.none,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.03,
                          //   child: IconButton(
                          //       onPressed: _showDataPICKER,
                          //       icon: const Icon(Icons.calendar_month)),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.10,
                            child: const Text(
                              'Type',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              height: 25,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: TextFormField(
                                style: const TextStyle(
                                    height: 1,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
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
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.10,
                            child: const Text(
                              'Party',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              height: 25,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: TextFormField(
                                style: const TextStyle(
                                    height: 1,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
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
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.10,
                            child: const Text(
                              'Place',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              height: 25,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: TextFormField(
                                style: const TextStyle(
                                    height: 1,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
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
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.10,
                            child: const Text(
                              'Bill No',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              height: 25,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: TextFormField(
                                style: const TextStyle(
                                    height: 1,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
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
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.10,
                            child: const Text(
                              'Date',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              height: 25,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: TextFormField(
                                controller: _dateController2,
                                style: const TextStyle(
                                  height: 1,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Select Date',
                                  border: InputBorder.none,
                                ),
                                onTap: () {
                                  _showDataPICKER();
                                },
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.03,
                          //   child: IconButton(
                          //       onPressed: _presentDatePICKER,
                          //       icon: const Icon(Icons.calendar_month)),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        // color: Colors.grey,
                        width: MediaQuery.of(context).size.width * 0.916,
                        height: MediaQuery.of(context).size.height * 0.07,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          // border: Border.all(
                          //   color: const Color.fromARGB(255, 44, 43, 43),
                          //   width: 1,
                          // ),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Sr')),
                              DataColumn(label: Text('Item Name')),
                              DataColumn(label: Text('Qty')),
                              DataColumn(label: Text('Unit')),
                              DataColumn(label: Text('Rate')),
                              DataColumn(label: Text('Unit')),
                              DataColumn(label: Text('Amount')),
                              DataColumn(label: Text('Disc.')),
                              DataColumn(label: Text('Tax%')),
                              DataColumn(label: Text('SGST')),
                              DataColumn(label: Text('CGST')),
                              DataColumn(label: Text('IGST')),
                              DataColumn(label: Text('Net Amt.')),
                            ],
                            rows: [],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
           
           
           
           
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.916,
                    height: MediaQuery.of(context).size.height * 0.30,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.zero,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: List.generate(
                            20,
                            (rowIndex) => Row(
                              children: List.generate(
                                13,
                                (colIndex) => Container(
                                  width: 100.0,
                                  height: 50,
                                  padding: const EdgeInsets.all(0.0),
                                  child: colIndex == 0
                                      ? Text(
                                          '${rowIndex + 1}',
                                        )
                                      : const TextField(
                                          style: TextStyle(
                                            height: 1,
                                            fontSize: 15,
                                          ),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.zero,
                                            ),
                                            hintText: 'Edit me',
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          
          
          
          
          
          
          
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  children: [
                    Container(
                      // color: Colors.grey,
                      width: MediaQuery.of(context).size.width * 0.916,
                      height: MediaQuery.of(context).size.height * 0.07,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        // border: Border.all(
                        //   color: const Color.fromARGB(255, 44, 43, 43),
                        //   width: 1,
                        // ),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Total')),
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('0.00')),
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('0.00')),
                            DataColumn(label: Text('0.00')),
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('0.00')),
                            DataColumn(label: Text('0.00')),
                            DataColumn(label: Text('0.00')),
                          ],
                          rows: [],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.30,
                                      child: const Text(
                                        'Remarks',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.70,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
       
       
       
       
       
       
       
       
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.91,
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 44, 43, 43),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: Row(
                              children: List.generate(
                                header2Titles.length,
                                (index) => Expanded(
                                  child: Text(
                                    header2Titles[index],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Table Body

                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Table(
                                border: TableBorder.all(color: Colors.black),
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                children: [
                                  for (String item in items)
                                    TableRow(
                                      children: [
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        const TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: TextField(),
                                        ),
                                        const TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: TextField(),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.91,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.50,
                                    ),
                                    child: const Text(
                                      'Round off',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    '0.00',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.50),
                                    child: const Text(
                                      'Net Total ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    '0.00',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 255, 243, 132),
                              ),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1.0),
                                  side: const BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Save',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.002,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 255, 243, 132),
                              ),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1.0),
                                  side: const BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.002,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 255, 243, 132),
                              ),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1.0),
                                  side: const BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
