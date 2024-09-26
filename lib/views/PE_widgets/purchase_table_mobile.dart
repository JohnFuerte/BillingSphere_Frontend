// import 'package:billingsphere/data/repository/item_repository.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:high_q_paginated_drop_down/high_q_paginated_drop_down.dart';

// import 'package:provider/provider.dart';

// import '../../auth/providers/onchange_item_provider.dart';
// import '../../data/models/item/item_model.dart';
// import '../../data/models/measurementLimit/measurement_limit_model.dart';
// import '../../data/models/taxCategory/tax_category_model.dart';
// import '../../data/repository/measurement_limit_repository.dart';
// import '../../data/repository/tax_category_repository.dart';
// import '../SE_variables/SE_variables.dart';

// class PEntries extends StatefulWidget {
//   const PEntries({
//     super.key,
//     required this.unitControllerP,
//     required this.entryId,
//     required this.itemNameControllerP,
//     required this.qtyControllerP,
//     required this.rateControllerP,
//     required this.amountControllerP,
//     required this.taxControllerP,
//     required this.sgstControllerP,
//     required this.cgstControllerP,
//     required this.igstControllerP,
//     required this.netAmountControllerP,
//     required this.discountControllerP,
//     required this.sellingPriceControllerP,
//     required this.onSaveValues,
//     required this.onDelete,
//     required this.serialNumber,
//   });

//   final TextEditingController itemNameControllerP;
//   final TextEditingController qtyControllerP;
//   final TextEditingController rateControllerP;
//   final TextEditingController unitControllerP;
//   final TextEditingController amountControllerP;
//   final TextEditingController taxControllerP;
//   final TextEditingController sgstControllerP;
//   final TextEditingController cgstControllerP;
//   final TextEditingController igstControllerP;
//   final TextEditingController netAmountControllerP;
//   final TextEditingController discountControllerP;
//   final TextEditingController sellingPriceControllerP;
//   final Function(Map<String, dynamic>) onSaveValues;
//   final Function(String) onDelete;
//   final String entryId;
//   final int serialNumber;

//   @override
//   State<PEntries> createState() => _PEntriesState();
// }

// class _PEntriesState extends State<PEntries> {
//   late TextEditingController itemNameController;
//   late TextEditingController qtyController;
//   final TextEditingController rateController = TextEditingController();
//   final TextEditingController unitController = TextEditingController();
//   late TextEditingController amountController;
//   final TextEditingController taxController = TextEditingController();
//   late TextEditingController sgstController;
//   late TextEditingController cgstController;
//   late TextEditingController sellingPriceController;
//   final TextEditingController igstController = TextEditingController();
//   final TextEditingController searchController = TextEditingController();
//   late TextEditingController netAmountController;
//   late TextEditingController discountController;

//   MeasurementLimitService measurementService = MeasurementLimitService();

//   TaxRateService taxRateService = TaxRateService();

//   ItemsService itemsService = ItemsService();

//   List<Item> itemsList = [];

//   bool isLoading = false;
//   double originalNetAmount = 0.0;

//   // Variables
//   String? selectedItemId;
//   String? selectedTaxRateId;
//   String? selectedmeasurementId;
//   double itemRate = 0.0; // Track the selected item's rate

//   List<TaxRate> taxLists = [];
//   List<MeasurementLimit> measurement = [];

//   // List of items
//   double persistentTotal = 0.00;
//   String? uid;
//   final formKey = GlobalKey<FormState>();

//   // Future Functions
//   Future<void> fetchAndSetTaxRates() async {
//     try {
//       final List<TaxRate> taxRates = await taxRateService.fetchTaxRates();

//       setState(() {
//         taxLists = taxRates;
//       });
//     } catch (error) {
//       print('Failed to fetch Tax Rates: $error');
//     }
//   }

//   Future<void> fetchMeasurementLimit() async {
//     try {
//       final List<MeasurementLimit> measurements =
//           await measurementService.fetchMeasurementLimits();

//       setState(() {
//         measurement = measurements;
//       });
//     } catch (error) {
//       print('Failed to fetch Tax Rates: $error');
//     }
//   }

//   Future<void> fetchAllData() async {
//     try {
//       await Future.wait([
//         fetchAndSetTaxRates(),
//         fetchMeasurementLimit(),
//       ]);
//     } catch (e) {
//       print('Failed to fetch data: $e');
//     }
//   }

//   void _saveValues() {
//     if (!formKey.currentState!.validate()) {
//       return;
//     }

//     final values = {
//       'uniqueKey': widget.entryId,
//       'itemName': itemNameController.text,
//       'qty': qtyController.text,
//       'unit': unitController.text,
//       'rate': rateController.text,
//       'unit2': unitController.text,
//       'amount': amountController.text,
//       'tax': taxController.text,
//       'sgst': sgstController.text,
//       'cgst': cgstController.text,
//       'igst': igstController.text,
//       'netAmount': netAmountController.text,
//       'discount': discountController.text,
//       'sellingPrice': sellingPriceController.text,
//     };
//     widget.onSaveValues(values);
//   }

//   @override
//   void initState() {
//     super.initState();
//     itemNameController = TextEditingController();
//     qtyController = TextEditingController();
//     amountController = TextEditingController();
//     sgstController = TextEditingController();
//     cgstController = TextEditingController();
//     netAmountController = TextEditingController();
//     sellingPriceController = TextEditingController();
//     discountController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     qtyController.dispose();
//     rateController.dispose();
//     amountController.dispose();
//     discountController.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final itemProvider =
//         Provider.of<OnChangeItenProvider>(context, listen: false);
//     return FutureBuilder(
//       future: fetchAllData(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return const SizedBox.shrink();
//         }

//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: SizedBox(
//             child: Form(
//               key: formKey,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 0.0, right: 8.0, top: 0),
//                 child: Column(
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                             height: 35,
//                             width: MediaQuery.of(context).size.width * 0.40,
//                             decoration: const BoxDecoration(
//                                 border: Border(
//                                     bottom: BorderSide(),
//                                     top: BorderSide(),
//                                     left: BorderSide())),
//                             child: HighQPaginatedDropdown<Item>.paginated(
//                               isDialogExpanded: false,
//                               spaceBetweenDropDownAndItemsDialog: 5,
//                               trailingIcon: const SizedBox.shrink(),
//                               hasTrailingClearIcon: false,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedItemId = value!.id;
//                                   selectedmeasurementId = value.id;

//                                   itemNameController.text = selectedItemId!;
//                                   widget.itemNameControllerP.text =
//                                       itemNameController.text;
//                                   igstController.text = '0.00';
//                                   discountController.text = '0.00';

//                                   String newId = '';
//                                   String newId2 = '';

//                                   for (Item item in itemsList) {
//                                     if (item.id == selectedItemId) {
//                                       newId = item.taxCategory;
//                                     }
//                                   }

//                                   for (Item item in itemsList) {
//                                     if (item.id == selectedmeasurementId) {
//                                       newId2 = item.measurementUnit;
//                                     }
//                                   }

//                                   for (TaxRate tax in taxLists) {
//                                     if (tax.id == newId) {
//                                       setState(() {
//                                         taxController.text =
//                                             items.isNotEmpty ? tax.rate : '0';
//                                         widget.taxControllerP.text =
//                                             taxController.text;
//                                       });
//                                     }
//                                   }
//                                   for (MeasurementLimit meu in measurement) {
//                                     if (meu.id == newId2) {
//                                       setState(() {
//                                         unitController.text =
//                                             itemsList.isNotEmpty
//                                                 ? meu.measurement
//                                                 : '0';
//                                         widget.unitControllerP.text =
//                                             unitController.text;
//                                       });
//                                     }
//                                   }

//                                   itemProvider.updateItemID(selectedItemId!);
//                                 });
//                               },
//                               paginatedRequest: (
//                                 int page,
//                                 String? searchText,
//                               ) async {
//                                 List<Item> fetchedItems =
//                                     await itemsService.fetchITEMS(
//                                   queryParameters: {
//                                     'page': page,
//                                     "q": searchText,
//                                   },
//                                 );

//                                 itemsList = fetchedItems;

//                                 if (searchText != null &&
//                                     searchText.isNotEmpty) {
//                                   fetchedItems = fetchedItems
//                                       .where((element) => element.itemName
//                                           .toLowerCase()
//                                           .contains(searchText.toLowerCase()))
//                                       .toList();
//                                 }

//                                 print("Search Text: $searchText");

//                                 List<MenuItemModel<Item>>? menuItemModels =
//                                     fetchedItems.map((item) {
//                                   return MenuItemModel<Item>(
//                                     value: item,
//                                     label: item.itemName,
//                                     child: Text(
//                                       item.itemName,
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                       maxLines: 1,
//                                     ),
//                                   );
//                                 }).toList();

//                                 return menuItemModels;
//                               },
//                             )),
//                         Container(
//                           height: 35,
//                           width: MediaQuery.of(context).size.width * 0.20,
//                           decoration: const BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(),
//                                   top: BorderSide(),
//                                   left: BorderSide())),
//                           child: TextFormField(
//                             controller: qtyController,
//                             validator: (value) {
//                               // Show Taost
//                               if (value!.isEmpty) {}

//                               return null;
//                             },
//                             cursorHeight: 18,
//                             decoration: const InputDecoration(
//                               contentPadding: EdgeInsets.all(15.0),
//                               border: InputBorder.none,
//                             ),
//                             onChanged: (value) {
//                               setState(() {
//                                 discountController.text = '0.00';

//                                 int amount =
//                                     (int.tryParse(rateController.text) ?? 0) *
//                                         int.parse(value);

//                                 amountController.text = amount.toString();

//                                 double amountValue =
//                                     double.tryParse(amountController.text) ??
//                                         0.0;
//                                 double taxValue =
//                                     double.tryParse(taxController.text) ?? 0.0;

//                                 if (taxValue != 0) {
//                                   double gsts = (amountValue * taxValue) / 100;
//                                   sgstController.text = (gsts / 2).toString();
//                                   cgstController.text = (gsts / 2).toString();
//                                   netAmountController.text =
//                                       (amountValue + gsts).toString();
//                                 } else {
//                                   // Handle division by zero scenario
//                                   sgstController.text = '0';
//                                   cgstController.text = '0';
//                                   netAmountController.text =
//                                       amountController.text;
//                                 }
//                                 // Update persistent controllers if needed
//                                 widget.sgstControllerP.text =
//                                     sgstController.text;
//                                 widget.cgstControllerP.text =
//                                     cgstController.text;
//                                 widget.netAmountControllerP.text =
//                                     netAmountController.text;
//                                 persistentTotal =
//                                     double.tryParse(netAmountController.text) ??
//                                         0.0;
//                                 widget.qtyControllerP.text = qtyController.text;

//                                 _saveValues();
//                               });
//                             },
//                             keyboardType: TextInputType.number,
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                             inputFormatters: <TextInputFormatter>[
//                               FilteringTextInputFormatter.digitsOnly
//                             ],
//                           ),
//                         ),
//                         Container(
//                           height: 35,
//                           width: MediaQuery.of(context).size.width * 0.20,
//                           decoration: const BoxDecoration(
//                             border: Border(
//                                 bottom: BorderSide(),
//                                 top: BorderSide(),
//                                 left: BorderSide()),
//                           ),
//                           child: TextFormField(
//                             cursorHeight: 18,
//                             decoration: const InputDecoration(
//                                contentPadding: EdgeInsets.all(15.0),
//                               border: InputBorder.none,
//                             ),
//                             controller: unitController,
//                             onSaved: (newValue) {
//                               unitController.text = newValue!;
//                             },
//                             validator: (value) {
//                               if (value!.isEmpty) {}
//                               return null;
//                             },
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                             inputFormatters: <TextInputFormatter>[
//                               FilteringTextInputFormatter.digitsOnly
//                             ],
//                             readOnly: true,
//                           ),
//                         ),
//                         Container(
//                           height: 35,
//                           width: MediaQuery.of(context).size.width * 0.20,
//                           decoration: const BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(),
//                                   top: BorderSide(),
//                                   left: BorderSide())),
//                           child: TextFormField(
//                             // itemRate.toString(),
//                             cursorHeight: 18,
//                             decoration: const InputDecoration(
//                              contentPadding: EdgeInsets.all(15.0),
//                               border: InputBorder.none,
//                             ),

//                             controller: rateController,
//                             onSaved: (newValue) {
//                               rateController.text = newValue!;
//                             },
//                             validator: (value) {
//                               if (value!.isEmpty) {}
//                               return null;
//                             },
//                             onChanged: (value) {
//                               setState(() {
//                                 discountController.text = '0.00';
//                                 amountController.text = (int.parse(value) *
//                                         int.parse(qtyController.text))
//                                     .toString();

//                                 double amount =
//                                     double.parse(amountController.text);
//                                 double tax = double.parse(taxController.text);
//                                 double gsts = (amount * tax) / 100;

//                                 sgstController.text =
//                                     (gsts / 2).toStringAsFixed(2);
//                                 cgstController.text =
//                                     (gsts / 2).toStringAsFixed(2);
//                                 netAmountController.text =
//                                     (amount + gsts).toStringAsFixed(2);

//                                 widget.sgstControllerP.text =
//                                     sgstController.text;
//                                 widget.cgstControllerP.text =
//                                     cgstController.text;
//                                 widget.netAmountControllerP.text =
//                                     netAmountController.text;
//                                 persistentTotal =
//                                     double.parse(netAmountController.text);
//                                 originalNetAmount = persistentTotal;

//                                 widget.qtyControllerP.text = qtyController.text;

//                                 _saveValues();
//                               });
//                             },
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                             // keyboardType: TextInputType.number,
//                           ),
//                         ),
//                         Container(
//                           height: 35,
//                           width: MediaQuery.of(context).size.width * 0.20,
//                           decoration: const BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(),
//                                   top: BorderSide(),
//                                   left: BorderSide())),
//                           child: TextFormField(
//                             cursorHeight: 18,
//                             decoration: const InputDecoration(
//                              contentPadding: EdgeInsets.all(15.0),
//                               border: InputBorder.none,
//                             ),
//                             controller: amountController,
//                             validator: (value) {
//                               if (value!.isEmpty) {}
//                               return null;
//                             },
//                             keyboardType: TextInputType.number,
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                             readOnly: true,
//                           ),
//                         ),
//                         Container(
//                           height: 35,
//                           width: MediaQuery.of(context).size.width * 0.20,
//                           decoration: const BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(),
//                                   top: BorderSide(),
//                                   left: BorderSide())),
//                           child: TextFormField(
//                             cursorHeight: 18,
//                             decoration: const InputDecoration(
//                               contentPadding: EdgeInsets.all(15.0),
//                               border: InputBorder.none,
//                             ),
//                             controller: discountController,
//                             onSaved: (newValue) {
//                               discountController.text = newValue!;
//                             },
//                             onChanged: (value) {
//                               double qty =
//                                   double.tryParse(qtyController.text) ?? 0;
//                               double rate =
//                                   double.tryParse(rateController.text) ?? 0;

//                               double discount =
//                                   double.tryParse(discountController.text) ?? 0;
//                               double taxRate =
//                                   double.tryParse(taxController.text) ?? 0;
//                               double amount = qty * rate;
//                               double taxableAmount = amount - discount;
//                               double sgst = taxableAmount * (taxRate / 2) / 100;
//                               double cgst = taxableAmount * (taxRate / 2) / 100;
//                               double netAmount = taxableAmount + sgst + cgst;

//                               setState(() {
//                                 sgstController.text = sgst.toStringAsFixed(2);
//                                 cgstController.text = cgst.toStringAsFixed(2);
//                                 netAmountController.text =
//                                     netAmount.toStringAsFixed(2);
//                               });
//                               _saveValues();
//                             },
//                             validator: (value) {
//                               if (value!.isEmpty) {}
//                               return null;
//                             },
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                             readOnly: false,
//                           ),
//                         ),

//                         Container(
//                           height: 35,
//                           width: MediaQuery.of(context).size.width * 0.20,
//                           decoration: const BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(),
//                                   top: BorderSide(),
//                                   left: BorderSide())),
//                           child: TextFormField(
//                             cursorHeight: 18,
//                             decoration: const InputDecoration(
//                               contentPadding: EdgeInsets.all(15.0),
//                               border: InputBorder.none,
//                             ),
//                             onChanged: (value) {},
//                             controller: taxController,
//                             onSaved: (newValue) {
//                               taxController.text = newValue!;
//                             },
//                             validator: (value) {
//                               if (value!.isEmpty) {}
//                               return null;
//                             },
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                             readOnly: true,
//                           ),
//                         ),
//                         Container(
//                           height: 35,
//                           width: MediaQuery.of(context).size.width * 0.20,
//                           decoration: const BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(),
//                                   top: BorderSide(),
//                                   left: BorderSide())),
//                           child: TextFormField(
//                             cursorHeight: 18,
//                             decoration: const InputDecoration(
//                               contentPadding: EdgeInsets.all(15.0),
//                               border: InputBorder.none,
//                             ),
//                             controller: sgstController,
//                             textAlign: TextAlign.center,
//                             validator: (value) {
//                               if (value!.isEmpty) {}
//                               return null;
//                             },
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                             readOnly: true,
//                           ),
//                         ),
//                         Container(
//                           height: 35,
//                           width: MediaQuery.of(context).size.width * 0.20,
//                           decoration: const BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(),
//                                   top: BorderSide(),
//                                   left: BorderSide())),
//                           child: TextFormField(
//                             cursorHeight: 18,
//                             decoration: const InputDecoration(
//                               contentPadding: EdgeInsets.all(15.0),
//                               border: InputBorder.none,
//                             ),
//                             controller: cgstController,
//                             validator: (value) {
//                               if (value!.isEmpty) {}
//                               return null;
//                             },
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                             readOnly: true,
//                           ),
//                         ),
//                         Container(
//                           height: 35,
//                           width: MediaQuery.of(context).size.width * 0.20,
//                           decoration: const BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(),
//                                   top: BorderSide(),
//                                   left: BorderSide())),
//                           child: TextFormField(
//                             cursorHeight: 18,
//                             decoration: const InputDecoration(
//                             contentPadding: EdgeInsets.all(15.0),
//                               border: InputBorder.none,
//                             ),
//                             controller: igstController,
//                             onChanged: (value) {
//                               widget.igstControllerP.text = igstController.text;
//                             },
//                             validator: (value) {
//                               if (value!.isEmpty) {}
//                               return null;
//                             },
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                             inputFormatters: <TextInputFormatter>[
//                               FilteringTextInputFormatter.allow(RegExp(
//                                   r'^\d*\.?\d*$')), // Allow digits and a single decimal point
//                             ],
//                           ),
//                         ),

//                         Container(
//                           height: 35,
//                           width: MediaQuery.of(context).size.width * 0.20,
//                           decoration: const BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(),
//                                   left: BorderSide(),
//                                   top: BorderSide(),
//                                   right: BorderSide())),
//                           child: TextFormField(
//                             cursorHeight: 18,
//                             decoration: const InputDecoration(
//                               contentPadding: EdgeInsets.all(15.0),
//                               border: InputBorder.none,
//                             ),
//                             validator: (value) {
//                               if (value!.isEmpty) {}
//                               return null;
//                             },
//                             controller: netAmountController,
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                             readOnly: true,
//                           ),
//                         ),
//                         Container(
//                           height: 35,
//                           width: MediaQuery.of(context).size.width * 0.30,
//                           decoration: const BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(),
//                                   left: BorderSide(),
//                                   top: BorderSide(),
//                                   right: BorderSide())),
//                           child: TextFormField(
//                             cursorHeight: 18,
//                             decoration: const InputDecoration(
//                               contentPadding: EdgeInsets.all(15.0),
//                               border: InputBorder.none,
//                             ),
//                             controller: sellingPriceController,
//                             validator: (value) {
//                               if (value!.isEmpty) {}
//                               return null;
//                             },
//                             textAlign: TextAlign.center,
//                             onChanged: (value) {
//                               _saveValues();
//                             },
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                             readOnly: false,
//                           ),
//                         ),
//                         // Flexible(
//                         //   child: SizedBox(
//                         //     width: MediaQuery.of(context).size.width * 0.01,
//                         //     height: 25,
//                         //     child: IconButton(
//                         //       hoverColor: Colors.transparent,
//                         //       splashColor: Colors.transparent,
//                         //       onPressed: () {
//                         //         _saveValues();
//                         //       },
//                         //       icon: const Icon(
//                         //         Icons.save,
//                         //         size: 15,
//                         //         color: Colors.green,
//                         //       ),
//                         //     ),
//                         //   ),
//                         // ),
//                         // Flexible(
//                         //   child: SizedBox(
//                         //     width: MediaQuery.of(context).size.width * 0.01,
//                         //     height: 25,
//                         //     child: IconButton(
//                         //       hoverColor: Colors.transparent,
//                         //       splashColor: Colors.transparent,
//                         //       onPressed: _deleteEntry,
//                         //       icon: const Icon(
//                         //         Icons.delete,
//                         //         size: 15,
//                         //         color: Colors.red,
//                         //       ),
//                         //     ),
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
