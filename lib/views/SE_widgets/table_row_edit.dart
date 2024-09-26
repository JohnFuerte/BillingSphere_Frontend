// ignore: file_names
import 'package:billingsphere/auth/providers/onchange_item_provider.dart';
import 'package:billingsphere/auth/providers/onchange_ledger_provider.dart';
import 'package:billingsphere/data/models/item/item_model.dart';
import 'package:billingsphere/data/models/measurementLimit/measurement_limit_model.dart';
import 'package:billingsphere/data/models/taxCategory/tax_category_model.dart';
import 'package:billingsphere/data/repository/item_repository.dart';
import 'package:billingsphere/data/repository/measurement_limit_repository.dart';
import 'package:billingsphere/data/repository/tax_category_repository.dart';
import 'package:billingsphere/views/SE_variables/SE_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/price/price_category.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/price_category_repository.dart';
import '../searchable_dropdown.dart';

class SEEntries extends StatefulWidget {
  const SEEntries({
    super.key,
    required this.itemNameControllerP,
    required this.qtyControllerP,
    required this.rateControllerP,
    required this.rate2ControllerP,
    required this.unitControllerP,
    required this.amountControllerP,
    required this.taxControllerP,
    required this.sgstControllerP,
    required this.cgstControllerP,
    required this.igstControllerP,
    required this.netAmountControllerP,
    required this.discountControllerP,
    required this.onSaveValues,
    required this.onDelete,
    required this.entryId,
    required this.selectedLegerId,
    required this.stockControllerP,
    required this.additionalInfoControllerP,
    required this.serialNo,
    this.itemsList,
    this.measurement,
    this.taxLists,
    // Create Cont
  });

  final TextEditingController itemNameControllerP;
  final TextEditingController stockControllerP;
  final TextEditingController qtyControllerP;
  final TextEditingController rateControllerP;
  final TextEditingController rate2ControllerP;
  final TextEditingController unitControllerP;
  final TextEditingController amountControllerP;
  final TextEditingController taxControllerP;
  final TextEditingController sgstControllerP;
  final TextEditingController cgstControllerP;
  final TextEditingController igstControllerP;
  final TextEditingController netAmountControllerP;
  final TextEditingController discountControllerP;
  final TextEditingController additionalInfoControllerP;
  final String selectedLegerId;
  final Function(Map<String, dynamic>) onSaveValues;
  final Function(String) onDelete;
  final String entryId;
  final int serialNo;
  final List<Item>? itemsList;
  final List<MeasurementLimit>? measurement;
  final List<TaxRate>? taxLists;

  @override
  State<SEEntries> createState() => _SEEntriesState();
}

class _SEEntriesState extends State<SEEntries> {
  late TextEditingController itemNameController;
  late TextEditingController qtyController;
  late TextEditingController stockController;
  // late TextEditingController discountController;
  late TextEditingController rateController;
  late TextEditingController rate2Controller;
  late TextEditingController unitController;
  late TextEditingController amountController;
  late TextEditingController taxController;
  late TextEditingController sgstController;
  late TextEditingController cgstController;
  late TextEditingController igstController;
  late TextEditingController netAmountController;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  late TextEditingController price2Controller;
  late TextEditingController discountRateController;
  late TextEditingController additionalInfoController;

  final TextEditingController originaldiscountController =
      TextEditingController();

  // Backend Services/Repositories
  double originalNetAmount = 0.0;

  // Variables
  String? selectedItemId;
  String? selectedItemId2;
  String? selectedTaxRateId;
  String? selectedPriceTypeId;
  String? selectedmeasurementId;
  double itemRate = 0.0;
  double stock = 0.0;

  Ledger? _fetchedSingleLedger;

  //Ledger
  LedgerService ledgerService = LedgerService();
  String? selectedLedgerName;
  String? selectedPersonType;

  void _saveValues() {
    final values = {
      'uniqueKey': widget.entryId,
      'itemName': itemNameController.text,
      'qty': qtyController.text,
      'unit': unitController.text,
      'rate': rateController.text,
      'baseRate': rate2Controller.text,
      'unit2': unitController.text,
      'amount': amountController.text,
      'tax': taxController.text,
      'discount': discountController.text,
      'originaldiscount': originaldiscountController.text,
      'sgst': sgstController.text,
      'cgst': cgstController.text,
      'igst': igstController.text,
      'netAmount': netAmountController.text,
      'additionalInfo': additionalInfoController.text,
    };

    widget.onSaveValues(values);

    print(values);
  }

  double discountPercentage = 0.00;
  @override
  void initState() {
    super.initState();

    itemNameController =
        TextEditingController(text: widget.itemNameControllerP.text);
    qtyController = TextEditingController(text: widget.qtyControllerP.text);
    stockController = TextEditingController(text: widget.stockControllerP.text);
    rateController = TextEditingController(text: widget.rateControllerP.text);
    rate2Controller = TextEditingController(text: widget.rate2ControllerP.text);
    unitController = TextEditingController(text: widget.unitControllerP.text);
    amountController =
        TextEditingController(text: widget.amountControllerP.text);
    taxController = TextEditingController(text: widget.taxControllerP.text);
    sgstController = TextEditingController(text: widget.sgstControllerP.text);
    cgstController = TextEditingController(text: widget.cgstControllerP.text);
    igstController = TextEditingController(text: widget.igstControllerP.text);
    netAmountController =
        TextEditingController(text: widget.netAmountControllerP.text);
    discountRateController =
        TextEditingController(text: widget.discountControllerP.text);
    additionalInfoController =
        TextEditingController(text: widget.additionalInfoControllerP.text);
  }

  // Get the ledger and store in a variable
  String cat = '';
  void _showAdditionalDetailsPopup(Item item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
          backgroundColor: Colors.white,
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
          title: Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(16.0),
            child: Text('${item.itemName} ADDTIONAL DETAILS',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 100,
                child: TextFormField(
                  controller: additionalInfoController,
                  decoration: const InputDecoration(labelText: 'Remarks'),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                // Add your save logic here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    itemNameController.dispose();
    qtyController.dispose();
    stockController.dispose();
    rateController.dispose();
    unitController.dispose();
    amountController.dispose();
    taxController.dispose();
    discountController.dispose();
    sgstController.dispose();
    cgstController.dispose();
    igstController.dispose();
    netAmountController.dispose();

    super.dispose();
  }

  void clearPreviousValues() {
    itemNameController.clear();
    qtyController.clear();
    rateController.clear();
    stockController.clear();
    discountController.clear();
    price2Controller.clear();

    rateController.clear();
    unitController.clear();
    amountController.clear();
    taxController.clear();
    sgstController.clear();
    cgstController.clear();
    netAmountController.clear();
    discountRateController.clear();
    originaldiscountController.clear();
    igstController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider =
        Provider.of<OnChangeItenProvider>(context, listen: false);
    return Row(
      children: [
        Consumer<OnChangeLedgerProvider>(
          builder: (context, value, _) {
            cat = value.ledger;
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
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff000000)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      //Item
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
                            initialSelection: itemNameController
                                        .text.isNotEmpty &&
                                    widget.itemsList!.isNotEmpty
                                ? widget.itemsList!.firstWhere(
                                    (element) =>
                                        element.id == itemNameController.text,
                                    orElse: () => widget.itemsList!.first)
                                : null,
                            enableSearch: true,
                            trailingIcon: const SizedBox.shrink(),
                            textStyle: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff000000),
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
                            width: MediaQuery.of(context).size.width * 0.19,
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

                                qtyController.text = '';
                                discountController.text = '0.00';

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
                                    taxController.text = item.taxCategory;
                                    widget.taxControllerP.text =
                                        taxController.text;
                                  }
                                }

                                for (Item item in widget.itemsList!) {
                                  if (item.id == selectedItemId) {
                                    newId2 = item.measurementUnit;
                                    unitController.text = item.measurementUnit;
                                    widget.unitControllerP.text =
                                        unitController.text;

                                    stockController.text =
                                        item.maximumStock.toString();

                                    print(stockController.text);
                                  }
                                }

                                for (TaxRate tax in widget.taxLists!) {
                                  if (tax.id == newId) {
                                    setState(() {
                                      taxController.text =
                                          items.isNotEmpty ? tax.rate : '0';
                                      widget.taxControllerP.text =
                                          taxController.text;
                                    });
                                  }
                                }
                                for (MeasurementLimit meu
                                    in widget.measurement!) {
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
                                // Find the selected item
                                Item? selectedItem =
                                    widget.itemsList!.firstWhere(
                                  (item) => item.id == selectedItemId,
                                );

                                cat = _fetchedSingleLedger!.priceListCategory;
                                igstController.text = '0.0';

                                if (selectedItemId != null) {
                                  switch (cat) {
                                    case 'DEALER':
                                      // Find the item with the selectedItemId and get the dealer price
                                      var item = widget.itemsList!.firstWhere(
                                        (e) => e.id == selectedItemId,
                                      );
                                      rate2Controller.text = item != null
                                          ? item.dealer.toString()
                                          : '0.0';
                                      break;
                                    case 'SUB DEALER':
                                      // Find the item with the selectedItemId and get the sub dealer price
                                      var item = widget.itemsList!.firstWhere(
                                        (e) => e.id == selectedItemId,
                                      );
                                      rate2Controller.text = item != null
                                          ? item.subDealer.toString()
                                          : '0.0';
                                      break;
                                    case 'RETAIL':
                                      // Find the item with the selectedItemId and get the retail price
                                      var item = widget.itemsList!.firstWhere(
                                        (e) => e.id == selectedItemId,
                                      );
                                      rate2Controller.text = item != null
                                          ? item.retail.toString()
                                          : '0.0';
                                      break;
                                    case 'MRP':
                                      // Find the item with the selectedItemId and get the MRP
                                      var item = widget.itemsList!.firstWhere(
                                        (e) => e.id == selectedItemId,
                                      );
                                      rate2Controller.text = item != null
                                          ? item.mrp.toString()
                                          : '0.0';
                                      break;
                                    default:
                                      rate2Controller.text = '0.0';
                                  }
                                }
                                itemProvider.updateItemID(selectedItemId!);
                                _showAdditionalDetailsPopup(selectedItem);
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

                        // child: DropdownButton<String>(
                        //   value: selectedItemId,
                        //   underline: Container(),
                        //   onChanged: (String? newValue) {
                        //     setState(() {
                        //       selectedItemId = newValue;
                        //       qtyController.text = '';
                        //       setState(() {
                        //         itemNameController.text = selectedItemId!;
                        //         widget.itemNameControllerP.text =
                        //             itemNameController.text;
                        //       });
                        //       String newId = '';
                        //       String newId2 = '';
                        //       for (Item item in itemsList) {
                        //         if (item.id == selectedItemId) {
                        //           newId = item.taxCategory;
                        //           taxController.text = item.taxCategory;
                        //           widget.taxControllerP.text =
                        //               taxController.text;
                        //         }
                        //       }
                        //       for (Item item in itemsList) {
                        //         if (item.id == selectedItemId) {
                        //           newId2 = item.measurementUnit;
                        //           unitController.text = item.measurementUnit;
                        //           widget.unitControllerP.text =
                        //               unitController.text;
                        //           stockController.text =
                        //               item.maximumStock.toString();
                        //           print(stockController.text);
                        //         }
                        //       }
                        //       for (TaxRate tax in taxLists) {
                        //         if (tax.id == newId) {
                        //           setState(() {
                        //             taxController.text =
                        //                 items.isNotEmpty ? tax.rate : '0';
                        //             widget.taxControllerP.text =
                        //                 taxController.text;
                        //           });
                        //         }
                        //       }
                        //       for (MeasurementLimit meu in measurement) {
                        //         if (meu.id == newId2) {
                        //           setState(() {
                        //             unitController.text = items.isNotEmpty
                        //                 ? meu.measurement
                        //                 : '0';
                        //             widget.unitControllerP.text =
                        //                 unitController.text;
                        //           });
                        //         }
                        //       }
                        //       // Find the selected item
                        //       Item? selectedItem = itemsList.firstWhere(
                        //         (item) => item.id == selectedItemId,
                        //       );
                        //       cat = _fetchedSingleLedger!.priceListCategory;
                        //       igstController.text = '0.0';
                        //       if (selectedItemId != null) {
                        //         switch (cat) {
                        //           case 'DEALER':
                        //             rateController.text =
                        //                 selectedItem.dealer.toString();
                        //             break;
                        //           case 'SUB DEALER':
                        //             rateController.text =
                        //                 selectedItem.subDealer.toString();
                        //             break;
                        //           case 'RETAIL':
                        //             rateController.text =
                        //                 selectedItem.retail.toString();
                        //             break;
                        //           case 'MRP':
                        //             rateController.text =
                        //                 selectedItem.mrp.toString();
                        //             break;
                        //           default:
                        //             rateController.text = '0.0';
                        //         }
                        //       }
                        //       itemProvider.updateItemID(selectedItemId!);
                        //     });
                        //   },
                        //   isDense: true,
                        //   isExpanded: true,
                        //   items: itemsList.map((Item items) {
                        //     return DropdownMenuItem<String>(
                        //       value: items.id,
                        //       child: Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
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
                      //qty
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.061,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(),
                            top: BorderSide(),
                            left: BorderSide(),
                          ),
                        ),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff000000),
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          cursorHeight: 18,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(12.0),
                          ),
                          controller: qtyController,
                          onChanged: (value) {
                            double newQty = double.tryParse(value) ?? 0;
                            double stock =
                                double.tryParse(stockController.text) ?? 0;

                            if (newQty > stock) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Please Add Stock ${stockController.text} Left.'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              setState(() {
                                qtyController.text = stockController
                                    .text; // Reset to the maximum available stock
                                discountRateController.text =
                                    '0.00'; // Reset discount rate to 0
                                discountController.text =
                                    '0.00'; // Reset discount percentage to 0
                              });
                            } else {
                              // double rateWithTax = 13500;
                              double rateWithTax = double.tryParse(
                                      rateController.text.toString()) ??
                                  0;
                              double tax =
                                  double.tryParse(taxController.text) ?? 0;
                              double qty =
                                  double.tryParse(qtyController.text) ?? 0;

                              // Calculate base rate (excluding tax)
                              double baseRate = rateWithTax / (1 + (tax / 100));

                              // Calculate amount before tax
                              double amountBeforeTax = qty * baseRate;

                              // Calculate the tax amount
                              double taxAmount = (tax / 100) * amountBeforeTax;

                              // Calculate the GST (split the tax amount into two equal parts)
                              double gst = taxAmount / 2;

                              // Calculate the total amount including tax
                              double totalAmount = amountBeforeTax + taxAmount;

                              setState(() {
                                rate2Controller.text =
                                    baseRate.toStringAsFixed(2);

                                amountController.text =
                                    amountBeforeTax.toStringAsFixed(2);
                                sgstController.text = gst.toStringAsFixed(2);
                                cgstController.text = gst.toStringAsFixed(2);
                                netAmountController.text =
                                    totalAmount.toStringAsFixed(2);
                                originalNetAmount = totalAmount;
                                widget.amountControllerP.text =
                                    amountController.text;
                                widget.sgstControllerP.text =
                                    sgstController.text;
                                widget.cgstControllerP.text =
                                    cgstController.text;
                                widget.netAmountControllerP.text =
                                    netAmountController.text;
                                widget.qtyControllerP.text = qtyController.text;
                                widget.rateControllerP.text =
                                    rateController.text;
                                discountController.text = '0.00';
                                discountRateController.text = '0.00';
                                originaldiscountController.text = '0.00';
                              });

                              // Save values or update state as needed
                              _saveValues();
                            }
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      //Unit
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
                          ),
                          controller: unitController,
                          readOnly: true,
                          onSaved: (newValue) {
                            unitController.text = newValue!;
                          },
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                      //Price
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
                          ),

                          controller: rate2Controller,
                          readOnly: true,

                          onSaved: (newValue) {
                            rate2Controller.text = newValue!;
                          },
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff000000),
                          ),

                          // keyboardType: TextInputType.number,
                        ),
                      ),
                      //amount
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
                          ),
                          controller: amountController,
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                      //discountrate
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.061,
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(),
                                top: BorderSide(),
                                left: BorderSide())),
                        child: TextFormField(
                          controller: discountRateController,
                          onEditingComplete: () {
                            double discountAmount =
                                double.tryParse(discountRateController.text) ??
                                    0;
                            print('discountAmount $discountAmount');
                            double qty =
                                double.tryParse(qtyController.text) ?? 0;
                            double rateWithTax = double.tryParse(
                                    rate2Controller.text.toString()) ??
                                0;
                            double tax =
                                double.tryParse(taxController.text) ?? 0;

                            // Calculate base rate (excluding tax)
                            double baseRate = rateWithTax / (1 + (tax / 100));
                            print('baseRate $baseRate');

                            // Calculate total amount before discount and tax
                            double amountBeforeTax = qty * baseRate;
                            print('amountBeforeTax $amountBeforeTax');

                            double taxAmount = (tax / 100) * amountBeforeTax;
                            print('taxAmount $taxAmount');

                            double totalAmount = amountBeforeTax + taxAmount;
                            print('totalAmount $totalAmount');

                            // Calculate the net amount after discount
                            double discountedNetAmount =
                                totalAmount - discountAmount;
                            print('discountedNetAmount $discountedNetAmount');

                            // Calculate the amount before tax based on the discounted net amount
                            double discountedAmountBeforeTax =
                                discountedNetAmount / (1 + (tax / 100));
                            print(
                                'discountedAmountBeforeTax $discountedAmountBeforeTax');

                            // Calculate the new tax amount based on the discounted amount before tax
                            double discountedTaxAmount =
                                (tax / 100) * discountedAmountBeforeTax;
                            print('discountedTaxAmount $discountedTaxAmount');

                            double discountedGst = discountedTaxAmount / 2;
                            print('discountedGst $discountedGst');

                            // Calculate the effective discount amount on the base rate
                            double effectiveDiscount =
                                amountBeforeTax - discountedAmountBeforeTax;
                            print('effectiveDiscount $effectiveDiscount');

                            double discountPercentage =
                                (effectiveDiscount / amountBeforeTax) * 100;
                            print('discountPercentage $discountPercentage');

                            setState(() {
                              // Update controllers with the new values
                              discountController.text =
                                  discountPercentage.toStringAsFixed(2);
                              sgstController.text =
                                  discountedGst.toStringAsFixed(2);
                              cgstController.text =
                                  discountedGst.toStringAsFixed(2);
                              netAmountController.text =
                                  discountedNetAmount.toStringAsFixed(2);
                              discountRateController.text =
                                  effectiveDiscount.toStringAsFixed(2);
                              originaldiscountController.text =
                                  discountAmount.toStringAsFixed(2);
                            });

                            _saveValues();
                          },
                          readOnly: false,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff000000),
                          ),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(12.0),
                          ),
                        ),
                      ),
                      //dispercentage
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.061,
                        // padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(),
                                top: BorderSide(),
                                left: BorderSide())),
                        child: TextFormField(
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*$')),
                          ],
                          controller: discountController,
                          readOnly: true,
                          onSaved: (newValue) {
                            discountController.text = newValue!;
                          },
                          onChanged: (value) {
                            double discountPercentage =
                                double.tryParse(discountController.text) ?? 0;
                            double qty =
                                double.tryParse(qtyController.text) ?? 0;
                            double rateWithTax = double.tryParse(
                                    rateController.text.toString()) ??
                                0;
                            double tax =
                                double.tryParse(taxController.text) ?? 0;
                            // Calculate base rate (excluding tax)
                            double baseRate = rateWithTax / (1 + (tax / 100));
                            print('baseRate $baseRate');
                            // Calculate the discount amount as a percentage of the base rate
                            double discountAmountPerUnit =
                                baseRate * (discountPercentage / 100);
                            double totalDiscountAmount =
                                discountAmountPerUnit * qty;
                            print(
                                'discountAmountPerUnit $discountAmountPerUnit');
                            print('totalDiscountAmount $totalDiscountAmount');

                            // Calculate the rate after applying the discount percentage
                            double rateAfterDiscountPerUnit =
                                baseRate - discountAmountPerUnit;
                            print(
                                'rateAfterDiscountPerUnit $rateAfterDiscountPerUnit');

                            // Calculate the amount before tax
                            double amountBeforeTax =
                                qty * rateAfterDiscountPerUnit;
                            print('amountBeforeTax $amountBeforeTax');

                            // Calculate the total tax amount on the amount before tax
                            double taxAmount = (tax / 100) * amountBeforeTax;
                            print('taxAmount $taxAmount');

                            // Calculate the final amount including tax
                            double amountAfterTax = amountBeforeTax + taxAmount;
                            print('amountAfterTax $amountAfterTax');

                            // Split the tax amount into SGST and CGST
                            double gst = taxAmount / 2;

                            setState(() {
                              amountController.text =
                                  amountBeforeTax.toStringAsFixed(2);
                              netAmountController.text =
                                  amountAfterTax.toStringAsFixed(2);
                              sgstController.text = gst.toStringAsFixed(2);
                              cgstController.text = gst.toStringAsFixed(2);
                              discountRateController.text =
                                  totalDiscountAmount.toStringAsFixed(2);
                            });
                            _saveValues();
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(12.0),
                          ),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),

                      //tax
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
                          ),
                          onChanged: (value) {},
                          controller: taxController,
                          readOnly: true,
                          onSaved: (newValue) {
                            taxController.text = newValue!;
                          },
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                      //sgst
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
                          ),
                          controller: sgstController,
                          readOnly: true,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                      //cgst
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
                          ),
                          controller: cgstController,
                          readOnly: true,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                      //igst
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
                          ),
                          controller: igstController,
                          onChanged: (value) {
                            widget.igstControllerP.text = igstController.text;
                          },
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff000000),
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(
                                r'^\d*\.?\d*$')), // Allow digits and a single decimal point
                          ],
                        ),
                      ),
                      //netAmount
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
                          ),
                          controller: netAmountController,
                          readOnly: true,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
