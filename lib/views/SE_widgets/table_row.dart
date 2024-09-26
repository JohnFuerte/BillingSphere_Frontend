// ignore: file_names
// ignore_for_file: unnecessary_null_comparison

import 'package:billingsphere/data/models/item/item_model.dart';
import 'package:billingsphere/data/models/measurementLimit/measurement_limit_model.dart';
import 'package:billingsphere/data/models/taxCategory/tax_category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../auth/providers/onchange_item_provider.dart';
import '../../auth/providers/onchange_ledger_provider.dart';
import '../../data/repository/ledger_repository.dart';

class SEntries extends StatefulWidget {
  final int serialNumber;

  const SEntries({
    super.key,
    required this.serialNumber,
    required this.itemNameControllerP,
    required this.qtyControllerP,
    required this.rateControllerP,
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
    this.itemsList,
    this.measurement,
    this.taxLists,

    // Create Cont
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
  final String selectedLegerId;
  final Function(Map<String, dynamic>) onSaveValues;
  final Function(String) onDelete;
  final String entryId;
  final List<Item>? itemsList;
  final List<MeasurementLimit>? measurement;
  final List<TaxRate>? taxLists;
  @override
  State<SEntries> createState() => _SEntriesState();
}

class _SEntriesState extends State<SEntries> {
  late TextEditingController itemNameController;
  late TextEditingController qtyController;
  late TextEditingController stockController;
  late TextEditingController discountController;
  late TextEditingController priceController;
  late TextEditingController rateController;
  late TextEditingController unitController;
  late TextEditingController amountController;
  late TextEditingController taxController;
  late TextEditingController sgstController;
  late TextEditingController cgstController;
  final TextEditingController igstController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController price2Controller = TextEditingController();
  final TextEditingController discountRateController = TextEditingController();
  final TextEditingController originaldiscountController =
      TextEditingController();
  late TextEditingController netAmountController;
  double originalNetAmount = 0.0;
  late TextEditingController additionalInfoController;

  late FocusNode itemNameFocusNode;
  late FocusNode remarkFocusNode;

  // Variables
  String? selectedItemId;
  String? selectedTaxRateId;
  String? selectedPriceTypeId;
  String? selectedmeasurementId;
  double itemRate = 0.0;
  double stock = 0.0;
  double price = 0.0;
  bool isLoading = false;

  //Ledger
  LedgerService ledgerService = LedgerService();
  String? selectedLedgerName;
  String? selectedPersonType;
  List<String>? company = [];

  void _saveValues() {
    final values = {
      'uniqueKey': widget.entryId,
      'itemName': itemNameController.text,
      'qty': qtyController.text,
      'unit': unitController.text,
      'rate': priceController.text,
      'baseRate': price2Controller.text,
      'unit2': unitController.text,
      'amount': amountController.text,
      'tax': taxController.text,
      'discount': discountRateController.text,
      'originaldiscount': originaldiscountController.text,
      'sgst': sgstController.text,
      'cgst': cgstController.text,
      'igst': igstController.text,
      'netAmount': netAmountController.text,
      'additionalInfo': additionalInfoController.text,
    };
    print(values);

    widget.onSaveValues(values);
  }

  void clearPreviousValues() {
    itemNameController.clear();
    qtyController.clear();
    rateController.clear();
    stockController.clear();
    discountController.clear();
    priceController.clear();
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
  void initState() {
    super.initState();

    itemNameController = TextEditingController();
    qtyController = TextEditingController();
    stockController = TextEditingController();
    discountController = TextEditingController();
    priceController = TextEditingController();
    rateController = TextEditingController();
    unitController = TextEditingController();
    amountController = TextEditingController();
    taxController = TextEditingController();
    sgstController = TextEditingController();
    cgstController = TextEditingController();
    netAmountController = TextEditingController();
    additionalInfoController = TextEditingController();
    itemNameFocusNode = FocusNode();
    remarkFocusNode = FocusNode();
  }

  void _showAdditionalDetailsPopup(Item item) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(remarkFocusNode);
        });

        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
          backgroundColor: Colors.white,
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
          title: Container(
            constraints: BoxConstraints(
              minHeight: 50,
              maxHeight: 50,
              maxWidth: MediaQuery.of(context).size.width * 0.50,
              minWidth: MediaQuery.of(context).size.width * 0.50,
            ),
            color: Colors.blue,
            padding: const EdgeInsets.all(16.0),
            child: Text(
              textAlign: TextAlign.center,
              '${item.itemName} ADDTIONAL DETAILS',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.40,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                focusNode: remarkFocusNode,
                controller: additionalInfoController,
                maxLines: 3,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                    labelText: 'Remarks',
                    labelStyle: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)))),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Unfocus the text field
                remarkFocusNode.unfocus();
                itemNameFocusNode.unfocus();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(),
              ),
            ),
            TextButton(
              onPressed: () {
                remarkFocusNode.unfocus();
                itemNameFocusNode.unfocus();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepPurple,
              ),
              child: Text(
                'Save',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider =
        Provider.of<OnChangeItenProvider>(context, listen: false);
    // final ledgerProvider =
    //     Provider.of<OnChangeLedgerProvider>(context, listen: false);

    return FocusScope(
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Consumer<OnChangeLedgerProvider>(
              builder: (context, value, _) {
                // Get the ledger and store in a variable
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
                          alignment: Alignment.center,
                          child: Text(
                            '${widget.serialNumber}',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff000000)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        //Item

                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.19,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(),
                              left: BorderSide(),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownMenu<Item>(
                              focusNode: itemNameFocusNode,
                              requestFocusOnTap: true,
                              initialSelection: null,
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
                                if (value != null) {
                                  setState(() {
                                    // Clear the previous values
                                    clearPreviousValues();

                                    selectedItemId = value.id;
                                    selectedmeasurementId = value.id;

                                    itemNameController.text = selectedItemId!;
                                    widget.itemNameControllerP.text =
                                        itemNameController.text;

                                    igstController.text = '0.00';
                                    discountController.text = '0.00';

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
                                              widget.itemsList!.isNotEmpty
                                                  ? tax.rate
                                                  : '0';
                                          widget.taxControllerP.text =
                                              taxController.text;
                                        });
                                      }
                                    }

                                    for (MeasurementLimit meu
                                        in widget.measurement!) {
                                      if (meu.id == newId2) {
                                        setState(() {
                                          unitController.text =
                                              widget.itemsList!.isNotEmpty
                                                  ? meu.measurement
                                                  : '0';
                                          widget.unitControllerP.text =
                                              unitController.text;
                                        });
                                      }
                                    }

                                    var item = widget.itemsList!.firstWhere(
                                      (e) => e.id == selectedItemId,
                                    );

                                    stockController.text = item != null
                                        ? item.maximumStock.toString()
                                        : '0.0';

                                    if (selectedItemId != null) {
                                      switch (cat) {
                                        case 'DEALER':
                                          priceController.text =
                                              item.dealer.toString();
                                          break;
                                        case 'SUB DEALER':
                                          priceController.text =
                                              item.subDealer.toString();
                                          break;
                                        case 'RETAIL':
                                          priceController.text =
                                              item.retail.toString();
                                          break;
                                        case 'MRP':
                                          priceController.text =
                                              item.mrp.toString();
                                          break;
                                        default:
                                          priceController.text = '0.0';
                                      }
                                    }

                                    itemProvider.updateItemID(selectedItemId!);

                                    _saveValues();

                                    _showAdditionalDetailsPopup(item);
                                  });

                                  print(selectedLedgerName);
                                }
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

                        // Container(
                        //   height: 40,
                        //   width: MediaQuery.of(context).size.width * 0.19,
                        //   decoration: const BoxDecoration(
                        //       border: Border(
                        //           bottom: BorderSide(),
                        //           // top: BorderSide(),
                        //           left: BorderSide())),
                        //   child: DropdownButtonHideUnderline(
                        //     child: DropdownButton2<String>(
                        //       isExpanded: true,
                        //       isDense: true,
                        //       underline: Container(),
                        //       iconStyleData: const IconStyleData(
                        //         icon: SizedBox.shrink(),
                        //       ),
                        //       selectedItemBuilder: (context) {
                        //         return widget.itemsList!.map((Item items) {
                        //           return Text(
                        //             items.itemName,
                        //             style: GoogleFonts.poppins(
                        //                 fontSize: 16,
                        //                 fontWeight: FontWeight.bold,
                        //                 color: const Color(0xff000000)),
                        //             maxLines: 2,
                        //             overflow: TextOverflow.ellipsis,
                        //           );
                        //         }).toList();
                        //       },
                        //       hint: Text(
                        //         '',
                        //         style: TextStyle(
                        //           fontSize: 14,
                        //           color: Theme.of(context).hintColor,
                        //         ),
                        //       ),
                        //       items: widget.itemsList!.map((Item items) {
                        //         return DropdownMenuItem<String>(
                        //           value: items.id,
                        //           child: Row(
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //             mainAxisAlignment: MainAxisAlignment.start,
                        //             children: [
                        //               SizedBox(
                        //                 width: 150,
                        //                 child: Text(
                        //                   items.itemName,
                        //                   style: GoogleFonts.poppins(
                        //                       fontSize: 16,
                        //                       fontWeight: FontWeight.bold,
                        //                       color: const Color(0xff000000)),
                        //                   overflow: TextOverflow.ellipsis,
                        //                   maxLines: 2,
                        //                 ),
                        //               ),
                        //               const Spacer(),
                        //               Text(
                        //                 ' Qty: ${(items.maximumStock).toString()}',
                        //                 style: GoogleFonts.poppins(
                        //                     fontSize: 16,
                        //                     fontWeight: FontWeight.bold,
                        //                     color: const Color(0xff000000)),
                        //                 overflow: TextOverflow.ellipsis,
                        //                 maxLines: 1,
                        //               ),
                        //               const Spacer(),
                        //               Text(
                        //                 ' Rate: ${(items.retail).toString()}',
                        //                 style: GoogleFonts.poppins(
                        //                     fontSize: 16,
                        //                     fontWeight: FontWeight.bold,
                        //                     color: const Color(0xff000000)),
                        //                 overflow: TextOverflow.ellipsis,
                        //                 maxLines: 1,
                        //               ),
                        //             ],
                        //           ),
                        //         );
                        //       }).toList(),
                        //       value: selectedItemId,
                        //       onChanged: (String? newValue) {},
                        //       buttonStyleData: const ButtonStyleData(
                        //         padding: EdgeInsets.symmetric(
                        //           horizontal: 16,
                        //         ),
                        //         height: 40,
                        //         width: 200,
                        //       ),
                        //       dropdownStyleData: const DropdownStyleData(
                        //         maxHeight: 200,
                        //       ),
                        //       menuItemStyleData: const MenuItemStyleData(
                        //         height: 50,
                        //       ),
                        //       dropdownSearchData: DropdownSearchData(
                        //         searchController: searchController,
                        //         searchInnerWidgetHeight: 50,
                        //         searchInnerWidget: Container(
                        //           height: 50,
                        //           padding: const EdgeInsets.only(
                        //             top: 8,
                        //             bottom: 4,
                        //             right: 8,
                        //             left: 8,
                        //           ),
                        //           child: TextFormField(
                        //             onChanged: (value) {},
                        //             expands: true,
                        //             maxLines: null,
                        //             controller: searchController,
                        //             decoration: InputDecoration(
                        //               isDense: true,
                        //               contentPadding: const EdgeInsets.symmetric(
                        //                 horizontal: 10,
                        //                 vertical: 8,
                        //               ),
                        //               hintText: 'Search for an item...',
                        //               hintStyle: const TextStyle(fontSize: 12),
                        //               border: OutlineInputBorder(
                        //                 borderRadius: BorderRadius.circular(
                        //                   8,
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //         searchMatchFn: (DropdownMenuItem<String> item,
                        //             String searchValue) {
                        //           final itemName = widget.itemsList!
                        //               .firstWhere((e) => e.id == item.value)
                        //               .itemName;
                        //           return itemName
                        //               .toLowerCase()
                        //               .contains(searchValue.toLowerCase());
                        //         },
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        //QTY
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.061,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(),
                                  // top: BorderSide(),
                                  left: BorderSide())),
                          alignment: Alignment.center,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            cursorHeight: 18,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff000000),
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(16.0),
                            ),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: qtyController,
                            onChanged: (value) {
                              double qty = double.tryParse(value) ?? 0;
                              double stock =
                                  double.tryParse(stockController.text) ?? 0;
                              if (qty > stock) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Please Add Stock ${stockController.text} Left.',
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                                qtyController.text = stockController.text;
                              } else {
                                double rateWithTax = double.tryParse(
                                        priceController.text.toString()) ??
                                    0;
                                double tax =
                                    double.tryParse(taxController.text) ?? 0;
                                double qty =
                                    double.tryParse(qtyController.text) ?? 0;

                                // Calculate base rate (excluding tax)
                                double baseRate =
                                    rateWithTax / (1 + (tax / 100));

                                // Calculate amount before tax
                                double amountBeforeTax = qty * baseRate;

                                // Calculate the tax amount
                                double taxAmount =
                                    (tax / 100) * amountBeforeTax;

                                // Calculate the GST (split the tax amount into two equal parts)
                                double gst = taxAmount / 2;

                                // Calculate the total amount including tax
                                double totalAmount =
                                    amountBeforeTax + taxAmount;

                                setState(() {
                                  price2Controller.text =
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
                                  widget.qtyControllerP.text =
                                      qtyController.text;
                                  widget.rateControllerP.text =
                                      rateController.text;
                                  discountController.text = '0.00';
                                  discountRateController.text = '0.00';
                                });
                              }
                              _saveValues();
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
                                  // top: BorderSide(),
                                  left: BorderSide())),
                          alignment: Alignment.center,
                          child: TextFormField(
                            controller: unitController,
                            readOnly: true,
                            onSaved: (newValue) {
                              unitController.text = newValue!;
                            },
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                            ),
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
                                  // top: BorderSide(),
                                  left: BorderSide())),
                          alignment: Alignment.center,
                          child: TextFormField(
                            // itemRate.toString(),

                            controller: price2Controller,
                            readOnly: true,

                            onSaved: (newValue) {
                              price2Controller.text = newValue!;
                            },
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                            ),

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
                                  // top: BorderSide(),
                                  left: BorderSide())),
                          alignment: Alignment.center,
                          child: TextFormField(
                            controller: amountController,
                            readOnly: true,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff000000),
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
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
                                  // top: BorderSide(),
                                  left: BorderSide())),
                          alignment: Alignment.center,
                          child: TextFormField(
                            controller: discountRateController,
                            // onChanged: (value) {
                            //   double discountAmount = double.tryParse(value) ?? 0;
                            //   double qty = double.tryParse(qtyController.text) ?? 0;
                            //   double rateWithTax = double.tryParse(
                            //           priceController.text.toString()) ??
                            //       0;
                            //   double tax = double.tryParse(taxController.text) ?? 0;
                            //   // Calculate base rate (excluding tax)
                            //   double baseRate = rateWithTax / (1 + (tax / 100));
                            //   print('baseRate $baseRate');
                            //   // Calculate total amount before discount and tax
                            //   double amountBeforeTax = qty * baseRate;
                            //   print('amountBeforeTax $amountBeforeTax');
                            //   double taxAmount = (tax / 100) * amountBeforeTax;
                            //   print('taxAmount $taxAmount');
                            //   double totalAmount = amountBeforeTax + taxAmount;
                            //   print('totalAmount $totalAmount');
                            //   // Calculate the net amount after discount
                            //   double discountedNetAmount =
                            //       totalAmount - discountAmount;
                            //   print('discountedNetAmount $discountedNetAmount');
                            //   // Calculate the amount before tax based on the discounted net amount
                            //   double discountedAmountBeforeTax =
                            //       discountedNetAmount / (1 + (tax / 100));
                            //   print(
                            //       'discountedAmountBeforeTax $discountedAmountBeforeTax');
                            //   // Calculate the new tax amount based on the discounted amount before tax
                            //   double discountedTaxAmount =
                            //       (tax / 100) * discountedAmountBeforeTax;
                            //   print('discountedTaxAmount $discountedTaxAmount');
                            //   double discountedGst = discountedTaxAmount / 2;
                            //   print('discountedGst $discountedGst');
                            //   // Calculate the effective discount amount on the base rate
                            //   double effectiveDiscount =
                            //       amountBeforeTax - discountedAmountBeforeTax;
                            //   print('effectiveDiscount $effectiveDiscount');
                            //   double discountPercentage =
                            //       (effectiveDiscount / amountBeforeTax) * 100;
                            //   print('discountPercentage $discountPercentage');
                            //   setState(() {
                            //     // Update controllers with the new values
                            //     discountController.text =
                            //         discountPercentage.toStringAsFixed(2);
                            //     sgstController.text =
                            //         discountedGst.toStringAsFixed(2);
                            //     cgstController.text =
                            //         discountedGst.toStringAsFixed(2);
                            //     netAmountController.text =
                            //         discountedNetAmount.toStringAsFixed(2);
                            //     // discountRateController.text =
                            //     //     effectiveDiscount.toStringAsFixed(2);
                            //   });
                            //   _saveValues();
                            // },
                            onEditingComplete: () {
                              double discountAmount = double.tryParse(
                                      discountRateController.text) ??
                                  0;
                              print('discountAmount $discountAmount');
                              double qty =
                                  double.tryParse(qtyController.text) ?? 0;
                              double rateWithTax = double.tryParse(
                                      priceController.text.toString()) ??
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
                              contentPadding: EdgeInsets.all(10.0),
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
                                // top: BorderSide(),
                                left: BorderSide()),
                          ),
                          alignment: Alignment.center,

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
                                      priceController.text.toString()) ??
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
                              double amountAfterTax =
                                  amountBeforeTax + taxAmount;
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
                              contentPadding: EdgeInsets.all(10.0),
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
                                  // top: BorderSide(),
                                  left: BorderSide())),
                          alignment: Alignment.center,
                          child: TextFormField(
                            onChanged: (value) {},
                            controller: taxController,
                            readOnly: true,
                            onSaved: (newValue) {
                              taxController.text = newValue!;
                            },
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                            ),
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
                                  // top: BorderSide(),
                                  left: BorderSide())),
                          alignment: Alignment.center,
                          child: TextFormField(
                            controller: sgstController,
                            readOnly: true,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff000000),
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
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
                                  // top: BorderSide(),
                                  left: BorderSide())),
                          alignment: Alignment.center,
                          child: TextFormField(
                            controller: cgstController,
                            readOnly: true,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff000000),
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
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
                                  // top: BorderSide(),
                                  left: BorderSide())),
                          alignment: Alignment.center,
                          child: TextFormField(
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
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                            ),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*$')),
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
                                  // top: BorderSide(),
                                  right: BorderSide())),
                          alignment: Alignment.center,
                          child: TextFormField(
                            controller: netAmountController,
                            readOnly: true,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff000000),
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
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
        ),
      ),
    );
  }
}
