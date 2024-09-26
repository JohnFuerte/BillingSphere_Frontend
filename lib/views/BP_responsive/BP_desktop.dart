import 'package:billingsphere/views/RA_widgets/RA_D_appbar.dart';
import 'package:billingsphere/views/RA_widgets/RA_D_side_buttons.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class BPMyDesktopBody extends StatefulWidget {
  const BPMyDesktopBody({super.key});

  @override
  State<BPMyDesktopBody> createState() => _BPMyDesktopBodyState();
}

class _BPMyDesktopBodyState extends State<BPMyDesktopBody> {
  List<SearchFieldListItem> suggestionItems = [
    SearchFieldListItem(' India'),
    SearchFieldListItem(' United States'),
    SearchFieldListItem(' NAVNEET 100 PAGES BOOK (Pc) [-10PC]'),
    SearchFieldListItem(' Canada'),
    SearchFieldListItem(' Canada'),
    SearchFieldListItem(' Canada'),
    SearchFieldListItem(' Canada'),
    SearchFieldListItem(' Canada'),
    SearchFieldListItem(' Canada'),
    SearchFieldListItem(' Canada'),
    SearchFieldListItem(' Canada'),
    SearchFieldListItem(' Canada'),
    SearchFieldListItem(' Canada'),
    SearchFieldListItem(' Canada'),
    SearchFieldListItem(' Canada'),
    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  const RACustomAppBar(
                    text: 'Barcode Print',
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.01,
                      left: MediaQuery.of(context).size.width * 0.01,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 600,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, top: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.28,
                                        child: const Text(
                                          'Item Name (F8)',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const Text(
                                        'Qty',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.26,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                        ),
                                        child: SearchField(
                                          suggestions: suggestionItems,
                                          searchStyle:
                                              const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        height: 25,
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
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        height: 27,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                            shape: MaterialStateProperty.all<
                                                OutlinedBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(1.0),
                                                side: const BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {},
                                          child: const Text(
                                            'Add',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.07,
                                        height: 27,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                            shape: MaterialStateProperty.all<
                                                OutlinedBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(1.0),
                                                side: const BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {},
                                          child: const Text(
                                            'Clear All',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.46,
                                    height: 500,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(0),
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              child: const Text(
                                                ' Item Name (F8)',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(0),
                                              ),
                                              child: const Text(
                                                'Qty',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(0),
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              child: const Text(
                                                ' NAVNEET 100 PAGES BOOK (Pc) [-10PC]',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(0),
                                              ),
                                              child: const Text(
                                                '20',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.41,
                                        child: Text(
                                          'Total',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.combine([
                                              TextDecoration.underline,
                                            ]),
                                            decorationThickness: 2.0,
                                            decorationColor: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const Text('0.00',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.46,
                                    child: const Divider(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                height: 700,
                child: Column(
                  children: [
                    DSideBUtton(
                      onTapped: () {},
                      text: 'P Print',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: 'M From Master',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
