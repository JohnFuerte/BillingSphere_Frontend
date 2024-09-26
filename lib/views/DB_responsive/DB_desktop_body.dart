// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'package:billingsphere/utils/constant.dart';
import 'package:billingsphere/views/DB_widgets/Desktop_widgets/d_custom_buttons.dart';
import 'package:billingsphere/views/DB_widgets/Desktop_widgets/d_custom_todo.dart';
import 'package:billingsphere/views/DB_widgets/Desktop_widgets/d_custome_remainder.dart';
import 'package:billingsphere/views/RA_homepage.dart';
import 'package:billingsphere/views/SE_responsive/SE_desktop_body_POS.dart';
import 'package:billingsphere/views/menu/menubar%20_onwer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../PA_homepage.dart';
import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/payment/payment_model.dart';
import '../../data/models/purchase/purchase_model.dart';
import '../../data/models/salesEntries/sales_entrires_model.dart';
import '../../data/models/user/user_group_model.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/payment_respository.dart';
import '../../data/repository/purchase_repository.dart';
import '../../data/repository/sales_enteries_repository.dart';
import '../../data/repository/user_group_repository.dart';
import '../CM_responsive/blank_desktop_body.dart';
import '../DB_widgets/Desktop_widgets/d_custom_table.dart';
import '../GST_Report/GST_report_desktop.dart';
import '../LG_responsive/LG_HOME.dart';
import '../Ledger_statement_responsive/ledger_statement_desktop.dart';
import '../NI_responsive.dart/NI_desktopBody.dart';
import '../NI_responsive.dart/NI_home.dart';
import '../PEresponsive/PE_desktop_body.dart';
import '../PM_homepage.dart';
import '../PM_responsive/payment_desktop.dart';
import '../RV_responsive/RV_desktopBody.dart';
import '../SE_responsive/SE_desktop_body.dart';
import '../Sales_Register/sales_register_desktop.dart';
import '../Stock_Status/stock_status.dart';
import '../Stock_Status/stock_status_filter.dart';
import '../TrailBalance_resposive/trail_balance.dart';
import '../menu/menubar.dart';
import '../paginated_datatable_test.dart';
import '../stock_voucher/stock_voucher_desktop.dart';

class DBMyDesktopBody extends StatefulWidget {
  const DBMyDesktopBody({super.key});

  @override
  State<DBMyDesktopBody> createState() => _DBMyDesktopBodyState();
}

class _DBMyDesktopBodyState extends State<DBMyDesktopBody> {
  late SharedPreferences _prefs;
  List<String> companies = [];
  String? userGroup = '';
  String? email = '';
  String? fullName = '';
  UserGroupServices userGroupServices = UserGroupServices();
  List<UserGroup> userGroupM = [];
  bool isLoading = false;
  Future<void> fetchUserGroup() async {
    final List<UserGroup> userGroupFetch =
        await userGroupServices.getUserGroups();

    setState(() {
      userGroupM = userGroupFetch;
    });
  }

  //Services
  SalesEntryService salesService = SalesEntryService();
  PurchaseServices purchaseService = PurchaseServices();
  PaymentService paymentService = PaymentService();
  LedgerService ledgerService = LedgerService();

//Fetch Data
  List<SalesEntry> suggestionSales = [];
  List<SalesEntry> suggestionSalesCash = [];
  List<Purchase> suggestionPurchase = [];
  List<Payment> suggestionPayment = [];
  List<Ledger> suggestionLedger = [];
  List<Ledger> suggestionLedgerCustomer = [];

  List<String>? companyCode;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //  Loaded Data
  Future<List<String>?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('companies');
  }

  Future<void> fetchLedger() async {
    try {
      final List<Ledger> ledger = await ledgerService.fetchLedgers();
      // print(ledger);
      final filteredLedgerEntry = ledger
          .where((ledgerentry) =>
              ledgerentry.ledgerGroup == '662f97d2a07ec73369c237b0')
          .toList();
      final filteredLedgerCustomerEntry = ledger
          .where((ledgerentry) =>
              ledgerentry.ledgerGroup == '662f984ba07ec73369c237c8')
          .toList();
      setState(() {
        suggestionLedger = filteredLedgerEntry;
        suggestionLedgerCustomer = filteredLedgerCustomerEntry;
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

  Future<void> fetchPayment() async {
    try {
      final List<Payment> payment = await paymentService.fetchPayments();
      final filteredPaymentEntry = payment
          .where(
              (purchasentry) => purchasentry.companyCode == companyCode!.first)
          .toList();
      setState(() {
        suggestionPayment = filteredPaymentEntry;
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

  Future<void> fetchPurchase() async {
    try {
      final List<Purchase> purchase = await purchaseService.getPurchase();
      final filteredPurchaseEntry = purchase
          .where(
              (purchasentry) => purchasentry.companyCode == companyCode!.first)
          .toList();
      setState(() {
        suggestionPurchase = filteredPurchaseEntry;
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

  Future<void> fetchSales() async {
    try {
      final List<SalesEntry> sales = await salesService.fetchSalesEntries();
      final filteredSalesEntry = sales
          .where((salesentry) => salesentry.companyCode == companyCode!.first)
          .toList();
      final filteredSalesCashEntry = sales
          .where((salesentry) =>
              salesentry.companyCode == companyCode!.first &&
              salesentry.type == 'CASH')
          .toList();
      setState(() {
        suggestionSales = filteredSalesEntry;
        suggestionSalesCash = filteredSalesCashEntry;
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

  Future<void> setCompanyCode() async {
    List<String>? code = await getCompanyCode();
    setState(() {
      companyCode = code;
    });
  }

  Future<void> initialize() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Future.wait([
        _initPrefs().then((value) => {
              companies = (_prefs.getStringList('companies') ?? []),
              userGroup = _prefs.getString('usergroup'),
              email = _prefs.getString('email'),
              fullName = _prefs.getString('fullName'),
            }),
        setCompanyCode(),
        fetchLedger(),
        fetchPayment(),
        fetchPurchase(),
        fetchSales(),
        fetchUserGroup().then((value) => {}),
      ]);
    } catch (e) {
      print("DB ERROR $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Navigation Screen Start

  void navigateSales() {
    if (userGroup != "Admin" || userGroup != "Owner") {
      var matchedGroup = userGroupM.firstWhere(
        (e) => e.userGroupName == userGroup,
      );

      if (matchedGroup.sales == "No") {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Access Denied'),
              content: const Text('You do not have access to Sales page.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
        return;
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SEMyDesktopBody(),
          ),
        );
      }
    }
  }

  void navigateToSalesPos() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SalesReturn(),
      ),
    );
  }

  void navigateReceipt() {
    if (userGroup != "Admin" || userGroup != "Owner") {
      var matchedGroup = userGroupM.firstWhere(
        (e) => e.userGroupName == userGroup,
      );

      if (matchedGroup.receipt2 == "No") {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Access Denied'),
              content: const Text('You do not have access to Receipt page.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
        return;
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RVDesktopBody(),
          ),
        );
      }
    }
  }

  void navigatePurchase() {
    if (userGroup != "Admin" || userGroup != "Owner") {
      var matchedGroup = userGroupM.firstWhere(
        (e) => e.userGroupName == userGroup,
      );

      if (matchedGroup.purchase == "No") {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Access Denied'),
              content: const Text('You do not have access to Purchase page.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
        return;
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PEMyDesktopBody(),
          ),
        );
      }
    }
  }

  void navigatePayment() {
    if (userGroup != "Admin" || userGroup != "Owner") {
      var matchedGroup = userGroupM.firstWhere(
        (e) => e.userGroupName == userGroup,
      );

      if (matchedGroup.payment == "No") {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Access Denied'),
              content: const Text('You do not have access to Payment page.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
        return;
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const PMMyPaymentDesktopBody()),
        );
      }
    }
  }

  void navigateReceivable() {
    if (userGroup != "Admin" || userGroup != "Owner") {
      var matchedGroup = userGroupM.firstWhere(
        (e) => e.userGroupName == userGroup,
      );

      if (matchedGroup.stock == "No") {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Access Denied'),
              content: const Text('You do not have access to Receivable page.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
        return;
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RAhomepage(),
          ),
        );
      }
    }
  }

  void navigatePayable() {
    if (userGroup != "Admin" || userGroup != "Owner") {
      var matchedGroup = userGroupM.firstWhere(
        (e) => e.userGroupName == userGroup,
      );

      if (matchedGroup.ownerGroup == "No") {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Access Denied'),
              content: const Text('You do not have access to Payable page.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
        return;
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PAHomepage(),
          ),
        );
      }
    }
  }

  void navigateLedger() {
    if (userGroup != "Admin" || userGroup != "Owner") {
      var matchedGroup = userGroupM.firstWhere(
        (e) => e.userGroupName == userGroup,
      );

      if (matchedGroup.addMaster == "No") {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Access Denied'),
              content: const Text('You do not have access to Ledger page.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
        return;
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LedgerHome(),
          ),
        );
      }
    }
  }

  void navigateItem() {
    if (userGroup != "Admin" || userGroup != "Owner") {
      var matchedGroup = userGroupM.firstWhere(
        (e) => e.userGroupName == userGroup,
      );

      if (matchedGroup.jobcard == "No") {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Access Denied'),
              content: const Text('You do not have access to Item page.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
        return;
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ItemHome(),
          ),
        );
      }
    }
  }

  void navigateLedgerStmnt() {
    if (userGroup != "Admin" || userGroup != "Owner") {
      var matchedGroup = userGroupM.firstWhere(
        (e) => e.userGroupName == userGroup,
      );

      if (matchedGroup.receiptNote == "No") {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Access Denied'),
              content: const Text(
                  'You do not have access to Ledger Statement page.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
        return;
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LedgerStmnt(),
          ),
        );
      }
    }
  }

  void navigateStockStatus() {
    if (userGroup != "Admin" || userGroup != "Owner") {
      var matchedGroup = userGroupM.firstWhere(
        (e) => e.userGroupName == userGroup,
      );

      if (matchedGroup.deliveryNote == "No") {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Access Denied'),
              content:
                  const Text('You do not have access to Stock Status page.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
        return;
      } else {
        userGroup == "Owner"
            ? Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const StockFilter(),
                ),
              )
            : Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const StockStatus(),
                ),
              );
      }
    }
  }

  void navigateStockVoucher() {
    if (userGroup != "Admin" || userGroup != "Owner") {
      var matchedGroup = userGroupM.firstWhere(
        (e) => e.userGroupName == userGroup,
      );

      if (matchedGroup.purchaseOrder == "No") {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Access Denied'),
              content:
                  const Text('You do not have access to Stock Vouchers page.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
        return;
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const StockVoucherDesktopBody(),
          ),
        );
      }
    }
  }

  void navigateSalesRegister() {
    if (userGroup != "Admin" || userGroup != "Owner") {
      var matchedGroup = userGroupM.firstWhere(
        (e) => e.userGroupName == userGroup,
      );

      if (matchedGroup.salesOrder == "No") {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Access Denied'),
              content:
                  const Text('You do not have access to Sales Register page.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
        return;
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SalesRegisterDesktop(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.f3): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.f4): const ActivateIntent(),
      },
      child: Focus(
        autofocus: true,
        onKey: (node, event) {
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.keyA) {
            navigateSales();
            return KeyEventResult.handled;
          } else if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.keyB) {
            navigateToSalesPos();
          } else if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.keyC) {
            navigateReceipt();
          } else if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.keyD) {
            navigatePurchase();
          } else if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.keyE) {
            navigatePayment();
          } else if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.keyF) {
            navigateReceivable();
          } else if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.keyG) {
            navigatePayable();
          } else if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.digit1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DataTablePaginationExample(),
              ),
            );
          } else if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.digit2) {
            navigateLedgerStmnt();
          } else if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.keyS) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const GstReportDesktop(),
              ),
            );
          } else if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.keyM) {
            navigateLedger();
          } else if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.keyN) {
            navigateItem();
          } else if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.digit6) {
            navigateStockStatus();
          } else if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.digit7) {
            navigateStockVoucher();
          } else if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.digit8) {
            navigateSalesRegister();
          }
          return KeyEventResult.ignored;
        },
        child: isLoading
            ? Scaffold(
                body: Center(
                  child: Constants.loadingIndicator,
                ),
              )
            : Scaffold(
                backgroundColor: Colors.white38,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.0859,
                            vertical: screenHeight * 0.01),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Visibility(
                                  visible: (userGroup == "Admin" ||
                                      userGroup == "Owner"),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: Container(
                                      // Top Buttons
                                      width: screenWidth * 0.4,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: userGroup == "Admin"
                                          ? CustomAppBarMenuAdmin
                                              .buildTitleMenu(context)
                                          : (userGroup == "Owner"
                                              ? CustomAppBarMenuOwner
                                                  .buildTitleMenu(context)
                                              : const Text('')),
                                    ),
                                  ),
                                ),
                                // Icon button with power off, color red
                                const Spacer(),
                                SizedBox(
                                  child: Text(
                                    '$fullName | $email',
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.power_settings_new,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Logout',
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                          content: Text(
                                            'Are you sure you want to logout?',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'No',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _prefs.clear();
                                                setState(() {});

                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        const BlankScreen(),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'Yes',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: screenWidth * 0.4,
                                  height: 600,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 208, 31, 34),
                                        ),
                                        child: const Text(
                                          'QUICK ACCESS',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Transaction
                                                SizedBox(
                                                  width: screenWidth * 0.15,
                                                  height: 300,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Transactions',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255, 208, 31, 34),
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  208,
                                                                  31,
                                                                  34),
                                                          decorationThickness:
                                                              2.0,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Visibility(
                                                        visible: (userGroup ==
                                                                    "Admin" ||
                                                                userGroup ==
                                                                    "Owner") ||
                                                            userGroupM
                                                                    .firstWhere(
                                                                      (e) =>
                                                                          e.userGroupName ==
                                                                          userGroup,
                                                                    )
                                                                    .sales !=
                                                                "No",
                                                        child: DButtons(
                                                          text: 'a) Sales',
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const SEMyDesktopBody(),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(height: 1),
                                                      DButtons(
                                                        text: 'b) Sales POS',
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const SalesReturn(),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      const SizedBox(height: 1),
                                                      Visibility(
                                                        visible: (userGroup ==
                                                                    "Admin" ||
                                                                userGroup ==
                                                                    "Owner") ||
                                                            userGroupM
                                                                    .firstWhere(
                                                                      (e) =>
                                                                          e.userGroupName ==
                                                                          userGroup,
                                                                    )
                                                                    .receipt2 !=
                                                                "No",
                                                        child: DButtons(
                                                          text: 'c) Receipt',
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const RVDesktopBody(),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      Visibility(
                                                        visible: (userGroup ==
                                                                    "Admin" ||
                                                                userGroup ==
                                                                    "Owner") ||
                                                            userGroupM
                                                                    .firstWhere(
                                                                      (e) =>
                                                                          e.userGroupName ==
                                                                          userGroup,
                                                                    )
                                                                    .purchase !=
                                                                "No",
                                                        child: DButtons(
                                                          text: 'd) Purchase',
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const PEMyDesktopBody(),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(height: 1),
                                                      Visibility(
                                                        visible: (userGroup ==
                                                                    "Admin" ||
                                                                userGroup ==
                                                                    "Owner") ||
                                                            userGroupM
                                                                    .firstWhere(
                                                                      (e) =>
                                                                          e.userGroupName ==
                                                                          userGroup,
                                                                    )
                                                                    .payment !=
                                                                "No",
                                                        child: DButtons(
                                                          text: 'e) Payment',
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const PMMyPaymentDesktopBody()),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(height: 1),
                                                      Visibility(
                                                        visible: (userGroup ==
                                                                    "Admin" ||
                                                                userGroup ==
                                                                    "Owner") ||
                                                            userGroupM
                                                                    .firstWhere(
                                                                      (e) =>
                                                                          e.userGroupName ==
                                                                          userGroup,
                                                                    )
                                                                    .stock !=
                                                                "No",
                                                        child: DButtons(
                                                          text: 'f) Receivable',
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const RAhomepage(),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(height: 1),
                                                      Visibility(
                                                        visible: (userGroup ==
                                                                    "Admin" ||
                                                                userGroup ==
                                                                    "Owner") ||
                                                            userGroupM
                                                                    .firstWhere(
                                                                      (e) =>
                                                                          e.userGroupName ==
                                                                          userGroup,
                                                                    )
                                                                    .ownerGroup !=
                                                                "No",
                                                        child: DButtons(
                                                          text: 'g) Payable',
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const PAHomepage(),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                const Spacer(),

                                                SizedBox(
                                                  width: screenWidth * 0.15,
                                                  height: 140,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Account Reports',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255, 208, 31, 34),
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  208,
                                                                  31,
                                                                  34),
                                                          decorationThickness:
                                                              2.0,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      DButtons(
                                                        text:
                                                            '1) Trial Balance',
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const DataTablePaginationExample(),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      const SizedBox(height: 1),
                                                      DButtons(
                                                        isDisabled: (userGroup ==
                                                                    "Admin" ||
                                                                userGroup ==
                                                                    "Owner" ||
                                                                userGroupM
                                                                        .firstWhere((e) =>
                                                                            e.userGroupName ==
                                                                            userGroup)
                                                                        .receiptNote !=
                                                                    "No")
                                                            ? false
                                                            : true,
                                                        text:
                                                            '2) Ledger Stmnt.',
                                                        onPressed: (userGroup ==
                                                                    "Admin" ||
                                                                userGroup ==
                                                                    "Owner" ||
                                                                userGroupM
                                                                        .firstWhere((e) =>
                                                                            e.userGroupName ==
                                                                            userGroup)
                                                                        .receiptNote !=
                                                                    "No")
                                                            ? () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const LedgerStmnt(),
                                                                  ),
                                                                );
                                                              }
                                                            : null,
                                                      ),
                                                      const SizedBox(height: 1),
                                                      DButtons(
                                                        text:
                                                            '3) Voucher Regi.',
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const StockFilter(),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: screenWidth * 0.15,
                                                  height: 110,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Masters',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255, 208, 31, 34),
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  208,
                                                                  31,
                                                                  34),
                                                          decorationThickness:
                                                              2.0,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      DButtons(
                                                        text: 'm) Ledgers',
                                                        onPressed: (userGroup ==
                                                                    "Admin" ||
                                                                userGroup ==
                                                                    "Owner" ||
                                                                userGroupM
                                                                        .firstWhere((e) =>
                                                                            e.userGroupName ==
                                                                            userGroup)
                                                                        .addMaster !=
                                                                    "No")
                                                            ? () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const LedgerHome(),
                                                                  ),
                                                                );
                                                              }
                                                            : null,
                                                      ),
                                                      const SizedBox(height: 1),
                                                      DButtons(
                                                        text: 'n) Items',
                                                        onPressed: (userGroup ==
                                                                    "Admin" ||
                                                                userGroup ==
                                                                    "Owner" ||
                                                                userGroupM
                                                                        .firstWhere((e) =>
                                                                            e.userGroupName ==
                                                                            userGroup)
                                                                        .jobcard !=
                                                                    "No")
                                                            ? () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const ItemHome(),
                                                                  ),
                                                                );
                                                              }
                                                            : null,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Spacer(),
                                                SizedBox(
                                                  width: screenWidth * 0.15,
                                                  height: 140,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Inventory Reports',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255, 208, 31, 34),
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  208,
                                                                  31,
                                                                  34),
                                                          decorationThickness:
                                                              2.0,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      userGroup == "Owner"
                                                          ? DButtons(
                                                              text:
                                                                  '6) Stock Status',
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const StockFilter(),
                                                                  ),
                                                                );
                                                              })
                                                          : DButtons(
                                                              text:
                                                                  '6) Stock Status',
                                                              onPressed: (userGroup == "Admin" ||
                                                                      userGroup ==
                                                                          "Owner" ||
                                                                      userGroupM
                                                                              .firstWhere((e) => e.userGroupName == userGroup)
                                                                              .deliveryNote !=
                                                                          "No")
                                                                  ? () {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              const StockStatus(),
                                                                        ),
                                                                      );
                                                                    }
                                                                  : null,
                                                            ),
                                                      const SizedBox(height: 1),
                                                      DButtons(
                                                        text:
                                                            '7) Stock Vouchers',
                                                        onPressed: (userGroup ==
                                                                    "Admin" ||
                                                                userGroup ==
                                                                    "Owner" ||
                                                                userGroupM
                                                                        .firstWhere((e) =>
                                                                            e.userGroupName ==
                                                                            userGroup)
                                                                        .purchaseOrder !=
                                                                    "No")
                                                            ? () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const StockVoucherDesktopBody(),
                                                                  ),
                                                                );
                                                              }
                                                            : null,
                                                      ),
                                                      const SizedBox(height: 1),
                                                      DButtons(
                                                        text:
                                                            '8)  Sales Register',
                                                        onPressed: (userGroup ==
                                                                    "Admin" ||
                                                                userGroup ==
                                                                    "Owner" ||
                                                                userGroupM
                                                                        .firstWhere((e) =>
                                                                            e.userGroupName ==
                                                                            userGroup)
                                                                        .salesOrder !=
                                                                    "No")
                                                            ? () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const SalesRegisterDesktop(),
                                                                  ),
                                                                );
                                                              }
                                                            : null,
                                                      )
                                                    ],
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
                                const SizedBox(width: 20),
                                Flexible(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 2,
                                            top: screenHeight * 0.001),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Shortcuts(
                                              shortcuts: {
                                                LogicalKeySet(
                                                        LogicalKeyboardKey.f1):
                                                    const ActivateIntent(),
                                              },
                                              child: Focus(
                                                autofocus: true,
                                                onKey: (FocusNode focusNode,
                                                    RawKeyEvent event) {
                                                  if (event
                                                          is RawKeyDownEvent &&
                                                      event.logicalKey ==
                                                          LogicalKeyboardKey
                                                              .f1) {
                                                    // Handle the shortcut, e.g., navigate to a new page
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const LedgerHome()),
                                                    );
                                                    return KeyEventResult
                                                        .handled;
                                                  }
                                                  return KeyEventResult.ignored;
                                                },
                                                child: const DToDo(),
                                              ),
                                            ),
                                            SizedBox(
                                                width: screenWidth * 0.006),
                                            const DRemainder(),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: (userGroup == "Admin" ||
                                                userGroup == "Owner") ||
                                            userGroupM
                                                    .firstWhere(
                                                      (e) =>
                                                          e.userGroupName ==
                                                          userGroup,
                                                    )
                                                    .ownerGroup !=
                                                "No",
                                        child: DTable(
                                          suggestionLedger: suggestionLedger,
                                          suggestionLedgerCustomer:
                                              suggestionLedgerCustomer,
                                          suggestionPayment: suggestionPayment,
                                          suggestionPurchase:
                                              suggestionPurchase,
                                          suggestionSales: suggestionSales,
                                          suggestionSalesCash:
                                              suggestionSalesCash,
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
                    ],
                  ),
                ),
                // bottomNavigationBar: const CustomFooter(),
              ),
      ),
    );
  }
}

class QuickAccessShimmer extends StatelessWidget {
  const QuickAccessShimmer({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: screenWidth * 0.4,
            height: 565,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            child: Column(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: double.infinity,
                    height: 30.0,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 240,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: double.infinity,
                                      height: 24.0,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: double.infinity,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                    ),
                                  ),
                                  // Add other shimmer containers here
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                              width: 10), // Add spacing between items
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 140,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: double.infinity,
                                      height: 24.0,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: double.infinity,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                    ),
                                  ),
                                  // Add other shimmer containers here
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Second Row...
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 110,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: double.infinity,
                                      height: 24.0,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: double.infinity,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                    ),
                                  ),
                                  // Add other shimmer containers here
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                              width: 10), // Add spacing between items
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 140,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: double.infinity,
                                      height: 24.0,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: double.infinity,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                    ),
                                  ),
                                  // Add other shimmer containers here
                                ],
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
    );
  }
}
