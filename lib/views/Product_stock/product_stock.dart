import 'package:billingsphere/data/models/item/item_model.dart';
import 'package:billingsphere/data/models/itemGroup/item_group_model.dart';
import 'package:billingsphere/data/models/purchase/purchase_model.dart';
import 'package:billingsphere/data/repository/item_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../data/repository/item_group_repository.dart';
import '../../data/repository/purchase_repository.dart';

class ProductStock extends StatefulWidget {
  const ProductStock({super.key});

  @override
  State<ProductStock> createState() => _ProductStockState();
}

class _ProductStockState extends State<ProductStock> {
  final ItemsGroupService itemsGroupService = ItemsGroupService();
  final PurchaseServices purchaseService = PurchaseServices();
  final ItemsService itemsService = ItemsService();
  List<ItemsGroup> categories = [];
  List<Purchase> purchase = [];
  String? selectedId;
  bool isLoading = false;

  Future<void> fetchCategories() async {
    setState(() {
      isLoading = true;
    });
    categories = await itemsGroupService.fetchItemGroups();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchPurchase() async {
    setState(() {
      isLoading = true;
    });
    purchase = await purchaseService.getPurchase();

    for (var i = 0; i < categories.length; i++) {
      String catid = categories[i].id;
      for (var j = 0; j < purchase.length; j++) {
        for (var entry in purchase[j].entries) {
          String itemName = entry.itemName;
          Item? singleItem = await itemsService.fetchItemById(itemName);
          if (singleItem != null && catid == singleItem.itemGroup) {}
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  void fetchAll() async {
    await fetchCategories();
    await fetchPurchase();
  }

  @override
  void initState() {
    super.initState();
    fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('PRODUCT STOCK'),
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              centerTitle: true,
            ),
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 15, left: 10, top: 10),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.88,
                          width: MediaQuery.of(context).size.width * 0.88,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.blue, width: 1),
                          ),
                          child: SingleChildScrollView(
                              // child: Table(
                              //   border: TableBorder.all(
                              //       width: 1, color: Colors.white),
                              //   columnWidths: const {
                              //     0: FlexColumnWidth(3),
                              //     1: FlexColumnWidth(1),
                              //     2: FlexColumnWidth(5),
                              //     3: FlexColumnWidth(2),
                              //     4: FlexColumnWidth(2),
                              //     5: FlexColumnWidth(2),
                              //     6: FlexColumnWidth(2),
                              //     7: FlexColumnWidth(2),
                              //     8: FlexColumnWidth(2),
                              //     9: FlexColumnWidth(2),
                              //   },
                              //   children: [
                              //     TableRow(
                              //       children: [
                              //         Container(
                              //           height: 30,
                              //           color: Colors.blue,
                              //           child: const TableCell(
                              //               child: Text(
                              //             "Select",
                              //             textAlign: TextAlign.center,
                              //             style: TextStyle(
                              //                 color: Colors.white, fontSize: 20),
                              //           )),
                              //         ),
                              //         Container(
                              //           height: 30,
                              //           color: Colors.blue,
                              //           child: const TableCell(
                              //               child: Text(
                              //             "Sr",
                              //             textAlign: TextAlign.center,
                              //             style: TextStyle(
                              //                 color: Colors.white, fontSize: 20),
                              //           )),
                              //         ),
                              //         Container(
                              //           color: Colors.blue,
                              //           height: 30,
                              //           child: const TableCell(
                              //               child: Text(
                              //             "Particulars",
                              //             textAlign: TextAlign.center,
                              //             style: TextStyle(
                              //                 color: Colors.white, fontSize: 20),
                              //           )),
                              //         ),
                              //         Container(
                              //           color: Colors.blue,
                              //           height: 30,
                              //           child: const TableCell(
                              //               child: Text(
                              //             "Min Qty",
                              //             textAlign: TextAlign.center,
                              //             style: TextStyle(
                              //                 color: Colors.white, fontSize: 20),
                              //           )),
                              //         ),
                              //         Container(
                              //           color: Colors.blue,
                              //           height: 30,
                              //           child: const TableCell(
                              //               child: Text(
                              //             "Stock",
                              //             textAlign: TextAlign.center,
                              //             style: TextStyle(
                              //                 color: Colors.white, fontSize: 20),
                              //           )),
                              //         ),
                              //         Container(
                              //           color: Colors.blue,
                              //           height: 30,
                              //           child: const TableCell(
                              //               child: Text(
                              //             "Qty",
                              //             textAlign: TextAlign.center,
                              //             style: TextStyle(
                              //                 color: Colors.white, fontSize: 20),
                              //           )),
                              //         ),
                              //         Container(
                              //           color: Colors.blue,
                              //           height: 30,
                              //           child: const TableCell(
                              //               child: Text(
                              //             "Unit",
                              //             textAlign: TextAlign.center,
                              //             style: TextStyle(
                              //                 color: Colors.white, fontSize: 20),
                              //           )),
                              //         ),
                              //         Container(
                              //           color: Colors.blue,
                              //           height: 30,
                              //           child: const TableCell(
                              //               child: Text(
                              //             "Rate",
                              //             textAlign: TextAlign.center,
                              //             style: TextStyle(
                              //                 color: Colors.white, fontSize: 20),
                              //           )),
                              //         ),
                              //         Container(
                              //           color: Colors.blue,
                              //           height: 30,
                              //           child: const TableCell(
                              //               child: Text(
                              //             "Sub Total",
                              //             textAlign: TextAlign.center,
                              //             style: TextStyle(
                              //                 color: Colors.white, fontSize: 20),
                              //           )),
                              //         ),
                              //         Container(
                              //           color: Colors.blue,
                              //           height: 30,
                              //           child: const TableCell(
                              //               child: Text(
                              //             "Total",
                              //             textAlign: TextAlign.center,
                              //             style: TextStyle(
                              //                 color: Colors.white, fontSize: 20),
                              //           )),
                              //         ),
                              //       ],
                              //     ),
                              //     for (int i = 0; i < categories.length; i++) ...[
                              //       TableRow(
                              //         children: [
                              //           // Widgets for category details
                              //           TableCell(
                              //             child: Padding(
                              //               padding: const EdgeInsets.all(8.0),
                              //               child: Text(
                              //                 categories[i].name,
                              //                 style: GoogleFonts.roboto(
                              //                   fontSize: 15,
                              //                   fontWeight: FontWeight.w500,
                              //                   color: Colors.black,
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //           // Placeholder cells for other category details
                              //           const TableCell(
                              //             child: SizedBox(),
                              //           ), // Min Qty
                              //           const TableCell(
                              //             child: SizedBox(),
                              //           ), // Stock
                              //           const TableCell(
                              //             child: SizedBox(),
                              //           ), // Qty
                              //           const TableCell(
                              //             child: SizedBox(),
                              //           ), // Unit
                              //           const TableCell(
                              //             child: SizedBox(),
                              //           ), // Rate
                              //           const TableCell(
                              //             child: SizedBox(),
                              //           ), // Sub Total
                              //           const TableCell(
                              //             child: SizedBox(),
                              //           ), // Sub Total
                              //           const TableCell(
                              //             child: SizedBox(),
                              //           ), // Total
                              //         ],
                              //       ),
                              //       for (int j = 0; j < purchase.length; j++) ...[
                              //         TableRow(children: [
                              //           FutureBuilder(
                              //             future: itemsService.fetchItemById(
                              //                 purchase[j].entries.first.itemName),
                              //             builder: (context, snapshot) {
                              //               if (snapshot.connectionState ==
                              //                   ConnectionState.done) {
                              //                 final item = snapshot.data;
                              //                 final categoryId = categories[i].id;
                              //                 final itemId =
                              //                     item?.itemGroup ?? '';

                              //                 if (itemId == categoryId) {
                              //                   return TableRow(
                              //                     children: [
                              //                       GestureDetector(
                              //                         onTap: () {
                              //                           setState(() {
                              //                             selectedId =
                              //                                 purchase[j].id;
                              //                           });
                              //                         },
                              //                         child: TableCell(
                              //                           child: Radio<String>(
                              //                             activeColor:
                              //                                 Colors.blue,
                              //                             value: purchase[j].id,
                              //                             groupValue: selectedId,
                              //                             onChanged:
                              //                                 (String? value) {
                              //                               setState(() {
                              //                                 selectedId = value;
                              //                               });
                              //                               print(
                              //                                   'Selected ID: $value');
                              //                             },
                              //                           ),
                              //                         ),
                              //                       ),
                              //                       TableCell(
                              //                         child: Padding(
                              //                           padding:
                              //                               const EdgeInsets.all(
                              //                                   8.0),
                              //                           child: Text(
                              //                             '${j + 1}',
                              //                             textAlign:
                              //                                 TextAlign.center,
                              //                           ),
                              //                         ),
                              //                       ),
                              //                       TableCell(
                              //                         child: Padding(
                              //                           padding:
                              //                               const EdgeInsets.all(
                              //                                   8.0),
                              //                           child: Text(
                              //                             purchase[j].billNumber,
                              //                             textAlign:
                              //                                 TextAlign.center,
                              //                           ),
                              //                         ),
                              //                       ),
                              //                       const TableCell(
                              //                         child: Padding(
                              //                           padding:
                              //                               EdgeInsets.all(8.0),
                              //                           child: Text(
                              //                             '0',
                              //                             textAlign:
                              //                                 TextAlign.center,
                              //                           ),
                              //                         ),
                              //                       ),
                              //                       TableCell(
                              //                         child: Padding(
                              //                           padding:
                              //                               const EdgeInsets.all(
                              //                                   8.0),
                              //                           child: Text(
                              //                             purchase[j]
                              //                                 .billNumber
                              //                                 .toString(),
                              //                             textAlign:
                              //                                 TextAlign.center,
                              //                           ),
                              //                         ),
                              //                       ),
                              //                       TableCell(
                              //                         child: Padding(
                              //                           padding:
                              //                               const EdgeInsets.all(
                              //                                   8.0),
                              //                           child: Text(
                              //                             purchase[j]
                              //                                 .billNumber
                              //                                 .toString(),
                              //                             textAlign:
                              //                                 TextAlign.center,
                              //                           ),
                              //                         ),
                              //                       ),
                              //                       TableCell(
                              //                         child: Padding(
                              //                           padding:
                              //                               const EdgeInsets.all(
                              //                                   8.0),
                              //                           child: Text(
                              //                             purchase[j]
                              //                                 .billNumber
                              //                                 .toString(),
                              //                             textAlign:
                              //                                 TextAlign.center,
                              //                           ),
                              //                         ),
                              //                       ),
                              //                       TableCell(
                              //                         child: Padding(
                              //                           padding:
                              //                               const EdgeInsets.all(
                              //                                   8.0),
                              //                           child: Text(
                              //                             purchase[j]
                              //                                 .billNumber
                              //                                 .toString(),
                              //                             textAlign:
                              //                                 TextAlign.center,
                              //                           ),
                              //                         ),
                              //                       ),
                              //                       TableCell(
                              //                         child: Padding(
                              //                           padding:
                              //                               const EdgeInsets.all(
                              //                                   8.0),
                              //                           child: Text(
                              //                             purchase[j]
                              //                                 .billNumber
                              //                                 .toString(),
                              //                             textAlign:
                              //                                 TextAlign.center,
                              //                           ),
                              //                         ),
                              //                       ),
                              //                       TableCell(
                              //                         child: Padding(
                              //                           padding:
                              //                               const EdgeInsets.all(
                              //                                   8.0),
                              //                           child: Text(
                              //                             purchase[j]
                              //                                 .billNumber
                              //                                 .toString(),
                              //                             textAlign:
                              //                                 TextAlign.center,
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     ],
                              //                   );
                              //                 }
                              //               }
                              //               return const SizedBox(); // Return an empty SizedBox if category doesn't match
                              //             },
                              //           ),
                              //         ]),
                              //       ],
                              //     ],
                              //   ],
                              // ),

                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.88,
                //   width: MediaQuery.of(context).size.width * 0.1,
                //   child: SingleChildScrollView(
                //     child: Column(
                //       children: [
                //         List1(
                //           name: "New",
                //           onPressed: () {
                //             // Navigator.of(context).push(
                //             //   MaterialPageRoute(
                //             //     builder: (context) => const LGHomePage(),
                //             //   ),
                //             // );
                //           },
                //         ),
                //         List1(
                //           name: "Edit",
                //           onPressed: () {
                //             // Navigator.of(context).push(
                //             //   MaterialPageRoute(
                //             //     builder: (context) => LGUpdateEntry(
                //             //       id: selectedId!,
                //             //     ),
                //             //   ),
                //             // );
                //           },
                //         ),
                //         List1(
                //           onPressed: () {
                //             print('Edit button pressed');
                //           },
                //         ),
                //         List1(
                //           name: "Delete",
                //           onPressed: () {
                //             showCupertinoDialog(
                //                 context: context,
                //                 builder: (context) {
                //                   return CupertinoAlertDialog(
                //                     title: const Text('Delete'),
                //                     content: const Text(
                //                         'Are you sure you want to delete this entry?'),
                //                     actions: [
                //                       CupertinoDialogAction(
                //                         child: const Text('Yes'),
                //                         onPressed: () {
                //                           // ledgerService.deleteLedger(
                //                           //     selectedId!, context);

                //                           Navigator.of(context).pop();
                //                         },
                //                       ),
                //                       CupertinoDialogAction(
                //                         child: const Text('No',
                //                             style:
                //                                 TextStyle(color: Colors.red)),
                //                         onPressed: () {
                //                           Navigator.of(context).pop();
                //                         },
                //                       ),
                //                     ],
                //                   );
                //                 });
                //           },
                //         ),
                //         List1(
                //           name: "Export Excel",
                //           onPressed: () {
                //             print('Edit button pressed');
                //           },
                //         ),
                //         List1(
                //           name: "Bulk Upload",
                //           onPressed: () {
                //             print('Edit button pressed');
                //           },
                //         ),
                //         List1(
                //           onPressed: () {
                //             print('Edit button pressed');
                //           },
                //         ),
                //         List1(
                //           onPressed: () {
                //             print('Edit button pressed');
                //           },
                //         ),
                //         List1(
                //           name: "Filters",
                //           onPressed: () {
                //             print('Edit button pressed');
                //           },
                //         ),
                //         List1(
                //           onPressed: () {
                //             print('Edit button pressed');
                //           },
                //         ),
                //         List1(
                //           onPressed: () {
                //             print('Edit button pressed');
                //           },
                //         ),
                //         List1(
                //           name: "Label Printing",
                //           onPressed: () {
                //             print('Edit button pressed');
                //           },
                //         ),
                //         List1(
                //           name: "Envelope Printing",
                //           onPressed: () {
                //             print('Edit button pressed');
                //           },
                //         ),
                //         List1(
                //           name: "Envelope",
                //           onPressed: () {
                //             print('Edit button pressed');
                //           },
                //         ),
                //         List1(
                //           onPressed: () {
                //             print('Edit button pressed');
                //           },
                //         ),
                //         List1(
                //           name: "Opening Balance",
                //           onPressed: () {
                //             print('Edit button pressed');
                //           },
                //         ),
                //         List1(
                //           onPressed: () {
                //             print('Edit button pressed');
                //           },
                //         ),
                //         List1(
                //           name: "Statement",
                //           onPressed: () {
                //             print('Edit button pressed');
                //           },
                //         ),
                //         List1(
                //           name: "Print Setup",
                //           onPressed: () {
                //             print('Edit button pressed');
                //           },
                //         ),
                //         List1(
                //           onPressed: () {
                //             print('Edit button pressed');
                //           },
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          );
  }
}

class List1 extends StatelessWidget {
  final String? name;
  final String? Skey;
  final Function onPressed;
  const List1({super.key, this.name, this.Skey, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: InkWell(
        splashColor: Colors.grey[350],
        onTap: onPressed as void Function()?,
        child: Container(
          height: 35,
          width: w * 0.1,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: 2, color: Colors.blue),
              right: BorderSide(width: 2, color: Colors.blue),
              left: BorderSide(width: 2, color: Colors.blue),
              bottom: BorderSide(width: 2, color: Colors.blue),
            ),
          ),
          child: Expanded(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: Expanded(
                    child: Text(
                      Skey ?? "",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    name ?? " ",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
