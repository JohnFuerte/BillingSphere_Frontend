import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/ledger/ledger_model.dart';
import '../../../data/models/receiptVoucher/receipt_voucher_model.dart' as re;
import '../../../data/models/receiptVoucher/receipt_voucher_model.dart';
import '../../../data/models/salesEntries/sales_entrires_model.dart';
import '../../../data/repository/ledger_repository.dart';
import '../../../data/repository/receipt_voucher_repository.dart';
import '../../../data/repository/sales_enteries_repository.dart';
import '../../RV_responsive/RV_receipt.dart';
import '../../searchable_dropdown.dart';
import '../ledger_statement2.dart';

class QuickEntryBillwiseReceipt extends StatefulWidget {
  const QuickEntryBillwiseReceipt({
    super.key,
    required this.id,
    required this.id2,
    required this.ledgerName,
    required this.ledgerName2,
    required this.totalamount,
    required this.narration,
    required this.lid,
    this.startDate,
    this.endDate,
  });
  final DateTime? startDate;
  final DateTime? endDate;

  final String id;
  final Ledger lid;
  final String id2;
  final String ledgerName;
  final String ledgerName2;
  final double totalamount;
  final String narration;

  @override
  State<QuickEntryBillwiseReceipt> createState() => _ChequeReturnEntryState();
}

class RowData {
  String selectedTypeOfRef;
  String? selectedSale;
  String? billno;
  String date;
  String amount;
  TextEditingController dateController;
  TextEditingController amountController;

  RowData({
    required this.selectedTypeOfRef,
    required this.selectedSale,
    required this.billno,
    required this.date,
    required this.amount,
    required this.dateController,
    required this.amountController,
  });

  Map<String, dynamic> toMap() {
    return {
      'selectedTypeOfRef': selectedTypeOfRef,
      'selectedSale': selectedSale,
      'billno': billno,
      'date': date,
      'amount': amount,
      'uniqueKey': selectedSale, // assuming `selectedSale` is unique
    };
  }
}

class _ChequeReturnEntryState extends State<QuickEntryBillwiseReceipt> {
  List<String> typesofReference = [
    '',
    ' Against Ref.',
    ' New Ref.',
    ' On Account'
  ];
  String selectedTypeOfRef = '';
  bool isLoading = false;
  String? selectedSale;
  String? selectedReceiptVch;
  int _generatedNumber = 0;

  late double remainingAmount;
  final formatter = DateFormat('dd/MM/yyyy');
  List<String>? companyCode;

  final TextEditingController searchController = TextEditingController();
  final TextEditingController noController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  SalesEntryService salesServices = SalesEntryService();
  ReceiptVoucherService receiptVoucherService = ReceiptVoucherService();
  LedgerService ledgerService = LedgerService();

  List<SalesEntry> filteredSales = [];
  List<ReceiptVoucher> fetchedReceiptVch = [];
  List<RowData> rowDataList = [];
  final List<Map<String, dynamic>> _allValues = [];
  double totalAmount = 0.00;
  Future<List<String>?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('companies');
  }

  Future<void> setCompanyCode() async {
    List<String>? code = await getCompanyCode();
    setState(() {
      companyCode = code;
    });
  }

  Future<void> getSales() async {
    final sale = await salesServices.fetchSalesEntries();
    setState(() {
      filteredSales = sale
          .where(
            (element) =>
                element.party == widget.id &&
                (element.type == 'DEBIT' || element.type == 'MULTI MODE') &&
                element.dueAmount != '0',
          )
          .toList();
    });
  }

  void _generateRandomNumber() {
    setState(() {
      if (fetchedReceiptVch.isEmpty) {
        _generatedNumber = 1;
      } else {
        // Find the maximum no value in suggestionItems6
        int maxNo = fetchedReceiptVch
            .map((e) => e.no)
            .reduce((value, element) => value > element ? value : element);
        _generatedNumber = maxNo + 1;
      }
      noController.text = _generatedNumber.toString();
    });
  }

  Future<void> fetchAllReceiptVch() async {
    final List<ReceiptVoucher> receiptVch =
        await receiptVoucherService.fetchReceiptVoucherEntries();

    setState(() {
      fetchedReceiptVch = receiptVch;
      _generateRandomNumber();

      if (fetchedReceiptVch.isNotEmpty) {
        selectedReceiptVch = fetchedReceiptVch[0].id;
      }
    });
  }

  Future<void> saveReceiptVouchertData() async {
    try {
      // Prepare entries for the receipt
      List<re.Entry> entries = [];
      List<re.Billwise> billwise = [];

      // Add entries for each selected sales
      double totalDebit = _allValues
          .map<double>((e) => double.parse(e['amount'].toString()))
          .reduce((value, element) => value + element);

      entries.add(
        re.Entry(
          account: 'Cr',
          ledger: widget.id,
          remark: '',
          debit: 0,
          credit: totalDebit,
        ),
      );

      // Add entry for the selected ledger
      entries.add(
        re.Entry(
          account: 'Dr',
          ledger: widget.id2,
          remark: '',
          debit: totalDebit,
          credit: 0,
        ),
      );
      // Adding billwise entries
      for (var value in _allValues) {
        billwise.add(
          re.Billwise(
            date: dateController.text,
            purchase: value['selectedSale'],
            amount: double.parse(value['amount'].toString()),
            billNo: value['billno'],
          ),
        );
      }

      // Create the ReceiptVoucher object
      ReceiptVoucher receiptVch = ReceiptVoucher(
        id: '', // Generate an ID for the payment
        companyCode: companyCode!.first,
        totalamount: _allValues
            .map<double>((e) => double.parse(e['amount'].toString()))
            .reduce((value, element) => value + element),
        no: int.parse(noController.text),
        date: dateController.text,
        entries: entries,
        billwise: billwise,
        narration: widget.narration,
      );

      print('ReceiptVoucher created: ${receiptVch.toJson()}');

      // Save the receipt voucher
      await receiptVoucherService
          .createReciptVoucher(receiptVch, context)
          .then((value) async {
        for (var value in _allValues) {
          var salesId = value['selectedSale'];
          var adjustmentAmount = double.parse(value['amount'].toString());

          SalesEntry? sales = await salesServices.fetchSalesById(salesId);
          if (sales != null) {
            double? dueAmount = double.tryParse(sales.dueAmount ?? '');
            if (dueAmount != null) {
              dueAmount -= adjustmentAmount;
              sales.dueAmount = dueAmount.toString();
              await salesServices.updateSalesEntry(sales);
            } else {
              print('Error: Unable to parse dueAmount.');
            }
          }
        }

        double totalAdjustmentAmount = _allValues
            .map<double>((e) => double.parse(e['amount'].toString()))
            .reduce((value, element) => value + element);

        Ledger? ledger = await ledgerService.fetchLedgerById(widget.id);
        if (ledger != null) {
          ledger.debitBalance -= totalAdjustmentAmount;
          await ledgerService.updateLedger2(
            ledger,
          );
        } else {
          print('Error: Unable to update Ledger.');
        }

        Ledger? ledger2 = await ledgerService.fetchLedgerById(widget.id2);
        if (ledger2 != null) {
          ledger2.debitBalance += totalAdjustmentAmount;
          await ledgerService.updateLedger2(
            ledger2,
          );
        } else {
          print('Error: Unable to update Ledger.');
        }

        setState(() {
          isLoading = false;
        });

        // _noController.clear();
        dateController.clear();

        fetchAllReceiptVch().then((_) {
          final newReceipt = fetchedReceiptVch.firstWhere(
            (element) => element.no == receiptVch.no,
            orElse: () => ReceiptVoucher(
              id: '',
              no: 0,
              date: '',
              companyCode: '',
              billwise: [],
              entries: [],
              totalamount: 0,
              narration: '',
            ),
          );
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Print Receipt"),
                content: const Text("Do you want to print the receipt?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => ReceiptVoucherPrint(
                            receiptID: newReceipt.id,
                            'RECEIPT VOUCHER PRINT',
                          ),
                        ),
                      );
                    },
                    child: const Text("Yes"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LedgerShow(
                            selectedLedger: widget.lid,
                            startDate: widget.startDate,
                            endDate: widget.endDate,
                          ),
                        ),
                      );
                    },
                    child: const Text("No"),
                  ),
                ],
              );
            },
          );
        });
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save payment: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    } catch (error) {
      print('Error in saveReceiptVouchertData: $error');
    }
  }

  @override
  void initState() {
    getSales();
    setCompanyCode();
    _generateRandomNumber();
    fetchAllReceiptVch();
    remainingAmount = widget.totalamount;
    dateController.text = formatter.format(DateTime.now());
    addNewRow();
    super.initState();
  }

  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  void addNewRow() {
    rowDataList.add(RowData(
      selectedTypeOfRef: '',
      selectedSale: null,
      date: formattedDate,
      amount: '',
      billno: '',
      dateController: TextEditingController(text: formattedDate),
      amountController: TextEditingController(),
    ));
  }

  void saveValues(Map<String, dynamic> values) {
    final String uniqueKey = values['uniqueKey'];
    final existingEntryIndex =
        _allValues.indexWhere((entry) => entry['uniqueKey'] == uniqueKey);

    setState(() {
      if (existingEntryIndex != -1) {
        _allValues.removeAt(existingEntryIndex);
      }
      _allValues.add(values);
      print('_allValues $_allValues');
    });
  }

  void updatetotalAmount() {
    totalAmount = rowDataList.fold(
        0.0, (sum, row) => sum + (double.tryParse(row.amount) ?? 0.0));

    // double totalEnteredAmount = _allValues.fold(
    //   0.0,
    //   (sum, entry) => sum + double.tryParse(entry['amount'])!,
    // );
    // setState(() {
    //   remainingAmount = widget.totalamount - totalEnteredAmount;
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildRow(int index) {
    // Filter available sales to exclude already selected sales
    List<SalesEntry> availableSales = filteredSales.where((sale) {
      return !_allValues.any((entry) => entry['uniqueKey'] == sale.id) ||
          sale.id == rowDataList[index].selectedSale;
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
            value: rowDataList[index].selectedSale,
            onChanged: (String? newValue) {
              setState(() {
                rowDataList[index].selectedSale = newValue;
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
                              sale.id == rowDataList[index].selectedSale)
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
                      rowDataList.add(RowData(
                        selectedTypeOfRef: '',
                        selectedSale: null,
                        billno: '',
                        date: formattedDate,
                        amount: '',
                        dateController:
                            TextEditingController(text: formattedDate),
                        amountController: TextEditingController(),
                      ));
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.59,
          width: MediaQuery.of(context).size.width * 0.5,
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
                height: MediaQuery.of(context).size.height * 0.55,
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
                              '${(widget.totalamount).toStringAsFixed(2)} ',
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                            ),
                            width: 932,
                            height: 360,
                            child: Column(
                              children: [
                                Row(
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
                                const Divider(height: 1, color: Colors.black),
                                Expanded(
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
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 45,
                            width: 942,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 20),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        Colors.yellow[100]),
                                    foregroundColor:
                                        const WidgetStatePropertyAll(
                                            Colors.black),
                                    shape: const WidgetStatePropertyAll(
                                      BeveledRectangleBorder(
                                        borderRadius:
                                            BorderRadius.all(Radius.zero),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    "Pending Bills",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  height: 30,
                                  width: 150,
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
                                const SizedBox(width: 20),
                              ],
                            ),
                          ),
                        ],
                      ),

                      //Buttons
                      Row(
                        children: [
                          SizedBox(
                              height: 45,
                              width: 942,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          Colors.yellow[100]),
                                      foregroundColor:
                                          const WidgetStatePropertyAll(
                                              Colors.black),
                                      shape: const WidgetStatePropertyAll(
                                        BeveledRectangleBorder(
                                          borderRadius:
                                              BorderRadius.all(Radius.zero),
                                        ),
                                      ),
                                    ),
                                    onPressed: saveReceiptVouchertData,
                                    child: const Text(
                                      "Save",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          Colors.yellow[100]),
                                      foregroundColor:
                                          const WidgetStatePropertyAll(
                                              Colors.black),
                                      shape: const WidgetStatePropertyAll(
                                        BeveledRectangleBorder(
                                          borderRadius:
                                              BorderRadius.all(Radius.zero),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
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
