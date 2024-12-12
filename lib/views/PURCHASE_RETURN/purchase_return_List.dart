import 'package:billingsphere/data/models/purchase/purchase_model.dart';
import 'package:billingsphere/data/models/purchaseReturn/purchase_return_model.dart';
import 'package:billingsphere/data/models/user/user_group_model.dart';
import 'package:billingsphere/data/repository/ledger_repository.dart';
import 'package:billingsphere/data/repository/purchase_return_repository.dart';
import 'package:billingsphere/data/repository/user_group_repository.dart';
import 'package:billingsphere/utils/constant.dart';
import 'package:billingsphere/views/PEresponsive/PE_edit_desktop_body.dart';
import 'package:billingsphere/views/PEresponsive/PE_receipt_print.dart';
import 'package:billingsphere/views/PURCHASE_RETURN/PR_desktop_body.dart';
import 'package:billingsphere/views/PURCHASE_RETURN/PR_receipt_print.dart';
import 'package:billingsphere/views/PURCHASE_RETURN/purchase_return_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/ledger/ledger_model.dart';
import '../SE_responsive/SE_master.dart';

class ListOfPurchaseReturn extends StatefulWidget {
  const ListOfPurchaseReturn({super.key});

  @override
  State<ListOfPurchaseReturn> createState() => _ListOfPurchaseReturnState();
}

class _ListOfPurchaseReturnState extends State<ListOfPurchaseReturn> {
  late SharedPreferences _prefs;

  LedgerService ledgerService = LedgerService();
  PurchaseReturnService purchaseReturnService = PurchaseReturnService();
  List<PurchaseReturn> fetchedPurchaseReturn = [];
  List<PurchaseReturn> fetchedPurchaseReturn2 = [];
  String? selectedId;
  bool isLoading = false;
  int? activeIndex;
  String? activeid;
  String? userGroup = '';
  UserGroupServices userGroupServices = UserGroupServices();
  int index = 0;
  bool isChecked = false;
  List<UserGroup> userGroupM = [];
  List<Ledger> fetchedLedger = [];
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

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

  Future<void> fetchPurchaseEntries() async {
    setState(() {
      isLoading = true;
    });
    try {
      final List<PurchaseReturn> purchase = await purchaseReturnService.fetchAllPurchaseReturns();

      setState(() {
        fetchedPurchaseReturn = purchase;
        fetchedPurchaseReturn2 = purchase;
        if (fetchedPurchaseReturn.isNotEmpty) {
          selectedId = fetchedPurchaseReturn[0].id;
        }
        isLoading = false;
      });
    } catch (error) {
      print('Failed to fetch purchase name: $error');
    }
  }

  Future<void> fetchUserGroup() async {
    final List<UserGroup> userGroupFetch = await userGroupServices.getUserGroups();

    setState(() {
      userGroupM = userGroupFetch;
    });
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

  void _initializeData() async {
    try {
      setState(() {
        isLoading = true;
      });

      await Future.wait([
        _initPrefs().then((value) => {
              userGroup = _prefs.getString('usergroup'),
            }),
        fetchUserGroup().then((value) => {}),
        fetchPurchaseEntries(),
        fetchLedger(),
      ]);
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handleTap(int index) {
    setState(() {
      activeIndex = index;
    });
  }

  // TextEditingConntrollers
  final TextEditingController _dateSearchController = TextEditingController();
  final TextEditingController _noSearchController = TextEditingController();
  final TextEditingController _typeSearchController = TextEditingController();
  final TextEditingController _printSearchController = TextEditingController();
  final TextEditingController _refNoSearchController = TextEditingController();
  final TextEditingController _refNo2SearchController = TextEditingController();
  final TextEditingController _particularsSearchController = TextEditingController();
  final TextEditingController _remarksSearchController = TextEditingController();
  final TextEditingController _amountSearchController = TextEditingController();

  // FocusNodes
  final FocusNode _dateFocusNode = FocusNode();
  final FocusNode _noFocusNode = FocusNode();
  final FocusNode _typeFocusNode = FocusNode();
  final FocusNode _printFocusNode = FocusNode();
  final FocusNode _refNoFocusNode = FocusNode();
  final FocusNode _refNo2FocusNode = FocusNode();
  final FocusNode _particularsFocusNode = FocusNode();
  final FocusNode _remarksFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();

  // Search Functionality for each cell
  // For Date
  void searchDate(String value) {
    setState(() {
      fetchedPurchaseReturn = fetchedPurchaseReturn2.where((sales) => sales.date.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  // For No
  void searchNo(String value) {
    setState(() {
      fetchedPurchaseReturn = fetchedPurchaseReturn2.where((sales) => sales.billNumber.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  // For Type
  void searchType(String value) {
    setState(() {
      fetchedPurchaseReturn = fetchedPurchaseReturn2.where((sales) => sales.type.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  // For Print
  void searchPrint(String value) {
    setState(() {
      fetchedPurchaseReturn = fetchedPurchaseReturn2.where((sales) => sales.id!.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  // For RefNo
  void searchRefNo(String value) {
    setState(() {
      fetchedPurchaseReturn = fetchedPurchaseReturn2.where((sales) => sales.billNumber.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  void searchParticulars(String value) {
    setState(() {
      // Get the ledger name from the fetchedLedger list
      fetchedPurchaseReturn = fetchedPurchaseReturn2.where((sales) {
        final ledger = fetchedLedger.firstWhere((ledger) => ledger.id == sales.ledger,
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
      fetchedPurchaseReturn = fetchedPurchaseReturn2.where((sales) => sales.remarks!.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  void searchAmount(String value) {
    setState(() {
      fetchedPurchaseReturn = fetchedPurchaseReturn2.where((sales) => sales.totalAmount.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   if (mounted) {
  //     FocusScope.of(context).requestFocus(_dateFocusNode);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _initializeData();
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
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    return FocusScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'List of Purchase Return',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 232, 159, 132),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: isLoading
            ? Center(
                child: Constants.loadingIndicator,
              )
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height,
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
                                  '${fetchedPurchaseReturn.length} Records',
                                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 0, 24, 43)),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      // CheckBox and then text for 'Auto Refresh'
                                      Checkbox(
                                        value: isChecked,
                                        fillColor: MaterialStateProperty.all(const Color.fromARGB(255, 0, 24, 43)),
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
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 1510,
                                child: Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(1),
                                    1: FlexColumnWidth(2),
                                    2: FlexColumnWidth(1),
                                    3: FlexColumnWidth(1),
                                    4: FlexColumnWidth(2),
                                    5: FlexColumnWidth(2),
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
                                            style: GoogleFonts.poppins(color: const Color.fromARGB(255, 0, 36, 66), fontSize: 16, fontWeight: FontWeight.w800, height: 2),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            "No",
                                            style: GoogleFonts.poppins(color: const Color.fromARGB(255, 0, 36, 66), fontSize: 16, fontWeight: FontWeight.w800, height: 2),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            "Type",
                                            style: GoogleFonts.poppins(color: const Color.fromARGB(255, 0, 36, 66), fontSize: 16, fontWeight: FontWeight.w800, height: 2),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            "Print",
                                            style: GoogleFonts.poppins(color: const Color.fromARGB(255, 0, 36, 66), fontSize: 16, fontWeight: FontWeight.w800, height: 2),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            "RefNo",
                                            style: GoogleFonts.poppins(color: const Color.fromARGB(255, 0, 36, 66), fontSize: 16, fontWeight: FontWeight.w800, height: 2),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            "RefNo2",
                                            style: GoogleFonts.poppins(color: const Color.fromARGB(255, 0, 36, 66), fontSize: 16, fontWeight: FontWeight.w800, height: 2),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            "Particulars",
                                            style: GoogleFonts.poppins(color: const Color.fromARGB(255, 0, 36, 66), fontSize: 16, fontWeight: FontWeight.w800, height: 2),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            "Remarks",
                                            style: GoogleFonts.poppins(color: const Color.fromARGB(255, 0, 36, 66), fontSize: 16, fontWeight: FontWeight.w800, height: 2),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            "Amount",
                                            style: GoogleFonts.poppins(color: const Color.fromARGB(255, 0, 36, 66), fontSize: 16, fontWeight: FontWeight.w800, height: 2),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 1510,
                                child: Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(1),
                                    1: FlexColumnWidth(2),
                                    2: FlexColumnWidth(1),
                                    3: FlexColumnWidth(1),
                                    4: FlexColumnWidth(2),
                                    5: FlexColumnWidth(2),
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
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.60,
                                width: 1510,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      Table(
                                        columnWidths: const {
                                          0: FlexColumnWidth(1),
                                          1: FlexColumnWidth(2),
                                          2: FlexColumnWidth(1),
                                          3: FlexColumnWidth(1),
                                          4: FlexColumnWidth(2),
                                          5: FlexColumnWidth(2),
                                          6: FlexColumnWidth(3),
                                          7: FlexColumnWidth(2),
                                          8: FlexColumnWidth(1),
                                        },
                                        border: const TableBorder.symmetric(
                                          inside: BorderSide(color: Colors.black),
                                          outside: BorderSide(color: Colors.black),
                                        ),
                                        children: [
                                          // Iterate over fetchedPurchaseReturn list and display each sales entry
                                          for (int i = 0; i < fetchedPurchaseReturn.length; i++)
                                            TableRow(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedId = fetchedPurchaseReturn[i].id;
                                                      index = i;
                                                    });
                                                  },
                                                  onDoubleTap: () {
                                                    print('Double Tapped');
                                                    selectedId = fetchedPurchaseReturn[i].id;
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PurchaseReturnEditPage(
                                                          data: fetchedPurchaseReturn[i].id!,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(8.0),
                                                    width: MediaQuery.of(context).size.width * 0.20,
                                                    color: selectedId == fetchedPurchaseReturn[i].id ? Colors.blue[500] : Colors.white,
                                                    child: Text(
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      fetchedPurchaseReturn[i].date,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: selectedId == fetchedPurchaseReturn[i].id ? Colors.white : Colors.black,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedId = fetchedPurchaseReturn[i].id;
                                                      index = i;
                                                    });
                                                  },
                                                  onDoubleTap: () {
                                                    print('Double Tapped');
                                                    selectedId = fetchedPurchaseReturn[i].id;
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PurchaseReturnEditPage(
                                                          data: fetchedPurchaseReturn[i].id!,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(8.0),
                                                    color: selectedId == fetchedPurchaseReturn[i].id ? Colors.blue[500] : Colors.white,
                                                    child: Text(
                                                      fetchedPurchaseReturn[i].billNumber,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: selectedId == fetchedPurchaseReturn[i].id ? Colors.white : Colors.black,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedId = fetchedPurchaseReturn[i].id;
                                                      index = i;
                                                    });
                                                  },
                                                  onDoubleTap: () {
                                                    print('Double Tapped');
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PurchaseReturnEditPage(
                                                          data: fetchedPurchaseReturn[i].id!,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(8.0),
                                                    width: MediaQuery.of(context).size.width * 0.20,
                                                    color: selectedId == fetchedPurchaseReturn[i].id ? Colors.blue[500] : Colors.white,
                                                    child: Text(
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      fetchedPurchaseReturn[i].type,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: selectedId == fetchedPurchaseReturn[i].id ? Colors.white : Colors.black,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedId = fetchedPurchaseReturn[i].id;
                                                      index = i;
                                                    });
                                                  },
                                                  onDoubleTap: () {
                                                    print('Double Tapped');
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PurchaseReturnEditPage(
                                                          data: fetchedPurchaseReturn[i].id!,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(8.0),
                                                    color: selectedId == fetchedPurchaseReturn[i].id ? Colors.blue[500] : Colors.white,
                                                    child: Text(
                                                      '0',
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: selectedId == fetchedPurchaseReturn[i].id ? Colors.white : Colors.black,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedId = fetchedPurchaseReturn[i].id;
                                                      index = i;
                                                    });
                                                  },
                                                  onDoubleTap: () {
                                                    print('Double Tapped');
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PurchaseReturnEditPage(
                                                          data: fetchedPurchaseReturn[i].id!,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(8.0),
                                                    color: selectedId == fetchedPurchaseReturn[i].id ? Colors.blue[500] : Colors.white,
                                                    child: Text(
                                                      fetchedPurchaseReturn[i].billNumber,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: selectedId == fetchedPurchaseReturn[i].id ? Colors.white : Colors.black,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedId = fetchedPurchaseReturn[i].id;
                                                      index = i;
                                                    });
                                                  },
                                                  onDoubleTap: () {
                                                    print('Double Tapped');
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PurchaseReturnEditPage(
                                                          data: fetchedPurchaseReturn[i].id!,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(8.0),
                                                    color: selectedId == fetchedPurchaseReturn[i].id ? Colors.blue[500] : Colors.white,
                                                    child: Text(
                                                      fetchedPurchaseReturn[i].billNumber,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: selectedId == fetchedPurchaseReturn[i].id ? Colors.white : Colors.black,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedId = fetchedPurchaseReturn[i].id;
                                                      index = i;
                                                    });
                                                  },
                                                  onDoubleTap: () {
                                                    print('Double Tapped');
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PurchaseReturnEditPage(
                                                          data: fetchedPurchaseReturn[index].id!,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(8.0),
                                                    // width
                                                    width: MediaQuery.of(context).size.width * 0.20,
                                                    color: selectedId == fetchedPurchaseReturn[i].id ? Colors.blue[500] : Colors.white,
                                                    child: fetchedLedger.isNotEmpty
                                                        ? Text(
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            fetchedLedger.firstWhere((ledger) => ledger.id == fetchedPurchaseReturn[i].ledger).name,
                                                            style: GoogleFonts.poppins(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w500,
                                                              color: selectedId == fetchedPurchaseReturn[i].id ? Colors.white : Colors.black,
                                                            ),
                                                            textAlign: TextAlign.start,
                                                          )
                                                        : const Text('No Data'),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedId = fetchedPurchaseReturn[i].id;
                                                      index = i;
                                                    });
                                                  },
                                                  onDoubleTap: () {
                                                    print('Double Tapped');
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PurchaseReturnEditPage(
                                                          data: fetchedPurchaseReturn[index].id!,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(8.0),
                                                    width: MediaQuery.of(context).size.width * 0.20,
                                                    color: selectedId == fetchedPurchaseReturn[i].id ? Colors.blue[500] : Colors.white,
                                                    child: Text(
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      fetchedPurchaseReturn[i].remarks!,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: selectedId == fetchedPurchaseReturn[i].id ? Colors.white : Colors.black,
                                                      ),
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedId = fetchedPurchaseReturn[i].id;
                                                      index = i;
                                                    });
                                                  },
                                                  onDoubleTap: () {
                                                    print('Double Tapped');
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => PurchaseReturnEditPage(
                                                          data: fetchedPurchaseReturn[index].id!,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(8.0),
                                                    color: selectedId == fetchedPurchaseReturn[i].id ? Colors.blue[500] : Colors.white,
                                                    child: Text(
                                                      fetchedPurchaseReturn[i].totalAmount,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: selectedId == fetchedPurchaseReturn[i].id ? Colors.white : Colors.black,
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
                            ],
                          ),
                        ),
                        s.width < 1000
                            ? SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  height: 50,
                                  width: 1000,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 0, 24, 43),
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
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
                                              builder: (context) => PRDesktopBody(),
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
                                                builder: (context) => PurchaseReturnEditPage(
                                                  data: fetchedPurchaseReturn[index].id!,
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
                                          // exportToExcel();
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
                                              builder: (context) => PurchaseReturnPrint(
                                                purchaseID: fetchedPurchaseReturn[index].id!,
                                                'Print Receipt',
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
                                            visible: (userGroup == "Admin" || userGroup == "Owner"),
                                            child: BottomButtons(
                                              title: 'DEL(Range)',
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text('Delete Sales'),
                                                      content: const Text('Are you sure you want to delete this sales?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Text('No'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {},
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
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 10.0),
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
                                              builder: (context) => PRDesktopBody(),
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
                                                builder: (context) => PurchaseReturnEditPage(
                                                  data: fetchedPurchaseReturn[index].id!,
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
                                          // exportToExcel();
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
                                              builder: (context) => PurchaseReturnPrint(
                                                purchaseID: fetchedPurchaseReturn[index].id!,
                                                'Print Receipt',
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
                                            visible: (userGroup == "Admin" || userGroup == "Owner"),
                                            child: BottomButtons(
                                              title: 'DEL(Range)',
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text('Delete Sales'),
                                                      content: const Text('Are you sure you want to delete this sales?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Text('No'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {},
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
                              ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
