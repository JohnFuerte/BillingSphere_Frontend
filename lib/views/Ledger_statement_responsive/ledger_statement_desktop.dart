import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/ledger/ledger_model.dart';
import '../../data/repository/ledger_repository.dart';
import '../DB_widgets/custom_footer.dart';
import '../RA_widgets/RA_M_Button.dart';
import '../searchable_dropdown.dart';
import '../sumit_screen/voucher _entry.dart/voucher_list_widget.dart';
import 'ledger_statement2.dart';

class LedgerStmnt extends StatefulWidget {
  const LedgerStmnt({super.key});

  @override
  State<LedgerStmnt> createState() => _LedgerStmntState();
}

class _LedgerStmntState extends State<LedgerStmnt> {
  // checkbox
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;
  // dropdown
  String dropdownValue1 = 'Yes';
  String dropdownValue2 = 'Yes';
  String dropdownValue3 = 'Yes';
  String dropdownValue4 = 'Yes';
  String dropdownValue5 = 'Yes';
  // date picker
  DateTime? startDate;
  DateTime? endDate;
  String? _ledgerDisplay;
  // fetch ledger
  Ledger? selectedLedger;
  List<Ledger> suggestionLedger = [];
  LedgerService ledgerService = LedgerService();
  final TextEditingController searchController = TextEditingController();

  Future<void> fetchLedger() async {
    try {
      final List<Ledger> ledgers = await ledgerService.fetchLedgers();

      setState(() {
        suggestionLedger = ledgers;
        selectedLedger = ledgers.isNotEmpty
            ? ledgers.first
            : null; // Assign the whole Item object
      });
      print('LEDGER $suggestionLedger');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    fetchLedger();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ledger Statement',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 33, 65, 243),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
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
                          height: 590,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.47,
                                height: 560,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Report Critaria',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
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
                                              '  Ledger name',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all()),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.36,
                                            height: 30,
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton2<Ledger>(
                                                isExpanded: true,
                                                hint: Text(
                                                  'Select Item',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .hintColor,
                                                  ),
                                                ),
                                                items: suggestionLedger
                                                    .map((Ledger ledger) {
                                                  return DropdownMenuItem<
                                                      Ledger>(
                                                    value: ledger,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  border: Border
                                                                      .all()),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.28,
                                                          child: Text(
                                                            ledger.name,
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontSize:
                                                                        16),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Text(
                                                          ledger.debitBalance
                                                              .toStringAsFixed(
                                                                  2),
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontSize: 16),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                                value: selectedLedger,
                                                onChanged: (Ledger? newValue) {
                                                  setState(() {
                                                    selectedLedger = newValue;
                                                  });
                                                },
                                                buttonStyleData:
                                                    const ButtonStyleData(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16),
                                                  height: 40,
                                                  width: 200,
                                                ),
                                                dropdownStyleData:
                                                    const DropdownStyleData(
                                                  maxHeight: 200,
                                                ),
                                                menuItemStyleData:
                                                    const MenuItemStyleData(
                                                  height: 40,
                                                ),
                                                dropdownSearchData:
                                                    DropdownSearchData(
                                                  searchController:
                                                      searchController,
                                                  searchInnerWidgetHeight: 50,
                                                  searchInnerWidget: Container(
                                                    height: 50,
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 8,
                                                      bottom: 4,
                                                      right: 8,
                                                      left: 8,
                                                    ),
                                                    child: TextFormField(
                                                      onChanged: (value) {},
                                                      expands: true,
                                                      maxLines: null,
                                                      controller:
                                                          searchController,
                                                      decoration:
                                                          InputDecoration(
                                                        isDense: true,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 10,
                                                          vertical: 8,
                                                        ),
                                                        hintText:
                                                            'Search for an item...',
                                                        hintStyle:
                                                            const TextStyle(
                                                                fontSize: 12),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  searchMatchFn:
                                                      (DropdownMenuItem<Ledger>
                                                              item,
                                                          String searchValue) {
                                                    final ledgerName =
                                                        item.value?.name ?? '';
                                                    return ledgerName
                                                        .toLowerCase()
                                                        .contains(searchValue
                                                            .toLowerCase());
                                                  },
                                                ),
                                              ),
                                            ),

                                            //     DropdownButtonFormField<Ledger>(
                                            //   isDense: true,
                                            //   // Change the type to Item
                                            //   value: selectedLedger,
                                            //   onChanged: (Ledger? newValue) {
                                            //     // Change the type to Item
                                            //     setState(() {
                                            //       selectedLedger = newValue;
                                            //     });
                                            //   },
                                            //   items: suggestionLedger
                                            //       .map((Ledger ledger) {
                                            //     return DropdownMenuItem<Ledger>(
                                            //       // Change the type to Item
                                            //       value: ledger,
                                            //       child: Padding(
                                            //         padding: const EdgeInsets
                                            //             .symmetric(
                                            //             horizontal: 8.0,
                                            //             vertical: 0.0),
                                            //         child: Text(ledger.name),
                                            //       ),
                                            //     );
                                            //   }).toList(),
                                            //   decoration: InputDecoration(
                                            //     contentPadding:
                                            //         const EdgeInsets.symmetric(
                                            //       vertical: 0,
                                            //     ),
                                            //     border: OutlineInputBorder(
                                            //       borderRadius:
                                            //           BorderRadius.circular(
                                            //               0.0),
                                            //     ),
                                            //   ),
                                            // ),
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
                                                      startDate = selectedDate;
                                                    });
                                                  }
                                                });
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.white),
                                                elevation: MaterialStateProperty
                                                    .all<double>(
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
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.08,
                                          ),
                                          const Text(
                                            'to',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.07,
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
                                                  initialDate:
                                                      endDate ?? DateTime.now(),
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
                                                elevation: MaterialStateProperty
                                                    .all<double>(
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
                                              '  Narration',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            height: 30,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white.withOpacity(
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
                                                value: dropdownValue1,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    dropdownValue1 = newValue!;
                                                  });
                                                },
                                                items: <String>[
                                                  'Yes',
                                                  'No',
                                                ].map<DropdownMenuItem<String>>(
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
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.09,
                                            child: const Text(
                                              '  Accounting',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            height: 30,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white.withOpacity(
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
                                                value: dropdownValue2,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    dropdownValue2 = newValue!;
                                                  });
                                                },
                                                items: <String>[
                                                  'Yes',
                                                  'No',
                                                ].map<DropdownMenuItem<String>>(
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
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            child: const Text(
                                              '  Stock',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            height: 30,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white.withOpacity(
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
                                                value: dropdownValue3,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    dropdownValue3 = newValue!;
                                                  });
                                                },
                                                items: <String>[
                                                  'Yes',
                                                  'No',
                                                ].map<DropdownMenuItem<String>>(
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
                                          Checkbox(
                                            value: isChecked1,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isChecked1 = value ??
                                                    false; // Update the isChecked variable with the new value
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            child: const Text(
                                              '  With Disc.',
                                              style: TextStyle(),
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
                                              '  Sub Ledger',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.36,
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
                                              '  Voucher Type',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.36,
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
                                              '  Entries',
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
                                                    color: Colors.white.withOpacity(
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
                                                value: dropdownValue4,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    dropdownValue4 = newValue!;
                                                  });
                                                },
                                                items: <String>[
                                                  'Yes',
                                                  'No',
                                                ].map<DropdownMenuItem<String>>(
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
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.09,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.09,
                                            child: const Text(
                                              '  User',
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
                                                    color: Colors.white.withOpacity(
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
                                                value: dropdownValue5,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    dropdownValue5 = newValue!;
                                                  });
                                                },
                                                items: <String>[
                                                  'Yes',
                                                  'No',
                                                ].map<DropdownMenuItem<String>>(
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
                                              '  Amount >=',
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
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.09,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.09,
                                            child: const Text(
                                              '  Amount <=',
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
                                              '  Narration Like',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.36,
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
                                              '  Ledger Display',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Radio(
                                            value: 'Single',
                                            groupValue: _ledgerDisplay,
                                            onChanged: (value) {
                                              setState(() {
                                                _ledgerDisplay =
                                                    value as String?;
                                              });
                                            },
                                          ),
                                          const Text('Single'),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                          ),
                                          Radio(
                                            value: 'Relevant Ledger',
                                            groupValue: _ledgerDisplay,
                                            onChanged: (value) {
                                              setState(() {
                                                _ledgerDisplay =
                                                    value as String?;
                                              });
                                            },
                                          ),
                                          const Text('Relevant Ledger'),
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
                                          ),
                                          Checkbox(
                                            value: isChecked2,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isChecked2 = value ??
                                                    false; // Update the isChecked variable with the new value
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: const Text(
                                              '  Show Ref No as Vch No',
                                              style: TextStyle(),
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
                                          ),
                                          Checkbox(
                                            value: isChecked3,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isChecked3 = value ??
                                                    false; // Update the isChecked variable with the new value
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            child: const Text(
                                              '  Show Op/Cl Bal',
                                              style: TextStyle(),
                                            ),
                                          ),
                                          Checkbox(
                                            value: isChecked4,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isChecked4 = value ??
                                                    false; // Update the isChecked variable with the new value
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.18,
                                            child: const Text(
                                              '  Show Cash Sale/Purchase',
                                              style: TextStyle(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 30,
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
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.11,
                                                  height: 30,
                                                  onPressed: () {
                                                    if (startDate == null ||
                                                        endDate == null) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Please select both start date and end date.'),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                    } else {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              LedgerShow(
                                                            selectedLedger:
                                                                selectedLedger!,
                                                            startDate:
                                                                startDate,
                                                            endDate: endDate,
                                                          ),
                                                        ),
                                                      );
                                                    }
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
                  CustomList(Skey: "F2", name: "Report", onTap: () {}),
                  CustomList(Skey: "P", name: "Print", onTap: () {}),
                  CustomList(Skey: "", name: "", onTap: () {}),
                  CustomList(Skey: "", name: "", onTap: () {}),
                  CustomList(Skey: "X", name: "Export-Excel", onTap: () {}),
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
          ),
        ],
      ),
      bottomNavigationBar: const CustomFooter(),
    );
  }
}
