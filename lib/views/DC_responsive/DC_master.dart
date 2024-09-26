import 'dart:async';

import 'package:billingsphere/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/deliveryChallan/delivery_challan_model.dart';
import '../../data/models/newCompany/new_company_model.dart';
import '../../data/repository/delivery_challan_repository.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/new_company_repository.dart';
import '../SE_responsive/SE_master.dart';
import 'DC_desktop_body.dart';
import 'DC_receipt.dart';
import 'Delivery_Challan_Edit_Screen.dart';

class DeliveryChallanHome extends StatefulWidget {
  const DeliveryChallanHome({super.key});

  @override
  State<DeliveryChallanHome> createState() => _DeliveryChallanHomeState();
}

class _DeliveryChallanHomeState extends State<DeliveryChallanHome> {
  List<DeliveryChallan> fetchedDelivery = [];
  List<DeliveryChallan> fetchedDelivery2 = [];
  LedgerService ledgerService = LedgerService();
  List<NewCompany> selectedComapny = [];
  NewCompanyRepository newCompanyRepo = NewCompanyRepository();
  final TextEditingController _searchController = TextEditingController();
  late LinkedScrollControllerGroup _horizontalControllersGroup;
  late ScrollController _horizontalController1;
  late ScrollController _horizontalController2;

  String? selectedId;
  bool isLoading = false;
  int index = 0;

  DeliveryChallanServices deliveryChallanRepo = DeliveryChallanServices();
  List<String>? companyCode;

  Future<List<String>?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('companies');
  }

  Future<void> setCompanyCode() async {
    List<String>? code = await getCompanyCode();
    setState(() {
      companyCode = code;
      print('DCCCC $companyCode');
    });
  }

  Future<void> fetchAllCompany() async {
    try {
      final List<NewCompany> allCompany =
          await newCompanyRepo.getAllCompanies();

      setState(() {
        selectedComapny = allCompany;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> fetchAllDC() async {
    setState(() {
      isLoading = true;
    });

    try {
      final List<DeliveryChallan> dc =
          await deliveryChallanRepo.fetchDeliveryChallan();

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        if (dc.isNotEmpty) {
          fetchedDelivery = dc;
          fetchedDelivery2 = dc;
          selectedId = fetchedDelivery[0].id;
        } else {
          fetchedDelivery = dc;
        }
        isLoading = false;
      });

      print(dc);
    } catch (error) {
      print('Failed to fetch Devlivery Challan: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Timer? _debounce;
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      searchItem(query);
    });

    setState(() {});
  }

  void searchItem(String query) {
    if (query.isNotEmpty) {
      List<DeliveryChallan> filteredDCList = fetchedDelivery2.where((group) {
        return group.dcNo.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        fetchedDelivery = filteredDCList;
      });
    } else {
      setState(() {
        fetchedDelivery = fetchedDelivery2;
      });
    }
  }

  String getCompanyName(String companyCode) {
    for (var company in selectedComapny) {
      if (company.companyCode == companyCode) {
        return company.companyName.toString();
      }
    }
    return 'Unknown Company'; // Fallback in case companyCode is not found
  }

  String getCityByCompanyCode(String companyCode) {
    for (var company in selectedComapny) {
      if (company.stores != null) {
        for (var store in company.stores!) {
          if (store.code == companyCode) {
            return store.city;
          }
        }
      }
    }
    return 'Unknown City'; // Fallback in case companyCode is not found
  }

  @override
  void initState() {
    _horizontalControllersGroup = LinkedScrollControllerGroup();
    _horizontalController1 = _horizontalControllersGroup.addAndGet();
    _horizontalController2 = _horizontalControllersGroup.addAndGet();

    initAsync();

    super.initState();
  }

  Future<void> initAsync() async {
    setState(() {
      isLoading = true;
    });

    try {
      await Future.wait([
        fetchAllCompany(),
        fetchAllDC(),
        setCompanyCode(),
      ]);
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: Constants.loadingIndicator,
            ),
          )
        : Shortcuts(
            shortcuts: <LogicalKeySet, Intent>{
              LogicalKeySet(LogicalKeyboardKey.escape): const ActivateIntent(),
              LogicalKeySet(LogicalKeyboardKey.f2):
                  const NavigateToNewDeliveryChallanIntent(),
              LogicalKeySet(LogicalKeyboardKey.f3):
                  const NavigateToEditDeliveryChallanIntent(),
              LogicalKeySet(LogicalKeyboardKey.delete):
                  const DeleteSelectedDeliveryChallan(),
            },
            child: Actions(
              actions: <Type, Action<Intent>>{
                ActivateIntent: CallbackAction<ActivateIntent>(
                  onInvoke: (ActivateIntent intent) {
                    Navigator.of(context).pop();
                    return KeyEventResult.handled;
                  },
                ),
                NavigateToNewDeliveryChallanIntent:
                    CallbackAction<NavigateToNewDeliveryChallanIntent>(
                  onInvoke: (NavigateToNewDeliveryChallanIntent intent) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const DCDesktopBody(),
                      ),
                    );
                    return KeyEventResult.handled;
                  },
                ),
                NavigateToEditDeliveryChallanIntent:
                    CallbackAction<NavigateToEditDeliveryChallanIntent>(
                  onInvoke: (NavigateToEditDeliveryChallanIntent intent) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DeliveryChallanEditScreen(
                          deliveryChallan: fetchedDelivery[index],
                          deliveryChallans: fetchedDelivery,
                        ),
                      ),
                    );
                    return KeyEventResult.handled;
                  },
                ),
                DeleteSelectedDeliveryChallan:
                    CallbackAction<DeleteSelectedDeliveryChallan>(
                  onInvoke: (DeleteSelectedDeliveryChallan intent) {
                    if (selectedId != null) {
                      PanaraConfirmDialog.showAnimatedGrow(
                        context,
                        title: "BillingSphere",
                        message: "Are you sure you want to delete this entry?",
                        confirmButtonText: "Confirm",
                        cancelButtonText: "Cancel",
                        onTapCancel: () {
                          Navigator.pop(context);
                        },
                        onTapConfirm: () {
                          // Pop the dialog
                          Navigator.pop(context);

                          // Call the delete function
                          deliveryChallanRepo.deleteDeliveryChallan(
                            fetchedDelivery[index].id,
                            context,
                          );
                        },
                        panaraDialogType: PanaraDialogType.warning,
                      );
                    } else {
                      PanaraConfirmDialog.showAnimatedGrow(
                        context,
                        title: "BillingSphere",
                        message: "Please select an entry to delete",
                        confirmButtonText: "Confirm",
                        cancelButtonText: "Cancel",
                        onTapCancel: () {
                          Navigator.pop(context);
                        },
                        onTapConfirm: () {
                          // Pop the dialog
                          Navigator.pop(context);

                          // Call the delete function
                          deliveryChallanRepo.deleteDeliveryChallan(
                            fetchedDelivery[index].id,
                            context,
                          );
                        },
                        panaraDialogType: PanaraDialogType.error,
                      );
                    }
                    return KeyEventResult.handled;
                  },
                ),
              },
              child: Focus(
                autofocus: true,
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'DELIVERY CHALLAN LIST',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
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
                  body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            // height: 35,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    if (constraints.maxWidth > 1200) {
                                      return Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.10,
                                            child: Text(
                                              "Search By Bill No.",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                color: Colors.pinkAccent,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85,
                                            child: Container(
                                              color: Colors.black,
                                              height: 35,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextField(
                                                  controller: _searchController,
                                                  onChanged: _onSearchChanged,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    height: 0.8,
                                                  ),
                                                  // cursorHeight: 15,
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.all(0.0),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.0), // Adjust the border radius as needed
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Search By Bill No.",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            color: Colors.pinkAccent,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Container(
                                          color: Colors.black,
                                          height: 35,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextField(
                                              controller: _searchController,
                                              onChanged: _onSearchChanged,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                height: 0.8,
                                              ),
                                              // cursorHeight: 15,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.all(0.0),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(
                                                      0.0), // Adjust the border radius as needed
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(0.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                )),
                          ),
                        ),
                        const SizedBox(height: 5),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth > 1200) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Table(
                                      columnWidths: {
                                        0: FixedColumnWidth(
                                            MediaQuery.of(context).size.width *
                                                0.20),
                                        1: FlexColumnWidth(
                                            MediaQuery.of(context).size.width *
                                                0.40),
                                        2: FlexColumnWidth(
                                            MediaQuery.of(context).size.width *
                                                0.40),
                                        3: FlexColumnWidth(
                                            MediaQuery.of(context).size.width *
                                                0.40),
                                        4: FlexColumnWidth(
                                            MediaQuery.of(context).size.width *
                                                0.40),
                                        5: FlexColumnWidth(
                                            MediaQuery.of(context).size.width *
                                                0.40),
                                        6: FlexColumnWidth(
                                            MediaQuery.of(context).size.width *
                                                0.40),
                                        7: FlexColumnWidth(
                                            MediaQuery.of(context).size.width *
                                                0.40),
                                        8: FlexColumnWidth(
                                            MediaQuery.of(context).size.width *
                                                0.40),
                                      },
                                      border:
                                          TableBorder.all(color: Colors.black),
                                      children: [
                                        TableRow(
                                          children: [
                                            TableCell(
                                              child: Text(
                                                "Sr",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.pinkAccent,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            TableCell(
                                              child: Text(
                                                "Date",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.pinkAccent,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            TableCell(
                                              child: Text(
                                                "Bill No",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.pinkAccent,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            TableCell(
                                              child: Text(
                                                "Store",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.pinkAccent,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            TableCell(
                                              child: Text(
                                                "Location",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.pinkAccent,
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
                                                  color: Colors.pinkAccent,
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
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height *
                                          0.60,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          children: [
                                            Table(
                                              columnWidths: {
                                                0: FixedColumnWidth(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.20),
                                                1: FlexColumnWidth(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.40),
                                                2: FlexColumnWidth(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.40),
                                                3: FlexColumnWidth(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.40),
                                                4: FlexColumnWidth(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.40),
                                                5: FlexColumnWidth(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.40),
                                                6: FlexColumnWidth(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.40),
                                                7: FlexColumnWidth(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.40),
                                                8: FlexColumnWidth(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.40),
                                              },
                                              border: const TableBorder.symmetric(
                                                inside: BorderSide(
                                                    color: Colors.black),
                                                outside: BorderSide(
                                                    color: Colors.black),
                                              ),
                                              children: [
                                                // Iterate over fetchedDelivery list and display each sales entry
                                                for (int i = 0;
                                                    i < fetchedDelivery.length;
                                                    i++)
                                                  // Declare companyName and city for each row
                                                  TableRow(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedId =
                                                                fetchedDelivery[i]
                                                                    .id;
                                                            index = i;
                                                          });
                                                        },
                                                        onDoubleTap: () {
                                                          print('Double Tapped');
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DeliveryChallanEditScreen(
                                                                deliveryChallan:
                                                                    fetchedDelivery[
                                                                        i],
                                                                deliveryChallans:
                                                                    fetchedDelivery,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.20,
                                                          color: selectedId ==
                                                                  fetchedDelivery[
                                                                          i]
                                                                      .id
                                                              ? Colors.blue[500]
                                                              : Colors.white,
                                                          child: Text(
                                                            '${i + 1}',
                                                            maxLines: 1,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              color: selectedId ==
                                                                      fetchedDelivery[
                                                                              i]
                                                                          .id
                                                                  ? Colors.white
                                                                  : Colors.black,
                                                            ),
                                                            textAlign:
                                                                TextAlign.center,
                                                          ),
                                                        ),
                                                      ),
                                                      // Retrieve companyName and city
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedId =
                                                                fetchedDelivery[i]
                                                                    .id;
                                                            index = i;
                                                          });
                                                        },
                                                        onDoubleTap: () {
                                                          print('Double Tapped');
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DeliveryChallanEditScreen(
                                                                deliveryChallan:
                                                                    fetchedDelivery[
                                                                        i],
                                                                deliveryChallans:
                                                                    fetchedDelivery,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.40,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          color: selectedId ==
                                                                  fetchedDelivery[
                                                                          i]
                                                                      .id
                                                              ? Colors.blue[500]
                                                              : Colors.white,
                                                          child: Text(
                                                            fetchedDelivery[i]
                                                                .date,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              color: selectedId ==
                                                                      fetchedDelivery[
                                                                              i]
                                                                          .id
                                                                  ? Colors.white
                                                                  : Colors.black,
                                                            ),
                                                            textAlign:
                                                                TextAlign.center,
                                                          ),
                                                        ),
                                                      ),
                
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedId =
                                                                fetchedDelivery[i]
                                                                    .id;
                                                            index = i;
                                                          });
                                                        },
                                                        onDoubleTap: () {
                                                          print('Double Tapped');
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DeliveryChallanEditScreen(
                                                                deliveryChallan:
                                                                    fetchedDelivery[
                                                                        i],
                                                                deliveryChallans:
                                                                    fetchedDelivery,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.40,
                                                          color: selectedId ==
                                                                  fetchedDelivery[
                                                                          i]
                                                                      .id
                                                              ? Colors.blue[500]
                                                              : Colors.white,
                                                          child: Text(
                                                            fetchedDelivery[i]
                                                                .dcNo,
                                                            maxLines: 1,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              color: selectedId ==
                                                                      fetchedDelivery[
                                                                              i]
                                                                          .id
                                                                  ? Colors.white
                                                                  : Colors.black,
                                                            ),
                                                            textAlign:
                                                                TextAlign.center,
                                                          ),
                                                        ),
                                                      ),
                
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedId =
                                                                fetchedDelivery[i]
                                                                    .id;
                                                            index = i;
                                                          });
                                                        },
                                                        onDoubleTap: () {
                                                          print('Double Tapped');
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DeliveryChallanEditScreen(
                                                                deliveryChallan:
                                                                    fetchedDelivery[
                                                                        i],
                                                                deliveryChallans:
                                                                    fetchedDelivery,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.40,
                                                          color: selectedId ==
                                                                  fetchedDelivery[
                                                                          i]
                                                                      .id
                                                              ? Colors.blue[500]
                                                              : Colors.white,
                                                          child: Text(
                                                            maxLines: 1,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            getCompanyName(
                                                                fetchedDelivery[i]
                                                                    .party), // Use companyName
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              color: selectedId ==
                                                                      fetchedDelivery[
                                                                              i]
                                                                          .id
                                                                  ? Colors.white
                                                                  : Colors.black,
                                                            ),
                                                            textAlign:
                                                                TextAlign.center,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedId =
                                                                fetchedDelivery[i]
                                                                    .id;
                                                            index = i;
                                                          });
                                                        },
                                                        onDoubleTap: () {
                                                          print('Double Tapped');
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DeliveryChallanEditScreen(
                                                                deliveryChallan:
                                                                    fetchedDelivery[
                                                                        i],
                                                                deliveryChallans:
                                                                    fetchedDelivery,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.40,
                                                          color: selectedId ==
                                                                  fetchedDelivery[
                                                                          i]
                                                                      .id
                                                              ? Colors.blue[500]
                                                              : Colors.white,
                                                          child: Text(
                                                            maxLines: 1,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            getCityByCompanyCode(
                                                                fetchedDelivery[i]
                                                                    .companyCode), // Use city
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              color: selectedId ==
                                                                      fetchedDelivery[
                                                                              i]
                                                                          .id
                                                                  ? Colors.white
                                                                  : Colors.black,
                                                            ),
                                                            textAlign:
                                                                TextAlign.center,
                                                          ),
                                                        ),
                                                      ),
                
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedId =
                                                                fetchedDelivery[i]
                                                                    .id;
                                                            index = i;
                                                          });
                                                        },
                                                        onDoubleTap: () {
                                                          print('Double Tapped');
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DeliveryChallanEditScreen(
                                                                deliveryChallan:
                                                                    fetchedDelivery[
                                                                        i],
                                                                deliveryChallans:
                                                                    fetchedDelivery,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.40,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          color: selectedId ==
                                                                  fetchedDelivery[
                                                                          i]
                                                                      .id
                                                              ? Colors.blue[500]
                                                              : Colors.white,
                                                          child: Text(
                                                            fetchedDelivery[i]
                                                                .totalamount,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              color: selectedId ==
                                                                      fetchedDelivery[
                                                                              i]
                                                                          .id
                                                                  ? Colors.white
                                                                  : Colors.black,
                                                            ),
                                                            textAlign:
                                                                TextAlign.center,
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
                                    )
                                  ],
                                ),
                              );
                            }
                
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.96,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 1,
                                              ),
                                            ),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              controller: _horizontalController1,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.10,
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        top: BorderSide(),
                                                        left: BorderSide(),
                                                        right: BorderSide(),
                                                        bottom: BorderSide(),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      '   Sr',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.pinkAccent,
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 30,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 5.0),
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.30,
                                                    decoration:
                                                        const BoxDecoration(
                                                            border: Border(
                                                      top: BorderSide(),
                                                      left: BorderSide(),
                                                      right: BorderSide(),
                                                      bottom: BorderSide(),
                                                    )),
                                                    child: const Text(
                                                      'Date',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.pinkAccent,
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 30,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 5.0),
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.40,
                                                    decoration:
                                                        const BoxDecoration(
                                                            border: Border(
                                                      top: BorderSide(),
                                                      left: BorderSide(),
                                                      right: BorderSide(),
                                                      bottom: BorderSide(),
                                                    )),
                                                    child: const Text(
                                                      'Bill No',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.pinkAccent,
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 30,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 5.0),
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.40,
                                                    decoration:
                                                        const BoxDecoration(
                                                            border: Border(
                                                      top: BorderSide(),
                                                      left: BorderSide(),
                                                      right: BorderSide(),
                                                      bottom: BorderSide(),
                                                    )),
                                                    child: const Text(
                                                      'Store',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.pinkAccent,
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 30,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 5.0),
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.40,
                                                    decoration:
                                                        const BoxDecoration(
                                                            border: Border(
                                                      top: BorderSide(),
                                                      left: BorderSide(),
                                                      right: BorderSide(),
                                                      bottom: BorderSide(),
                                                    )),
                                                    child: const Text(
                                                      'Location',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.pinkAccent,
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 30,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 5.0),
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.20,
                                                    decoration:
                                                        const BoxDecoration(
                                                            border: Border(
                                                      top: BorderSide(),
                                                      left: BorderSide(),
                                                      right: BorderSide(),
                                                      bottom: BorderSide(),
                                                    )),
                                                    child: const Text(
                                                      'Amount',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.pinkAccent,
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 30,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 5.0),
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.32,
                                                    decoration:
                                                        const BoxDecoration(
                                                            border: Border(
                                                      top: BorderSide(),
                                                      left: BorderSide(),
                                                      right: BorderSide(),
                                                      bottom: BorderSide(),
                                                    )),
                                                    child: const Text(
                                                      'Action',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.pinkAccent,
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
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
                                  // Table Body...
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: fetchedDelivery.length,
                                    itemBuilder: (context, index) {
                                      String companyName = getCompanyName(
                                          fetchedDelivery[index].party);
                
                                      String city = getCityByCompanyCode(
                                          fetchedDelivery[index].companyCode);
                
                                      if (fetchedDelivery.isEmpty) {
                                        return const Center(
                                          child:
                                              Text('No Delivery Challan Found'),
                                        );
                                      }
                
                                      return SizedBox(
                                        width: MediaQuery.of(context).size.width *
                                            0.96,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          elevation: 1,
                                          child: SizedBox(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              controller: _horizontalController2,
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.10,
                                                    child: Text(
                                                      "${index + 1}".toString(),
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.30,
                                                    child: Text(
                                                      fetchedDelivery[index].date,
                                                      textAlign: TextAlign.center,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.40,
                                                    child: Text(
                                                      fetchedDelivery[index].dcNo,
                                                      textAlign: TextAlign.center,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.40,
                                                    child: Text(
                                                      companyName,
                                                      textAlign: TextAlign.center,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.40,
                                                    child: Text(
                                                      city,
                                                      textAlign: TextAlign.center,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.20,
                                                    child: Text(
                                                      fetchedDelivery[index]
                                                          .totalamount,
                                                      textAlign: TextAlign.center,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  StatefulBuilder(
                                                    builder: (context, setState) {
                                                      return SizedBox(
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.30,
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            IconButton(
                                                              icon: const Icon(
                                                                  Icons.print,
                                                                  size: 15,
                                                                  color: Colors
                                                                      .blue),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            DCReceipt(
                                                                      'Print Sales',
                                                                      deliveryChallan:
                                                                          fetchedDelivery[index]
                                                                              .id,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
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
                                  title: '',
                                  subtitle: '',
                                ),
                                BottomButtons(
                                  title: 'New',
                                  subtitle: 'F2',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const DCDesktopBody(),
                                      ),
                                    );
                                  },
                                ),
                                BottomButtons(
                                  title: 'Edit',
                                  subtitle: 'F3',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DeliveryChallanEditScreen(
                                          deliveryChallan: fetchedDelivery[index],
                                          deliveryChallans: fetchedDelivery,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                BottomButtons(
                                  title: 'XLS',
                                  subtitle: 'X',
                                  onPressed: () {},
                                ),
                                BottomButtons(
                                  title: 'Print',
                                  subtitle: 'P',
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => DCReceipt(
                                          'Print Sales',
                                          deliveryChallan: fetchedDelivery[index]
                                              .id,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                StatefulBuilder(
                                  builder: (context, setState) {
                                    return BottomButtons(
                                      title: 'DEL',
                                      subtitle: 'DEL',
                                      onPressed: () {
                                        PanaraConfirmDialog.showAnimatedGrow(
                                          context,
                                          title: "BillingSphere",
                                          message:
                                              "Are you sure you want to delete this entry?",
                                          confirmButtonText: "Confirm",
                                          cancelButtonText: "Cancel",
                                          onTapCancel: () {
                                            Navigator.pop(context);
                                          },
                                          onTapConfirm: () {
                                            // Pop the dialog
                                            Navigator.pop(context);
                
                                            // Call the delete function
                                            deliveryChallanRepo
                                                .deleteDeliveryChallan(
                                              fetchedDelivery[index].id,
                                              context,
                                            );
                                          },
                                          panaraDialogType:
                                              PanaraDialogType.warning,
                                        );
                                      },
                                    );
                                  },
                                ),
                                const BottomButtons(
                                  title: '',
                                  subtitle: '',
                                ),
                                const BottomButtons(
                                  title: '',
                                  subtitle: '',
                                ),
                                const BottomButtons(),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}

class DeleteSelectedDeliveryChallan extends Intent {
  const DeleteSelectedDeliveryChallan();
}

class NavigateToEditDeliveryChallanIntent extends Intent {
  const NavigateToEditDeliveryChallanIntent();
}

class NavigateToNewDeliveryChallanIntent extends Intent {
  const NavigateToNewDeliveryChallanIntent();
}
