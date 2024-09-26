import 'package:billingsphere/views/RA_widgets/RA_M_Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../DB_homepage.dart';
import '../DB_responsive/DB_desktop_body.dart';
import '../DB_widgets/custom_footer.dart';
import '../searchable_dropdown.dart';
import '../sumit_screen/voucher _entry.dart/voucher_list_widget.dart';
import 'sales_register_show.dart';

class SalesRegisterDesktop extends StatefulWidget {
  const SalesRegisterDesktop({
    super.key,
  });

  @override
  State<SalesRegisterDesktop> createState() => _SalesRegisterDesktopState();
}

class _SalesRegisterDesktopState extends State<SalesRegisterDesktop> {
  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedPlaceState = 'Standard (Short)';
  List<String> placestate = [
    'Standard (Short)',
    'Standard Paymentwise',
    'Standard (Detailed)GST',
    'Standard (Detailed) Itemwise',
    'Standard (Detailed) VAT',
    'With Inventory GST',
    'With Inventory/Bill/Receipt',
    'With Vehicle Details',
    'With Dispatch Details',
    'Ledger Extract',
    'Item Groupwise Extract',
  ];

  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    initializeDates();
  }

  void initializeDates() {
    DateTime now = DateTime.now();
    int currentYear = now.year;

    // Start date is 1st April of the current year
    startDate = DateTime(currentYear, 4, 1);

    // End date is 31st March of the next year
    endDate = DateTime(currentYear + 1, 3, 31);
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
    final List<Map<String, dynamic>> menuItems = [
      {'text': 'Report', 'icon': Icons.report},
      {'text': 'Print', 'icon': Icons.print},
      {'text': 'Export Excel', 'icon': Icons.file_download_outlined},
      {'text': 'Filters', 'icon': Icons.filter},
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35.0),
        child: AppBar(
          title: Text(
            'Sales Register',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
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
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF008000),
          centerTitle: true,
        ),
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
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 850,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                    decorationThickness: 2),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                'Date Range :',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: const Color(0xFF4B0082),
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
                                    builder:
                                        (BuildContext context, Widget? child) {
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
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  elevation: MaterialStateProperty.all<double>(
                                      0), // Remove elevation
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      side: const BorderSide(
                                          color: Colors.black), // Border color
                                    ),
                                  ),
                                ),
                                child: Text(
                                  startDate != null
                                      ? dateFormat.format(startDate!)
                                      : 'Start Date',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                'to',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: const Color(0xFF4B0082),
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
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
                                    builder:
                                        (BuildContext context, Widget? child) {
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
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  elevation: MaterialStateProperty.all<double>(
                                      0), // Remove elevation
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      side: const BorderSide(
                                          color: Colors.black), // Border color
                                    ),
                                  ),
                                ),
                                child: Text(
                                  endDate != null
                                      ? dateFormat.format(endDate!)
                                      : 'End Date',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
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
                                'Format : ',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: const Color(0xFF4B0082),
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
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white
                                          .withOpacity(0.5), // Add shadow color
                                      spreadRadius: 2, // Spread radius
                                      blurRadius: 2, // Blur radius
                                      offset: const Offset(
                                          0, 1), // Offset of shadow
                                    ),
                                  ],
                                ),
                                child: SearchableDropDown(
                                  controller: _searchController,
                                  searchController: _searchController,
                                  value: selectedPlaceState,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedPlaceState = newValue!;
                                    });
                                  },
                                  items: placestate.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  searchMatchFn: (item, searchValue) {
                                    final itemValue = item.value as String;
                                    return itemValue
                                        .toLowerCase()
                                        .contains(searchValue.toLowerCase());
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RAMButtons(
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SalesRegisterShow(
                                      startDate: startDate,
                                      endDate: endDate,
                                    ),
                                  ),
                                );
                              },
                              text: 'Show',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RAMButtons(
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DBMyDesktopBody(),
                                  ),
                                );
                              },
                              text: 'Close',
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
    );
  }

  Widget _buildTabletWidget() {
    final List<Map<String, dynamic>> menuItems = [
      {'text': 'Report', 'icon': Icons.report},
      {'text': 'Print', 'icon': Icons.print},
      {'text': 'Export Excel', 'icon': Icons.file_download_outlined},
      {'text': 'Filters', 'icon': Icons.filter},
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35.0),
        child: AppBar(
          title: Text(
            'Sales Register',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
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
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF008000),
          centerTitle: true,
        ),
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
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 850,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                    decorationThickness: 2),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                'Date Range :',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: const Color(0xFF4B0082),
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
                                    builder:
                                        (BuildContext context, Widget? child) {
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
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  elevation: MaterialStateProperty.all<double>(
                                      0), // Remove elevation
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      side: const BorderSide(
                                          color: Colors.black), // Border color
                                    ),
                                  ),
                                ),
                                child: Text(
                                  startDate != null
                                      ? dateFormat.format(startDate!)
                                      : 'Start Date',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                'to',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: const Color(0xFF4B0082),
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
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
                                    builder:
                                        (BuildContext context, Widget? child) {
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
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  elevation: MaterialStateProperty.all<double>(
                                      0), // Remove elevation
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      side: const BorderSide(
                                          color: Colors.black), // Border color
                                    ),
                                  ),
                                ),
                                child: Text(
                                  endDate != null
                                      ? dateFormat.format(endDate!)
                                      : 'End Date',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
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
                                'Format : ',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: const Color(0xFF4B0082),
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
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white
                                          .withOpacity(0.5), // Add shadow color
                                      spreadRadius: 2, // Spread radius
                                      blurRadius: 2, // Blur radius
                                      offset: const Offset(
                                          0, 1), // Offset of shadow
                                    ),
                                  ],
                                ),
                                child: SearchableDropDown(
                                  controller: _searchController,
                                  searchController: _searchController,
                                  value: selectedPlaceState,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedPlaceState = newValue!;
                                    });
                                  },
                                  items: placestate.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  searchMatchFn: (item, searchValue) {
                                    final itemValue = item.value as String;
                                    return itemValue
                                        .toLowerCase()
                                        .contains(searchValue.toLowerCase());
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RAMButtons(
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SalesRegisterShow(
                                      startDate: startDate,
                                      endDate: endDate,
                                    ),
                                  ),
                                );
                              },
                              text: 'Show',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RAMButtons(
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DBMyDesktopBody(),
                                  ),
                                );
                              },
                              text: 'Close',
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
    );
  }

  Widget _buildDesktopWidget() {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35.0),
        child: AppBar(
          title: Text(
            'Sales Register',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const DBMyDesktopBody(),
                ),
              );
            },
          ),
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF008000),
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  SingleChildScrollView(
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
                              const SizedBox(height: 100),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 400,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Report Criteria',
                                          style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationThickness: 2),
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.07,
                                              child: Text(
                                                '  Date Range',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  color:
                                                      const Color(0xFF4B0082),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
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
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
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
                                                  0.05,
                                              child: Text(
                                                'to',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  color:
                                                      const Color(0xFF4B0082),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
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
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
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
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.07,
                                              child: Text(
                                                '  Format',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  color:
                                                      const Color(0xFF4B0082),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.21,
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
                                                child: SearchableDropDown(
                                                  controller: _searchController,
                                                  searchController:
                                                      _searchController,
                                                  value: selectedPlaceState,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedPlaceState =
                                                          newValue!;
                                                    });
                                                  },
                                                  items: placestate
                                                      .map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    );
                                                  }).toList(),
                                                  searchMatchFn:
                                                      (item, searchValue) {
                                                    final itemValue =
                                                        item.value as String;
                                                    return itemValue
                                                        .toLowerCase()
                                                        .contains(searchValue
                                                            .toLowerCase());
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        height: 250,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.07),
                                                RAMButtons(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.08,
                                                  height: 30,
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SalesRegisterShow(
                                                          startDate: startDate,
                                                          endDate: endDate,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  text: 'Show [F4]',
                                                ),
                                                SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.01),
                                                RAMButtons(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.08,
                                                  height: 30,
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const DBMyDesktopBody(),
                                                      ),
                                                    );
                                                  },
                                                  text: 'Close',
                                                ),
                                              ],
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
                    } else if (event is RawKeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.f4) {
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
                        CustomList(Skey: "O", name: "Op. Bal", onTap: () {}),
                        CustomList(Skey: "", name: "", onTap: () {}),
                        CustomList(Skey: "", name: "", onTap: () {}),
                        CustomList(
                            Skey: "X", name: "Exports-Excel", onTap: () {}),
                        CustomList(Skey: "F", name: "Filters", onTap: () {}),
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
      bottomNavigationBar: const CustomFooter(),
    );
  }
}
