import 'package:billingsphere/data/models/deliveryChallan/delivery_challan_model.dart';
import 'package:billingsphere/utils/constant.dart';
import 'package:billingsphere/views/DC_responsive/Delivery_Challan_Edit_Screen.dart';
import 'package:billingsphere/views/Stock_Status/stock_status_common.dart';
import 'package:billingsphere/views/sumit_screen/voucher%20_entry.dart/voucher_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/purchase/purchase_model.dart';
import '../../data/models/salesEntries/sales_entrires_model.dart';
import '../../data/repository/delivery_challan_repository.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/purchase_repository.dart';
import '../../data/repository/sales_enteries_repository.dart';
import '../PEresponsive/PE_edit_desktop_body.dart';
import '../SE_responsive/SalesEditScreen.dart';

// class StockStatusReport extends StatefulWidget {
//   final String monthDate;
//   final String itemId;
//   final String itemName;
//   final String closingStock;

//   const StockStatusReport({
//     Key? key,
//     required this.monthDate,
//     required this.itemId,
//     required this.itemName,
//     required this.closingStock,
//   }) : super(key: key);

//   @override
//   _StockStatusReportState createState() => _StockStatusReportState();
// }

// class _StockStatusReportState extends State<StockStatusReport> {
//   List<SalesEntry> suggestionSales = [];
//   List<Purchase> suggestionPurchase = [];
//   List<DeliveryChallan> suggestionDeliveryChallan = [];
//   SalesEntryService salesService = SalesEntryService();
//   LedgerService ledgerService = LedgerService();
//   PurchaseServices purchaseService = PurchaseServices();
//   DeliveryChallanServices deliveryChallanService = DeliveryChallanServices();

//   List<dynamic> mergedData = []; // To hold the merged sales and purchase data
//   double closingStock = 0; // Current closing stock
//   List<double> closingStocks = [];

//   // List<String>? companyCode;
//   // Future<List<String>?> getCompanyCode() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   return prefs.getStringList('companies');
//   // }

//   // Future<void> setCompanyCode() async {
//   //   List<String>? code = await getCompanyCode();
//   //   setState(() {
//   //     companyCode = code;
//   //   });
//   // }

//   int _getMonthNumber(String month) {
//     switch (month) {
//       case 'Jan':
//         return 1;
//       case 'Feb':
//         return 2;
//       case 'Mar':
//         return 3;
//       case 'Apr':
//         return 4;
//       case 'May':
//         return 5;
//       case 'Jun':
//         return 6;
//       case 'Jul':
//         return 7;
//       case 'Aug':
//         return 8;
//       case 'Sep':
//         return 9;
//       case 'Oct':
//         return 10;
//       case 'Nov':
//         return 11;
//       case 'Dec':
//         return 12;
//       default:
//         return 1;
//     }
//   }

//   Future<List<SalesEntry>> fetchSales() async {
//     final List<SalesEntry> sales = await salesService.fetchSalesEntries();
//     final List<String> monthDateParts = widget.monthDate.split('-');
//     final int selectedMonth = _getMonthNumber(monthDateParts[0]);
//     final int selectedYear = int.parse('20${monthDateParts[1]}');

//     return sales.where((salesEntry) {
//       final List<String> dateParts = salesEntry.date.split('/');
//       final int day = int.parse(dateParts[0]);
//       final int month = int.parse(dateParts[1]);
//       final int year = int.parse(dateParts[2]);
// // salesEntry.companyCode == companyCode!.first &&
//       return month == selectedMonth &&
//           year == selectedYear &&
//           salesEntry.entries.any((entry) => entry.itemName == widget.itemId);
//     }).toList();
//   }

//   Future<List<Purchase>> fetchPurchase() async {
//     final List<Purchase> purchases =
//         await purchaseService.fetchPurchaseEntries();
//     final List<String> monthDateParts = widget.monthDate.split('-');
//     final int selectedMonth = _getMonthNumber(monthDateParts[0]);
//     final int selectedYear = int.parse('20${monthDateParts[1]}');

//     return purchases.where((purchaseEntry) {
//       final List<String> dateParts = purchaseEntry.date.split('/');
//       final int day = int.parse(dateParts[0]);
//       final int month = int.parse(dateParts[1]);
//       final int year = int.parse(dateParts[2]);
// // purchaseEntry.companyCode == companyCode!.first &&
//       return month == selectedMonth &&
//           year == selectedYear &&
//           purchaseEntry.entries.any((entry) => entry.itemName == widget.itemId);
//     }).toList();
//   }

//   Future<List<DeliveryChallan>> fetchDeliveryChallan() async {
//     final List<DeliveryChallan> deliverychallan =
//         await deliveryChallanService.fetchDeliveryChallan();

//     print('Fetched Delivery Challan Entries: $deliverychallan');

//     final List<String> monthDateParts = widget.monthDate.split('-');
//     final int selectedMonth = _getMonthNumber(monthDateParts[0]);
//     final int selectedYear = int.parse('20${monthDateParts[1]}');

//     return deliverychallan.where((deliveryChallanEntry) {
//       final List<String> dateParts = deliveryChallanEntry.date.split('/');
//       final int day = int.parse(dateParts[0]);
//       final int month = int.parse(dateParts[1]);
//       final int year = int.parse(dateParts[2]);
// // deliveryChallanEntry.type == companyCode!.first &&
//       return month == selectedMonth &&
//           year == selectedYear &&
//           deliveryChallanEntry.entries
//               .any((entry) => entry.itemName == widget.itemId);
//     }).toList();
//   }

//   Future<void> fetchAndMergeData() async {
//     try {
//       final List<SalesEntry> salesEntries = await fetchSales();
//       final List<Purchase> purchaseEntries = await fetchPurchase();
//       final List<DeliveryChallan> deliveryChallanEntries =
//           await fetchDeliveryChallan();

//       // Combine sales and purchase entries
//       final List<Map<String, dynamic>> combinedEntries = [];

//       // Add a custom field to each entry to indicate its type
//       salesEntries.forEach((salesEntry) {
//         combinedEntries.add({
//           'type': 'TI',
//           'data': salesEntry,
//         });
//       });

//       purchaseEntries.forEach((purchaseEntry) {
//         combinedEntries.add({
//           'type': 'RP',
//           'data': purchaseEntry,
//         });
//       });
//       deliveryChallanEntries.forEach((deliveryChallanEntry) {
//         combinedEntries.add({
//           'type': 'DC',
//           'data': deliveryChallanEntry,
//         });
//       });
//       print('Combined Entries Before Sorting: $combinedEntries');

// // Sort combined entries by date
//       combinedEntries.sort((a, b) {
//         final DateTime dateA =
//             DateFormat('dd/MM/yyyy').parse((a['data'] is Purchase)
//                 ? (a['data'] as Purchase).date
//                 : (a['data'] is SalesEntry)
//                     ? (a['data'] as SalesEntry).date
//                     : (a['data'] as DeliveryChallan).date);
//         final DateTime dateB =
//             DateFormat('dd/MM/yyyy').parse((b['data'] is Purchase)
//                 ? (b['data'] as Purchase).date
//                 : (b['data'] is SalesEntry)
//                     ? (b['data'] as SalesEntry).date
//                     : (b['data'] as DeliveryChallan).date);
//         return dateA.compareTo(dateB);
//       });

//       setState(() {
//         mergedData = combinedEntries;
//         calculateClosingStock();
//       });

//       print('Merged Data: $mergedData');
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error fetching data: $error'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   double totalInwardQty = 0;
//   double totalInwardValue = 0;

//   double totalOutwardQty = 0;
//   double totalOutwardValue = 0;

//   void calculateClosingStock() {
//     closingStock =
//         double.parse(widget.closingStock); // Initialize with opening stock
//     closingStocks.clear(); // Clear previous closing stocks

//     for (var entry in mergedData) {
//       final isSales = entry['type'] == 'TI';
//       final isPurchase = entry['type'] == 'RP';
//       final isDeliveryChallan = entry['type'] == 'DC';
//       final data = entry['data'];

//       if (isSales) {
//         closingStock -= data.entries.isNotEmpty ? data.entries[0].qty : 0;
//         totalOutwardQty += data.entries.isNotEmpty ? data.entries[0].qty : 0;
//         totalOutwardValue +=
//             data.entries.isNotEmpty ? data.entries[0].netAmount : 0;
//       } else if (isPurchase) {
//         closingStock += data.entries.isNotEmpty ? data.entries[0].qty : 0;
//         totalInwardQty += data.entries.isNotEmpty ? data.entries[0].qty : 0;
//         totalInwardValue +=
//             data.entries.isNotEmpty ? data.entries[0].netAmount : 0;
//       } else if (isDeliveryChallan) {
//         closingStock -= data.entries.isNotEmpty ? data.entries[0].qty : 0;
//         totalOutwardQty += data.entries.isNotEmpty ? data.entries[0].qty : 0;
//         totalOutwardValue +=
//             data.entries.isNotEmpty ? data.entries[0].netAmount : 0;
//       }

//       // Store the updated closing stock after each entry
//       closingStocks.add(closingStock);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchAndMergeData();
//     // setCompanyCode();
//     print(widget.closingStock);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Stock Voucher',
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color.fromARGB(255, 33, 65, 243),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Text(
//                   'Item: ${widget.itemName}',
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       decoration: TextDecoration.underline,
//                       fontSize: 20),
//                 ),
//                 const Spacer(),
//                 // Text(
//                 //   DateTime(DateTime.now().year, DateTime.now().month, 1)
//                 //       .toString(),
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
//           ),
//           const SizedBox(height: 20),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               height: 750, // Adjust height as needed
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.grey[200],
//               ),
//               padding: const EdgeInsets.all(16),
//               child: ListView.builder(
//                 itemCount: mergedData.length + 7,
//                 itemBuilder: (context, index) {
//                   if (index == 0) {
//                     // Header row
//                     return Container(
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: const Color.fromARGB(255, 33, 65, 243),
//                         borderRadius: BorderRadius.circular(0),
//                       ),
//                       child: const Row(
//                         children: [
//                           Expanded(
//                             child: Center(
//                               child: Text(
//                                 'Date',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Center(
//                               child: Text(
//                                 'Particulars',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Center(
//                               child: Text(
//                                 'Type',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Center(
//                               child: Text(
//                                 'No',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Center(
//                               child: Text(
//                                 'Qty',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Center(
//                               child: Text(
//                                 'Rate',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Center(
//                               child: Text(
//                                 'In.Qty',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Center(
//                               child: Text(
//                                 'Value',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Center(
//                               child: Text(
//                                 'Out.Qty',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Center(
//                               child: Text(
//                                 'Value',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Center(
//                               child: Text(
//                                 'Cl.Qty',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   } else if (index == 1) {
//                     return Container(
//                       color: Colors.blue.shade100,
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       child: Row(
//                         children: [
//                           const Expanded(child: Center(child: Text(''))),
//                           const Expanded(
//                               child: Center(child: Text('Opening Balance'))),
//                           const Expanded(child: Center(child: Text(''))),
//                           const Expanded(
//                               child: Center(child: Text(''))), // In(Qty)
//                           const Expanded(
//                               child: Center(child: Text(''))), // In(Val)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Out(Qty)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Out(Val)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Cl(Qty)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Cl(Val)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Cl(Val)
//                           Expanded(
//                               child: Center(
//                                   child: Text(widget.closingStock))), // Cl(Val)
//                         ],
//                       ),
//                     );
//                   } else if (index < mergedData.length + 2) {
//                     final entry =
//                         mergedData[index - 2]; // Adjust for header row
//                     final isSales = entry['type'] == 'TI';
//                     final isPurchase = entry['type'] == 'RP';
//                     final isDeliveryChallan = entry['type'] == 'DC';
//                     final data = entry['data'];
//                     final closingStockForRow =
//                         closingStocks[index - 2]; // Adjust for header row

//                     return InkWell(
//                       onTap: () {
//                         if (isSales) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => SalesEditScreen(
//                                 salesEntryId: data.id,
//                               ),
//                             ),
//                           );
//                         } else if (isPurchase) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => PurchaseEditD(
//                                 data: data.id,
//                               ),
//                             ),
//                           );
//                         }
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: index % 2 == 0
//                               ? Colors.white
//                               : Colors.blue.shade100, // Alternating row colors
//                           borderRadius: BorderRadius.circular(0),
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 8),
//                         child: Row(
//                           children: [
//                             Expanded(
//                                 child: Center(
//                                     child: Text(data.date))), // Date value
//                             Expanded(
//                               child: Center(
//                                 child: isDeliveryChallan
//                                     ? Text('')
//                                     : FutureBuilder<Ledger?>(
//                                         future: ledgerService.fetchLedgerById(
//                                             isSales ? data.party : data.ledger),
//                                         builder: (BuildContext context,
//                                             AsyncSnapshot<Ledger?> snapshot) {
//                                           if (snapshot.connectionState ==
//                                               ConnectionState.waiting) {
//                                             // While data is being fetched
//                                             return const Text('');
//                                           } else if (snapshot.hasError) {
//                                             // If an error occurs
//                                             return Text(
//                                                 'Error: ${snapshot.error}');
//                                           } else {
//                                             // Data successfully fetched, display it
//                                             return SizedBox(
//                                               child: Text(
//                                                 snapshot.data?.name ??
//                                                     '', // Display the ledger name or empty string if data is null
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: const TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             );
//                                           }
//                                         },
//                                       ),
//                               ),
//                             ), // Particular value
//                             Expanded(
//                               child: Center(
//                                   child: Text(isSales
//                                       ? 'TI'
//                                       : isDeliveryChallan
//                                           ? 'DC'
//                                           : '')),
//                             ), // Type value
//                             Expanded(
//                                 child: Center(
//                                     child:
//                                         Text(data.no.toString()))), // No value
//                             Expanded(
//                               child: Center(
//                                 child: Text(data.entries.isNotEmpty
//                                     ? ('${data.entries[0].qty.toString()}-${data.entries[0].unit.toString()}')
//                                     : 'N/A'),
//                               ),
//                             ), // Qty value
//                             Expanded(
//                               child: Center(
//                                 child: Text(data.entries.isNotEmpty
//                                     ? data.entries[0].rate.toString()
//                                     : '0'),
//                               ),
//                             ), // Rate value
//                             Expanded(
//                               child: Center(
//                                 child: Text(isPurchase
//                                     ? (data.entries.isNotEmpty
//                                         ? data.entries[0].qty.toString()
//                                         : '0')
//                                     : '0'),
//                               ),
//                             ), // In.Qty value for now set to 0
//                             Expanded(
//                               child: Center(
//                                 child: Text(isPurchase
//                                     ? (data.entries.isNotEmpty
//                                         ? data.entries[0].netAmount.toString()
//                                         : '0')
//                                     : '0'),
//                               ),
//                             ), // Value for now set to 0
//                             Expanded(
//                               child: Center(
//                                 child: Text(
//                                   isSales
//                                       ? (data.entries.isNotEmpty
//                                           ? data.entries[0].qty.toString()
//                                           : '0')
//                                       : isDeliveryChallan
//                                           ? (data.entries.isNotEmpty
//                                               ? data.entries[0].qty.toString()
//                                               : '0')
//                                           : '0',
//                                 ),
//                               ),
//                             ), // Out.Qty value for now set to 0
//                             Expanded(
//                               child: Center(
//                                 child: Text(isSales
//                                     ? (data.entries.isNotEmpty
//                                         ? data.entries[0].netAmount.toString()
//                                         : '0')
//                                     : '0'),
//                               ),
//                             ), // Qty value for now set to entry qty
//                             Expanded(
//                               child: Center(
//                                 child: Text(closingStockForRow.toString()),
//                               ),
//                             ), // Closing Qty value for now set to 0
//                           ],
//                         ),
//                       ),
//                     );
//                   } else if (index == mergedData.length + 2) {
//                     return Container(
//                       color: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       child: const Row(
//                         children: [
//                           Expanded(child: Center(child: Text(''))),
//                           Expanded(
//                               child: Center(
//                                   child: Text('SUMMARY',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold)))),
//                           Expanded(child: Center(child: Text(''))),
//                           Expanded(child: Center(child: Text(''))), // In(Qty)
//                           Expanded(child: Center(child: Text(''))), // In(Val)
//                           Expanded(child: Center(child: Text(''))), // Out(Qty)
//                           Expanded(child: Center(child: Text(''))), // Out(Val)
//                           Expanded(child: Center(child: Text(''))), // Cl(Qty)
//                           Expanded(child: Center(child: Text(''))), // Cl(Val)
//                           Expanded(child: Center(child: Text(''))), // Cl(Val)
//                           Expanded(child: Center(child: Text(''))), // Cl(Val)
//                         ],
//                       ),
//                     );
//                   } else if (index == mergedData.length + 3) {
//                     return Container(
//                       color: Colors.blue.shade100,
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       child: Row(
//                         children: [
//                           const Expanded(child: Center(child: Text(''))),
//                           const Expanded(
//                               child: Center(
//                                   child: Text('Opening Balance',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold)))),
//                           const Expanded(child: Center(child: Text(''))),
//                           const Expanded(
//                               child: Center(child: Text(''))), // In(Qty)
//                           Expanded(
//                               child: Center(
//                                   child: Text(widget.closingStock,
//                                       style: const TextStyle(
//                                           fontWeight:
//                                               FontWeight.bold)))), // In(Val)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Out(Qty)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Out(Val)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Cl(Qty)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Cl(Val)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Cl(Val)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Cl(Val)
//                         ],
//                       ),
//                     );
//                   } else if (index == mergedData.length + 4) {
//                     return Container(
//                       color: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       child: Row(
//                         children: [
//                           const Expanded(child: Center(child: Text(''))),
//                           const Expanded(
//                               child: Center(
//                                   child: Text('Total Inward',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold)))),
//                           const Expanded(child: Center(child: Text(''))),
//                           const Expanded(
//                               child: Center(child: Text(''))), // In(Qty)
//                           Expanded(
//                               child: Center(
//                                   child: Text('$totalInwardQty',
//                                       style: const TextStyle(
//                                           fontWeight:
//                                               FontWeight.bold)))), // In(Val)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Out(Qty)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Out(Val)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Cl(Qty)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Cl(Val)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Cl(Val)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Cl(Val)
//                         ],
//                       ),
//                     );
//                   } else if (index == mergedData.length + 5) {
//                     return Container(
//                       color: Colors.blue.shade100,
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       child: Row(
//                         children: [
//                           const Expanded(child: Center(child: Text(''))),
//                           const Expanded(
//                               child: Center(
//                                   child: Text('Total Outward',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold)))),
//                           const Expanded(child: Center(child: Text(''))),
//                           const Expanded(
//                               child: Center(child: Text(''))), // In(Qty)
//                           Expanded(
//                               child: Center(
//                                   child: Text('$totalOutwardQty',
//                                       style: const TextStyle(
//                                           fontWeight:
//                                               FontWeight.bold)))), // In(Val)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Out(Qty)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Out(Val)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Cl(Qty)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Cl(Val)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Cl(Val)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Cl(Val)
//                         ],
//                       ),
//                     );
//                   } else if (index == mergedData.length + 6) {
//                     return Container(
//                       color: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       child: Row(
//                         children: [
//                           const Expanded(child: Center(child: Text(''))),
//                           const Expanded(
//                               child: Center(
//                                   child: Text('Closing Balance',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold)))),
//                           const Expanded(child: Center(child: Text(''))),
//                           const Expanded(
//                               child: Center(child: Text(''))), // In(Qty)
//                           Expanded(
//                               child: Center(
//                                   child: Text('$closingStock',
//                                       style: const TextStyle(
//                                           fontWeight:
//                                               FontWeight.bold)))), // In(Val)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Out(Qty)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Out(Val)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Cl(Qty)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Cl(Val)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Cl(Val)
//                           const Expanded(
//                               child: Center(child: Text(''))), // Cl(Val)
//                         ],
//                       ),
//                     );
//                   } else {
//                     return Container(); // Or any other default widget
//                   }
//                 },
//               ),
//             ),
//           ),
//           Container(
//             color: Colors.grey[300],
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             child: Row(
//               children: [
//                 Expanded(
//                     child: Center(
//                         child: Text('Total (${mergedData.length})',
//                             style:
//                                 const TextStyle(fontWeight: FontWeight.bold)))),
//                 const Expanded(child: Center(child: Text(''))),
//                 const Expanded(child: Center(child: Text(''))),
//                 const Expanded(
//                     child: Center(
//                         child: Text('',
//                             style: TextStyle(fontWeight: FontWeight.bold)))),
//                 const Expanded(
//                     child: Center(
//                         child: Text('',
//                             style: TextStyle(fontWeight: FontWeight.bold)))),
//                 const Expanded(
//                     child: Center(
//                         child: Text('',
//                             style: TextStyle(fontWeight: FontWeight.bold)))),
//                 Expanded(
//                     child: Center(
//                         child: Text('$totalInwardQty',
//                             style:
//                                 const TextStyle(fontWeight: FontWeight.bold)))),
//                 Expanded(
//                     child: Center(
//                         child: Text('$totalInwardValue',
//                             style:
//                                 const TextStyle(fontWeight: FontWeight.bold)))),
//                 Expanded(
//                     child: Center(
//                         child: Text('$totalOutwardQty',
//                             style:
//                                 const TextStyle(fontWeight: FontWeight.bold)))),
//                 Expanded(
//                     child: Center(
//                         child: Text('$totalOutwardValue',
//                             style:
//                                 const TextStyle(fontWeight: FontWeight.bold)))),
//                 const Expanded(child: Center(child: Text(''))),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class StockStatusReport extends StatefulWidget {
  final String monthDate;
  final String itemId;
  final String itemName;
  final String closingStock;
  const StockStatusReport(
      {super.key,
      required this.monthDate,
      required this.itemId,
      required this.itemName,
      required this.closingStock});

  @override
  State<StockStatusReport> createState() => _StockStatusReportState();
}

class _StockStatusReportState extends State<StockStatusReport> {
  List<SalesEntry> suggestionSales = [];
  List<Purchase> suggestionPurchase = [];
  List<DeliveryChallan> suggestionDeliveryChallan = [];
  SalesEntryService salesService = SalesEntryService();
  LedgerService ledgerService = LedgerService();
  PurchaseServices purchaseService = PurchaseServices();
  DeliveryChallanServices deliveryChallanService = DeliveryChallanServices();
  bool isLoading = false;

  List<dynamic> mergedData = []; // To hold the merged sales and purchase data
  double closingStock = 0; // Current closing stock
  List<double> closingStocks = [];

  // List<String>? companyCode;
  // Future<List<String>?> getCompanyCode() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getStringList('companies');
  // }

  // Future<void> setCompanyCode() async {
  //   List<String>? code = await getCompanyCode();
  //   setState(() {
  //     companyCode = code;
  //   });
  // }

  int _getMonthNumber(String month) {
    switch (month) {
      case 'Jan':
        return 1;
      case 'Feb':
        return 2;
      case 'Mar':
        return 3;
      case 'Apr':
        return 4;
      case 'May':
        return 5;
      case 'Jun':
        return 6;
      case 'Jul':
        return 7;
      case 'Aug':
        return 8;
      case 'Sep':
        return 9;
      case 'Oct':
        return 10;
      case 'Nov':
        return 11;
      case 'Dec':
        return 12;
      default:
        return 1;
    }
  }

  Future<List<SalesEntry>> fetchSales() async {
    final List<SalesEntry> sales = await salesService.fetchSalesEntries();
    final List<String> monthDateParts = widget.monthDate.split('-');
    final int selectedMonth = _getMonthNumber(monthDateParts[0]);
    final int selectedYear = int.parse('20${monthDateParts[1]}');

    return sales.where((salesEntry) {
      final List<String> dateParts = salesEntry.date.split('/');
      final int day = int.parse(dateParts[0]);
      final int month = int.parse(dateParts[1]);
      final int year = int.parse(dateParts[2]);
// salesEntry.companyCode == companyCode!.first &&
      return month == selectedMonth &&
          year == selectedYear &&
          salesEntry.entries.any((entry) => entry.itemName == widget.itemId);
    }).toList();
  }

  Future<List<Purchase>> fetchPurchase() async {
    final List<Purchase> purchases =
        await purchaseService.fetchPurchaseEntries();
    final List<String> monthDateParts = widget.monthDate.split('-');
    final int selectedMonth = _getMonthNumber(monthDateParts[0]);
    final int selectedYear = int.parse('20${monthDateParts[1]}');

    return purchases.where((purchaseEntry) {
      final List<String> dateParts = purchaseEntry.date.split('/');
      final int day = int.parse(dateParts[0]);
      final int month = int.parse(dateParts[1]);
      final int year = int.parse(dateParts[2]);
// purchaseEntry.companyCode == companyCode!.first &&
      return month == selectedMonth &&
          year == selectedYear &&
          purchaseEntry.entries.any((entry) => entry.itemName == widget.itemId);
    }).toList();
  }

  Future<List<DeliveryChallan>> fetchDeliveryChallan() async {
    final List<DeliveryChallan> deliverychallan =
        await deliveryChallanService.fetchDeliveryChallan();

    print('Fetched Delivery Challan Entries: $deliverychallan');

    final List<String> monthDateParts = widget.monthDate.split('-');
    final int selectedMonth = _getMonthNumber(monthDateParts[0]);
    final int selectedYear = int.parse('20${monthDateParts[1]}');

    return deliverychallan.where((deliveryChallanEntry) {
      final List<String> dateParts = deliveryChallanEntry.date.split('/');
      final int day = int.parse(dateParts[0]);
      final int month = int.parse(dateParts[1]);
      final int year = int.parse(dateParts[2]);
// deliveryChallanEntry.type == companyCode!.first &&
      return month == selectedMonth &&
          year == selectedYear &&
          deliveryChallanEntry.entries
              .any((entry) => entry.itemName == widget.itemId);
    }).toList();
  }

  Future<void> fetchAndMergeData() async {
    try {
      setState(() {
        isLoading = true;
      });

      final List<SalesEntry> salesEntries = await fetchSales();
      final List<Purchase> purchaseEntries = await fetchPurchase();
      final List<DeliveryChallan> deliveryChallanEntries =
          await fetchDeliveryChallan();

      // Combine sales and purchase entries
      final List<Map<String, dynamic>> combinedEntries = [];

      // Add a custom field to each entry to indicate its type
      salesEntries.forEach((salesEntry) {
        combinedEntries.add({
          'type': 'TI',
          'data': salesEntry,
        });
      });

      purchaseEntries.forEach((purchaseEntry) {
        combinedEntries.add({
          'type': 'RP',
          'data': purchaseEntry,
        });
      });
      deliveryChallanEntries.forEach((deliveryChallanEntry) {
        combinedEntries.add({
          'type': 'DC',
          'data': deliveryChallanEntry,
        });
      });
      print('Combined Entries Before Sorting: $combinedEntries');

// Sort combined entries by date
      combinedEntries.sort((a, b) {
        final DateTime dateA =
            DateFormat('dd/MM/yyyy').parse((a['data'] is Purchase)
                ? (a['data'] as Purchase).date
                : (a['data'] is SalesEntry)
                    ? (a['data'] as SalesEntry).date
                    : (a['data'] as DeliveryChallan).date);
        final DateTime dateB =
            DateFormat('dd/MM/yyyy').parse((b['data'] is Purchase)
                ? (b['data'] as Purchase).date
                : (b['data'] is SalesEntry)
                    ? (b['data'] as SalesEntry).date
                    : (b['data'] as DeliveryChallan).date);
        return dateA.compareTo(dateB);
      });

      setState(() {
        mergedData = combinedEntries;
        calculateClosingStock();
        isLoading = false;
      });

      print('Merged Data: $mergedData');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching data: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  double totalInwardQty = 0;
  double totalInwardValue = 0;

  double totalOutwardQty = 0;
  double totalOutwardValue = 0;

  void calculateClosingStock() {
    closingStock =
        double.parse(widget.closingStock); // Initialize with opening stock
    closingStocks.clear(); // Clear previous closing stocks

    for (var entry in mergedData) {
      final isSales = entry['type'] == 'TI';
      final isPurchase = entry['type'] == 'RP';
      final isDeliveryChallan = entry['type'] == 'DC';
      final data = entry['data'];

      if (isSales) {
        closingStock -= data.entries.isNotEmpty ? data.entries[0].qty : 0;
        totalOutwardQty += data.entries.isNotEmpty ? data.entries[0].qty : 0;
        totalOutwardValue +=
            data.entries.isNotEmpty ? data.entries[0].netAmount : 0;
      } else if (isPurchase) {
        closingStock += data.entries.isNotEmpty ? data.entries[0].qty : 0;
        totalInwardQty += data.entries.isNotEmpty ? data.entries[0].qty : 0;
        totalInwardValue +=
            data.entries.isNotEmpty ? data.entries[0].netAmount : 0;
      } else if (isDeliveryChallan) {
        closingStock -= data.entries.isNotEmpty ? data.entries[0].qty : 0;
        totalOutwardQty += data.entries.isNotEmpty ? data.entries[0].qty : 0;
        totalOutwardValue +=
            data.entries.isNotEmpty ? data.entries[0].netAmount : 0;
      }

      // Store the updated closing stock after each entry
      closingStocks.add(closingStock);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAndMergeData();
    // setCompanyCode();
    print(widget.closingStock);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Stock Vouchers",
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
                      'Stock Item: ${widget.itemName}',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700, fontSize: 17),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: Column(
                      children: [
                        // Header Row
                        Row(
                          children: [
                            HeaderCell(
                              flex: 2,
                              text: "Date",
                              fontWeight: FontWeight.bold,
                              bordor: Border.all(),
                              textColor: Colors.purple,
                              align: TextAlign.center,
                            ),
                            HeaderCell(
                              flex: 4,
                              text: "Particulars",
                              fontWeight: FontWeight.bold,
                              bordor: Border.all(),
                              textColor: Colors.purple,
                            ),
                            HeaderCell(
                              flex: 2,
                              text: "Type",
                              fontWeight: FontWeight.bold,
                              textColor: Colors.purple,
                              align: TextAlign.center,
                              bordor: Border.all(),
                            ),
                            HeaderCell(
                              flex: 2,
                              text: "No.",
                              fontWeight: FontWeight.bold,
                              textColor: Colors.purple,
                              align: TextAlign.center,
                              bordor: Border.all(),
                            ),
                            HeaderCell(
                              flex: 2,
                              text: "Qty",
                              fontWeight: FontWeight.bold,
                              textColor: Colors.purple,
                              align: TextAlign.center,
                              bordor: Border.all(),
                            ),
                            HeaderCell(
                              flex: 2,
                              text: "Rate",
                              fontWeight: FontWeight.bold,
                              textColor: Colors.purple,
                              align: TextAlign.center,
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
                              text: "Value",
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
                              text: "Value",
                              fontWeight: FontWeight.bold,
                              textColor: Colors.purple,
                              align: TextAlign.right,
                              bordor: Border.all(),
                            ),
                            HeaderCell(
                              flex: 2,
                              text: "Cl.Qty",
                              fontWeight: FontWeight.bold,
                              textColor: Colors.purple,
                              align: TextAlign.right,
                              bordor: Border.all(),
                            ),
                          ],
                        ),

                        isLoading == true
                            ? Expanded(
                                child: Center(
                                  child: Constants.loadingBar,
                                ),
                              )
                            : Expanded(
                                child: SingleChildScrollView(
                                    child: Column(
                                children: [
                                  // Opening balance row - 1
                                  Row(
                                    children: [
                                      HeaderCell(
                                        flex: 2,
                                        text: "",
                                        bordor: Border.all(),
                                      ),
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
                                        text: widget.closingStock,
                                        fontWeight: FontWeight.w600,
                                        align: TextAlign.right,
                                        bordor: Border.all(),
                                      ),
                                    ],
                                  ),

                                  // Data Item Row

                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: mergedData.length,
                                    itemBuilder: (context, index) {
                                      final entry = mergedData[index];
                                      final isSales = entry['type'] == 'TI';
                                      final isPurchase = entry['type'] == 'RP';
                                      final isDeliveryChallan =
                                          entry['type'] == 'DC';
                                      final data = entry['data'];
                                      final closingStockForRow =
                                          closingStocks[index];
                                      return DataItemRowDate(
                                        date: data.date,
                                        particular: isDeliveryChallan
                                            ? const Text('')
                                            : FutureBuilder<Ledger?>(
                                                future: ledgerService
                                                    .fetchLedgerById(isSales
                                                        ? data.party
                                                        : data.ledger),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<Ledger?>
                                                        snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Text('');
                                                  } else if (snapshot
                                                      .hasError) {
                                                    // If an error occurs
                                                    return Text(
                                                        'Error: ${snapshot.error}');
                                                  } else {
                                                    // Data successfully fetched, display it
                                                    return SizedBox(
                                                      child: Text(
                                                        snapshot.data?.name ??
                                                            '',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                        type: isSales
                                            ? 'TI'
                                            : isPurchase
                                                ? 'TP'
                                                : isDeliveryChallan
                                                    ? 'DC'
                                                    : '',
                                        no: data.no.toString(),
                                        qty: data.entries.isNotEmpty
                                            ? ('${data.entries[0].qty.toString()}-${data.entries[0].unit.toString()}')
                                            : 'N/A',
                                        rate: data.entries.isNotEmpty
                                            ? data.entries[0].rate.toString()
                                            : '0',
                                        qtyIn: isPurchase
                                            ? (data.entries.isNotEmpty
                                                ? data.entries[0].qty.toString()
                                                : '0')
                                            : '0',
                                        valueIn: isPurchase
                                            ? (data.entries.isNotEmpty
                                                ? data.entries[0].netAmount
                                                    .toString()
                                                : '0')
                                            : '0',
                                        qtyOut: isSales
                                            ? (data.entries.isNotEmpty
                                                ? data.entries[0].qty.toString()
                                                : '0')
                                            : isDeliveryChallan
                                                ? (data.entries.isNotEmpty
                                                    ? data.entries[0].qty
                                                        .toString()
                                                    : '0')
                                                : '0',
                                        valueOut: isSales
                                            ? (data.entries.isNotEmpty
                                                ? data.entries[0].netAmount
                                                    .toString()
                                                : '0')
                                            : '0',
                                        qtyCl: closingStockForRow.toString(),
                                        onTap: () {
                                          if (isSales) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SalesEditScreen(
                                                  salesEntryId: data,
                                                ),
                                              ),
                                            );
                                          } else if (isPurchase) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PurchaseEditD(
                                                  data: data.id,
                                                ),
                                              ),
                                            );
                                          } else if (isDeliveryChallan) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DeliveryChallanEditScreen(
                                                          deliveryChallan: data,
                                                          deliveryChallans: const [],
                                                        )));
                                          }
                                        },
                                      );
                                    },
                                  ),

                                  // Empty Row
                                  const CustomDataWidget(text1: "", text2: ""),

                                  // Summary Row
                                  const CustomDataWidget(
                                      text1: "S  U  M  M  A  R  Y", text2: ""),

                                  // Opening Balance Row - 2
                                  CustomDataWidget(
                                      text1: "Opening Balance",
                                      text2: widget.closingStock),

                                  //Total Inward Row
                                  CustomDataWidget(
                                      text1: "Total Inward",
                                      text2: "$totalInwardQty"),

                                  //Total Outward Row
                                  CustomDataWidget(
                                      text1: "Total Outward",
                                      text2: "$totalOutwardQty"),

                                  //Closing Balnce Row
                                  CustomDataWidget(
                                      text1: "Closing Balance",
                                      text2: "$closingStock"),
                                ],
                              )))
                      ],
                    ),
                  ),
                ),

                // Last Total Row
                Row(
                  children: [
                    const HeaderCell(
                      flex: 1,
                      text: "",
                    ),
                    HeaderCell(
                      align: TextAlign.left,
                      flex: 4,
                      text: "Total (${mergedData.length})",
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
                      text: "$totalInwardQty.00",
                      align: TextAlign.right,
                      textColor: const Color.fromARGB(255, 33, 65, 243),
                      fontWeight: FontWeight.w600,
                    ),
                    HeaderCell(
                      flex: 2,
                      text: "$totalInwardValue.00",
                      align: TextAlign.right,
                      textColor: const Color.fromARGB(255, 33, 65, 243),
                      fontWeight: FontWeight.w600,
                    ),
                    HeaderCell(
                      flex: 2,
                      text: "$totalOutwardQty.00",
                      align: TextAlign.right,
                      textColor: const Color.fromARGB(255, 33, 65, 243),
                      fontWeight: FontWeight.w600,
                    ),
                    HeaderCell(
                      flex: 2,
                      text: "$totalOutwardValue.00",
                      align: TextAlign.right,
                      textColor: const Color.fromARGB(255, 33, 65, 243),
                      fontWeight: FontWeight.w600,
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

class DataItemRowDate extends StatelessWidget {
  final String date;
  final Widget particular;
  final String type;
  final String no;
  final String qty;
  final String rate;
  final String qtyIn;
  final String valueIn;
  final String qtyOut;
  final String valueOut;
  final String qtyCl;
  final VoidCallback onTap;

  const DataItemRowDate(
      {super.key,
      required this.date,
      required this.particular,
      required this.type,
      required this.no,
      required this.qty,
      required this.rate,
      required this.qtyIn,
      required this.valueIn,
      required this.qtyOut,
      required this.valueOut,
      required this.qtyCl,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Row(
          children: [
            RowCell(
              flex: 2,
              text: date,
              align: TextAlign.center,
              fontWeight: FontWeight.w600,
              // containercolor: isSelected ? const Color(0xFF4169E1) : null,
              // textColor: isSelected ? Colors.yellow : Colors.black,
            ),
            RowCell(
              flex: 4,
              child: particular,
              // containercolor: isSelected ? const Color(0xFF4169E1) : null,
              // textColor: isSelected ? Colors.white : Colors.black,
            ),
            RowCell(
              flex: 2,
              text: type,
              align: TextAlign.center,
              fontWeight: FontWeight.w500,
              // containercolor: isSelected ? const Color(0xFF4169E1) : null,
              // textColor: isSelected ? Colors.white : Colors.black,
            ),
            RowCell(
              flex: 2,
              text: no,
              align: TextAlign.center,
              fontWeight: FontWeight.w500,

              // containercolor: isSelected ? const Color(0xFF4169E1) : null,
              // textColor: isSelected ? Colors.white : Colors.black,
            ),
            RowCell(
              flex: 2,
              text: qty,
              align: TextAlign.center,
              fontWeight: FontWeight.w500,
              // containercolor: isSelected ? const Color(0xFF4169E1) : null,
              // textColor: isSelected ? Colors.white : Colors.black,
            ),
            RowCell(
              flex: 2,
              text: rate,
              fontWeight: FontWeight.w500,
              // containercolor: isSelected ? const Color(0xFF4169E1) : null,
              // textColor: isSelected ? Colors.white : Colors.black,
              align: TextAlign.center,
            ),
            RowCell(
              flex: 2,
              text: qtyIn,
              align: TextAlign.right,
              fontWeight: FontWeight.w500,
              // containercolor: isSelected ? const Color(0xFF4169E1) : null,
              // textColor: isSelected ? Colors.white : Colors.black,
            ),
            RowCell(
              flex: 2,
              text: valueIn,
              align: TextAlign.right,
              fontWeight: FontWeight.w500,
              // containercolor: isSelected ? const Color(0xFF4169E1) : null,
              // textColor: isSelected ? Colors.white : Colors.black,
            ),
            RowCell(
              flex: 2,
              text: qtyOut,
              align: TextAlign.right,
              fontWeight: FontWeight.w500,
              // containercolor: isSelected ? const Color(0xFF4169E1) : null,
              // textColor: isSelected ? Colors.white : Colors.black,
            ),
            RowCell(
              flex: 2,
              text: qtyOut,
              align: TextAlign.right,
              fontWeight: FontWeight.w500,
              // containercolor: isSelected ? const Color(0xFF4169E1) : null,
              // textColor: isSelected ? Colors.white : Colors.black,
            ),
            RowCell(
              flex: 2,
              text: qtyCl,
              align: TextAlign.right,
              fontWeight: FontWeight.w500,
              // containercolor: isSelected ? const Color(0xFF4169E1) : null,
              // textColor: isSelected ? Colors.white : Colors.black,
            ),
          ],
        ));
  }
}

class CustomDataWidget extends StatelessWidget {
  final String text1;
  final String text2;
  const CustomDataWidget({super.key, required this.text1, required this.text2});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HeaderCell(
          flex: 2,
          text: "",
          bordor: Border.all(),
        ),
        HeaderCell(
          flex: 4,
          text: text1,
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
          text: text2,
          fontWeight: FontWeight.w600,
          align: TextAlign.center,
          textColor: const Color.fromARGB(255, 33, 65, 243),
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
          bordor: Border.all(),
        ),
      ],
    );
  }
}
