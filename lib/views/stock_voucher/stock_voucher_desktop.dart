import 'package:billingsphere/data/repository/item_repository.dart';
import 'package:billingsphere/views/RA_widgets/RA_D_side_buttons.dart';
import 'package:billingsphere/views/RA_widgets/RA_M_Button.dart';
import 'package:billingsphere/views/stock_voucher/stock_show.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/item/item_model.dart';
import '../DB_widgets/custom_footer.dart';

class StockVoucherDesktopBody extends StatefulWidget {
  const StockVoucherDesktopBody({
    super.key,
  });

  @override
  State<StockVoucherDesktopBody> createState() =>
      _StockVoucherDesktopBodyState();
}

class _StockVoucherDesktopBodyState extends State<StockVoucherDesktopBody> {
  //services
  ItemsService itemService = ItemsService();

  List<Item> suggestionItem = [];
  DateTime? startDate;
  DateTime? endDate;
  List<String>? companyCode;
  Future<List<String>?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('companies');
  }

  Future<void> setCompanyCode() async {
    List<String>? code = await getCompanyCode();
    setState(() {
      companyCode = code;
    });
  }

  Item? selectedItem;

  //fetch item
  Future<void> fetchItem() async {
    try {
      final List<Item> items = await itemService.fetchItems();

      setState(() {
        suggestionItem = items;
        selectedItem = items.isNotEmpty
            ? items.first
            : null; // Assign the whole Item object
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String dropdownValue = 'All';

  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    setCompanyCode();
    fetchItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stock Voucher',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 33, 65, 243),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  // const RACustomAppBar(
                  //   text: 'Stock Voucher',
                  //   color: Color.fromARGB(255, 33, 65, 243),
                  // ),
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
                            width: MediaQuery.of(context).size.width,
                            height: 615,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height: 330,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Report Criteria',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.09,
                                              child: const Text(
                                                '  Item name',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              height: 30,
                                              child:
                                                  DropdownButtonFormField<Item>(
                                                // Change the type to Item
                                                value: selectedItem,
                                                onChanged: (Item? newValue) {
                                                  // Change the type to Item
                                                  setState(() {
                                                    selectedItem = newValue;
                                                  });
                                                },
                                                items: suggestionItem
                                                    .map((Item item) {
                                                  return DropdownMenuItem<Item>(
                                                    // Change the type to Item
                                                    value: item,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8.0,
                                                          vertical: 0.0),
                                                      child:
                                                          Text(item.itemName),
                                                    ),
                                                  );
                                                }).toList(),
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    vertical: 0,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.09,
                                              child: const Text(
                                                '  Date Range',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.10,
                                              height: 30,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // Show Date Picker for Start Date
                                                  showDatePicker(
                                                    context: context,
                                                    initialDate: startDate ??
                                                        DateTime.now(),
                                                    firstDate: DateTime(2000),
                                                    lastDate: DateTime(2100),
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      return Theme(
                                                        data: ThemeData
                                                            .light(), // Change to dark if needed
                                                        child: child!,
                                                      );
                                                    },
                                                  ).then(
                                                      (DateTime? selectedDate) {
                                                    if (selectedDate != null) {
                                                      setState(() {
                                                        startDate =
                                                            selectedDate;
                                                      });
                                                    }
                                                  });
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.white),
                                                  elevation:
                                                      MaterialStateProperty.all<
                                                              double>(
                                                          0), // Remove elevation
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      side: const BorderSide(
                                                          color: Colors
                                                              .black), // Border color
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  startDate != null
                                                      ? dateFormat
                                                          .format(startDate!)
                                                      : 'Start Date',
                                                  style: const TextStyle(
                                                    color: Colors
                                                        .black, // Text color
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Text(
                                              'to',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.10,
                                              height: 30,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // Show Date Picker for End Date with constraints
                                                  showDatePicker(
                                                    context: context,
                                                    initialDate: endDate ??
                                                        DateTime.now(),
                                                    firstDate: startDate ??
                                                        DateTime(2000),
                                                    lastDate: DateTime(2100),
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      return Theme(
                                                        data: ThemeData
                                                            .light(), // Change to dark if needed
                                                        child: child!,
                                                      );
                                                    },
                                                  ).then(
                                                      (DateTime? selectedDate) {
                                                    if (selectedDate != null) {
                                                      setState(() {
                                                        endDate = selectedDate;
                                                      });
                                                    }
                                                  });
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.white),
                                                  elevation:
                                                      MaterialStateProperty.all<
                                                              double>(
                                                          0), // Remove elevation
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      side: const BorderSide(
                                                          color: Colors
                                                              .black), // Border color
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  endDate != null
                                                      ? dateFormat
                                                          .format(endDate!)
                                                      : 'End Date',
                                                  style: const TextStyle(
                                                    color: Colors
                                                        .black, // Text color
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.075,
                                              child: const Text(
                                                ' Entry Type',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.09,
                                              height: 30,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.white
                                                          .withOpacity(
                                                              0.5), // Add shadow color
                                                      spreadRadius:
                                                          2, // Spread radius
                                                      blurRadius:
                                                          2, // Blur radius
                                                      offset: const Offset(0,
                                                          1), // Offset of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: DropdownButton<String>(
                                                  isExpanded: true,
                                                  value: dropdownValue,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      dropdownValue = newValue!;
                                                    });
                                                  },
                                                  items: <String>[
                                                    'All',
                                                    'Inward',
                                                    'Outward'
                                                  ].map<
                                                      DropdownMenuItem<String>>(
                                                    (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 8.0,
                                                              vertical:
                                                                  4.0), // Add padding to text
                                                          child: Text(
                                                            value,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).toList(),
                                                  dropdownColor: Colors
                                                      .white, // Set dropdown background color
                                                  icon: const Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Colors.black,
                                                  ), // Customize dropdown icon
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  underline:
                                                      Container(), // Remove the underline
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.09,
                                              child: const Text(
                                                '  Remarks',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              height: 30,
                                              child: TextField(
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  height: 0.8,
                                                ),
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                  ),
                                                ),
                                                cursorHeight: 15.0,
                                                cursorWidth: 1.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01,
                                                bottom: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01,
                                              ),
                                              child: Row(
                                                children: [
                                                  RAMButtons(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.11,
                                                    height: 30,
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              StockShow(
                                                            selectedItem:
                                                                selectedItem!,
                                                            startDate:
                                                                startDate,
                                                            endDate: endDate,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    text: 'Show [F4]',
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: RAMButtons(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.11,
                                                      height: 30,
                                                      text: 'Close',
                                                    ),
                                                  ),
                                                ],
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
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
                      text: 'F2 Report',
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
                      text: 'F5 Make Receipt',
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
      bottomNavigationBar: const CustomFooter(),
    );
  }
}
