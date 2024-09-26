import 'package:flutter/material.dart';

class NIMyMobileBody extends StatefulWidget {
  const NIMyMobileBody({super.key});

  @override
  State<NIMyMobileBody> createState() => _NIMyMobileBodyState();
}

class _NIMyMobileBodyState extends State<NIMyMobileBody> {
  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.3;
    double buttonHeight = MediaQuery.of(context).size.height * 0.01;
    double screenWidth = MediaQuery.of(context).size.width;
    double columnWidth = screenWidth * 0.08;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('NEW Item', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      // body: SingleChildScrollView(
      //   child: Center(
      //     child: Padding(
      //       padding: const EdgeInsets.only(top: 8, bottom: 8),
      //       child: Column(
      //         children: [
      //           Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Container(
      //                 height: MediaQuery.of(context).size.height * 0.55,
      //                 width: MediaQuery.of(context).size.width * 0.90,
      //                 decoration: const BoxDecoration(
      //                     border: Border(
      //                         left: BorderSide(
      //                           color: Colors.black,
      //                         ),
      //                         right: BorderSide(color: Colors.black),
      //                         top: BorderSide(color: Colors.black))),
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Padding(
      //                       padding: const EdgeInsets.only(bottom: 4),
      //                       child: Container(
      //                         height: MediaQuery.of(context).size.height * 0.04,
      //                         width: MediaQuery.of(context).size.width * 0.3,
      //                         color: const Color.fromARGB(255, 14, 63, 147),
      //                         child: const Text(
      //                           ' BASIC DETAILS',
      //                           style: TextStyle(
      //                               color: Colors.white, fontSize: 15),
      //                         ),
      //                       ),
      //                     ),
      //                     Column(children: [
      //                       NISingleTextField(labelText: 'Item Group'),
      //                       const NICustomRowTextField(
      //                         labelText1: 'Item Brand',
      //                         labelText2: 'Code No',
      //                         suggestionItems: [],
      //                         flex: 4,
      //                       ),
      //                       NISingleTextField(labelText: 'Item Name'),
      //                       NISingleTextField(labelText: 'Print Name'),
      //                       const NICustomRowTextField(
      //                         labelText1: 'Tax Category',
      //                         labelText2: 'HSN Code',
      //                         suggestionItems: [],
      //                         flex: 4,
      //                       ),
      //                     ]),
      //                   ],
      //                 ),
      //               ),
      //               Container(
      //                 height: MediaQuery.of(context).size.height * 0.59,
      //                 width: MediaQuery.of(context).size.width * 0.90,
      //                 decoration: const BoxDecoration(
      //                     border: Border(
      //                         left: BorderSide(
      //                           color: Colors.black,
      //                         ),
      //                         right: BorderSide(color: Colors.black),
      //                         top: BorderSide(color: Colors.black))),
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Padding(
      //                       padding: const EdgeInsets.only(bottom: 4),
      //                       child: Container(
      //                         height: MediaQuery.of(context).size.height * 0.04,
      //                         width: MediaQuery.of(context).size.width * 0.3,
      //                         color: const Color.fromARGB(255, 14, 63, 147),
      //                         child: const Text(
      //                           ' PRICE DETAILS',
      //                           style: TextStyle(
      //                               color: Colors.white, fontSize: 15),
      //                         ),
      //                       ),
      //                     ),
      //                     Center(
      //                         child: NIEditableVerticalTable(
      //                       columnWidthWhenLess:
      //                           MediaQuery.of(context).size.width * .2,
      //                       columnWidthWhenMore:
      //                           MediaQuery.of(context).size.width * .12,
      //                     ))
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //           Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Container(
      //                 height: MediaQuery.of(context).size.height * 0.50,
      //                 width: MediaQuery.of(context).size.width * 0.90,
      //                 decoration: const BoxDecoration(
      //                     border: Border(
      //                         left: BorderSide(
      //                           color: Colors.black,
      //                         ),
      //                         right: BorderSide(color: Colors.black),
      //                         top: BorderSide(color: Colors.black))),
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Padding(
      //                       padding: const EdgeInsets.only(bottom: 4),
      //                       child: Container(
      //                         height: MediaQuery.of(context).size.height * 0.04,
      //                         width: MediaQuery.of(context).size.width * 0.3,
      //                         color: const Color.fromARGB(255, 14, 63, 147),
      //                         child: const Text(
      //                           ' STOCK OPTIONS',
      //                           style: TextStyle(
      //                               color: Colors.white, fontSize: 15),
      //                         ),
      //                       ),
      //                     ),
      //                     Column(children: [
      //                       const NICustomRowTextField(
      //                         labelText1: 'Barcode Sr',
      //                         labelText2: 'Code NO',
      //                         suggestionItems: [],
      //                         flex: 4,
      //                       ),
      //                       const NICustomRowTextField(
      //                         labelText1: 'Measurement Unit',
      //                         labelText2: 'Secondary Unit',
      //                         suggestionItems: [],
      //                         flex: 4,
      //                       ),
      //                       const NICustomRowTextField(
      //                         labelText1: 'Minimum Stock',
      //                         labelText2: 'Maximum Stock',
      //                         suggestionItems: [],
      //                         flex: 4,
      //                       ),
      //                       NISingleTextField(labelText: "Monthly Sale Qty")
      //                     ]),
      //                   ],
      //                 ),
      //               ),
      //               Container(
      //                 height: MediaQuery.of(context).size.height * 0.51,
      //                 width: MediaQuery.of(context).size.width * 0.90,
      //                 decoration: BoxDecoration(
      //                     border: Border.all(color: Colors.black)),
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Padding(
      //                       padding: const EdgeInsets.only(bottom: 4),
      //                       child: Container(
      //                         height: MediaQuery.of(context).size.height * 0.04,
      //                         width: MediaQuery.of(context).size.width * 0.3,
      //                         color: const Color.fromARGB(255, 14, 63, 147),
      //                         child: const Text(
      //                           ' ITEM IMAGES',
      //                           style: TextStyle(
      //                               color: Colors.white, fontSize: 15),
      //                         ),
      //                       ),
      //                     ),
      //                     Column(children: [
      //                       Padding(
      //                         padding: const EdgeInsets.all(4.0),
      //                         child: Row(
      //                           children: [
      //                             const Text(
      //                               'Update Image ? :',
      //                               style: TextStyle(
      //                                   fontSize: 12,
      //                                   color:
      //                                       Color.fromARGB(255, 14, 63, 147)),
      //                             ),
      //                             SizedBox(
      //                               width:
      //                                   MediaQuery.of(context).size.width * .01,
      //                             ),
      //                             Container(
      //                               width:
      //                                   MediaQuery.of(context).size.width * .25,
      //                               height: MediaQuery.of(context).size.height *
      //                                   .055,
      //                               child: const TextField(
      //                                 style: TextStyle(
      //                                     fontWeight: FontWeight.bold),
      //                                 textAlignVertical: TextAlignVertical.top,
      //                                 decoration: InputDecoration(
      //                                   border: OutlineInputBorder(
      //                                     borderSide: BorderSide(
      //                                       color: Colors.black,
      //                                     ),
      //                                   ),
      //                                 ),
      //                               ),
      //                             )
      //                           ],
      //                         ),
      //                       ),
      //                       SizedBox(
      //                         height: MediaQuery.of(context).size.height * .01,
      //                       ),
      //                       Center(
      //                           child: Row(
      //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //                         children: [
      //                           Container(
      //                             decoration: BoxDecoration(
      //                                 border: Border.all(color: Colors.black)),
      //                             height:
      //                                 MediaQuery.of(context).size.height * 0.32,
      //                             width:
      //                                 MediaQuery.of(context).size.width * 0.42,
      //                           ),
      //                           Column(
      //                             children: [
      //                               Padding(
      //                                 padding: const EdgeInsets.all(1.0),
      //                                 child: ElevatedButton(
      //                                   onPressed: () {},
      //                                   style: ElevatedButton.styleFrom(
      //                                     fixedSize:
      //                                         Size(buttonWidth, buttonHeight),
      //                                     primary: Colors.deepPurple,
      //                                     onPrimary: Colors.white,
      //                                   ),
      //                                   child: const Text('Add'),
      //                                 ),
      //                               ),
      //                               Padding(
      //                                 padding: const EdgeInsets.all(1.0),
      //                                 child: ElevatedButton(
      //                                   onPressed: () {},
      //                                   style: ElevatedButton.styleFrom(
      //                                     fixedSize:
      //                                         Size(buttonWidth, buttonHeight),
      //                                     primary: Colors.deepPurple,
      //                                     onPrimary: Colors.white,
      //                                   ),
      //                                   child: const Text('Delete'),
      //                                 ),
      //                               ),
      //                               Padding(
      //                                 padding: const EdgeInsets.all(1.0),
      //                                 child: ElevatedButton(
      //                                   onPressed: () {},
      //                                   style: ElevatedButton.styleFrom(
      //                                     fixedSize:
      //                                         Size(buttonWidth, buttonHeight),
      //                                     primary: Colors.deepPurple,
      //                                     onPrimary: Colors.white,
      //                                   ),
      //                                   child: const Text('Next'),
      //                                 ),
      //                               ),
      //                               Padding(
      //                                 padding: const EdgeInsets.all(1.0),
      //                                 child: ElevatedButton(
      //                                   onPressed: () {},
      //                                   style: ElevatedButton.styleFrom(
      //                                     fixedSize:
      //                                         Size(buttonWidth, buttonHeight),
      //                                     primary: Colors.deepPurple,
      //                                     onPrimary: Colors.white,
      //                                   ),
      //                                   child: const Text('Previous'),
      //                                 ),
      //                               ),
      //                               Padding(
      //                                 padding: const EdgeInsets.all(1.0),
      //                                 child: ElevatedButton(
      //                                   onPressed: () {},
      //                                   style: ElevatedButton.styleFrom(
      //                                     fixedSize:
      //                                         Size(buttonWidth, buttonHeight),
      //                                     primary: Colors.deepPurple,
      //                                     onPrimary: Colors.white,
      //                                   ),
      //                                   child: const Text('Zoom'),
      //                                 ),
      //                               ),
      //                             ],
      //                           )
      //                         ],
      //                       ))
      //                     ]),
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //           Container(
      //             height: MediaQuery.of(context).size.height * .16,
      //             width: MediaQuery.of(context).size.width * .90,
      //             decoration: const BoxDecoration(
      //                 border: Border(
      //                     right: BorderSide(
      //                       color: Colors.black,
      //                     ),
      //                     bottom: BorderSide(
      //                       color: Colors.black,
      //                     ),
      //                     left: BorderSide(color: Colors.black))),
      //             child: Column(
      //               children: [
      //                 const NICustomRowTextField(
      //                   labelText1: 'Opening Stock(F7)',
      //                   labelText2: 'IsActive',
      //                   suggestionItems: [],
      //                   flex: 4,
      //                 ),
      //                 Padding(
      //                   padding: const EdgeInsets.only(top: 8),
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: [
      //                       ElevatedButton(
      //                           style: ElevatedButton.styleFrom(
      //                               fixedSize: Size(
      //                                   MediaQuery.of(context).size.width * .23,
      //                                   25),
      //                               shape: const BeveledRectangleBorder(
      //                                   side: BorderSide(
      //                                       color: Colors.black, width: .3)),
      //                               backgroundColor: Colors.yellow.shade100),
      //                           onPressed: () {},
      //                           child: const Text(
      //                             'Save [F4]',
      //                             style: TextStyle(
      //                                 color: Colors.black,
      //                                 fontWeight: FontWeight.bold),
      //                           )),
      //                       SizedBox(
      //                         width: MediaQuery.of(context).size.width * .002,
      //                       ),
      //                       ElevatedButton(
      //                           style: ElevatedButton.styleFrom(
      //                               fixedSize: Size(
      //                                   MediaQuery.of(context).size.width * .23,
      //                                   25),
      //                               shape: const BeveledRectangleBorder(
      //                                   side: BorderSide(
      //                                       color: Colors.black, width: .3)),
      //                               backgroundColor: Colors.yellow.shade100),
      //                           onPressed: () {},
      //                           child: const Text(
      //                             'Cancel',
      //                             style: TextStyle(
      //                                 color: Colors.black,
      //                                 fontWeight: FontWeight.bold),
      //                           )),
      //                       SizedBox(
      //                         width: MediaQuery.of(context).size.width * .002,
      //                       ),
      //                     ],
      //                   ),
      //                 )
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
