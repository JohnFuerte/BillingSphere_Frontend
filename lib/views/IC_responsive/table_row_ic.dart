// ignore: file_names
// ignore_for_file: unnecessary_null_comparison

import 'package:billingsphere/data/models/item/item_model.dart';
import 'package:billingsphere/data/models/measurementLimit/measurement_limit_model.dart';
import 'package:billingsphere/views/SE_variables/SE_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../auth/providers/onchange_ledger_provider.dart';
import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/stock/product_stock_model.dart';
import '../../data/repository/product_stock_repository.dart';

class IEntries extends StatefulWidget {
  final int serialNumber;

  const IEntries({
    super.key,
    required this.serialNumber,
    required this.itemNameControllerP,
    required this.qtyControllerP,
    required this.rateControllerP,
    required this.unitControllerP,
    required this.netAmountControllerP,
    required this.selectedLegerId,
    required this.entryId,
    required this.onSaveValues,
    required this.item,
    required this.measurementLimit,
  });

  final TextEditingController itemNameControllerP;
  final TextEditingController qtyControllerP;
  final TextEditingController rateControllerP;
  final TextEditingController unitControllerP;
  final TextEditingController netAmountControllerP;
  final String selectedLegerId;
  final String entryId;
  final Function(Map<String, dynamic>) onSaveValues;
  final List<Item> item;
  final List<MeasurementLimit> measurementLimit;

  @override
  State<IEntries> createState() => _IEntriesState();
}

class _IEntriesState extends State<IEntries> {
  late TextEditingController itemNameController;
  late TextEditingController qtyController;
  late TextEditingController rateController;
  late TextEditingController unitController;
  late TextEditingController netAmountController;

  final TextEditingController searchController = TextEditingController();

  // Variables
  double itemRate = 0.0;
  double stock = 0.0;
  double price = 0.0;
  String? selectedItemId;
  // List of items
  bool isLoading = false;

  ProductStockService productStockService = ProductStockService();
  List<ProductStockModel> fectedStocks = [];
  List<String>? company = [];

  //Ledger

  String? selectedPersonType;
  List<Ledger> suggestionItems5 = [];

  void _saveValues() {
    final values = {
      'uniqueKey': widget.entryId,
      'itemName': itemNameController.text,
      'qty': qtyController.text,
      'rate': rateController.text,
      'unit': unitController.text,
      'netAmount': netAmountController.text,
    };

    widget.onSaveValues(values);
  }

  @override
  void initState() {
    super.initState();
    itemNameController = TextEditingController();
    qtyController = TextEditingController();
    rateController = TextEditingController();
    unitController = TextEditingController();
    netAmountController = TextEditingController();
    selectedItemId = widget.item.first.id;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Consumer<OnChangeLedgerProvider>(
          builder: (context, value, _) {
            final cat = value.ledger;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.023,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(),
                          // top: BorderSide(),
                          left: BorderSide(),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          '${widget.serialNumber}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: const Color(0xff000000),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(),
                              // top: BorderSide(),
                              left: BorderSide())),
                      child: DropdownButtonHideUnderline(
                        child: DropdownMenu<Item>(
                          requestFocusOnTap: true,
                          initialSelection:
                              widget.item.isNotEmpty ? widget.item.first : null,
                          enableSearch: true,
                          trailingIcon: const SizedBox.shrink(),
                          textStyle: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                          menuHeight: 300,
                          enableFilter: true,
                          filterCallback:
                              (List<DropdownMenuEntry<Item>> entries,
                                  String filter) {
                            final String trimmedFilter =
                                filter.trim().toLowerCase();

                            if (trimmedFilter.isEmpty) {
                              return entries;
                            }

                            // Filter the entries based on the query
                            return entries.where((entry) {
                              return entry.value.itemName
                                  .toLowerCase()
                                  .contains(trimmedFilter);
                            }).toList();
                          },
                          selectedTrailingIcon: const SizedBox.shrink(),
                          inputDecorationTheme: const InputDecorationTheme(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            isDense: true,
                            activeIndicatorBorder: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          expandedInsets: EdgeInsets.zero,
                          onSelected: (Item? value) {
                            setState(() {
                              selectedItemId = value!.id;
                              itemNameController.text = selectedItemId!;
                              widget.itemNameControllerP.text =
                                  itemNameController.text;
                              String newId = '';
                              String newId2 = '';
                              for (Item item in widget.item) {
                                if (item.id == selectedItemId) {
                                  newId = item.retail.toStringAsFixed(2);
                                  newId2 = item.measurementUnit;
                                  stock = item.maximumStock as double;
                                }
                              }

                              for (var element in fectedStocks) {
                                if (company![0] == element.company) {
                                  if (element.product == selectedItemId) {
                                    stock = element.quantity as double;
                                  }
                                }
                              }
                              rateController.text = newId;
                              widget.rateControllerP.text = rateController.text;

                              for (MeasurementLimit meu
                                  in widget.measurementLimit) {
                                if (meu.id == newId2) {
                                  setState(() {
                                    unitController.text = items.isNotEmpty
                                        ? meu.measurement
                                        : '0';
                                    widget.unitControllerP.text =
                                        unitController.text;
                                  });
                                }
                              }

                              // itemProvider.updateItemID(selectedItemId!);
                            });
                          },
                          dropdownMenuEntries: widget.item
                              .map<DropdownMenuEntry<Item>>((Item value) {
                            return DropdownMenuEntry<Item>(
                              value: value,
                              label: value.itemName,
                              style: ButtonStyle(
                                textStyle: WidgetStateProperty.all(
                                  GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      //  DropdownButton<String>(
                      //   value: selectedItemId,
                      //   underline: Container(),
                      //   onChanged: (String? newValue) {
                      //     setState(() {
                      //       selectedItemId = newValue;

                      //       itemNameController.text = selectedItemId!;
                      //       widget.itemNameControllerP.text =
                      //           itemNameController.text;

                      //       String newId = '';
                      //       String newId2 = '';

                      //       for (Item item in itemsList) {
                      //         if (item.id == selectedItemId) {
                      //           newId = item.mrp.toString();
                      //           newId2 = item.measurementUnit;
                      //           stock = item.maximumStock as double;
                      //         }
                      //       }

                      //       for (var element in fectedStocks) {
                      //         if (company![0] == element.company) {
                      //           if (element.product == selectedItemId) {
                      //             stock = element.quantity as double;
                      //           }
                      //         }
                      //       }

                      //       rateController.text = newId;
                      //       widget.rateControllerP.text = rateController.text;

                      //       for (MeasurementLimit meu in measurement) {
                      //         if (meu.id == newId2) {
                      //           setState(() {
                      //             unitController.text =
                      //                 items.isNotEmpty ? meu.measurement : '0';
                      //             widget.unitControllerP.text =
                      //                 unitController.text;
                      //           });
                      //         }
                      //       }

                      //       // itemProvider.updateItemID(selectedItemId!);
                      //     });
                      //   },
                      //   isDense: true,
                      //   isExpanded: true,
                      //   items: itemsList.map((Item items) {
                      //     return DropdownMenuItem<String>(
                      //       value: items.id,
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text(
                      //             items.itemName,
                      //             style: const TextStyle(
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.bold,
                      //               overflow: TextOverflow.ellipsis,
                      //             ),
                      //             maxLines: 1,
                      //           ),
                      //         ],
                      //       ),
                      //     );
                      //   }).toList(),
                      // ),
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.15,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(),
                          // top: BorderSide(),
                          left: BorderSide(),
                        ),
                      ),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: const Color(0xff000000),
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        cursorHeight: 18,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(15.0),
                        ),
                        controller: qtyController,
                        onChanged: (value) {
                          double qty = double.parse(value);
                          if (qty > stock || qty <= 0) {
                            Fluttertoast.showToast(
                                msg:
                                    'Quantity should not be greater than stock and less/equal than 0',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            qtyController.text = stock.toString();
                          }
                          double rate = double.parse(rateController.text);
                          double netAmount = qty * rate;
                          netAmountController.text = netAmount.toString();
                          widget.qtyControllerP.text = qtyController.text;
                          widget.netAmountControllerP.text =
                              netAmountController.text;

                          _saveValues();
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.15,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(),
                              // top: BorderSide(),
                              left: BorderSide())),
                      child: TextFormField(
                        cursorHeight: 18,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(15.0),
                        ),
                        controller: unitController,
                        readOnly: true,
                        onSaved: (newValue) {
                          unitController.text = newValue!;
                        },
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.15,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(),
                              // top: BorderSide(),
                              left: BorderSide())),
                      child: TextFormField(
                        cursorHeight: 18,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(15.0),
                        ),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: const Color(0xff000000),
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: rateController,
                        onChanged: (value) {},
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.15,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(),
                              left: BorderSide(),
                              // top: BorderSide(),
                              right: BorderSide())),
                      child: TextFormField(
                        cursorHeight: 18,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(15.0),
                        ),
                        controller: netAmountController,
                        readOnly: true,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
