import 'package:billingsphere/data/models/salesEntries/sales_entrires_model.dart';
import 'package:billingsphere/data/repository/sales_enteries_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../data/repository/ledger_repository.dart';
import '../searchable_dropdown.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class ReceiptBillwise extends StatefulWidget {
  const ReceiptBillwise({
    super.key,
    required this.ledgerID,
    required this.ledgerName,
    required this.debitAmount,
    required this.allValuesCallback,
    required this.onSave,
  });
  final String ledgerID;
  final String ledgerName;
  final double debitAmount;
  final Function(List<Map<String, dynamic>>) allValuesCallback;
  final VoidCallback onSave;

  @override
  State<ReceiptBillwise> createState() => _ChequeReturnEntryState();
}

class RowData {
  String selectedTypeOfRef;
  String? selectedSales;
  String? billno;
  String date;
  String amount;
  TextEditingController dateController;
  TextEditingController amountController;
  String uniqueKey;
  RowData({
    required this.selectedTypeOfRef,
    required this.selectedSales,
    required this.billno,
    required this.date,
    required this.amount,
    required this.dateController,
    required this.amountController,
  }) : uniqueKey = const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'selectedTypeOfRef': selectedTypeOfRef,
      'selectedSales': selectedSales,
      'billno': billno,
      'date': date,
      'amount': amount,
      'uniqueKey': uniqueKey,
    };
  }
}

class _ChequeReturnEntryState extends State<ReceiptBillwise> {
  List<String> typesofReference = [
    '',
    ' Against Ref.',
    ' New Ref.',
    ' On Account'
  ];
  String selectedTypeOfRef = '';
  bool isLoading = false;
  String? selectedSales;

  late double remainingAmount;
  final formatter = DateFormat('dd/MM/yyyy');

  final TextEditingController searchController = TextEditingController();
  final TextEditingController noController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  late ScrollController _horizontalController1;
  late ScrollController _horizontalController2;
  late LinkedScrollControllerGroup _horizontalControllersGroup;

  SalesEntryService saleServices = SalesEntryService();
  LedgerService ledgerService = LedgerService();

  List<SalesEntry> filteredSale = [];
  List<RowData> rowDataList = [];
  final List<Map<String, dynamic>> _allValuesBillwise = [];
  double totalAmount = 0.00;

  Future<void> getSale() async {
    final sale = await saleServices.fetchSalesEntries();
    setState(() {
      filteredSale = sale
          .where((element) =>
              element.party == widget.ledgerID &&
              (element.type == 'DEBIT' || element.type == 'MULTI MODE') &&
              element.dueAmount != '0')
          .toList();
    });

    print('filteredSale $filteredSale');
  }

  @override
  void initState() {
    getSale();
    remainingAmount = widget.debitAmount;
    dateController.text = formatter.format(DateTime.now());
    addNewRow();
    _horizontalControllersGroup = LinkedScrollControllerGroup();
    _horizontalController1 = _horizontalControllersGroup.addAndGet();
    _horizontalController2 = _horizontalControllersGroup.addAndGet();

    super.initState();
  }

  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  void addNewRow() {
    rowDataList.add(
      RowData(
        selectedTypeOfRef: '',
        selectedSales: null,
        date: formattedDate,
        amount: '',
        billno: '',
        dateController: TextEditingController(text: formattedDate),
        amountController: TextEditingController(),
      ),
    );
  }

  void saveValues(Map<String, dynamic> values) {
    final String uniqueKey = values['uniqueKey'];
    final existingEntryIndex = _allValuesBillwise.indexWhere(
      (entry) => entry['uniqueKey'] == uniqueKey,
    );

    setState(() {
      if (existingEntryIndex != -1) {
        _allValuesBillwise[existingEntryIndex] =
            values; // Update existing entry
      } else {
        _allValuesBillwise.add(values); // Add new entry
      }
    });
  }

  void updatetotalAmount() {
    totalAmount = rowDataList.fold(
        0.0, (sum, row) => sum + (double.tryParse(row.amount) ?? 0.0));
  }

  @override
  void dispose() {
    searchController.dispose();
    noController.dispose();
    amountController.dispose();
    dateController.dispose();
    for (var rowData in rowDataList) {
      rowData.dateController.dispose();
      rowData.amountController.dispose();
    }
    _horizontalController1.dispose();
    _horizontalController2.dispose();

    super.dispose();
  }

  Widget _buildRow(int index) {
    // Filter available sales to exclude already selected sales
    List<SalesEntry> availableSales = filteredSale.where((sale) {
      return !_allValuesBillwise
              .any((entry) => entry['selectedSales'] == sale.id) ||
          sale.id == rowDataList[index].selectedSales;
    }).toList();
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Container(
            decoration: BoxDecoration(border: Border.all()),
            width: 170,
            height: 40,
            alignment: Alignment.centerLeft,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: rowDataList[index].selectedTypeOfRef,
                underline: Container(),
                onChanged: (String? newValue) {
                  setState(() {
                    rowDataList[index].selectedTypeOfRef = newValue!;
                  });
                },
                items: typesofReference.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(value),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          width: 364,
          height: 40,
          decoration: BoxDecoration(border: Border.all()),
          child: SearchableDropDown(
            controller: searchController,
            searchController: searchController,
            value: rowDataList[index].selectedSales,
            onChanged: (String? newValue) {
              setState(() {
                rowDataList[index].selectedSales = newValue;
                // Assign billno here
                rowDataList[index].billno = availableSales
                    .firstWhere((sale) => sale.id == newValue)
                    .dcNo;
              });
            },
            items: availableSales.map((SalesEntry sale) {
              return DropdownMenuItem<String>(
                value: sale.id,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: [
                      Text('${sale.date} TI# ${sale.dcNo}'),
                      const Spacer(),
                      Text(sale.dueAmount),
                    ],
                  ),
                ),
              );
            }).toList(),
            searchMatchFn: (item, searchValue) {
              final itemMLimit =
                  availableSales.firstWhere((e) => e.id == item.value).dcNo;
              return itemMLimit
                  .toLowerCase()
                  .contains(searchValue.toLowerCase());
            },
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          width: 150,
          height: 40,
          decoration: BoxDecoration(border: Border.all()),
          child: TextFormField(
            controller: rowDataList[index].dateController,
            onChanged: (value) {
              setState(() {
                rowDataList[index].date = value;
              });
            },
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Container(
            width: 190,
            height: 40,
            decoration: BoxDecoration(border: Border.all()),
            alignment: Alignment.centerRight,
            child: TextFormField(
              controller: rowDataList[index].amountController,
              onFieldSubmitted: (value) {
                setState(() {
                  double enteredAmount = double.tryParse(value) ?? 0.0;
                  double dueAmount = double.tryParse(availableSales
                          .firstWhere((sale) =>
                              sale.id == rowDataList[index].selectedSales)
                          .dueAmount) ??
                      0.0;

                  double previousAmount =
                      double.tryParse(rowDataList[index].amount) ?? 0.0;
                  double amountDifference = enteredAmount - previousAmount;

                  // Validate the amount
                  if (enteredAmount <= dueAmount &&
                      (remainingAmount - amountDifference) >= 0) {
                    // If the amount is valid, update the amount and remaining amount
                    rowDataList[index].amount = value;
                    saveValues(rowDataList[index].toMap());
                    remainingAmount -= amountDifference;
                    updatetotalAmount();
                    // Add a new row with default values if remainingAmount > 0
                    if (remainingAmount > 0) {
                      rowDataList.add(
                        RowData(
                          selectedTypeOfRef: '',
                          selectedSales: null,
                          billno: '',
                          date: formattedDate,
                          amount: '',
                          dateController:
                              TextEditingController(text: formattedDate),
                          amountController: TextEditingController(),
                        ),
                      );
                    }
                  } else {
                    // Handle invalid amount case
                    print('Invalid amount entered');
                  }
                });
              },
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600) {
          return _buildMobileWidget();
        } else if (constraints.maxWidth >= 600 && constraints.maxWidth < 1200) {
          return _buildTabletWidget();
        } else {
          return _buildDesktopWidget();
        }
      },
    );
  }

  Widget _buildMobileWidget() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: SingleChildScrollView(
        child: SizedBox(
          height: 550,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 25,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                ),
                child: const Text(
                  "Billwise Reference",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                height: 525,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 30,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Ledger",
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(border: Border.all()),
                            height: 30,
                            width: 300,
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              ' ${widget.ledgerName}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 30,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Amount",
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(border: Border.all()),
                            height: 30,
                            width: 300,
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${(widget.debitAmount).toStringAsFixed(2)} ',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        width: 932,
                        height: 343,
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: _horizontalController1,
                              child: Row(
                                children: [
                                  Container(
                                    width: 180,
                                    height: 40,
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      '  Type of Reference',
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 364,
                                    height: 40,
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Particulars',
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 150,
                                    height: 40,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Date',
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 200,
                                    height: 40,
                                    alignment: Alignment.centerRight,
                                    child: const Text(
                                      'Amount     ',
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1, color: Colors.black),
                            SizedBox(
                              width: 932,
                              height: 300,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _horizontalController2,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 932,
                                      height: 300,
                                      child: ListView.builder(
                                        itemCount: rowDataList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return _buildRow(index);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),

                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 30,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Amount",
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(border: Border.all()),
                            height: 30,
                            width: 300,
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${totalAmount.toStringAsFixed(2)} ',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const SizedBox(),
                          const Spacer(),
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.yellow[100]),
                                foregroundColor:
                                    const WidgetStatePropertyAll(Colors.black),
                                shape: const WidgetStatePropertyAll(
                                  BeveledRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.zero),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                widget.allValuesCallback(_allValuesBillwise);
                                widget.onSave();

                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Save",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.yellow[100]),
                                foregroundColor:
                                    const WidgetStatePropertyAll(Colors.black),
                                shape: const WidgetStatePropertyAll(
                                  BeveledRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.zero),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(),
                        ],
                      ),

                      const SizedBox(height: 5),

                      //Buttons
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletWidget() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: SingleChildScrollView(
        child: SizedBox(
          height: 550,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 25,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                ),
                child: const Text(
                  "Billwise Reference",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                height: 525,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 30,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Ledger",
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(border: Border.all()),
                            height: 30,
                            width: 350,
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              ' ${widget.ledgerName}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 30,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Amount",
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(border: Border.all()),
                            height: 30,
                            width: 350,
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${(widget.debitAmount).toStringAsFixed(2)} ',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        width: 932,
                        height: 343,
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: _horizontalController1,
                              child: Row(
                                children: [
                                  Container(
                                    width: 180,
                                    height: 40,
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      '  Type of Reference',
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 364,
                                    height: 40,
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Particulars',
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 150,
                                    height: 40,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Date',
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 200,
                                    height: 40,
                                    alignment: Alignment.centerRight,
                                    child: const Text(
                                      'Amount     ',
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1, color: Colors.black),
                            SizedBox(
                              width: 932,
                              height: 300,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _horizontalController2,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 932,
                                      height: 300,
                                      child: ListView.builder(
                                        itemCount: rowDataList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return _buildRow(index);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),

                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 30,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Amount",
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(border: Border.all()),
                            height: 30,
                            width: 350,
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${totalAmount.toStringAsFixed(2)} ',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const SizedBox(),
                          const Spacer(),
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.yellow[100]),
                                foregroundColor:
                                    const WidgetStatePropertyAll(Colors.black),
                                shape: const WidgetStatePropertyAll(
                                  BeveledRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.zero),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                widget.allValuesCallback(_allValuesBillwise);
                                widget.onSave();

                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Save",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.yellow[100]),
                                foregroundColor:
                                    const WidgetStatePropertyAll(Colors.black),
                                shape: const WidgetStatePropertyAll(
                                  BeveledRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.zero),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(),
                        ],
                      ),

                      const SizedBox(height: 5),

                      //Buttons
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopWidget() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: SingleChildScrollView(
        child: SizedBox(
          height: 500,
          width: 932,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 25,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                ),
                child: const Text(
                  "Billwise Reference",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                height: 475,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Ledger name and amount
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 30,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Ledger",
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(border: Border.all()),
                            height: 30,
                            width: 300,
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              ' ${widget.ledgerName}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 80,
                            height: 30,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Amount",
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(border: Border.all()),
                            height: 30,
                            width: 150,
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${(widget.debitAmount).toStringAsFixed(2)} ',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),

                      const SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        width: 932,
                        height: 343,
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: _horizontalController1,
                              child: Row(
                                children: [
                                  Container(
                                    width: 180,
                                    height: 40,
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      '  Type of Reference',
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 364,
                                    height: 40,
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Particulars',
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 150,
                                    height: 40,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Date',
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 200,
                                    height: 40,
                                    alignment: Alignment.centerRight,
                                    child: const Text(
                                      'Amount     ',
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1, color: Colors.black),
                            SizedBox(
                              width: 932,
                              height: 300,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _horizontalController2,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 932,
                                      height: 300,
                                      child: ListView.builder(
                                        itemCount: rowDataList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return _buildRow(index);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),

                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 30,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Amount",
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(border: Border.all()),
                            height: 30,
                            width: 300,
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${totalAmount.toStringAsFixed(2)} ',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const SizedBox(),
                          const Spacer(),
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.yellow[100]),
                                foregroundColor:
                                    const WidgetStatePropertyAll(Colors.black),
                                shape: const WidgetStatePropertyAll(
                                  BeveledRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.zero),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                widget.allValuesCallback(_allValuesBillwise);
                                widget.onSave();

                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Save",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.yellow[100]),
                                foregroundColor:
                                    const WidgetStatePropertyAll(Colors.black),
                                shape: const WidgetStatePropertyAll(
                                  BeveledRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.zero),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(),
                        ],
                      ),

                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
