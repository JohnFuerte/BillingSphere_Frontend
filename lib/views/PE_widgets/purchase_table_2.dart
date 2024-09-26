import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/item/item_model.dart';
import '../../data/models/measurementLimit/measurement_limit_model.dart';
import '../../data/models/taxCategory/tax_category_model.dart';
import '../../data/repository/item_repository.dart';
import '../../data/repository/measurement_limit_repository.dart';
import '../../data/repository/tax_category_repository.dart';
import '../SE_variables/SE_variables.dart';
import '../searchable_dropdown.dart';

class PEntries2 extends StatefulWidget {
  const PEntries2({
    super.key,
    required this.unitControllerP,
    required this.entryId,
    required this.itemNameControllerP,
    required this.qtyControllerP,
    required this.rateControllerP,
    required this.amountControllerP,
    required this.taxControllerP,
    required this.sgstControllerP,
    required this.cgstControllerP,
    required this.igstControllerP,
    required this.netAmountControllerP,
    required this.discountControllerP,
    required this.sellingPriceControllerP,
    required this.onSaveValues,
    required this.onDelete,
    required this.serialNo,
    this.itemsList,
    this.taxLists,
    this.measurement,
  });

  final TextEditingController itemNameControllerP;
  final TextEditingController qtyControllerP;
  final TextEditingController rateControllerP;
  final TextEditingController unitControllerP;
  final TextEditingController amountControllerP;
  final TextEditingController taxControllerP;
  final TextEditingController sgstControllerP;
  final TextEditingController cgstControllerP;
  final TextEditingController igstControllerP;
  final TextEditingController netAmountControllerP;
  final TextEditingController discountControllerP;
  final TextEditingController sellingPriceControllerP;
  final Function(Map<String, dynamic>) onSaveValues;
  final Function(String) onDelete;
  final String entryId;
  final int serialNo;
  final List<Item>? itemsList;
  final List<MeasurementLimit>? measurement;
  final List<TaxRate>? taxLists;

  @override
  State<PEntries2> createState() => _PEntriesState();
}

class _PEntriesState extends State<PEntries2> {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController sgstController = TextEditingController();
  final TextEditingController cgstController = TextEditingController();
  final TextEditingController sellingPriceController = TextEditingController();
  final TextEditingController igstController = TextEditingController();
  final TextEditingController netAmountController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  double originalNetAmount = 0.0;

  // Backend Services/Repositories
  ItemsService itemsService = ItemsService();
  TaxRateService taxRateService = TaxRateService();
  MeasurementLimitService measurementService = MeasurementLimitService();
  // Variables
  String? selectedItemId;
  String? selectedTaxRateId;
  String? selectedmeasurementId;
  double itemRate = 0.0; // Track the selected item's rate

  // List of items
  double persistentTotal = 0.00;

  void _saveValues() {
    final values = {
      'uniqueKey': widget.entryId,
      'itemName': itemNameController.text,
      'qty': qtyController.text,
      'unit': unitController.text,
      'rate': rateController.text,
      'amount': amountController.text,
      'tax': taxController.text,
      'sgst': sgstController.text,
      'cgst': cgstController.text,
      'igst': igstController.text,
      'netAmount': netAmountController.text,
      'discount': discountController.text,
      'sellingPrice': sellingPriceController.text,
    };

    // Fluttertoast.showToast(
    //   msg: "Values added to list successfully!",
    //   toastLength: Toast.LENGTH_LONG,
    //   gravity: ToastGravity.CENTER_RIGHT,
    //   webPosition: "right",
    //   timeInSecForIosWeb: 1,
    //   backgroundColor: Colors.black,
    //   textColor: Colors.white,
    // );

    widget.onSaveValues(values);

    print(values);
  }

  void _initializeData() async {
    setState(() {
      itemNameController.text = widget.itemNameControllerP.text;
      qtyController.text = widget.qtyControllerP.text;
      rateController.text = widget.rateControllerP.text;
      unitController.text = widget.unitControllerP.text;
      amountController.text = widget.amountControllerP.text;
      taxController.text = widget.taxControllerP.text;
      sgstController.text = widget.sgstControllerP.text;
      cgstController.text = widget.cgstControllerP.text;
      igstController.text = widget.igstControllerP.text;
      netAmountController.text = widget.netAmountControllerP.text;
      sellingPriceController.text = widget.sellingPriceControllerP.text;
      selectedItemId = widget.itemNameControllerP.text;
      discountController.text = widget.discountControllerP.text;
    });

    print('unitController: ${widget.unitControllerP.text}');
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    qtyController.dispose();
    rateController.dispose();
    amountController.dispose();
    sgstController.dispose();
    cgstController.dispose();
    igstController.dispose();
    netAmountController.dispose();
    sellingPriceController.dispose();
    itemNameController.dispose();
    taxController.dispose();
    unitController.dispose();
    discountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.023,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(),
                        top: BorderSide(),
                        left: BorderSide())),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${widget.serialNo}',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.19,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(),
                        top: BorderSide(),
                        left: BorderSide())),
                child: DropdownButtonHideUnderline(
                  child: DropdownMenu<Item>(
                    requestFocusOnTap: true,
                    initialSelection: itemNameController.text.isNotEmpty &&
                            widget.itemsList!.isNotEmpty
                        ? widget.itemsList!.firstWhere(
                            (element) => element.id == itemNameController.text,
                            orElse: () => widget.itemsList!.first)
                        : null,
                    enableSearch: true,
                    enableFilter: true,
                    filterCallback:
                        (List<DropdownMenuEntry<Item>> entries, String filter) {
                      final String trimmedFilter = filter.trim().toLowerCase();

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
                    trailingIcon: const SizedBox.shrink(),
                    textStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff000000),
                      decoration: TextDecoration.none,
                    ),
                    menuHeight: 300,
                    width: MediaQuery.of(context).size.width * 0.19,
                    selectedTrailingIcon: const SizedBox.shrink(),
                    inputDecorationTheme: const InputDecorationTheme(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      isDense: true,
                      activeIndicatorBorder: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    expandedInsets: EdgeInsets.zero,
                    onSelected: (Item? newValue) {
                      setState(() {
                        selectedItemId = newValue!.id;
                        selectedmeasurementId = newValue.id;

                        setState(() {
                          itemNameController.text = selectedItemId!;
                          widget.itemNameControllerP.text =
                              itemNameController.text;
                        });

                        String newId = '';
                        String newId2 = '';

                        for (Item item in widget.itemsList!) {
                          if (item.id == selectedItemId) {
                            newId = item.taxCategory;
                          }
                        }

                        for (Item item in widget.itemsList!) {
                          if (item.id == selectedmeasurementId) {
                            newId2 = item.measurementUnit;
                          }
                        }

                        for (TaxRate tax in widget.taxLists!) {
                          if (tax.id == newId) {
                            setState(() {
                              taxController.text =
                                  items.isNotEmpty ? tax.rate : '0';
                              widget.taxControllerP.text = taxController.text;
                            });
                          }
                        }
                        for (MeasurementLimit meu in widget.measurement!) {
                          if (meu.id == newId2) {
                            setState(() {
                              unitController.text =
                                  items.isNotEmpty ? meu.measurement : '0';
                              widget.unitControllerP.text = unitController.text;
                            });
                          }
                        }
                      });
                    },
                    dropdownMenuEntries: widget.itemsList!
                        .map<DropdownMenuEntry<Item>>((Item value) {
                      return DropdownMenuEntry<Item>(
                        value: value,
                        label: value.itemName,
                        trailingIcon: Text(
                          'Qty: ${value.maximumStock}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
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
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.061,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(),
                        top: BorderSide(),
                        left: BorderSide())),
                child: TextFormField(
                  controller: qtyController,
                  validator: (value) {
                    // Show Taost
                    if (value!.isEmpty) {}

                    return null;
                  },
                  cursorHeight: 18,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      int amount = (int.tryParse(rateController.text) ?? 0) *
                          int.parse(value);
                      discountController.text = '0.00';

                      amountController.text = amount.toString();

                      double amountValue =
                          double.tryParse(amountController.text) ?? 0.0;
                      double taxValue =
                          double.tryParse(taxController.text) ?? 0.0;

                      if (taxValue != 0) {
                        double gsts = (amountValue * taxValue) / 100;
                        sgstController.text = (gsts / 2).toString();
                        cgstController.text = (gsts / 2).toString();
                        netAmountController.text =
                            (amountValue + gsts).toString();
                      } else {
                        // Handle division by zero scenario
                        sgstController.text = '0';
                        cgstController.text = '0';
                        netAmountController.text = amountController.text;
                      }

                      // Update persistent controllers if needed
                      widget.sgstControllerP.text = sgstController.text;
                      widget.cgstControllerP.text = cgstController.text;
                      widget.netAmountControllerP.text =
                          netAmountController.text;
                      persistentTotal =
                          double.tryParse(netAmountController.text) ?? 0.0;
                      originalNetAmount = persistentTotal;
                      widget.qtyControllerP.text = qtyController.text;

                      _saveValues();
                    });
                  },
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.061,
                decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(),
                      top: BorderSide(),
                      left: BorderSide()),
                ),
                child: TextFormField(
                  cursorHeight: 18,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    border: InputBorder.none,
                  ),
                  controller: unitController,
                  onSaved: (newValue) {
                    unitController.text = newValue!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {}
                    return null;
                  },
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  readOnly: true,
                ),
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.061,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(),
                        top: BorderSide(),
                        left: BorderSide())),
                child: TextFormField(
                  // itemRate.toString(),
                  cursorHeight: 18,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    border: InputBorder.none,
                  ),

                  controller: rateController,
                  onSaved: (newValue) {
                    rateController.text = newValue!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {}
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      discountController.text = '0.00';
                      double qty = double.parse(qtyController.text);
                      double val = double.parse(value);
                      double result = qty * val;
                      amountController.text = result.toStringAsFixed(2);
                      // amountController.text =
                      //     (double.parse(qtyController.text) *
                      //             double.parse(value))
                      //         .toString();

                      double amount = double.parse(amountController.text);
                      double tax = double.parse(taxController.text);
                      double gsts = (amount * tax) / 100;

                      sgstController.text = (gsts / 2).toStringAsFixed(2);
                      cgstController.text = (gsts / 2).toStringAsFixed(2);
                      netAmountController.text =
                          (amount + gsts).toStringAsFixed(2);

                      widget.sgstControllerP.text = sgstController.text;
                      widget.cgstControllerP.text = cgstController.text;
                      widget.netAmountControllerP.text =
                          netAmountController.text;
                      persistentTotal = double.parse(netAmountController.text);
                      originalNetAmount = persistentTotal;

                      widget.qtyControllerP.text = qtyController.text;

                      _saveValues();
                    });
                  },
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  // keyboardType: TextInputType.number,
                ),
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.061,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(),
                        top: BorderSide(),
                        left: BorderSide())),
                child: TextFormField(
                  cursorHeight: 18,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    border: InputBorder.none,
                  ),
                  controller: amountController,
                  validator: (value) {
                    if (value!.isEmpty) {}
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  readOnly: true,
                ),
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.061,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(),
                        top: BorderSide(),
                        left: BorderSide())),
                child: TextFormField(
                  cursorHeight: 18,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    border: InputBorder.none,
                  ),
                  controller: discountController,
                  onSaved: (newValue) {
                    discountController.text = newValue!;
                  },
                  onChanged: (value) {
                    double qty = double.tryParse(qtyController.text) ?? 0;
                    double rate = double.tryParse(rateController.text) ?? 0;

                    double discount =
                        double.tryParse(discountController.text) ?? 0;
                    double taxRate = double.tryParse(taxController.text) ?? 0;
                    double amount = qty * rate;
                    double taxableAmount = amount - discount;
                    double sgst = taxableAmount * (taxRate / 2) / 100;
                    double cgst = taxableAmount * (taxRate / 2) / 100;
                    double netAmount = taxableAmount + sgst + cgst;

                    setState(() {
                      sgstController.text = sgst.toStringAsFixed(2);
                      cgstController.text = cgst.toStringAsFixed(2);
                      netAmountController.text = netAmount.toStringAsFixed(2);
                    });
                    _saveValues();
                  },
                  validator: (value) {
                    if (value!.isEmpty) {}
                    return null;
                  },
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  readOnly: false,
                ),
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.061,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(),
                        top: BorderSide(),
                        left: BorderSide())),
                child: TextFormField(
                  cursorHeight: 18,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {},
                  controller: taxController,
                  onSaved: (newValue) {
                    taxController.text = newValue!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {}
                    return null;
                  },
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  readOnly: true,
                ),
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.061,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(),
                        top: BorderSide(),
                        left: BorderSide())),
                child: TextFormField(
                  cursorHeight: 18,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    border: InputBorder.none,
                  ),
                  controller: sgstController,
                  textAlign: TextAlign.center,
                  validator: (value) {
                    if (value!.isEmpty) {}
                    return null;
                  },
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  readOnly: true,
                ),
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.061,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(),
                        top: BorderSide(),
                        left: BorderSide())),
                child: TextFormField(
                  cursorHeight: 18,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    border: InputBorder.none,
                  ),
                  controller: cgstController,
                  validator: (value) {
                    if (value!.isEmpty) {}
                    return null;
                  },
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  readOnly: true,
                ),
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.061,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(),
                        top: BorderSide(),
                        left: BorderSide())),
                child: TextFormField(
                  cursorHeight: 18,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    border: InputBorder.none,
                  ),
                  controller: igstController,
                  onChanged: (value) {
                    widget.igstControllerP.text = igstController.text;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {}
                    return null;
                  },
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(
                        r'^\d*\.?\d*$')), // Allow digits and a single decimal point
                  ],
                ),
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.061,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(),
                        left: BorderSide(),
                        top: BorderSide(),
                        right: BorderSide())),
                child: TextFormField(
                  cursorHeight: 18,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {}
                    return null;
                  },
                  controller: netAmountController,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  readOnly: true,
                ),
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.061,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(),
                        left: BorderSide(color: Colors.transparent),
                        top: BorderSide(),
                        right: BorderSide())),
                child: TextFormField(
                  cursorHeight: 18,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    border: InputBorder.none,
                  ),
                  controller: sellingPriceController,
                  validator: (value) {
                    if (value!.isEmpty) {}
                    return null;
                  },
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    _saveValues();
                  },
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  readOnly: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
