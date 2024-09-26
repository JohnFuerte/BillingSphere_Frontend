// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:billingsphere/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

import 'package:billingsphere/data/models/salesEntries/sales_entrires_model.dart';
import 'package:billingsphere/data/repository/sales_enteries_repository.dart';
import 'package:billingsphere/views/SE_responsive/SE_receipt_2.dart';
import 'package:billingsphere/views/SE_responsive/SalesEditScreen.dart';

import '../../data/models/item/item_model.dart';
import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/user/user_group_model.dart';
import '../../data/repository/ledger_repository.dart';

import 'dart:html' as html;

import '../../data/repository/user_group_repository.dart';
import 'SE_desktop_body.dart';

class SalesHome extends StatefulWidget {
  const SalesHome({super.key, required this.item});

  final List<Item> item;

  @override
  State<SalesHome> createState() => _SalesHomeState();
}

class _SalesHomeState extends State<SalesHome> {
  List<SalesEntry> fetchedSales = [];
  List<SalesEntry> fetchedSales2 = [];
  List<Ledger> fetchedLedger = [];
  LedgerService ledgerService = LedgerService();
  late SharedPreferences _prefs;
  bool isChecked = false;

  String? selectedId;
  bool isLoading = false;
  String? userGroup = '';
  UserGroupServices userGroupServices = UserGroupServices();
  List<UserGroup> userGroupM = [];

  int index = 0;

  // Search Controllers
  final TextEditingController _dateSearchController = TextEditingController();
  final TextEditingController _noSearchController = TextEditingController();
  final TextEditingController _typeSearchController = TextEditingController();
  final TextEditingController _printSearchController = TextEditingController();
  final TextEditingController _refNoSearchController = TextEditingController();
  final TextEditingController _refNo2SearchController = TextEditingController();
  final TextEditingController _particularsSearchController =
      TextEditingController();
  final TextEditingController _remarksSearchController =
      TextEditingController();
  final TextEditingController _amountSearchController = TextEditingController();

  // Focus Nodes for all the search fields
  final FocusNode _dateFocusNode = FocusNode();
  final FocusNode _noFocusNode = FocusNode();
  final FocusNode _typeFocusNode = FocusNode();
  final FocusNode _printFocusNode = FocusNode();
  final FocusNode _refNoFocusNode = FocusNode();
  final FocusNode _refNo2FocusNode = FocusNode();
  final FocusNode _particularsFocusNode = FocusNode();
  final FocusNode _remarksFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();

  // Scroll Controllers
  late ScrollController _horizontalController1;
  late ScrollController _horizontalController2;
  late ScrollController _horizontalController3;
  late LinkedScrollControllerGroup _horizontalControllersGroup;

  // Search Functionality for each cell
  // For Date
  void searchDate(String value) {
    setState(() {
      fetchedSales = fetchedSales2
          .where(
              (sales) => sales.date.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  // For No
  void searchNo(String value) {
    setState(() {
      fetchedSales = fetchedSales2
          .where(
              (sales) => sales.dcNo.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  // For Type
  void searchType(String value) {
    setState(() {
      fetchedSales = fetchedSales2
          .where(
              (sales) => sales.type.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  // For Print
  void searchPrint(String value) {
    setState(() {
      fetchedSales = fetchedSales2
          .where(
              (sales) => sales.id.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  // For RefNo
  void searchRefNo(String value) {
    setState(() {
      fetchedSales = fetchedSales2
          .where(
              (sales) => sales.dcNo.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  // For Particulars
  void searchParticulars(String value) {
    setState(() {
      // Get the ledger name from the fetchedLedger list
      fetchedSales = fetchedSales2.where((sales) {
        final ledger =
            fetchedLedger.firstWhere((ledger) => ledger.id == sales.party,
                orElse: () => Ledger(
                      id: '',
                      name: '',
                      ledgerGroup: '',
                      printName: '',
                      aliasName: '',
                      date: '',
                      bilwiseAccounting: '',
                      creditDays: 0,
                      openingBalance: 0,
                      debitBalance: 0,
                      ledgerType: '',
                      priceListCategory: '',
                      remarks: '',
                      status: '',
                      ledgerCode: 0,
                      mailingName: '',
                      address: '',
                      city: '',
                      region: '',
                      state: '',
                      pincode: 0,
                      tel: 0,
                      fax: 0,
                      mobile: 0,
                      sms: 0,
                      email: '',
                      contactPerson: '',
                      bankName: '',
                      branchName: '',
                      ifsc: '',
                      accName: '',
                      accNo: '',
                      panNo: '',
                      gst: '',
                      gstDated: '',
                      cstNo: '',
                      cstDated: '',
                      lstNo: '',
                      lstDated: '',
                      serviceTaxNo: '',
                      serviceTaxDated: '',
                      registrationType: '',
                      registrationTypeDated: '',
                    ));
        return ledger.name.toLowerCase().contains(value.toLowerCase());
      }).toList();
    });
  }

  // For Remarks
  void searchRemarks(String value) {
    setState(() {
      fetchedSales = fetchedSales2
          .where((sales) =>
              sales.remark.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  // For Amount
  void searchAmount(String value) {
    setState(() {
      fetchedSales = fetchedSales2
          .where((sales) =>
              sales.totalamount.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

 
 
 
 
 
  void deleteSalesEntry() async {
    try {
      await salesEntryService.deleteSalesEntry(selectedId!);
      await fetchAllSales();

      // Close the dialog
      Navigator.of(context).pop();
    } catch (error) {
      print('Failed to delete sales entry: $error');
    }
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SalesEntryService salesEntryService = SalesEntryService();

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

  Future<void> fetchAllSales() async {
    try {
      final List<SalesEntry> sales = await salesEntryService.getSales();
      // final filteredSalesEntry = sales
      //     .where((salesentry) => salesentry.companyCode == companyCode?[0])
      //     .toList();
      setState(() {
        if (sales.isNotEmpty) {
          fetchedSales = sales;
          fetchedSales2 = sales;
          selectedId = fetchedSales[0].id;
        } else {
          fetchedSales = sales;
        }
      });
    } catch (error) {
      print('Failed to fetch ledger name: $error');
    }
  }

  Future<void> exportToExcel() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch ledger data for each sales entry
      List<Ledger?> ledgerList = [];
      for (var salesEntry in fetchedSales) {
        Ledger? ledger = await ledgerService.fetchLedgerById(salesEntry.party);
        ledgerList.add(ledger);
      }

      // Create an Excel document.
      final xlsio.Workbook workbook = xlsio.Workbook();
      final xlsio.Worksheet sheet = workbook.worksheets[0];

      // Add heading row.
      sheet.getRangeByName('A1').setText('Sr');
      sheet.getRangeByName('B1').setText('Date');
      sheet.getRangeByName('C1').setText('Bill No');
      sheet.getRangeByName('D1').setText('Type');
      sheet.getRangeByName('E1').setText('Ledger Name');

      // Format the heading row.
      final xlsio.Style headingStyle = workbook.styles.add('HeadingStyle');
      headingStyle.bold = true;
      headingStyle.backColor = '#D3D3D3'; // Light grey background color

      for (int i = 1; i <= 5; i++) {
        sheet.getRangeByIndex(1, i).cellStyle = headingStyle;
      }

      // Add data to the sheet.
      for (int i = 0; i < fetchedSales.length; i++) {
        int itemNumber = i + 1; // Fix the item number calculation

        sheet.getRangeByIndex(i + 2, 1).setText(itemNumber.toString());
        sheet.getRangeByIndex(i + 2, 2).setText(fetchedSales[i].date);
        sheet
            .getRangeByIndex(i + 2, 3)
            .setText(fetchedSales[i].dcNo.toString());
        sheet
            .getRangeByIndex(i + 2, 4)
            .setText(fetchedSales[i].type.toString());

        // Add ledger name to the sheet
        if (ledgerList[i] != null) {
          sheet.getRangeByIndex(i + 2, 5).setText(ledgerList[i]!.name);
        } else {
          sheet.getRangeByIndex(i + 2, 5).setText('No Data');
        }
      }

      // Save the document as a stream of bytes.
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      // Convert the bytes to a Uint8List
      final Uint8List uint8List = Uint8List.fromList(bytes);

      // Create a blob from the Uint8List
      final html.Blob blob = html.Blob([uint8List]);
      final formatter = DateFormat('dd-MM-yyyy');
      final formattedDate = formatter.format(DateTime.now());

      // Create a link element
      final html.AnchorElement link = html.AnchorElement(
        href: html.Url.createObjectUrlFromBlob(blob),
      )
        ..setAttribute("download", "SalesEntries-$formattedDate.xlsx")
        ..click();

      // Optionally, you can show a message or alert to indicate the file has been saved.
      print('Excel file saved successfully and download triggered.');
    } catch (error) {
      print('Failed to export to Excel: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchUserGroup() async {
    final List<UserGroup> userGroupFetch =
        await userGroupServices.getUserGroups();

    setState(() {
      userGroupM = userGroupFetch;
    });
  }

  Future<void> initialize() async {
    await Future.wait([
      _initPrefs().then((value) => {
            userGroup = _prefs.getString('usergroup'),
          }),
      fetchUserGroup().then((value) => {}),
    ]);
  }

  // Fetch Ledger
  Future<void> fetchLedger() async {
    try {
      final List<Ledger> ledger = await ledgerService.fetchLedgers();
      setState(() {
        fetchedLedger = ledger;
      });
    } catch (error) {
      print('Failed to fetch ledger name: $error');
    }
  }

  Future<void> initAsync() async {
    setState(() {
      isLoading = true;
    });

    try {
      await Future.wait([
        fetchAllSales(),
        setCompanyCode(),
        fetchLedger(),
      ]);
    } catch (e) {
      print('Error: $e');
    } finally {
      // Delay
      // await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        isLoading = false;
      });
    }
  }

  // dispose
  @override
  void dispose() {
    _dateSearchController.dispose();
    _noSearchController.dispose();
    _typeSearchController.dispose();
    _printSearchController.dispose();
    _refNoSearchController.dispose();
    _refNo2SearchController.dispose();
    _particularsSearchController.dispose();
    _remarksSearchController.dispose();
    _amountSearchController.dispose();

    _horizontalController1.dispose();
    _horizontalController2.dispose();
    _horizontalController3.dispose();

    // Dispose all the focus nodes
    _dateFocusNode.dispose();
    _noFocusNode.dispose();
    _typeFocusNode.dispose();
    _printFocusNode.dispose();
    _refNoFocusNode.dispose();
    _refNo2FocusNode.dispose();
    _particularsFocusNode.dispose();
    _remarksFocusNode.dispose();
    _amountFocusNode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    initialize();
    initAsync();

    _horizontalControllersGroup = LinkedScrollControllerGroup();
    _horizontalController1 = _horizontalControllersGroup.addAndGet();
    _horizontalController2 = _horizontalControllersGroup.addAndGet();
    _horizontalController3 = _horizontalControllersGroup.addAndGet();

    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   if (mounted) {
  //     FocusScope.of(context).requestFocus(_dateFocusNode);
  //   }
  // }

  Widget buildDesktopScreen() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '${fetchedSales.length} Records',
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 0, 24, 43)),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          // CheckBox and then text for 'Auto Refresh'
                          Checkbox(
                            value: isChecked,
                            fillColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 0, 24, 43)),
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                          const Text(
                            'Auto Refresh Mode',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
                5: FlexColumnWidth(1),
                6: FlexColumnWidth(3),
                7: FlexColumnWidth(2),
                8: FlexColumnWidth(1),
              },
              border: TableBorder.all(color: Colors.black),
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Text(
                        "Date",
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 0, 36, 66),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "No",
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 0, 36, 66),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "Type",
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 0, 36, 66),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "Print",
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 0, 36, 66),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "RefNo",
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 0, 36, 66),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "RefNo2",
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 0, 36, 66),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "Particulars",
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 0, 36, 66),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "Remarks",
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 0, 36, 66),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "Amount",
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 0, 36, 66),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
                5: FlexColumnWidth(1),
                6: FlexColumnWidth(3),
                7: FlexColumnWidth(2),
                8: FlexColumnWidth(1),
              },
              border: TableBorder.all(color: Colors.black),
              children: [
                TableRow(
                  children: [
                    SearchCell(
                      searchController: _dateSearchController,
                      onChanged: searchDate,
                      // focusNode: _dateFocusNode,
                    ),
                    SearchCell(
                      searchController: _noSearchController,
                      onChanged: searchNo,
                      // focusNode: _noFocusNode,
                    ),
                    SearchCell(
                      searchController: _typeSearchController,
                      onChanged: searchType,
                      // focusNode: _typeFocusNode,
                    ),
                    SearchCell(
                      searchController: _printSearchController,
                      onChanged: searchPrint,
                      // focusNode: _printFocusNode,
                    ),
                    SearchCell(
                      searchController: _refNoSearchController,
                      onChanged: searchRefNo,
                      // focusNode: _refNoFocusNode,
                    ),
                    SearchCell(
                      searchController: _refNo2SearchController,
                      onChanged: searchRefNo,
                      // focusNode: _refNo2FocusNode,
                    ),
                    SearchCell(
                      searchController: _particularsSearchController,
                      textAlign: TextAlign.start,
                      onChanged: searchParticulars,
                      // focusNode: _particularsFocusNode,
                    ),
                    SearchCell(
                      searchController: _remarksSearchController,
                      textAlign: TextAlign.start,
                      onChanged: searchRemarks,
                      // focusNode: _remarksFocusNode,
                    ),
                    SearchCell(
                      searchController: _amountSearchController,
                      textAlign: TextAlign.end,
                      onChanged: searchAmount,
                      // focusNode: _amountFocusNode,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.60,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1),
                        4: FlexColumnWidth(1),
                        5: FlexColumnWidth(1),
                        6: FlexColumnWidth(3),
                        7: FlexColumnWidth(2),
                        8: FlexColumnWidth(1),
                      },
                      border: const TableBorder.symmetric(
                        inside: BorderSide(color: Colors.black),
                        outside: BorderSide(color: Colors.black),
                      ),
                      children: [
                        // Iterate over fetchedSales list and display each sales entry
                        for (int i = 0; i < fetchedSales.length; i++)
                          TableRow(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedId = fetchedSales[i].id;
                                    index = i;
                                  });
                                },
                                onDoubleTap: () {
                                  print('Double Tapped');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SalesEditScreen(
                                        salesEntryId: fetchedSales[i],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  color: selectedId == fetchedSales[i].id
                                      ? Colors.blue[500]
                                      : Colors.white,
                                  child: Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    fetchedSales[i].date,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: selectedId == fetchedSales[i].id
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedId = fetchedSales[i].id;
                                    index = i;
                                  });
                                },
                                onDoubleTap: () {
                                  print('Double Tapped');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SalesEditScreen(
                                        salesEntryId: fetchedSales[i],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  color: selectedId == fetchedSales[i].id
                                      ? Colors.blue[500]
                                      : Colors.white,
                                  child: Text(
                                    fetchedSales[i].dcNo,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: selectedId == fetchedSales[i].id
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedId = fetchedSales[i].id;
                                    index = i;
                                  });
                                },
                                onDoubleTap: () {
                                  print('Double Tapped');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SalesEditScreen(
                                        salesEntryId: fetchedSales[i],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  color: selectedId == fetchedSales[i].id
                                      ? Colors.blue[500]
                                      : Colors.white,
                                  child: Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    fetchedSales[i].type,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: selectedId == fetchedSales[i].id
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedId = fetchedSales[i].id;
                                    index = i;
                                  });
                                },
                                onDoubleTap: () {
                                  print('Double Tapped');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SalesEditScreen(
                                        salesEntryId: fetchedSales[i],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  color: selectedId == fetchedSales[i].id
                                      ? Colors.blue[500]
                                      : Colors.white,
                                  child: Text(
                                    '0',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: selectedId == fetchedSales[i].id
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedId = fetchedSales[i].id;
                                    index = i;
                                  });
                                },
                                onDoubleTap: () {
                                  print('Double Tapped');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SalesEditScreen(
                                        salesEntryId: fetchedSales[i],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  color: selectedId == fetchedSales[i].id
                                      ? Colors.blue[500]
                                      : Colors.white,
                                  child: Text(
                                    fetchedSales[i].dcNo,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: selectedId == fetchedSales[i].id
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedId = fetchedSales[i].id;
                                    index = i;
                                  });
                                },
                                onDoubleTap: () {
                                  print('Double Tapped');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SalesEditScreen(
                                        salesEntryId: fetchedSales[i],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  color: selectedId == fetchedSales[i].id
                                      ? Colors.blue[500]
                                      : Colors.white,
                                  child: Text(
                                    fetchedSales[i].dcNo,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: selectedId == fetchedSales[i].id
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedId = fetchedSales[i].id;
                                    index = i;
                                  });
                                },
                                onDoubleTap: () {
                                  print('Double Tapped');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SalesEditScreen(
                                        salesEntryId: fetchedSales[i],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  // width
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  color: selectedId == fetchedSales[i].id
                                      ? Colors.blue[500]
                                      : Colors.white,
                                  child: fetchedLedger.isNotEmpty
                                      ? Text(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          fetchedLedger
                                              .firstWhere((ledger) =>
                                                  ledger.id ==
                                                  fetchedSales[i].party)
                                              .name,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                selectedId == fetchedSales[i].id
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                          textAlign: TextAlign.start,
                                        )
                                      : const Text('No Data'),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedId = fetchedSales[i].id;
                                    index = i;
                                  });
                                },
                                onDoubleTap: () {
                                  print('Double Tapped');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SalesEditScreen(
                                        salesEntryId: fetchedSales[i],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  color: selectedId == fetchedSales[i].id
                                      ? Colors.blue[500]
                                      : Colors.white,
                                  child: Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    fetchedSales[i].remark,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: selectedId == fetchedSales[i].id
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedId = fetchedSales[i].id;
                                    index = i;
                                  });
                                },
                                onDoubleTap: () {
                                  print('Double Tapped');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SalesEditScreen(
                                        salesEntryId: fetchedSales[i],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  color: selectedId == fetchedSales[i].id
                                      ? Colors.blue[500]
                                      : Colors.white,
                                  child: Text(
                                    fetchedSales[i].totalamount,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: selectedId == fetchedSales[i].id
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    textAlign: TextAlign.end,
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 24, 43),
                    width: 3,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BottomButtons(),
                    const BottomButtons(
                      title: 'List Prn',
                      subtitle: 'L',
                    ),
                    BottomButtons(
                      title: 'New',
                      subtitle: 'F2',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SEMyDesktopBody(),
                          ),
                        );
                      },
                    ),
                    Visibility(
                      visible: (userGroup == "Admin" || userGroup == "Owner"),
                      child: BottomButtons(
                        title: 'Edit',
                        subtitle: 'F3',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SalesEditScreen(
                                salesEntryId: fetchedSales[index],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    BottomButtons(
                      title: 'XLS',
                      subtitle: 'X',
                      onPressed: () {
                        exportToExcel();
                      },
                    ),
                    BottomButtons(
                      title: 'Print',
                      subtitle: 'P',
                      onPressed: () {
                        // I need to get the items from the sales screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrintBigReceipt(
                              sales: fetchedSales[index],
                              ledger: fetchedLedger.firstWhere((ledger) =>
                                  ledger.id == fetchedSales[index].party),
                              'Sales Receipt',
                            ),
                          ),
                        );
                      },
                    ),
                    const BottomButtons(
                      title: 'Prn (Range)',
                      subtitle: 'R',
                    ),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return Visibility(
                          visible:
                              (userGroup == "Admin" || userGroup == "Owner"),
                          child: BottomButtons(
                            title: 'DEL(Range)',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete Sales'),
                                    content: const Text(
                                        'Are you sure you want to delete this sales?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: deleteSalesEntry,
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const BottomButtons(
                      title: 'Email/SMS',
                      subtitle: 'E',
                    ),
                    const BottomButtons(),
                  ],
                ),
              ),
            )
         
         
         
         
          ],
        ),
      ),
    );
  }

  Widget buildMobileScreen() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '${fetchedSales.length} Records',
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(255, 0, 24, 43)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      // CheckBox and then text for 'Auto Refresh'
                      Checkbox(
                        value: isChecked,
                        fillColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 0, 24, 43)),
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      const Text(
                        'Auto Refresh Mode',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Table Header...
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.96,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border.symmetric(
                              vertical: BorderSide(color: Colors.black),
                            ),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _horizontalController1,
                            child: Row(
                              children: [
                                Container(
                                  height: 20,
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  child: Text(
                                    'Date',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          const Color.fromARGB(255, 0, 36, 66),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  child: Text(
                                    'No',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          const Color.fromARGB(255, 0, 36, 66),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  child: Text(
                                    'Type',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          const Color.fromARGB(255, 0, 36, 66),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  child: Text(
                                    'Print',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          const Color.fromARGB(255, 0, 36, 66),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  child: Text(
                                    'RefNo',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          const Color.fromARGB(255, 0, 36, 66),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  child: Text(
                                    'RefNo2',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          const Color.fromARGB(255, 0, 36, 66),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  child: Text(
                                    'Particulars',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          const Color.fromARGB(255, 0, 36, 66),
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  child: Text(
                                    'Remarks',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          const Color.fromARGB(255, 0, 36, 66),
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  child: Text(
                                    'Amount',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          const Color.fromARGB(255, 0, 36, 66),
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
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

          //  Search Fields...
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.96,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border.symmetric(
                              vertical: BorderSide(color: Colors.black),
                            ),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _horizontalController2,
                            child: Row(
                              children: [
                                searchCellMobile(
                                  searchController: _dateSearchController,
                                  onChanged: searchDate,
                                  width: 0.20,
                                  textAlign: TextAlign.center,
                                ),
                                searchCellMobile(
                                  searchController: _noSearchController,
                                  onChanged: searchNo,
                                  width: 0.20,
                                  textAlign: TextAlign.center,
                                ),
                                searchCellMobile(
                                  searchController: _typeSearchController,
                                  onChanged: searchType,
                                  width: 0.20,
                                  textAlign: TextAlign.center,
                                ),
                                searchCellMobile(
                                  searchController: _printSearchController,
                                  onChanged: searchPrint,
                                  width: 0.20,
                                  textAlign: TextAlign.center,
                                ),
                                searchCellMobile(
                                  searchController: _refNoSearchController,
                                  onChanged: searchRefNo,
                                  width: 0.20,
                                  textAlign: TextAlign.center,
                                ),
                                searchCellMobile(
                                  searchController: _refNo2SearchController,
                                  onChanged: searchRefNo,
                                  width: 0.20,
                                  textAlign: TextAlign.center,
                                ),
                                searchCellMobile(
                                  searchController:
                                      _particularsSearchController,
                                  onChanged: searchParticulars,
                                  width: 0.40,
                                  textAlign: TextAlign.start,
                                ),
                                searchCellMobile(
                                  searchController: _remarksSearchController,
                                  onChanged: searchRemarks,
                                  width: 0.30,
                                  textAlign: TextAlign.start,
                                ),
                                searchCellMobile(
                                  searchController: _amountSearchController,
                                  onChanged: searchAmount,
                                  width: 0.20,
                                  textAlign: TextAlign.end,
                                ),
                              ],
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

          // Table Body...
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.96,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _horizontalController3,
                            child: Column(
                              children: [
                                // Iterate over fetchedSales list and display each sales entry
                                for (int i = 0; i < fetchedSales.length; i++)
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedId = fetchedSales[i].id;
                                      });
                                    },
                                    onDoubleTap: () {
                                      print('Double Tapped');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SalesEditScreen(
                                            salesEntryId: fetchedSales[i],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      decoration: BoxDecoration(
                                        color: selectedId == fetchedSales[i].id
                                            ? Colors.blue[500]
                                            : Colors.white,
                                        border: const Border.symmetric(
                                          vertical:
                                              BorderSide(color: Colors.black),
                                          horizontal:
                                              BorderSide(color: Colors.black),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.20,
                                            child: Text(
                                              fetchedSales[i].date,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: selectedId ==
                                                        fetchedSales[i].id
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.20,
                                            child: Text(
                                              fetchedSales[i].dcNo,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: selectedId ==
                                                        fetchedSales[i].id
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.20,
                                            child: Text(
                                              fetchedSales[i].type,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: selectedId ==
                                                        fetchedSales[i].id
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.20,
                                            child: Text(
                                              '0',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: selectedId ==
                                                        fetchedSales[i].id
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.20,
                                            child: Text(
                                              fetchedSales[i].dcNo,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: selectedId ==
                                                        fetchedSales[i].id
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.20,
                                            child: Text(
                                              fetchedSales[i].dcNo,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: selectedId ==
                                                        fetchedSales[i].id
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8.0),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.40,
                                            child: fetchedLedger.isNotEmpty
                                                ? Text(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fetchedLedger
                                                        .firstWhere((ledger) =>
                                                            ledger.id ==
                                                            fetchedSales[i]
                                                                .party)
                                                        .name,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: selectedId ==
                                                              fetchedSales[i].id
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  )
                                                : const Text('No Data'),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.30,
                                            child: Text(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              fetchedSales[i].remark,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: selectedId ==
                                                        fetchedSales[i].id
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.20,
                                            child: Text(
                                              fetchedSales[i].totalamount,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: selectedId ==
                                                        fetchedSales[i].id
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              textAlign: TextAlign.end,
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
                  ],
                ),
              ],
            ),
          ),

          // Bottom Buttons...
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BottomButtonMobile(
                  icon: CupertinoIcons.list_dash,
                  onPressed: () {},
                ),
                BottomButtonMobile(
                  icon: CupertinoIcons.add,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SEMyDesktopBody(),
                      ),
                    );
                  },
                ),
                BottomButtonMobile(
                  icon: CupertinoIcons.pencil,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SalesEditScreen(
                          salesEntryId: fetchedSales[index],
                        ),
                      ),
                    );
                  },
                ),
                BottomButtonMobile(
                  icon: CupertinoIcons.square_on_square,
                  onPressed: () {
                    exportToExcel();
                  },
                ),
                BottomButtonMobile(
                  icon: CupertinoIcons.printer,
                  onPressed: () {},
                ),
                BottomButtonMobile(
                  icon: CupertinoIcons.printer_fill,
                  onPressed: () {},
                ),
                BottomButtonMobile(
                  icon: CupertinoIcons.trash,
                  onPressed: () {},
                ),
                BottomButtonMobile(
                  icon: CupertinoIcons.mail,
                  onPressed: () {},
                ),
              ],
            ),
          )
        
        
        
        
        ],
      ),
    );
  }

  Container searchCellMobile({
    TextAlign? textAlign,
    void Function(String)? onChanged,
    TextEditingController? searchController,
    double width = 0.20,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * width,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: TextField(
        textAlign: textAlign ?? TextAlign.center,
        cursorColor: Colors.black,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        controller: searchController,
        onChanged: onChanged,
        decoration: const InputDecoration(
          fillColor: Colors.pinkAccent,
          filled: true,
          hintText: 'Search',
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(0),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 40,
        title: Text(
          'List of TAX INVOICE Voucher',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF008000),
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
      body: isLoading
          ? Center(
              child: Constants.loadingIndicator,
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 1200) {
                  return buildDesktopScreen();
                } else {
                  return buildMobileScreen();
                }
              },
            ),
    );
  }
}

class BottomButtonMobile extends StatelessWidget {
  const BottomButtonMobile({
    super.key,
    this.onPressed,
    this.icon,
  });

  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color.fromARGB(255, 0, 24, 43),
            width: 1,
          ),
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon ?? Icons.add,
            color: const Color.fromARGB(255, 0, 24, 43),
            size: 15,
          ),
        ),
      ),
    );
  }
}

class BottomButtons extends StatelessWidget {
  const BottomButtons({
    super.key,
    this.title,
    this.subtitle,
    this.onPressed,
  });

  final String? title;
  final String? subtitle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: InkWell(
        onTap: onPressed,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                subtitle ?? '',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  color: Colors.red,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.black54,
                    width: 3,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  title ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
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

class SearchCell extends StatefulWidget {
  const SearchCell({
    super.key,
    required TextEditingController searchController,
    this.textAlign,
    this.onChanged,
    // this.focusNode,
  }) : _searchController = searchController;

  final TextEditingController _searchController;
  final TextAlign? textAlign;
  final void Function(String)? onChanged;
  // final FocusNode? focusNode;

  @override
  State<SearchCell> createState() => _SearchCellState();
}

class _SearchCellState extends State<SearchCell> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    // widget.focusNode?.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    // widget.focusNode?.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      // _isFocused = widget.focusNode?.hasFocus ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: TextField(
        // focusNode: widget.focusNode,
        textAlign: widget.textAlign ?? TextAlign.center,
        cursorColor: Colors.black,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        controller: widget._searchController,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          filled: true,
          hintText: _isFocused ? '' : 'Search Here',
          hintStyle: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(0),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(0),
            ),
          ),
        ),
      ),
    );
  }
}
