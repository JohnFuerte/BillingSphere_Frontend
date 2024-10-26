import 'package:billingsphere/data/models/deliveryChallan/delivery_challan_model.dart';
import 'package:billingsphere/data/repository/delivery_challan_repository.dart';
import 'package:billingsphere/utils/constant.dart';
import 'package:billingsphere/views/Stock_Status/stock_status_owner.dart';
import 'package:billingsphere/views/Stock_Status/stock_status_report.dart';
import 'package:billingsphere/views/sumit_screen/voucher%20_entry.dart/voucher_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/item/item_model.dart';
import '../../data/models/purchase/purchase_model.dart';
import '../../data/models/salesEntries/sales_entrires_model.dart';
import '../../data/repository/item_repository.dart';
import '../../data/repository/purchase_repository.dart';
import '../../data/repository/sales_enteries_repository.dart';
import '../../utils/controllers/purchase_text_controller.dart';
import '../../utils/controllers/sales_text_controllers.dart';
import '../DB_responsive/DB_desktop_body.dart';

// class OtherScreen extends StatefulWidget {
//   final String itemId;
//   final String itemName;

//   const OtherScreen({Key? key, required this.itemId, required this.itemName})
//       : super(key: key);

//   @override
//   _OtherScreenState createState() => _OtherScreenState();
// }

// class _OtherScreenState extends State<OtherScreen> {
//   Map<String, Map<String, dynamic>> monthlySales = {};
//   Map<String, Map<String, dynamic>> monthlyPurchase = {};
//   Map<String, Map<String, dynamic>> mergedData = {};

//   String? uid;
//   Future<String?> getUID() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('user_id');
//   }

//   void setId() async {
//     String? id = await getUID();
//     setState(() {
//       uid = id;
//     });
//   }

//   SalesEntryFormController salesEntryFormController =
//       SalesEntryFormController();
//   SalesEntryService salesService = SalesEntryService();
//   PurchaseFormController purchaseEntryFormController = PurchaseFormController();
//   PurchaseServices purchaseService = PurchaseServices();

//   DeliveryChallanServices deliveryChallanService = DeliveryChallanServices();

//   Future<void> fetchSalesAndPurchases() async {
//     try {
//       final List<SalesEntry> sales = await salesService.fetchSalesEntries();
//       final List<Purchase> purchases =
//           await purchaseService.fetchPurchaseEntries();
//       final List<DeliveryChallan> delivery =
//           await deliveryChallanService.fetchDeliveryChallan();

//       final filteredSalesEntry = sales.where((salesentry) {
//         return salesentry.entries
//             .any((entry) => entry.itemName == widget.itemId);
//       }).toList();

//       final filteredPurchaseEntry = purchases.where((purchaseentry) {
//         return purchaseentry.entries
//             .any((entry) => entry.itemName == widget.itemId);
//       }).toList();

//       final filteredDeliveryChallanEntry =
//           delivery.where((deliverychallanentry) {
//         return deliverychallanentry.entries
//             .any((entry) => entry.itemName == widget.itemId);
//       }).toList();

//       // Process sales entries
//       for (var entry in filteredSalesEntry) {
//         final dateParts = entry.date.split('/');
//         final day = int.parse(dateParts[0]);
//         final month = int.parse(dateParts[1]);
//         final year = int.parse(dateParts[2]);
//         final formattedDate =
//             DateFormat('MMM-yy').format(DateTime(year, month, day));

//         if (!mergedData.containsKey(formattedDate)) {
//           mergedData[formattedDate] = {
//             'totalQtyS': 0,
//             'totalValS': 0,
//             'totalQtyP': 0,
//             'totalValP': 0,
//             'totalQtyD': 0,
//             'totalValD': 0,
//           };
//         }

//         for (var subEntry in entry.entries) {
//           if (subEntry.itemName == widget.itemId) {
//             mergedData[formattedDate]!['totalQtyS'] += subEntry.qty;
//             mergedData[formattedDate]!['totalValS'] += subEntry.amount;
//           }
//         }
//       }

//       // Process purchase entries
//       for (var entry in filteredPurchaseEntry) {
//         final dateParts = entry.date.split('/');
//         final day = int.parse(dateParts[0]);
//         final month = int.parse(dateParts[1]);
//         final year = int.parse(dateParts[2]);
//         final formattedDate =
//             DateFormat('MMM-yy').format(DateTime(year, month, day));

//         if (!mergedData.containsKey(formattedDate)) {
//           mergedData[formattedDate] = {
//             'totalQtyS': 0,
//             'totalValS': 0,
//             'totalQtyP': 0,
//             'totalValP': 0,
//             'totalQtyD': 0,
//             'totalValD': 0,
//           };
//         }

//         for (var subEntry in entry.entries) {
//           if (subEntry.itemName == widget.itemId) {
//             mergedData[formattedDate]!['totalQtyP'] += subEntry.qty;
//             mergedData[formattedDate]!['totalValP'] += subEntry.amount;
//           }
//         }
//       }

//       // Process delivery challan entries
//       for (var entry in filteredDeliveryChallanEntry) {
//         final dateParts = entry.date.split('/');
//         final day = int.parse(dateParts[0]);
//         final month = int.parse(dateParts[1]);
//         final year = int.parse(dateParts[2]);
//         final formattedDate =
//             DateFormat('MMM-yy').format(DateTime(year, month, day));

//         if (!mergedData.containsKey(formattedDate)) {
//           mergedData[formattedDate] = {
//             'totalQtyS': 0,
//             'totalValS': 0,
//             'totalQtyP': 0,
//             'totalValP': 0,
//             'totalQtyD': 0,
//             'totalValD': 0,
//           };
//         }

//         for (var subEntry in entry.entries) {
//           if (subEntry.itemName == widget.itemId) {
//             mergedData[formattedDate]!['totalQtyD'] += subEntry.qty;
//             mergedData[formattedDate]!['totalValD'] += subEntry.netAmount;
//           }
//         }
//       }

//       setState(() {});

//       print(mergedData);
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: $error'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   List<Item> itemsList = [];
//   String? selectedItemId;
//   ItemsService items = ItemsService();
//   Item? _item;
//   String OpeiningQty = '';
//   String OpeiningAtm = '';

//   Future<void> _fetchSingleItem() async {
//     print(widget.itemId);
//     try {
//       final item = await items.getSingleItem(widget.itemId);

//       setState(() {
//         _item = item;
//         OpeiningQty = _item!.openingBalanceQty.toString();
//         OpeiningAtm = _item!.openingBalanceAmt.toString();
//       });
//     } catch (error) {}
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchSingleItem();
//     fetchSalesAndPurchases();
//     // fetchPurchase();
//     setId();
//   }

//   DateTime parseMonth(String month) {
//     return DateFormat('MMM-yy').parse(month);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final sortedKeys = mergedData.keys.toList()
//       ..sort((a, b) => parseMonth(a).compareTo(parseMonth(b)));
//     double totalInQty = 0;
//     double totalInVal = 0;
//     double totalOutQty = 0;
//     double totalOutVal = 0;

//     for (var month in sortedKeys) {
//       final data = mergedData[month]!;
//       totalInQty += data['totalQtyP'];
//       totalInVal += data['totalValP'];
//       totalOutQty += data['totalQtyS'];
//       totalOutVal += data['totalValS'];
//       totalOutQty += data['totalQtyD'];
//       totalOutVal += data['totalValD'];
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Stock Item Montly Summary',
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color.fromARGB(255, 33, 65, 243),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Text(
//                   'Item: ${widget.itemName} (Monthly Summary)',
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       decoration: TextDecoration.underline,
//                       fontSize: 18),
//                 ),
//                 const Spacer(),
//                 // const Text(
//                 //   '1/1/2023',
//                 //   style: TextStyle(
//                 //       fontWeight: FontWeight.bold,
//                 //       decoration: TextDecoration.underline,
//                 //       fontSize: 18),
//                 // ),
//                 // const Text(
//                 //   ' to',
//                 //   style: TextStyle(
//                 //       fontWeight: FontWeight.bold,
//                 //       decoration: TextDecoration.underline,
//                 //       fontSize: 18),
//                 // ),
//                 // const Text(
//                 //   '1/1/2024',
//                 //   style: TextStyle(
//                 //       fontWeight: FontWeight.bold,
//                 //       decoration: TextDecoration.underline,
//                 //       fontSize: 18),
//                 // ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             // Display monthly sales data in a table
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: 750,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(0),
//                   color: Colors.grey[200],
//                 ),
//                 padding: const EdgeInsets.all(16),
//                 child: ListView.builder(
//                   itemCount: sortedKeys.length +
//                       2, // +2 for header and opening balance row
//                   itemBuilder: (context, index) {
//                     if (index == 0) {
//                       // Header row
//                       return Container(
//                         height: 50,
//                         decoration: BoxDecoration(
//                           color: const Color.fromARGB(
//                               255, 33, 65, 243), // Header row color
//                           borderRadius: BorderRadius.circular(0),
//                         ),
//                         child: const Row(
//                           children: [
//                             Expanded(
//                                 child: Center(
//                                     child: Text('Particulars',
//                                         style:
//                                             TextStyle(color: Colors.white)))),
//                             Expanded(
//                                 child: Center(
//                                     child: Text('Op(Qty)',
//                                         style:
//                                             TextStyle(color: Colors.white)))),
//                             Expanded(
//                                 child: Center(
//                                     child: Text('Op(Val)',
//                                         style:
//                                             TextStyle(color: Colors.white)))),
//                             Expanded(
//                                 child: Center(
//                                     child: Text('In(Qty)',
//                                         style:
//                                             TextStyle(color: Colors.white)))),
//                             Expanded(
//                                 child: Center(
//                                     child: Text('In(Val)',
//                                         style:
//                                             TextStyle(color: Colors.white)))),
//                             Expanded(
//                                 child: Center(
//                                     child: Text('Out(Qty)',
//                                         style:
//                                             TextStyle(color: Colors.white)))),
//                             Expanded(
//                                 child: Center(
//                                     child: Text('Out(Val)',
//                                         style:
//                                             TextStyle(color: Colors.white)))),
//                             Expanded(
//                                 child: Center(
//                                     child: Text('Cl(Qty)',
//                                         style:
//                                             TextStyle(color: Colors.white)))),
//                             Expanded(
//                                 child: Center(
//                                     child: Text(
//                               'Cl(Val)',
//                               style: TextStyle(color: Colors.white),
//                             ))),
//                           ],
//                         ),
//                       );
//                     } else if (index == 1) {
//                       // Opening balance row
//                       return Container(
//                         color: Colors.blue.shade100,
//                         padding: const EdgeInsets.symmetric(vertical: 8),
//                         child: Row(
//                           children: [
//                             const Expanded(
//                                 child: Center(child: Text('Opening Balance'))),
//                             const Expanded(child: Center(child: Text(''))),
//                             const Expanded(child: Center(child: Text(''))),
//                             const Expanded(
//                                 child: Center(child: Text(''))), // In(Qty)
//                             const Expanded(
//                                 child: Center(child: Text(''))), // In(Val)
//                             const Expanded(
//                                 child: Center(child: Text(''))), // Out(Qty)
//                             const Expanded(
//                                 child: Center(child: Text(''))), // Out(Val)
//                             Expanded(
//                                 child: Center(
//                                     child: Text(OpeiningQty))), // Cl(Qty)
//                             Expanded(
//                                 child: Center(
//                                     child: Text(OpeiningAtm))), // Cl(Val)
//                           ],
//                         ),
//                       );
//                     } else {
//                       final month = sortedKeys[index - 2];
//                       final data = mergedData[month]!;

//                       double opQty;
//                       double opAmt;
//                       if (index == 2) {
//                         opQty = double.parse(OpeiningQty);
//                         opAmt = double.parse(OpeiningAtm);
//                       } else {
//                         final prevMonth = sortedKeys[index - 3];
//                         final prevData = mergedData[prevMonth]!;
//                         opQty = prevData['closingQty'];
//                         opAmt = prevData['closingVal'];
//                       }

//                       final inQty = data['totalQtyP'];
//                       final inVal = data['totalValP'];
//                       final outQty = data['totalQtyS'] + data['totalQtyD'];
//                       final outVal = data['totalValS'] + data['totalValD'];
//                       final clQty = opQty + inQty - outQty;
//                       final clVal = opAmt + inVal - outVal;

//                       // Update the merged data with closing balances
//                       data['closingQty'] = clQty;
//                       data['closingVal'] = clVal;

//                       return InkWell(
//                         onTap: () {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (context) {
//                                 return StockStatusReport(
//                                   monthDate: month,
//                                   itemId: widget.itemId,
//                                   itemName: widget.itemName,
//                                   closingStock: opQty.toString(),
//                                 );
//                               },
//                             ),
//                           );
//                         },
//                         child: Container(
//                           color: index % 2 == 0
//                               ? Colors.white
//                               : Colors.blue.shade100,
//                           padding: const EdgeInsets.symmetric(vertical: 8),
//                           child: Row(
//                             children: [
//                               Expanded(child: Center(child: Text(month))),
//                               Expanded(
//                                   child: Center(child: Text(opQty.toString()))),
//                               Expanded(
//                                   child: Center(child: Text(opAmt.toString()))),
//                               Expanded(
//                                   child: Center(
//                                       child:
//                                           Text(inQty.toString()))), // In(Qty)
//                               Expanded(
//                                   child: Center(
//                                       child:
//                                           Text(inVal.toString()))), // In(Val)
//                               Expanded(
//                                   child: Center(
//                                       child:
//                                           Text(outQty.toString()))), // Out(Qty)
//                               Expanded(
//                                   child: Center(
//                                       child:
//                                           Text(outVal.toString()))), // Out(Val)
//                               Expanded(
//                                   child: Center(
//                                       child:
//                                           Text(clQty.toString()))), // Cl(Qty)
//                               Expanded(
//                                   child: Center(
//                                       child:
//                                           Text(clVal.toString()))), // Cl(Val)
//                             ],
//                           ),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//               ),
//             ),
//             Container(
//               color: Colors.grey[300],
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               child: Row(
//                 children: [
//                   Expanded(
//                       child: Center(
//                           child: Text('Total (${sortedKeys.length})',
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold)))),
//                   const Expanded(child: Center(child: Text(''))), // Op(Qty)
//                   const Expanded(child: Center(child: Text(''))), // Op(Val)
//                   Expanded(
//                       child: Center(
//                           child: Text(totalInQty.toString(),
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold)))),
//                   Expanded(
//                       child: Center(
//                           child: Text(totalInVal.toString(),
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold)))),
//                   Expanded(
//                       child: Center(
//                           child: Text(totalOutQty.toString(),
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold)))),
//                   Expanded(
//                       child: Center(
//                           child: Text(totalOutVal.toString(),
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold)))),
//                   const Expanded(child: Center(child: Text(''))), // Cl(Qty)
//                   const Expanded(child: Center(child: Text(''))), // Cl(Val)
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class OtherScreen extends StatefulWidget {
  final String itemId;
  final String itemName;
  const OtherScreen({super.key, required this.itemId, required this.itemName});

  @override
  State<OtherScreen> createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  Map<String, Map<String, dynamic>> monthlySales = {};
  Map<String, Map<String, dynamic>> monthlyPurchase = {};
  Map<String, Map<String, dynamic>> mergedData = {};
  bool isLoading = false;

  String? uid;
  Future<String?> getUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  void setId() async {
    String? id = await getUID();
    setState(() {
      uid = id;
    });
  }

  SalesEntryFormController salesEntryFormController =
      SalesEntryFormController();
  SalesEntryService salesService = SalesEntryService();
  PurchaseFormController purchaseEntryFormController = PurchaseFormController();
  PurchaseServices purchaseService = PurchaseServices();

  DeliveryChallanServices deliveryChallanService = DeliveryChallanServices();

  Future<void> fetchSalesAndPurchases() async {
    try {
      setState(() {
        isLoading = true;
      });

      final List<SalesEntry> sales = await salesService.fetchSalesEntries();
      final List<Purchase> purchases =
          await purchaseService.fetchPurchaseEntries();
      final List<DeliveryChallan> delivery =
          await deliveryChallanService.fetchDeliveryChallan();

      final filteredSalesEntry = sales.where((salesentry) {
        return salesentry.entries
            .any((entry) => entry.itemName == widget.itemId);
      }).toList();

      final filteredPurchaseEntry = purchases.where((purchaseentry) {
        return purchaseentry.entries
            .any((entry) => entry.itemName == widget.itemId);
      }).toList();

      final filteredDeliveryChallanEntry =
          delivery.where((deliverychallanentry) {
        return deliverychallanentry.entries
            .any((entry) => entry.itemName == widget.itemId);
      }).toList();

      // Process sales entries
      for (var entry in filteredSalesEntry) {
        final dateParts = entry.date.split('/');
        final day = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final year = int.parse(dateParts[2]);
        final formattedDate =
            DateFormat('MMM-yy').format(DateTime(year, month, day));

        if (!mergedData.containsKey(formattedDate)) {
          mergedData[formattedDate] = {
            'totalQtyS': 0,
            'totalValS': 0,
            'totalQtyP': 0,
            'totalValP': 0,
            'totalQtyD': 0,
            'totalValD': 0,
          };
        }

        for (var subEntry in entry.entries) {
          if (subEntry.itemName == widget.itemId) {
            mergedData[formattedDate]!['totalQtyS'] += subEntry.qty;
            mergedData[formattedDate]!['totalValS'] += subEntry.amount;
          }
        }
      }

      // Process purchase entries
      for (var entry in filteredPurchaseEntry) {
        final dateParts = entry.date.split('/');
        final day = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final year = int.parse(dateParts[2]);
        final formattedDate =
            DateFormat('MMM-yy').format(DateTime(year, month, day));

        if (!mergedData.containsKey(formattedDate)) {
          mergedData[formattedDate] = {
            'totalQtyS': 0,
            'totalValS': 0,
            'totalQtyP': 0,
            'totalValP': 0,
            'totalQtyD': 0,
            'totalValD': 0,
          };
        }

        for (var subEntry in entry.entries) {
          if (subEntry.itemName == widget.itemId) {
            mergedData[formattedDate]!['totalQtyP'] += subEntry.qty;
            mergedData[formattedDate]!['totalValP'] += subEntry.amount;
          }
        }
      }

      // Process delivery challan entries
      for (var entry in filteredDeliveryChallanEntry) {
        final dateParts = entry.date.split('/');
        final day = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final year = int.parse(dateParts[2]);
        final formattedDate =
            DateFormat('MMM-yy').format(DateTime(year, month, day));

        if (!mergedData.containsKey(formattedDate)) {
          mergedData[formattedDate] = {
            'totalQtyS': 0,
            'totalValS': 0,
            'totalQtyP': 0,
            'totalValP': 0,
            'totalQtyD': 0,
            'totalValD': 0,
          };
        }

        for (var subEntry in entry.entries) {
          if (subEntry.itemName == widget.itemId) {
            mergedData[formattedDate]!['totalQtyD'] += subEntry.qty;
            mergedData[formattedDate]!['totalValD'] += subEntry.netAmount;
          }
        }
      }

      setState(() {
        isLoading = false;
      });

      print(mergedData);
    } catch (error) {
      print("Inside the Error Box:.....................$error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Item> itemsList = [];
  String? selectedItemId;
  ItemsService items = ItemsService();
  Item? _item;
  String OpeiningQty = '';
  String OpeiningAtm = '';

  Future<void> _fetchSingleItem() async {
    print(widget.itemId);
    try {
      final item = await items.getSingleItem(widget.itemId);

      setState(() {
        _item = item;
        OpeiningQty = _item!.openingBalanceQty.toString();
        OpeiningAtm = _item!.openingBalanceAmt.toString();
      });
    } catch (error) {}
  }

  @override
  void initState() {
    super.initState();
    _fetchSingleItem();
    fetchSalesAndPurchases();
    // fetchPurchase();
    setId();
  }

  DateTime parseMonth(String month) {
    return DateFormat('MMM-yy').parse(month);
  }

  @override
  Widget build(BuildContext context) {
    final sortedKeys = mergedData.keys.toList()
      ..sort((a, b) => parseMonth(a).compareTo(parseMonth(b)));
    double totalInQty = 0;
    double totalInVal = 0;
    double totalOutQty = 0;
    double totalOutVal = 0;

    for (var month in sortedKeys) {
      final data = mergedData[month]!;
      totalInQty += data['totalQtyP'];
      totalInVal += data['totalValP'];
      totalOutQty += data['totalQtyS'];
      totalOutVal += data['totalValS'];
      totalOutQty += data['totalQtyD'];
      totalOutVal += data['totalValD'];
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Stock Item Periodic Summary",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(32, 91, 212, 1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Row(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Item: ${widget.itemName} (Monthly Summary)',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700, fontSize: 17),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(border: Border.all()),
                  child: Column(
                    children: [
                      // Header Row
                      Row(
                        children: [
                          HeaderCell(
                            flex: 4,
                            text: "Particulars",
                            fontWeight: FontWeight.bold,
                            bordor: Border.all(),
                            textColor: Colors.purple,
                          ),
                          HeaderCell(
                            flex: 2,
                            text: "Op(Qty)",
                            fontWeight: FontWeight.bold,
                            textColor: Colors.purple,
                            align: TextAlign.right,
                            bordor: Border.all(),
                          ),
                          HeaderCell(
                            flex: 2,
                            text: "Op(Val)",
                            fontWeight: FontWeight.bold,
                            textColor: Colors.purple,
                            align: TextAlign.right,
                            bordor: Border.all(),
                          ),
                          HeaderCell(
                            flex: 2,
                            text: "In(Qty)",
                            fontWeight: FontWeight.bold,
                            textColor: Colors.purple,
                            align: TextAlign.right,
                            bordor: Border.all(),
                          ),
                          HeaderCell(
                            flex: 2,
                            text: "In(Val)",
                            fontWeight: FontWeight.bold,
                            textColor: Colors.purple,
                            align: TextAlign.right,
                            bordor: Border.all(),
                          ),
                          HeaderCell(
                            flex: 2,
                            text: "Out(Qty)",
                            fontWeight: FontWeight.bold,
                            textColor: Colors.purple,
                            align: TextAlign.right,
                            bordor: Border.all(),
                          ),
                          HeaderCell(
                            flex: 2,
                            text: "Out(Val)",
                            fontWeight: FontWeight.bold,
                            textColor: Colors.purple,
                            align: TextAlign.right,
                            bordor: Border.all(),
                          ),
                          HeaderCell(
                            flex: 2,
                            text: "CI(Qty)",
                            fontWeight: FontWeight.bold,
                            textColor: Colors.purple,
                            align: TextAlign.right,
                            bordor: Border.all(),
                          ),
                          HeaderCell(
                            flex: 2,
                            text: "CI(Val)",
                            fontWeight: FontWeight.bold,
                            textColor: Colors.purple,
                            align: TextAlign.right,
                            bordor: Border.all(),
                          ),
                        ],
                      ),

                      Expanded(
                          child: Column(
                        children: [
                          // Opening Balance Row
                          Row(
                            children: [
                              HeaderCell(
                                flex: 4,
                                text: "Opening Balance",
                                fontWeight: FontWeight.w600,
                                bordor: Border.all(),
                              ),
                              HeaderCell(
                                flex: 2,
                                text: "",
                                bordor: Border.all(),
                              ),
                              HeaderCell(
                                flex: 2,
                                text: "",
                                bordor: Border.all(),
                              ),
                              HeaderCell(
                                flex: 2,
                                text: "",
                                align: TextAlign.right,
                                fontWeight: FontWeight.w600,
                                bordor: Border.all(),
                              ),
                              HeaderCell(
                                flex: 2,
                                text: "",
                                align: TextAlign.right,
                                fontWeight: FontWeight.w600,
                                bordor: Border.all(),
                              ),
                              HeaderCell(
                                flex: 2,
                                text: "",
                                align: TextAlign.right,
                                fontWeight: FontWeight.w600,
                                bordor: Border.all(),
                              ),
                              HeaderCell(
                                flex: 2,
                                text: "",
                                align: TextAlign.right,
                                fontWeight: FontWeight.w600,
                                bordor: Border.all(),
                              ),
                              HeaderCell(
                                flex: 2,
                                text: OpeiningQty,
                                fontWeight: FontWeight.w600,
                                align: TextAlign.right,
                                bordor: Border.all(),
                              ),
                              HeaderCell(
                                flex: 2,
                                text: OpeiningAtm,
                                fontWeight: FontWeight.w600,
                                align: TextAlign.right,
                                bordor: Border.all(),
                              ),
                            ],
                          ),

                          // Data Item Row
                          isLoading == true
                              ? Expanded(
                                  child: Center(
                                  child: Constants.loadingBar,
                                ))
                              : Expanded(
                                  child: sortedKeys.isEmpty
                                      ? const Center(
                                          child: Text("No Data Available"),
                                        )
                                      : ListView.builder(
                                          itemCount: sortedKeys.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final month = sortedKeys[index];
                                            final data = mergedData[month]!;

                                            // If this is the first entry, use the item’s initial opening balance.
                                            double opQty = index == 0
                                                ? double.parse(OpeiningQty)
                                                : 0;
                                            double opAmt = index == 0
                                                ? double.parse(OpeiningAtm)
                                                : 0;

                                            if (index > 0) {
                                              // Fetch the previous month data for opQty and opAmt
                                              final prevMonth =
                                                  sortedKeys[index - 1];
                                              final prevData =
                                                  mergedData[prevMonth]!;
                                              opQty =
                                                  prevData['closingQty'] ?? 0.0;
                                              opAmt =
                                                  prevData['closingVal'] ?? 0.0;
                                            }

                                            final inQty = data['totalQtyP'];
                                            final inVal = data['totalValP'];
                                            final outQty = data['totalQtyS'] +
                                                data['totalQtyD'];
                                            final outVal = data['totalValS'] +
                                                data['totalValD'];
                                            final clQty =
                                                opQty + inQty - outQty;
                                            final clVal =
                                                opAmt + inVal - outVal;

                                            // Update the mergedData with calculated closing balances for the month.
                                            data['closingQty'] = clQty;
                                            data['closingVal'] = clVal;

                                            return DataItemRow(
                                              particulartext: month,
                                              opText1: opQty.toString(),
                                              opText2: opAmt.toString(),
                                              inText1: inQty.toString(),
                                              inText2: inVal.toString(),
                                              outText1: outQty.toString(),
                                              outText2: outVal.toString(),
                                              ciText1: clQty.toString(),
                                              ciText2: clVal.toString(),
                                              doubleTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return StockStatusReport(
                                                        monthDate: month,
                                                        itemId: widget.itemId,
                                                        itemName:
                                                            widget.itemName,
                                                        closingStock:
                                                            clQty.toString(),
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                ),
                        ],
                      ))
                    ],
                  ),
                )),

                // Last Total Row
                Row(
                  children: [
                    HeaderCell(
                      align: TextAlign.left,
                      flex: 4,
                      text: "Total (${sortedKeys.length})",
                      fontWeight: FontWeight.w600,
                    ),
                    const HeaderCell(
                      flex: 2,
                      text: "",
                    ),
                    const HeaderCell(
                      flex: 2,
                      text: "",
                    ),
                    HeaderCell(
                      flex: 2,
                      text: "${totalInQty.toString()}",
                      align: TextAlign.right,
                      textColor: const Color.fromARGB(255, 33, 65, 243),
                      fontWeight: FontWeight.w600,
                    ),
                    HeaderCell(
                      flex: 2,
                      text: "${totalInVal.toString()}",
                      align: TextAlign.right,
                      textColor: const Color.fromARGB(255, 33, 65, 243),
                      fontWeight: FontWeight.w600,
                    ),
                    HeaderCell(
                      flex: 2,
                      text: "${totalOutQty.toString()}",
                      align: TextAlign.right,
                      textColor: const Color.fromARGB(255, 33, 65, 243),
                      fontWeight: FontWeight.w600,
                    ),
                    HeaderCell(
                      flex: 2,
                      text: "${totalOutVal.toString()}",
                      align: TextAlign.right,
                      textColor: const Color.fromARGB(255, 33, 65, 243),
                      fontWeight: FontWeight.w600,
                    ),
                    const HeaderCell(
                      flex: 2,
                      text: "",
                    ),
                    const HeaderCell(
                      flex: 2,
                      text: "",
                    ),
                  ],
                ),
              ],
            ),
          )),

          // Side Box
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomList(Skey: "F2", name: "Report", onTap: () async {}),
                  CustomList(
                    Skey: "P",
                    name: "Print",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "V",
                    name: "View",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "X",
                    name: "Export-Excel",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "D",
                    name: "Daily",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "F3",
                    name: "Find",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "F3",
                    name: "Find Next",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DataItemRow extends StatelessWidget {
  final String particulartext;
  final String opText1;
  final String opText2;
  final String inText1;
  final String inText2;
  final String outText1;
  final String outText2;
  final String ciText1;
  final String ciText2;
  final VoidCallback doubleTap;

  const DataItemRow({
    super.key,
    required this.particulartext,
    required this.opText1,
    required this.opText2,
    required this.inText1,
    required this.inText2,
    required this.outText1,
    required this.outText2,
    required this.ciText1,
    required this.ciText2,
    required this.doubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onDoubleTap: doubleTap,
        child: Row(
          children: [
            RowCell(
              flex: 4,
              text: particulartext,
              align: TextAlign.left,
              fontWeight: FontWeight.w600,
              // containercolor: isSelected ? const Color(0xFF4169E1) : null,
              // textColor: isSelected ? Colors.yellow : Colors.black,
            ),
            RowCell(
              flex: 2,
              text: opText1,
              align: TextAlign.right,
              fontWeight: FontWeight.w500,
              // containercolor: isSelected ? const Color(0xFF4169E1) : null,
              // textColor: isSelected ? Colors.white : Colors.black,
            ),
            RowCell(
              flex: 2,
              text: opText2,
              align: TextAlign.right,
              fontWeight: FontWeight.w500,
              // containercolor: isSelected ? const Color(0xFF4169E1) : null,
              // textColor: isSelected ? Colors.white : Colors.black,
            ),
            RowCell(
              flex: 2,
              text: inText1,
              align: TextAlign.right,
              fontWeight: FontWeight.w500,
              // containercolor: isSelected ? const Color(0xFF4169E1) : null,
              // textColor: isSelected ? Colors.white : Colors.black,
            ),
            RowCell(
              flex: 2,
              text: inText2,
              align: TextAlign.right,
              fontWeight: FontWeight.w500,
              // containercolor: isSelected ? const Color(0xFF4169E1) : null,
              // textColor: isSelected ? Colors.white : Colors.black,
            ),
            RowCell(
              flex: 2,
              text: outText1,
              fontWeight: FontWeight.w500,
              // containercolor: isSelected ? const Color(0xFF4169E1) : null,
              // textColor: isSelected ? Colors.white : Colors.black,
              align: TextAlign.right,
            ),
            RowCell(
              flex: 2,
              text: outText2,
              align: TextAlign.right,
              fontWeight: FontWeight.w500,
              // containercolor: isSelected ? const Color(0xFF4169E1) : null,
              // textColor: isSelected ? Colors.white : Colors.black,
            ),
            RowCell(
              flex: 2,
              text: ciText1,
              align: TextAlign.right,
              fontWeight: FontWeight.w500,
              // containercolor: isSelected ? const Color(0xFF4169E1) : null,
              // textColor: isSelected ? Colors.white : Colors.black,
            ),
            RowCell(
              flex: 2,
              text: ciText2,
              align: TextAlign.right,
              fontWeight: FontWeight.w500,
              // containercolor: isSelected ? const Color(0xFF4169E1) : null,
              // textColor: isSelected ? Colors.white : Colors.black,
            ),
          ],
        ));
  }
}
