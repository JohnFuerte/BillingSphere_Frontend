import 'package:billingsphere/views/DB_homepage.dart';
import 'package:billingsphere/views/sumit_screen/voucher%20_entry.dart/voucher_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/salesEntries/sales_entrires_model.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/sales_enteries_repository.dart';
import '../DB_responsive/DB_desktop_body.dart';
import '../SE_responsive/SalesEditScreen.dart';
import 'sales_register_desktop.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import 'dart:html' as html;

class SalesRegisterShow extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;

  const SalesRegisterShow({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  _SalesRegisterShowState createState() => _SalesRegisterShowState();
}

class _SalesRegisterShowState extends State<SalesRegisterShow> {
  late SalesEntryService salesService;
  List<SalesEntry> suggestionItems6 = [];
  List<Ledger> fectedLedger = [];
  LedgerService ledgerService = LedgerService();
  bool isLoading = false;
  ValueNotifier<String?> selectedId = ValueNotifier<String?>(null);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double totalSalesAmount = 0.0;
  int salesCount = 0;
  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });

    fetchLedger();
    salesService = SalesEntryService();
    fetchSalesForSelectedItemAndDateRange(widget.startDate, widget.endDate);
    _horizontalControllersGroup = LinkedScrollControllerGroup();
    _horizontalController1 = _horizontalControllersGroup.addAndGet();
    _horizontalController2 = _horizontalControllersGroup.addAndGet();
    _horizontalController3 = _horizontalControllersGroup.addAndGet();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _horizontalController1.dispose();
    _horizontalController2.dispose();
    _horizontalController3.dispose();

    super.dispose();
  }

  Future<void> fetchSalesForSelectedItemAndDateRange(
      DateTime? startDate, DateTime? endDate) async {
    try {
      final List<SalesEntry> sales = await salesService.getSales();

      final filteredSalesEntry = sales.where((salesentry) {
        if (startDate != null && endDate != null) {
          final entryDate = DateFormat('d/M/y').parse(salesentry.date);
          return entryDate.isAtSameMomentAs(startDate) ||
              entryDate.isAfter(startDate) && entryDate.isBefore(endDate) ||
              entryDate.isAtSameMomentAs(endDate);
        }
        return true;
      }).toList();

      double totalAmount = 0.0;
      for (var salesEntry in filteredSalesEntry) {
        try {
          totalAmount += double.parse(salesEntry.totalamount);
        } catch (e) {
          // Handle parsing error if needed
          print('Error parsing total amount: ${salesEntry.totalamount}');
        }
      }

      setState(() {
        suggestionItems6 = filteredSalesEntry;
        totalSalesAmount = totalAmount;
        salesCount = filteredSalesEntry.length;
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

  Future<void> fetchLedger() async {
    try {
      final List<Ledger> ledgers = await ledgerService.fetchLedgers();
      setState(() {
        fectedLedger = ledgers;
      });
    } catch (error) {
      print('Failed to fetch Ledger: $error');
    }
  }

  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  Future<void> exportToExcel() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch ledger data for each sales entry
      List<Ledger?> ledgerList = [];
      for (var salesEntry in suggestionItems6) {
        Ledger? ledger = await ledgerService.fetchLedgerById(salesEntry.party);
        ledgerList.add(ledger);
      }

      // Create an Excel document.
      final xlsio.Workbook workbook = xlsio.Workbook();
      final xlsio.Worksheet sheet = workbook.worksheets[0];

      // Add heading row.
      sheet.getRangeByName('A1').setText('Date');
      sheet.getRangeByName('B1').setText('Particulars');
      sheet.getRangeByName('C1').setText('Voucher');
      sheet.getRangeByName('D1').setText('Vch. No');
      sheet.getRangeByName('E1').setText('Ref No');
      sheet.getRangeByName('F1').setText('Type');
      sheet.getRangeByName('G1').setText('Amount');

      // Format the heading row.
      final xlsio.Style headingStyle = workbook.styles.add('HeadingStyle');
      headingStyle.bold = true;
      headingStyle.backColor = '#D3D3D3'; // Light grey background color

      for (int i = 1; i <= 7; i++) {
        sheet.getRangeByIndex(1, i).cellStyle = headingStyle;
      }

      // Add data to the sheet.
      for (int i = 0; i < suggestionItems6.length; i++) {
        sheet.getRangeByIndex(i + 2, 1).setText(suggestionItems6[i].date);
        if (ledgerList[i] != null) {
          sheet.getRangeByIndex(i + 2, 2).setText(ledgerList[i]!.name);
        } else {
          sheet.getRangeByIndex(i + 2, 2).setText('No Data');
        }

        sheet.getRangeByIndex(i + 2, 3).setText('TI');
        sheet
            .getRangeByIndex(i + 2, 4)
            .setText(suggestionItems6[i].no.toString());
        sheet.getRangeByIndex(i + 2, 5).setText('');

        sheet
            .getRangeByIndex(i + 2, 6)
            .setText(suggestionItems6[i].type.toString());
        sheet
            .getRangeByIndex(i + 2, 7)
            .setText(suggestionItems6[i].totalamount.toString());

        // Add ledger name to the sheet
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
        ..setAttribute("download", "SalesRegister-$formattedDate.xlsx")
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

  String getLedger(String party) {
    for (var ledger in fectedLedger) {
      if (ledger.id == party) {
        return ledger.name.toString();
      }
    }
    return '';
  }

  late ScrollController _horizontalController1;
  late ScrollController _horizontalController2;
  late ScrollController _horizontalController3;
  late LinkedScrollControllerGroup _horizontalControllersGroup;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600) {
          return _buildTabletWidget();
        } else if (constraints.maxWidth >= 600 && constraints.maxWidth < 1200) {
          return _buildTabletWidget();
        } else {
          return _buildDesktopWidget();
        }
      },
    );
  }

  Widget _buildTabletWidget() {
    final List<Map<String, dynamic>> menuItems = [
      {'text': 'Report', 'icon': Icons.report},
      {'text': 'Print', 'icon': Icons.print},
      {'text': 'AdvView', 'icon': Icons.view_agenda},
      {'text': 'Export Excel', 'icon': Icons.file_download_outlined},
      {'text': 'Filters', 'icon': Icons.filter},
    ];
    final textAlignments = [
      TextAlign.center,
      TextAlign.left,
      TextAlign.center,
      TextAlign.center,
      TextAlign.center,
      TextAlign.center,
      TextAlign.right,
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35.0),
        child: AppBar(
          title: Text(
            'Sales Register',
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
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xFF008000),
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
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        '1) Standard (Short)',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                            fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        '${widget.startDate != null ? dateFormat.format(widget.startDate!) : 'Not selected'} to ${widget.endDate != null ? dateFormat.format(widget.endDate!) : 'Not selected'}',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            fontSize: 18),
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1500,
              height: 850,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(border: Border.all()),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _horizontalController1,
                    child: Container(
                      width: 1352,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Row(
                        children: [
                          _buildHeaderCellTablet('Date', 150, TextAlign.center),
                          _buildHeaderCellTablet(
                              'Particulars', 500, TextAlign.left),
                          _buildHeaderCellTablet(
                              'Voucher', 100, TextAlign.center),
                          _buildHeaderCellTablet(
                              'Vch. No', 100, TextAlign.center),
                          _buildHeaderCellTablet(
                              'Ref No', 100, TextAlign.center),
                          _buildHeaderCellTablet('Type', 200, TextAlign.center),
                          _buildHeaderCellTablet(
                              'Amount', 200, TextAlign.right),
                        ],
                      ),
                    ),
                  ),
                  isLoading
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 750,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : SizedBox(
                          width: 1352,
                          height: 750,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _horizontalController2,
                            child: Column(
                              children: [
                                // Optionally, add your header row here
                                SizedBox(
                                  width: 1352,
                                  height: 750,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: suggestionItems6.length,
                                    itemBuilder: (context, i) {
                                      final sales = suggestionItems6[i];
                                      double total =
                                          double.parse(sales.totalamount);
                                      final cellData = [
                                        sales.date.toString(),
                                        getLedger(sales.party),
                                        'TI',
                                        sales.no.toString(),
                                        '',
                                        sales.type.toString(),
                                        total.toStringAsFixed(2),
                                      ];

                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedId.value = sales.id;
                                          });
                                        },
                                        onDoubleTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SalesEditScreen(
                                                salesEntryId: sales,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: selectedId.value == sales.id
                                                ? const Color(0xFF4169E1)
                                                : null,
                                            border: Border.all(),
                                          ),
                                          child: Row(
                                            children: List.generate(
                                                cellData.length, (j) {
                                              return SizedBox(
                                                width: [
                                                  150.00,
                                                  500.00,
                                                  100.00,
                                                  100.00,
                                                  100.00,
                                                  200.00,
                                                  200.00,
                                                ][j], // Adjust flex as needed
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      right: BorderSide(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    cellData[j],
                                                    textAlign:
                                                        textAlignments[j],
                                                    style: GoogleFonts.poppins(
                                                      color: selectedId.value ==
                                                              sales.id
                                                          ? Colors.yellow
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _horizontalController3,
                    child: Container(
                      width: 1352,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Row(
                        children: [
                          _buildFooterCellTablet('', 150, TextAlign.center),
                          _buildFooterCellTablet(
                              'Total ($salesCount)  ', 500, TextAlign.left),
                          _buildFooterCellTablet('', 100, TextAlign.center),
                          _buildFooterCellTablet('', 100, TextAlign.center),
                          _buildFooterCellTablet('', 100, TextAlign.center),
                          _buildFooterCellTablet('', 200, TextAlign.center),
                          _buildFooterCellTablet(
                              totalSalesAmount.toStringAsFixed(2),
                              200,
                              TextAlign.right),
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
    final textAlignments = [
      TextAlign.center,
      TextAlign.left,
      TextAlign.center,
      TextAlign.center,
      TextAlign.center,
      TextAlign.center,
      TextAlign.right,
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35.0),
        child: AppBar(
          title: Text(
            'Sales Register',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xFF008000),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.only(
                          left: 8.0, top: 8.0, right: 8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.12,
                            child: Text(
                              'Sales Register',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2,
                                  fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.18,
                            child: Text(
                              '1) Standard (Short)',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2,
                                  fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Text(
                              '${widget.startDate != null ? dateFormat.format(widget.startDate!) : 'Not selected'} to ${widget.endDate != null ? dateFormat.format(widget.endDate!) : 'Not selected'}',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 850,
                      padding: const EdgeInsets.only(
                          left: 8.0, bottom: 8.0, right: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 820,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Row(
                                    children: [
                                      _buildHeaderCell(
                                          'Date', 2, TextAlign.center),
                                      _buildHeaderCell(
                                          'Particulars', 6, TextAlign.left),
                                      _buildHeaderCell(
                                          'Voucher', 2, TextAlign.center),
                                      _buildHeaderCell(
                                          'Vch. No', 2, TextAlign.center),
                                      _buildHeaderCell(
                                          'Ref No', 2, TextAlign.center),
                                      _buildHeaderCell(
                                          'Type', 2, TextAlign.center),
                                      _buildHeaderCell(
                                          'Amount', 2, TextAlign.right),
                                    ],
                                  ),
                                ),
                                isLoading
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        height: 736,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : Expanded(
                                        child: ListView.builder(
                                          itemCount: suggestionItems6.length,
                                          itemBuilder: (context, i) {
                                            final sales = suggestionItems6[i];
                                            final cellData = [
                                              sales.date.toString(),
                                              getLedger(sales.party),
                                              'TI',
                                              sales.no.toString(),
                                              '',
                                              sales.type.toString(),
                                              sales.totalamount.toString(),
                                            ];

                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedId.value = sales.id;
                                                });
                                              },
                                              onDoubleTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SalesEditScreen(
                                                      salesEntryId: sales,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: selectedId.value ==
                                                          sales.id
                                                      ? const Color(0xFF4169E1)
                                                      : null,
                                                  border: Border.all(),
                                                ),
                                                child: Row(
                                                  children: List.generate(
                                                      cellData.length, (j) {
                                                    return Expanded(
                                                      flex: [
                                                        2,
                                                        6,
                                                        2,
                                                        2,
                                                        2,
                                                        2,
                                                        2,
                                                      ][j], // Adjust flex as needed
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        decoration:
                                                            const BoxDecoration(
                                                          border: Border(
                                                            right: BorderSide(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          cellData[j],
                                                          textAlign:
                                                              textAlignments[j],
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: selectedId
                                                                        .value ==
                                                                    sales.id
                                                                ? Colors.yellow
                                                                : Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Row(
                                    children: [
                                      _buildFooterCell('', 2, TextAlign.center),
                                      _buildFooterCell('Total ($salesCount)  ',
                                          6, TextAlign.left),
                                      _buildFooterCell('', 2, TextAlign.center),
                                      _buildFooterCell('', 2, TextAlign.center),
                                      _buildFooterCell('', 2, TextAlign.center),
                                      _buildFooterCell('', 2, TextAlign.center),
                                      _buildFooterCell(
                                          totalSalesAmount.toStringAsFixed(2),
                                          2,
                                          TextAlign.right),
                                    ],
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: Shortcuts(
                    shortcuts: {
                      LogicalKeySet(LogicalKeyboardKey.f3):
                          const ActivateIntent(),
                      LogicalKeySet(LogicalKeyboardKey.f4):
                          const ActivateIntent(),
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
                            CustomList(
                              Skey: "F2",
                              name: "Report",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SalesRegisterDesktop(),
                                  ),
                                );
                              },
                            ),
                            CustomList(Skey: "P", name: "Print", onTap: () {}),
                            CustomList(
                                Skey: "V", name: "AdvView", onTap: () {}),
                            CustomList(Skey: "", name: "", onTap: () {}),
                            CustomList(
                                Skey: "X",
                                name: "Export-Excel",
                                onTap: () {
                                  exportToExcel();
                                }),
                            CustomList(
                                Skey: "F", name: "Filters", onTap: () {}),
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
          ],
        ),
      ),
    );
  }
}

Widget _buildHeaderCellTablet(String text, double width, TextAlign textAlign) {
  return SizedBox(
    width: width,
    child: Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.black),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w800,
          fontSize: 16,
          color: const Color(0xFF6C0082),
        ),
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
      ),
    ),
  );
}

Widget _buildFooterCellTablet(String text, double width, TextAlign textAlign) {
  return SizedBox(
    width: width,
    child: Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: Colors.black,
        ),
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
      ),
    ),
  );
}

Widget _buildHeaderCell(String text, int flex, TextAlign textAlign) {
  return Expanded(
    flex: flex,
    child: Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.black),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w800,
          fontSize: 16,
          color: const Color(0xFF6C0082),
        ),
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
      ),
    ),
  );
}

Widget _buildFooterCell(String text, int flex, TextAlign textAlign) {
  return Expanded(
    flex: flex,
    child: Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: Colors.black,
        ),
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
      ),
    ),
  );
}
