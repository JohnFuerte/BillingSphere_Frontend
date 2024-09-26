import 'package:billingsphere/data/models/deliveryChallan/delivery_challan_model.dart';
import 'package:billingsphere/data/repository/delivery_challan_repository.dart';
import 'package:billingsphere/views/Stock_Status/stock_status_report.dart';
import 'package:flutter/material.dart';
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

class OtherScreen extends StatefulWidget {
  final String itemId;
  final String itemName;

  const OtherScreen({Key? key, required this.itemId, required this.itemName})
      : super(key: key);

  @override
  _OtherScreenState createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  Map<String, Map<String, dynamic>> monthlySales = {};
  Map<String, Map<String, dynamic>> monthlyPurchase = {};
  Map<String, Map<String, dynamic>> mergedData = {};

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

      setState(() {});

      print(mergedData);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
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
        title: const Text(
          'Stock Item Montly Summary',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 33, 65, 243),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Item: ${widget.itemName} (Monthly Summary)',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      fontSize: 18),
                ),
                const Spacer(),
                // const Text(
                //   '1/1/2023',
                //   style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       decoration: TextDecoration.underline,
                //       fontSize: 18),
                // ),
                // const Text(
                //   ' to',
                //   style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       decoration: TextDecoration.underline,
                //       fontSize: 18),
                // ),
                // const Text(
                //   '1/1/2024',
                //   style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       decoration: TextDecoration.underline,
                //       fontSize: 18),
                // ),
              ],
            ),
            const SizedBox(height: 10),
            // Display monthly sales data in a table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 750,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  color: Colors.grey[200],
                ),
                padding: const EdgeInsets.all(16),
                child: ListView.builder(
                  itemCount: sortedKeys.length +
                      2, // +2 for header and opening balance row
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // Header row
                      return Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                              255, 33, 65, 243), // Header row color
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                                child: Center(
                                    child: Text('Particulars',
                                        style:
                                            TextStyle(color: Colors.white)))),
                            Expanded(
                                child: Center(
                                    child: Text('Op(Qty)',
                                        style:
                                            TextStyle(color: Colors.white)))),
                            Expanded(
                                child: Center(
                                    child: Text('Op(Val)',
                                        style:
                                            TextStyle(color: Colors.white)))),
                            Expanded(
                                child: Center(
                                    child: Text('In(Qty)',
                                        style:
                                            TextStyle(color: Colors.white)))),
                            Expanded(
                                child: Center(
                                    child: Text('In(Val)',
                                        style:
                                            TextStyle(color: Colors.white)))),
                            Expanded(
                                child: Center(
                                    child: Text('Out(Qty)',
                                        style:
                                            TextStyle(color: Colors.white)))),
                            Expanded(
                                child: Center(
                                    child: Text('Out(Val)',
                                        style:
                                            TextStyle(color: Colors.white)))),
                            Expanded(
                                child: Center(
                                    child: Text('Cl(Qty)',
                                        style:
                                            TextStyle(color: Colors.white)))),
                            Expanded(
                                child: Center(
                                    child: Text(
                              'Cl(Val)',
                              style: TextStyle(color: Colors.white),
                            ))),
                          ],
                        ),
                      );
                    } else if (index == 1) {
                      // Opening balance row
                      return Container(
                        color: Colors.blue.shade100,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            const Expanded(
                                child: Center(child: Text('Opening Balance'))),
                            const Expanded(child: Center(child: Text(''))),
                            const Expanded(child: Center(child: Text(''))),
                            const Expanded(
                                child: Center(child: Text(''))), // In(Qty)
                            const Expanded(
                                child: Center(child: Text(''))), // In(Val)
                            const Expanded(
                                child: Center(child: Text(''))), // Out(Qty)
                            const Expanded(
                                child: Center(child: Text(''))), // Out(Val)
                            Expanded(
                                child: Center(
                                    child: Text(OpeiningQty))), // Cl(Qty)
                            Expanded(
                                child: Center(
                                    child: Text(OpeiningAtm))), // Cl(Val)
                          ],
                        ),
                      );
                    } else {
                      final month = sortedKeys[index - 2];
                      final data = mergedData[month]!;

                      double opQty;
                      double opAmt;
                      if (index == 2) {
                        opQty = double.parse(OpeiningQty);
                        opAmt = double.parse(OpeiningAtm);
                      } else {
                        final prevMonth = sortedKeys[index - 3];
                        final prevData = mergedData[prevMonth]!;
                        opQty = prevData['closingQty'];
                        opAmt = prevData['closingVal'];
                      }

                      final inQty = data['totalQtyP'];
                      final inVal = data['totalValP'];
                      final outQty = data['totalQtyS'] + data['totalQtyD'];
                      final outVal = data['totalValS'] + data['totalValD'];
                      final clQty = opQty + inQty - outQty;
                      final clVal = opAmt + inVal - outVal;

                      // Update the merged data with closing balances
                      data['closingQty'] = clQty;
                      data['closingVal'] = clVal;

                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return StockStatusReport(
                                  monthDate: month,
                                  itemId: widget.itemId,
                                  itemName: widget.itemName,
                                  closingStock: opQty.toString(),
                                );
                              },
                            ),
                          );
                        },
                        child: Container(
                          color: index % 2 == 0
                              ? Colors.white
                              : Colors.blue.shade100,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Expanded(child: Center(child: Text(month))),
                              Expanded(
                                  child: Center(child: Text(opQty.toString()))),
                              Expanded(
                                  child: Center(child: Text(opAmt.toString()))),
                              Expanded(
                                  child: Center(
                                      child:
                                          Text(inQty.toString()))), // In(Qty)
                              Expanded(
                                  child: Center(
                                      child:
                                          Text(inVal.toString()))), // In(Val)
                              Expanded(
                                  child: Center(
                                      child:
                                          Text(outQty.toString()))), // Out(Qty)
                              Expanded(
                                  child: Center(
                                      child:
                                          Text(outVal.toString()))), // Out(Val)
                              Expanded(
                                  child: Center(
                                      child:
                                          Text(clQty.toString()))), // Cl(Qty)
                              Expanded(
                                  child: Center(
                                      child:
                                          Text(clVal.toString()))), // Cl(Val)
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            Container(
              color: Colors.grey[300],
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                      child: Center(
                          child: Text('Total (${sortedKeys.length})',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)))),
                  const Expanded(child: Center(child: Text(''))), // Op(Qty)
                  const Expanded(child: Center(child: Text(''))), // Op(Val)
                  Expanded(
                      child: Center(
                          child: Text(totalInQty.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)))),
                  Expanded(
                      child: Center(
                          child: Text(totalInVal.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)))),
                  Expanded(
                      child: Center(
                          child: Text(totalOutQty.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)))),
                  Expanded(
                      child: Center(
                          child: Text(totalOutVal.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)))),
                  const Expanded(child: Center(child: Text(''))), // Cl(Qty)
                  const Expanded(child: Center(child: Text(''))), // Cl(Val)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
