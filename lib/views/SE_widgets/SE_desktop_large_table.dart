import 'package:billingsphere/data/models/item/item_model.dart';
import 'package:billingsphere/data/models/taxCategory/tax_category_model.dart';
import 'package:billingsphere/data/repository/item_repository.dart';
import 'package:billingsphere/data/repository/tax_category_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SEDesktopLargeTable extends StatefulWidget {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  TextEditingController sgstController = TextEditingController();
  TextEditingController cgstController = TextEditingController();
  TextEditingController igstController = TextEditingController();
  TextEditingController netAmountController = TextEditingController();

  SEDesktopLargeTable({
    super.key,
    required this.itemNameController,
    required this.qtyController,
    required this.rateController,
    required this.unitController,
    required this.amountController,
    required this.taxController,
    required this.sgstController,
    required this.cgstController,
    required this.igstController,
    required this.netAmountController,
  });

  @override
  State<SEDesktopLargeTable> createState() => _SEDesktopLargeTableState();
}

class _SEDesktopLargeTableState extends State<SEDesktopLargeTable> {
  // Backend Services/Repositories
  ItemsService itemsService = ItemsService();
  TaxRateService taxRateService = TaxRateService();

  // Variables
  String? selectedItemId;
  String? selectedTaxRateId;

  // List of items
  List<Item> itemsList = [];
  List<TaxRate> taxLists = [];
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

  // Future Functions
  Future<void> fetchItems() async {
    try {
      final List<Item> items = await itemsService.fetchItems();

      
      for (TaxRate tax in taxLists) {
        if (tax.id == items.first.taxCategory) {
          print('Tax: ${tax.id}');
          setState(() {
            widget.taxController.text =
                items.isNotEmpty ? tax.rate : '0';
          });
        }
      }

      setState(() {
        itemsList = items;
        selectedItemId = itemsList.isNotEmpty ? itemsList.first.id : 'Select';
      });
    } catch (error) {
      // ignore: avoid_print
      print('Failed to fetch ledger name: $error');
    }
  }

  Future<void> fetchAndSetTaxRates() async {
    try {
      final List<TaxRate> taxRates = await taxRateService.fetchTaxRates();

      setState(() {
        taxLists = taxRates;
        selectedTaxRateId = taxLists.isNotEmpty ? taxLists.first.id : null;
      });
    } catch (error) {
      print('Failed to fetch Tax Rates: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchItems();
    fetchAndSetTaxRates();
    setId();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> items = List.generate(20, (index) => '${index + 1}');
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Table(
              columnWidths: {
                0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.03),
                1: FixedColumnWidth(MediaQuery.of(context).size.width * 0.46),
                2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.05),
                3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.05),
                4: FixedColumnWidth(MediaQuery.of(context).size.width * 0.05),
                5: FixedColumnWidth(MediaQuery.of(context).size.width * 0.05),
                6: FixedColumnWidth(MediaQuery.of(context).size.width * 0.05),
                7: FixedColumnWidth(MediaQuery.of(context).size.width * 0.05),
                8: FixedColumnWidth(MediaQuery.of(context).size.width * 0.05),
                9: FixedColumnWidth(MediaQuery.of(context).size.width * 0.05),
                10: FixedColumnWidth(MediaQuery.of(context).size.width * 0.05),
                11: FixedColumnWidth(MediaQuery.of(context).size.width * 0.05),
                12: FixedColumnWidth(MediaQuery.of(context).size.width * 0.05),
              },
              border: TableBorder.all(color: Colors.black),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: const [
                TableRow(
                  decoration: BoxDecoration(),
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'Sr',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'Item Name',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'Qty',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'Unit',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'Rate',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'Unit',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'Amount',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),

                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'Tax%',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'SGST',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'CGST',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'IGST',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'Net Amt.',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),

                    // Repeat the pattern for other cells
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Table(
                    columnWidths: {
                      0: FixedColumnWidth(
                          MediaQuery.of(context).size.width * 0.03),
                      1: FixedColumnWidth(
                          MediaQuery.of(context).size.width * 0.46),
                      2: FixedColumnWidth(
                          MediaQuery.of(context).size.width * 0.05),
                      3: FixedColumnWidth(
                          MediaQuery.of(context).size.width * 0.05),
                      4: FixedColumnWidth(
                          MediaQuery.of(context).size.width * 0.05),
                      5: FixedColumnWidth(
                          MediaQuery.of(context).size.width * 0.05),
                      6: FixedColumnWidth(
                          MediaQuery.of(context).size.width * 0.05),
                      7: FixedColumnWidth(
                          MediaQuery.of(context).size.width * 0.05),
                      8: FixedColumnWidth(
                          MediaQuery.of(context).size.width * 0.05),
                      9: FixedColumnWidth(
                          MediaQuery.of(context).size.width * 0.05),
                      10: FixedColumnWidth(
                          MediaQuery.of(context).size.width * 0.05),
                      11: FixedColumnWidth(
                          MediaQuery.of(context).size.width * 0.05),
                      12: FixedColumnWidth(
                          MediaQuery.of(context).size.width * 0.05),
                    },
                    border: TableBorder.all(color: Colors.black),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      for (String item in items)
                        TableRow(
                          children: [
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: DropdownButton<String>(
                                value: selectedItemId,
                                underline: Container(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedItemId = newValue;

                                    String newId = '';

                                    for (Item item in itemsList) {
                                      if (item.id == selectedItemId) {
                                        newId = item.taxCategory;
                                      }
                                    }

                                    for (TaxRate tax in taxLists) {
                                      if (tax.id == newId) {
                                        print('Tax: ${tax.id}');
                                        setState(() {
                                          widget.taxController.text =
                                              items.isNotEmpty ? tax.rate : '0';
                                        });
                                      }
                                    }
                                  });
                                },
                                isDense: true,
                                isExpanded: true,
                                items: itemsList.map((Item items) {
                                  return DropdownMenuItem<String>(
                                    value: items.id,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          items.itemName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: TextFormField(
                                controller: widget.qtyController,
                                onSaved: (newValue) {
                                  widget.qtyController.text = newValue!;
                                },
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: TextFormField(
                                controller: widget.unitController,
                                onSaved: (newValue) {
                                  widget.unitController.text = newValue!;
                                },
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: TextFormField(
                                controller: widget.rateController,
                                onSaved: (newValue) {
                                  widget.rateController.text = newValue!;
                                },
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: TextFormField(
                                controller: widget.unitController,
                                onSaved: (newValue) {
                                  widget.unitController.text = newValue!;
                                },
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: TextFormField(
                                controller: widget.amountController,
                                onSaved: (newValue) {
                                  widget.amountController.text = newValue!;
                                },
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: TextFormField(
                                controller: widget.taxController,
                                onSaved: (newValue) {
                                  widget.taxController.text = newValue!;
                                },
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: TextFormField(
                                controller: widget.sgstController,
                                onSaved: (newValue) {
                                  widget.sgstController.text = newValue!;
                                },
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: TextFormField(
                                controller: widget.cgstController,
                                onSaved: (newValue) {
                                  widget.cgstController.text = newValue!;
                                },
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: TextFormField(
                                controller: widget.igstController,
                                onSaved: (newValue) {
                                  widget.igstController.text = newValue!;
                                },
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: TextFormField(
                                controller: widget.netAmountController,
                                onSaved: (newValue) {
                                  widget.netAmountController.text = newValue!;
                                },
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Table(
              columnWidths: {
                0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.03),
                1: FixedColumnWidth(MediaQuery.of(context).size.width * 0.46),
                2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.05),
                3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.05),
                4: FixedColumnWidth(MediaQuery.of(context).size.width * 0.05),
                5: FixedColumnWidth(MediaQuery.of(context).size.width * 0.05),
                6: FixedColumnWidth(MediaQuery.of(context).size.width * 0.05),
                7: FixedColumnWidth(MediaQuery.of(context).size.width * 0.05),
                8: FixedColumnWidth(MediaQuery.of(context).size.width * 0.05),
                9: FixedColumnWidth(MediaQuery.of(context).size.width * 0.05),
                10: FixedColumnWidth(MediaQuery.of(context).size.width * 0.05),
                11: FixedColumnWidth(MediaQuery.of(context).size.width * 0.05),
                12: FixedColumnWidth(MediaQuery.of(context).size.width * 0.05),
              },
              border: TableBorder.all(color: Colors.black),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: const [
                TableRow(
                  decoration: BoxDecoration(),
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'Total',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '0.00',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '0.00',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '0.00',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '0.00',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '0.00',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '0.00',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '0.00',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),

                    // Repeat the pattern for other cells
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
