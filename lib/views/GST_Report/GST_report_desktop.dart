import 'package:billingsphere/views/RA_widgets/RA_M_Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../DB_homepage.dart';
import '../searchable_dropdown.dart';
import '../sumit_screen/voucher _entry.dart/voucher_list_widget.dart';
import 'GST_Summary.dart';

class GstReportDesktop extends StatefulWidget {
  const GstReportDesktop({
    super.key,
  });

  @override
  State<GstReportDesktop> createState() => _GstReportDesktopState();
}

class _GstReportDesktopState extends State<GstReportDesktop> {
  bool isLoading = false;
  DateTime? startDate;
  DateTime? endDate;
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? selectedValue;
  final Map<int, String> keyValuePairs = {
    1: "01) GST 3B SUMMARY",
    2: "02) GST SALES REGISTER",
    3: "02) GST SALES REGISTER (SUMMARY)",
    4: "02) GST SALES RETURN REGISTER",
    5: "02) GST SALES RETURN REGISTER SUMMARY",
    6: "03) GST DAILY SUMMARY",
    7: "04) GSTR 1 EXCEL GENERATION",
    8: "05) GSTR 1 JSON GENERATION",
    9: "05) GSTR 1 SECTIONWISE CSV GENERATION",
    10: "05) GSTR IFF JSON GENERATION",
    11: "06) GST SALES REGI. BILL & TAX% WISE",
    12: "11) GST PURCHASE REGISTER",
    13: "11) GST PURCHASE REGISTER (SUMMARY)",
    14: "11) GST PURCHASE RETURN REGISTER",
    15: "11) GST PURCHASE RETURN REGISTER (SUMMARY)",
    16: "12) GSTR 2 EXCEL GENERATION",
    17: "13) GSTR 4 EXCEL GENERATION",
    18: "14) GST PURCH. REGI. BILL & TAX% WISE",
    19: "15) HSN WISE SUMMARY",
    20: "16) GST PURCH./PURCH. RETURN COMBINED REGISTER",
    21: "17) GST SALE/SALES RETRUN COMBINED REGISTER",
    22: "18) GSTR 9 EXCEL GENERATION",
  };
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    startDate = DateTime(now.year, now.month, 1);
    endDate = DateTime(now.year, now.month + 1, 0);
  }

  void setLastMonthDates() {
    final now = DateTime.now();
    final firstDayOfLastMonth = DateTime(now.year, now.month - 1, 1);
    final lastDayOfLastMonth = DateTime(now.year, now.month, 0);

    setState(() {
      startDate = firstDayOfLastMonth;
      endDate = lastDayOfLastMonth;
    });
  }

  void setLastQuarterDates() {
    final now = DateTime.now();
    DateTime firstDayOfLastQuarter;
    DateTime lastDayOfLastQuarter;

    if (now.month >= 1 && now.month <= 3) {
      // Current quarter: Q1, Last quarter: Q4 of last year
      firstDayOfLastQuarter = DateTime(now.year - 1, 10, 1);
      lastDayOfLastQuarter = DateTime(now.year - 1, 12, 31);
    } else if (now.month >= 4 && now.month <= 6) {
      // Current quarter: Q2, Last quarter: Q1
      firstDayOfLastQuarter = DateTime(now.year, 1, 1);
      lastDayOfLastQuarter = DateTime(now.year, 3, 31);
    } else if (now.month >= 7 && now.month <= 9) {
      // Current quarter: Q3, Last quarter: Q2
      firstDayOfLastQuarter = DateTime(now.year, 4, 1);
      lastDayOfLastQuarter = DateTime(now.year, 6, 30);
    } else {
      // Current quarter: Q4, Last quarter: Q3
      firstDayOfLastQuarter = DateTime(now.year, 7, 1);
      lastDayOfLastQuarter = DateTime(now.year, 9, 30);
    }

    setState(() {
      startDate = firstDayOfLastQuarter;
      endDate = lastDayOfLastQuarter;
    });
  }

  void setCurrentMonthDates() {
    final now = DateTime.now();
    final firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
    final lastDayOfCurrentMonth = DateTime(now.year, now.month + 1, 0);

    setState(() {
      startDate = firstDayOfCurrentMonth;
      endDate = lastDayOfCurrentMonth;
    });
  }

  void setCurrentQuarterDates() {
    final now = DateTime.now();
    DateTime firstDayOfCurrentQuarter;
    DateTime lastDayOfCurrentQuarter;

    if (now.month >= 1 && now.month <= 3) {
      // Q1: January 1 - March 31
      firstDayOfCurrentQuarter = DateTime(now.year, 1, 1);
      lastDayOfCurrentQuarter = DateTime(now.year, 3, 31);
    } else if (now.month >= 4 && now.month <= 6) {
      // Q2: April 1 - June 30
      firstDayOfCurrentQuarter = DateTime(now.year, 4, 1);
      lastDayOfCurrentQuarter = DateTime(now.year, 6, 30);
    } else if (now.month >= 7 && now.month <= 9) {
      // Q3: July 1 - September 30
      firstDayOfCurrentQuarter = DateTime(now.year, 7, 1);
      lastDayOfCurrentQuarter = DateTime(now.year, 9, 30);
    } else {
      // Q4: October 1 - December 31
      firstDayOfCurrentQuarter = DateTime(now.year, 10, 1);
      lastDayOfCurrentQuarter = DateTime(now.year, 12, 31);
    }

    setState(() {
      startDate = firstDayOfCurrentQuarter;
      endDate = lastDayOfCurrentQuarter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600) {
          return _buildMobileWidget();
        } else if (constraints.maxWidth >= 600 && constraints.maxWidth < 1200) {
          return _buildTabletWidget();
        } else {
          return _buildDesktopWidget();
        }
      },
    );
  }

  Widget _buildMobileWidget() {
    final items = keyValuePairs.entries.map((entry) {
      return DropdownMenuItem<String>(
        value: entry.value.toString(),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(entry.value),
        ),
      );
    }).toList();
    final List<Map<String, dynamic>> menuItems = [
      {'text': 'Report', 'icon': Icons.report},
      {'text': 'Print', 'icon': Icons.print},
      {'text': 'Export Excel', 'icon': Icons.file_download_outlined},
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'GST Reports Mobile',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const DBHomePage(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
            icon: const Icon(
              Icons.menu,
            ),
          )
        ],
        centerTitle: true,
        backgroundColor: const Color(0xFF4169E1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      endDrawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        child: ListView(
          children: [
            ...menuItems.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  dense: true,
                  leading: Icon(item['icon'], color: Colors.black54),
                  title: Text(
                    item['text'],
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF6C0082),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    // Handle the tap event
                    print('Tapped on ${item['text']}');
                  },
                ),
              );
            }),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 850,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 150),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 550,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  'Report Criteria',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  'Quick Dates',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: const Color(0xFF600F93),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                        onPressed: setLastMonthDates,
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            'Last Month',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF3434FF),
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  const Color(0xFF3434FF),
                                              decorationThickness: 2,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: setLastQuarterDates,
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            'Last Quarter',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF3434FF),
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  const Color(0xFF3434FF),
                                              decorationThickness: 2,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                        onPressed: setCurrentMonthDates,
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            'Current Month',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF3434FF),
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  const Color(0xFF3434FF),
                                              decorationThickness: 2,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: setCurrentQuarterDates,
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            'Current Quarter',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF3434FF),
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  const Color(0xFF3434FF),
                                              decorationThickness: 2,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  'Date Range',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: const Color(0xFF600F93),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Show Date Picker for Start Date
                                    showDatePicker(
                                      context: context,
                                      initialDate: startDate ?? DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return Theme(
                                          data: ThemeData
                                              .light(), // Change to dark if needed
                                          child: child!,
                                        );
                                      },
                                    ).then((DateTime? selectedDate) {
                                      if (selectedDate != null) {
                                        setState(() {
                                          startDate = selectedDate;
                                        });
                                      }
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.white),
                                    elevation: WidgetStateProperty.all<double>(
                                        0), // Remove elevation
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                        side: const BorderSide(
                                            color:
                                                Colors.black), // Border color
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    startDate != null
                                        ? dateFormat.format(startDate!)
                                        : 'Start Date',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black, // Text color
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  'to',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: const Color(0xFF600F93),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Show Date Picker for End Date with constraints
                                    showDatePicker(
                                      context: context,
                                      initialDate: endDate ?? DateTime.now(),
                                      firstDate: startDate ?? DateTime(2000),
                                      lastDate: DateTime(2100),
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return Theme(
                                          data: ThemeData
                                              .light(), // Change to dark if needed
                                          child: child!,
                                        );
                                      },
                                    ).then((DateTime? selectedDate) {
                                      if (selectedDate != null) {
                                        setState(() {
                                          endDate = selectedDate;
                                        });
                                      }
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.white),
                                    elevation: WidgetStateProperty.all<double>(
                                        0), // Remove elevation
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                        side: const BorderSide(
                                            color:
                                                Colors.black), // Border color
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    endDate != null
                                        ? dateFormat.format(endDate!)
                                        : 'End Date',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black, // Text color
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  'Ledger Name',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: const Color(0xFF600F93),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 30,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: SearchableDropDown(
                                    items: items,
                                    value: selectedValue,
                                    hintText: 'Select an option',
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedValue = newValue;
                                      });

                                      // if (newValue != null) {
                                      //   int selectedKey =
                                      //       int.parse(newValue);
                                      //   // navigateToPage(
                                      //   //     selectedKey);
                                      // }
                                    },
                                    searchMatchFn: (item, searchValue) {
                                      return item.value
                                          .toString()
                                          .toLowerCase()
                                          .contains(searchValue.toLowerCase());
                                    },
                                    searchController: searchController,
                                    controller: searchController,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RAMButtons(
                                width: MediaQuery.of(context).size.width,
                                height: 30,
                                text: 'Show',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GSTSummary(
                                        startDate: startDate,
                                        endDate: endDate,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RAMButtons(
                                width: MediaQuery.of(context).size.width,
                                height: 30,
                                text: 'Close',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const DBHomePage(),
                                    ),
                                  );
                                },
                              ),
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
    );
  }

  Widget _buildTabletWidget() {
    final items = keyValuePairs.entries.map((entry) {
      return DropdownMenuItem<String>(
        value: entry.value.toString(),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(entry.value),
        ),
      );
    }).toList();
    final List<Map<String, dynamic>> menuItems = [
      {'text': 'Report', 'icon': Icons.report},
      {'text': 'Print', 'icon': Icons.print},
      {'text': 'Export Excel', 'icon': Icons.file_download_outlined},
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'GST Reports Tablet',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const DBHomePage(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
            icon: const Icon(
              Icons.menu,
            ),
          )
        ],
        centerTitle: true,
        backgroundColor: const Color(0xFF4169E1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      endDrawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        child: ListView(
          children: [
            ...menuItems.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  dense: true,
                  leading: Icon(item['icon'], color: Colors.black54),
                  title: Text(
                    item['text'],
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF6C0082),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    // Handle the tap event
                    print('Tapped on ${item['text']}');
                  },
                ),
              );
            }),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 850,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 150),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 500,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  'Report Criteria',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  'Quick Dates',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: const Color(0xFF600F93),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                        onPressed: setLastMonthDates,
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            'Last Month',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF3434FF),
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  const Color(0xFF3434FF),
                                              decorationThickness: 2,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: setLastQuarterDates,
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            'Last Quarter',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF3434FF),
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  const Color(0xFF3434FF),
                                              decorationThickness: 2,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: setCurrentMonthDates,
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            'Current Month',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF3434FF),
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  const Color(0xFF3434FF),
                                              decorationThickness: 2,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: setCurrentQuarterDates,
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            'Current Quarter',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF3434FF),
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  const Color(0xFF3434FF),
                                              decorationThickness: 2,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  'Date Range',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: const Color(0xFF600F93),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Show Date Picker for Start Date
                                    showDatePicker(
                                      context: context,
                                      initialDate: startDate ?? DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return Theme(
                                          data: ThemeData
                                              .light(), // Change to dark if needed
                                          child: child!,
                                        );
                                      },
                                    ).then((DateTime? selectedDate) {
                                      if (selectedDate != null) {
                                        setState(() {
                                          startDate = selectedDate;
                                        });
                                      }
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.white),
                                    elevation: WidgetStateProperty.all<double>(
                                        0), // Remove elevation
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                        side: const BorderSide(
                                            color:
                                                Colors.black), // Border color
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    startDate != null
                                        ? dateFormat.format(startDate!)
                                        : 'Start Date',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black, // Text color
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  'to',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: const Color(0xFF600F93),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Show Date Picker for End Date with constraints
                                    showDatePicker(
                                      context: context,
                                      initialDate: endDate ?? DateTime.now(),
                                      firstDate: startDate ?? DateTime(2000),
                                      lastDate: DateTime(2100),
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return Theme(
                                          data: ThemeData
                                              .light(), // Change to dark if needed
                                          child: child!,
                                        );
                                      },
                                    ).then((DateTime? selectedDate) {
                                      if (selectedDate != null) {
                                        setState(() {
                                          endDate = selectedDate;
                                        });
                                      }
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.white),
                                    elevation: WidgetStateProperty.all<double>(
                                        0), // Remove elevation
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                        side: const BorderSide(
                                            color:
                                                Colors.black), // Border color
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    endDate != null
                                        ? dateFormat.format(endDate!)
                                        : 'End Date',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black, // Text color
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  'Ledger Name',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: const Color(0xFF600F93),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 30,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: SearchableDropDown(
                                    items: items,
                                    value: selectedValue,
                                    hintText: 'Select an option',
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedValue = newValue;
                                      });

                                      // if (newValue != null) {
                                      //   int selectedKey =
                                      //       int.parse(newValue);
                                      //   // navigateToPage(
                                      //   //     selectedKey);
                                      // }
                                    },
                                    searchMatchFn: (item, searchValue) {
                                      return item.value
                                          .toString()
                                          .toLowerCase()
                                          .contains(searchValue.toLowerCase());
                                    },
                                    searchController: searchController,
                                    controller: searchController,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RAMButtons(
                                width: MediaQuery.of(context).size.width,
                                height: 30,
                                text: 'Show',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GSTSummary(
                                        startDate: startDate,
                                        endDate: endDate,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RAMButtons(
                                width: MediaQuery.of(context).size.width,
                                height: 30,
                                text: 'Close',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const DBHomePage(),
                                    ),
                                  );
                                },
                              ),
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
    );
  }

  Widget _buildDesktopWidget() {
    final items = keyValuePairs.entries.map((entry) {
      return DropdownMenuItem<String>(
        value: entry.value.toString(),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(entry.value),
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GST Reports',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 33, 65, 243),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 850,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 150),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 400,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: SingleChildScrollView(
                            child: isLoading
                                ? SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height: 550,
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: CircularProgressIndicator(
                                            color: Color.fromARGB(
                                                255, 33, 65, 243),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Report Criteria',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                          decorationThickness: 2,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.10,
                                              child: Text(
                                                'Quick Dates',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 18,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.26,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: TextButton(
                                                      onPressed:
                                                          setLastMonthDates,
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                        child: Text(
                                                          'Last Month',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: const Color(
                                                                0xFF3434FF),
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            decorationColor:
                                                                const Color(
                                                                    0xFF3434FF),
                                                            decorationThickness:
                                                                2,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TextButton(
                                                      onPressed:
                                                          setLastQuarterDates,
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                        child: Text(
                                                          'Last Quarter',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: const Color(
                                                                0xFF3434FF),
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            decorationColor:
                                                                const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    0,
                                                                    8,
                                                                    255),
                                                            decorationThickness:
                                                                2,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TextButton(
                                                      onPressed:
                                                          setCurrentMonthDates,
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                        child: Text(
                                                          'Current Month',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: const Color(
                                                                0xFF3434FF),
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            decorationColor:
                                                                const Color(
                                                                    0xFF3434FF),
                                                            decorationThickness:
                                                                2,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TextButton(
                                                      onPressed:
                                                          setCurrentQuarterDates,
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.06,
                                                        child: Text(
                                                          'Current Quarter',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: const Color(
                                                                0xFF3434FF),
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            decorationColor:
                                                                const Color(
                                                                    0xFF3434FF),
                                                            decorationThickness:
                                                                2,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
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
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.10,
                                              child: Text(
                                                'Date Range',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 18,
                                                ),
                                                overflow: TextOverflow.ellipsis,
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
                                                      WidgetStateProperty.all<
                                                          Color>(Colors.white),
                                                  elevation: WidgetStateProperty
                                                      .all<double>(
                                                          0), // Remove elevation
                                                  shape: WidgetStateProperty.all<
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
                                                  style: GoogleFonts.poppins(
                                                    color: Colors
                                                        .black, // Text color
                                                    fontSize: 18,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.025,
                                            ),
                                            Text(
                                              'to',
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.025,
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
                                                      WidgetStateProperty.all<
                                                          Color>(Colors.white),
                                                  elevation: WidgetStateProperty
                                                      .all<double>(
                                                          0), // Remove elevation
                                                  shape: WidgetStateProperty.all<
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
                                                  style: GoogleFonts.poppins(
                                                    color: Colors
                                                        .black, // Text color
                                                    fontSize: 18,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.10,
                                              child: Text(
                                                'Ledger Name',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 18,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.26,
                                              height: 30,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black),
                                                ),
                                                child: SearchableDropDown(
                                                  items: items,
                                                  value: selectedValue,
                                                  hintText: 'Select an option',
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedValue = newValue;
                                                    });

                                                    // if (newValue != null) {
                                                    //   int selectedKey =
                                                    //       int.parse(newValue);
                                                    //   // navigateToPage(
                                                    //   //     selectedKey);
                                                    // }
                                                  },
                                                  searchMatchFn:
                                                      (item, searchValue) {
                                                    return item.value
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains(searchValue
                                                            .toLowerCase());
                                                  },
                                                  searchController:
                                                      searchController,
                                                  controller: searchController,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 100),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.07,
                                            ),
                                            RAMButtons(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.11,
                                              height: 30,
                                              text: 'Show [F4]',
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        GSTSummary(
                                                      startDate: startDate,
                                                      endDate: endDate,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                            ),
                                            RAMButtons(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.11,
                                              height: 30,
                                              text: 'Close',
                                              onPressed: () {},
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
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              child: Shortcuts(
                shortcuts: {
                  LogicalKeySet(LogicalKeyboardKey.f3): const ActivateIntent(),
                  LogicalKeySet(LogicalKeyboardKey.f4): const ActivateIntent(),
                },
                child: Focus(
                  autofocus: true,
                  onKey: (node, event) {
                    // ignore: deprecated_member_use
                    if (event is RawKeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.f2) {
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.099,
                    child: Column(
                      children: [
                        CustomList(Skey: "F2", name: "Report", onTap: () {}),
                        CustomList(Skey: "P", name: "Print", onTap: () {}),
                        CustomList(Skey: "", name: "", onTap: () {}),
                        CustomList(Skey: "", name: "", onTap: () {}),
                        CustomList(
                            Skey: "X", name: "Export-Excel", onTap: () {}),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
