// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:billingsphere/data/models/ledger/ledger_model.dart';
import 'package:billingsphere/data/models/payment/payment_model.dart';
import 'package:billingsphere/data/repository/ledger_repository.dart';
import 'package:billingsphere/data/repository/payment_respository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/purchase/purchase_model.dart';
import '../../data/repository/purchase_repository.dart';
import '../DB_homepage.dart';
import '../RV_responsive/RV_desktopBody.dart';
import '../searchable_dropdown.dart';
import '../sumit_screen/voucher _entry.dart/voucher_list_widget.dart';
import 'payment_billwise.dart';
import 'payment_home.dart';
import 'payment_receipt2.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class PMMyPaymentDesktopBody extends StatefulWidget {
  const PMMyPaymentDesktopBody({super.key});

  @override
  State<PMMyPaymentDesktopBody> createState() => _PMMyPaymentDesktopBodyState();
}

class RowData {
  String type;
  String? ledger;
  String? remarks;
  String debit;
  String credit;
  TextEditingController remarksController;
  TextEditingController debitController;
  TextEditingController creditController;
  bool isDebit;
  bool isCredit;
  String uniqueKey;
  String? ledgerGroup;

  RowData({
    required this.type,
    required this.ledger,
    required this.remarks,
    required this.debit,
    required this.credit,
    required this.remarksController,
    required this.debitController,
    required this.creditController,
    this.isDebit = true,
    this.isCredit = false,
    this.ledgerGroup,
  }) : uniqueKey = const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'ledger': ledger,
      'remarks': remarks,
      'debit': debit,
      'credit': credit,
      'uniqueKey': uniqueKey,
      'isDebit': isDebit,
      'isCredit': isCredit,
    };
  }
}

class _PMMyPaymentDesktopBodyState extends State<PMMyPaymentDesktopBody> {
  @override
  void initState() {
    super.initState();
    _horizontalControllersGroup = LinkedScrollControllerGroup();
    _horizontalController1 = _horizontalControllersGroup.addAndGet();
    _horizontalController2 = _horizontalControllersGroup.addAndGet();

    _initializeData();
    addNewRow();
  }

  void _initializeData() async {
    await setCompanyCode();
    await fetchPayment();
    await fetchLedger();
    _selectedDate = DateTime.now();
    _dateController.text = formatter.format(_selectedDate!);
    formattedDay = DateFormat('EEE').format(_selectedDate!);
  }

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
    _noController.dispose();
    _narrationController.dispose();
    _horizontalController1.dispose();
    _horizontalController2.dispose();
  }

  List<String> types = [
    'Dr',
    'Cr',
  ];
  String type = '';
  String? ledger;
  double ledgerAmount = 0;
  String ledgerName = '';
  int ledgerMo = 0;
  String ledgerState = '';
  String? selectedLedgerName;
  double totalDebitAmount = 0.0;
  int debitRowCount = 0;

  double totalCreditAmount = 0.0;
  int creditRowCount = 0;

  final formatter = DateFormat('dd/MM/yyyy');
  DateTime? _selectedDate;
  DateTime? _selectedChqDate;
  DateTime? _selectedDepoDate;
  String? formattedChqDay;
  String? formattedDepoDay;
  String formattedDay = '';

  // TextControllers
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _noController = TextEditingController();
  final TextEditingController _narrationController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _chequeNoController = TextEditingController();
  final TextEditingController _chequeDateController = TextEditingController();
  final TextEditingController _depositDateController = TextEditingController();
  final TextEditingController _batchNoController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();

  //Services
  PaymentService paymentServices = PaymentService();
  LedgerService ledgerServices = LedgerService();
  PurchaseServices purchaseServices = PurchaseServices();

  List<Payment> suggestedPayment = [];
  List<Ledger> suggestedLedger = [];
  List<Purchase> suggestedPurchase = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<RowData> rowDataList = [];
  final List<Map<String, dynamic>> _allValues = [];
  final List<Map<String, dynamic>> _allValuesBillwise = [];

  late ScrollController _horizontalController1;
  late ScrollController _horizontalController2;
  late LinkedScrollControllerGroup _horizontalControllersGroup;

  Random random = Random();
  int _generatedNumber = 0;
  bool isLoading = false;
  bool showChequeDepositDetails = false;

  List<String>? companyCode;
  Future<List<String>?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('companies');
  }

  Future<void> setCompanyCode() async {
    List<String>? code = await getCompanyCode();
    setState(() {
      companyCode = code;
      print(companyCode);
    });
  }

  // generate number
  void _generateRandomNumber() {
    setState(() {
      if (suggestedPayment.isEmpty) {
        _generatedNumber = 1;
      } else {
        // Find the maximum no value in suggestionItems6
        int maxNo = suggestedPayment
            .map((e) => e.no)
            .reduce((value, element) => value > element ? value : element);
        _generatedNumber = maxNo + 1;
      }
      _noController.text = _generatedNumber.toString();
    });
  }

  //Fetch Payment
  Future<void> fetchPayment() async {
    try {
      final List<Payment> payment = await paymentServices.fetchPayments();
      final filteredPaymentEntry = payment
          .where(
              (paymententry) => paymententry.companyCode == companyCode!.first)
          .toList();

      setState(() {
        suggestedPayment = filteredPaymentEntry;
        _generateRandomNumber();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> fetchLedger() async {
    try {
      final List<Ledger> ledger = await ledgerServices.fetchLedgers();
      ledger.insert(
        0,
        Ledger(
          id: '',
          address: '',
          aliasName: '',
          bankName: '',
          branchName: '',
          date: '',
          ifsc: '',
          accName: '',
          accNo: '',
          bilwiseAccounting: '',
          city: '',
          contactPerson: '',
          creditDays: 0,
          cstDated: '',
          cstNo: '',
          email: '',
          fax: 0,
          gst: '',
          gstDated: '',
          ledgerCode: 0,
          ledgerGroup: '',
          ledgerType: '',
          mobile: 0,
          lstDated: '',
          lstNo: '',
          mailingName: '',
          name: '',
          openingBalance: 0,
          debitBalance: 0,
          panNo: '',
          pincode: 0,
          priceListCategory: '',
          printName: '',
          region: '',
          registrationType: '',
          registrationTypeDated: '',
          remarks: '',
          serviceTaxDated: '',
          serviceTaxNo: '',
          sms: 0,
          state: '',
          status: 'Yes',
          tel: 0,
        ),
      );

      setState(() {
        suggestedLedger = ledger;
        selectedLedgerName =
            suggestedLedger.isNotEmpty ? suggestedLedger.first.id : null;

        ledgerAmount = suggestedLedger.first.debitBalance;
        ledgerName = suggestedLedger.first.name;
        ledgerMo = suggestedLedger.first.mobile;
        ledgerState = suggestedLedger.first.state;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Date Picker
  void _presentDatePICKER({required TextEditingController controller}) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    DateTime lastDate;

    // Check which controller is being used and set the lastDate accordingly
    if (controller == _depositDateController) {
      lastDate = DateTime(now.year + 1, now.month, now.day);
    } else {
      lastDate = now;
    }

    final _pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (_pickedDate != null) {
      setState(() {
        controller.text = formatter.format(_pickedDate);
        if (controller == _chequeDateController) {
          _selectedChqDate = _pickedDate;
          // formattedChqDay = DateFormat('EEE').format(_selectedChqDate!);
        } else if (controller == _depositDateController) {
          _selectedDepoDate = _pickedDate;
          // formattedDepoDay = DateFormat('EEE').format(_selectedDepoDate!);
        } else if (controller == _dateController) {
          _selectedDate = _pickedDate;
          formattedDay = DateFormat('EEE').format(_selectedDate!);
        }
      });
    }
  }

  void _selectChqDate() {
    _presentDatePICKER(controller: _chequeDateController);
  }

  void _selectDepoDate() {
    _presentDatePICKER(controller: _depositDateController);
  }

  void _selectDate() {
    _presentDatePICKER(controller: _dateController);
  }

  void addNewRow() {
    rowDataList.add(RowData(
      type: 'Dr',
      ledger: null,
      remarks: '',
      debit: '',
      credit: '',
      remarksController: TextEditingController(),
      debitController: TextEditingController(),
      creditController: TextEditingController(),
      isDebit: true,
      isCredit: false,
    ));
  }

  void addNewRowCr() {
    rowDataList.add(RowData(
      type: 'Cr',
      ledger: null,
      remarks: '',
      debit: '',
      credit: '',
      remarksController: TextEditingController(),
      debitController: TextEditingController(),
      creditController: TextEditingController(),
      isDebit: false,
      isCredit: true,
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

  void openDialog1(BuildContext context, String ledgerID, String ledgerName,
      double debitAmount, VoidCallback onSave) {
    showDialog(
      context: context,
      builder: (context) => PaymentBillwise(
        ledgerID: ledgerID,
        ledgerName: ledgerName,
        debitAmount: debitAmount,
        allValuesCallback: (List<Map<String, dynamic>> newValues) {
          setState(() {
            // Merge newValues into _allValuesBillwise
            for (var newValue in newValues) {
              final existingIndex = _allValuesBillwise.indexWhere(
                (entry) => entry['uniqueKey'] == newValue['uniqueKey'],
              );
              if (existingIndex != -1) {
                _allValuesBillwise[existingIndex] = newValue;
              } else {
                _allValuesBillwise.add(newValue);
              }
            }
            print('Updated _allValuesBillwise: $_allValuesBillwise');
          });
        },
        onSave: onSave,
      ),
    );
  }

  void calculateTotalDebitAmount() {
    double total = 0.0;
    int count = 0;

    for (var row in rowDataList) {
      if (row.type == 'Dr') {
        total += double.tryParse(row.debit) ?? 0.0;
        count++;
      }
    }

    setState(() {
      totalDebitAmount = total;
      debitRowCount = count;
    });
  }

  void calculateTotalCreditAmount() {
    double total = 0.0;
    int count = 0;

    for (var row in rowDataList) {
      if (row.type == 'Cr') {
        total += double.tryParse(row.credit) ?? 0.0;
        count++;
      }
    }

    setState(() {
      totalCreditAmount = total;
      creditRowCount = count;
    });
  }

  // Save Payment
  Future<void> savePaymentData() async {
    try {
      if (totalDebitAmount <= 0 ||
          totalCreditAmount <= 0 ||
          totalDebitAmount != totalCreditAmount) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Total debit amount and total credit amount must be equal.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Prepare entries for the receipt
      List<Entry> entries = [];
      List<Billwise> billwise = [];

      // double totalDebit = _allValues
      //     .map<double>((e) => e['debit'])
      //     .reduce((value, element) => value + element);

      for (var value in _allValues) {
        double debit = double.tryParse(value['debit']) ?? 0.0;
        double credit = double.tryParse(value['credit']) ?? 0.0;

        entries.add(
          Entry(
            account: value['type'],
            ledger: value['ledger'],
            remark: value['remarks'],
            debit: debit,
            credit: credit,
          ),
        );
      }
      // Adding billwise entries
      for (var valueBillwise in _allValuesBillwise) {
        double amount = double.tryParse(valueBillwise['amount']) ?? 0.0;

        billwise.add(
          Billwise(
            date: valueBillwise['date'],
            purchase: valueBillwise['selectedPurchase'],
            amount: amount,
            billNo: valueBillwise['billno'],
          ),
        );
      }
      ChequeDetails? chequeDetails;
      if (_chequeNoController.text.isNotEmpty ||
          _chequeDateController.text.isNotEmpty ||
          _depositDateController.text.isNotEmpty ||
          _batchNoController.text.isNotEmpty ||
          _bankController.text.isNotEmpty ||
          _branchController.text.isNotEmpty) {
        chequeDetails = ChequeDetails(
          chequeNo: _chequeNoController.text.isNotEmpty
              ? _chequeNoController.text
              : null,
          chequeDate: _chequeDateController.text.isNotEmpty
              ? _chequeDateController.text
              : null,
          depositDate: _depositDateController.text.isNotEmpty
              ? _depositDateController.text
              : null,
          batchNo: _batchNoController.text.isNotEmpty
              ? _batchNoController.text
              : null,
          bank: _bankController.text.isNotEmpty ? _bankController.text : null,
          branch:
              _branchController.text.isNotEmpty ? _branchController.text : null,
        );
      }

      // Create the ReceiptVoucher object
      Payment payment = Payment(
        id: '', // Generate an ID for the payment
        companyCode: companyCode!.first,
        totalamount: totalDebitAmount,
        no: int.parse(_noController.text),
        date: _dateController.text,
        entries: entries,
        billwise: billwise,
        narration: _narrationController.text,
        chequeDetails: chequeDetails,
      );

      print('Payment created: ${payment.toJson()}');

      // Save the receipt voucher
      await paymentServices.createPayment(payment, context).then((value) async {
        for (var valueBillwise in _allValuesBillwise) {
          var purchaseId = valueBillwise['selectedPurchase'];
          var adjustmentAmount =
              double.parse(valueBillwise['amount'].toString());

          Purchase? purchase =
              await purchaseServices.fetchPurchaseById(purchaseId);
          if (purchase != null) {
            double? dueAmount = double.tryParse(purchase.dueAmount ?? '');
            if (dueAmount != null) {
              dueAmount -= adjustmentAmount;
              purchase.dueAmount = dueAmount.toString();
              await purchaseServices.updatePurchase(purchase, context);
            } else {
              print('Error: Unable to parse dueAmount.');
            }
          }
        }

        for (var value in _allValues) {
          var type = value['type'];
          var ledgerId = value['ledger'];
          var debit = value['debit'];
          var credit = value['credit'];

          Ledger? ledger = await ledgerServices.fetchLedgerById(ledgerId);
          if (ledger != null) {
            if (type == 'Dr') {
              ledger.debitBalance -= double.parse(debit);
              ledgerServices.updateLedger2(ledger, context);
            } else if (type == 'Cr') {
              ledger.debitBalance += double.parse(credit);
              ledgerServices.updateLedger2(ledger, context);
            } else {
              print('Error: Unable to update Ledger.');
            }
          }
        }

        setState(() {
          isLoading = false;
        });

        _noController.clear();
        _dateController.clear();

        _narrationController.clear();

        _searchController.clear();

        _chequeNoController.clear();
        _chequeDateController.clear();
        _depositDateController.clear();
        _batchNoController.clear();
        _bankController.clear();
        _branchController.clear();
        rowDataList.clear();
        totalDebitAmount = 0.0;
        debitRowCount = 0;
        totalCreditAmount = 0.0;
        creditRowCount = 0;
        fetchPayment().then((_) {
          final newReceipt = suggestedPayment.firstWhere(
            (element) => element.no == payment.no,
            orElse: () => Payment(
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
                content:
                    const Text("Do you want to print the payment receipt?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => PaymentVoucherPrint(
                            receiptID: newReceipt.id,
                            'PAYMENT VOUCHER PRINT',
                          ),
                        ),
                      );
                    },
                    child: const Text("Yes"),
                  ),
                  TextButton(
                    onPressed: () {},
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

  void _updateChequeDepositDetailsFlag() {
    showChequeDepositDetails =
        rowDataList.any((row) => row.ledgerGroup == '662f9807a07ec73369c237ba');
  }

  Widget _buildRow(int index) {
    final double width = MediaQuery.of(context).size.width;
    final bool isDesktopBody = width >= 1200;

    return Row(
      children: [
        Container(
          width: isDesktopBody ? width * 0.05 : 100,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(0),
          ),
          alignment: Alignment.center,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              alignment: Alignment.center,
              value: rowDataList[index].type,
              underline: Container(),
              onChanged: (String? newValue) {
                setState(() {
                  rowDataList[index].type = newValue!;
                  if (newValue == 'Cr') {
                    rowDataList[index].isCredit = true;
                    rowDataList[index].isDebit = false;
                    rowDataList[index].debitController.clear();
                    rowDataList[index].debit = '';
                    calculateTotalDebitAmount();
                  } else {
                    rowDataList[index].isCredit = false;
                    rowDataList[index].isDebit = true;
                    rowDataList[index].creditController.clear();
                    rowDataList[index].credit = '';
                    calculateTotalCreditAmount();
                  }
                });
              },
              items: types.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      value,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Container(
          width: isDesktopBody ? width * 0.3 : 500,
          height: 40,
          decoration: BoxDecoration(border: Border.all()),
          child: SearchableDropDown(
            controller: _searchController,
            searchController: _searchController,
            value: rowDataList[index].ledger,
            onChanged: (String? newValue) {
              setState(() {
                rowDataList[index].ledger = newValue;

                if (rowDataList[index].ledger != null) {
                  final selectedLedger = suggestedLedger.firstWhere(
                      (element) => element.id == rowDataList[index].ledger);
                  rowDataList[index].ledgerGroup = selectedLedger.ledgerGroup;

                  ledgerAmount = selectedLedger.debitBalance;
                  ledgerName = selectedLedger.name;
                  ledgerMo = selectedLedger.mobile;
                  ledgerState = selectedLedger.state;

                  _updateChequeDepositDetailsFlag();
                }
              });
            },
            items: suggestedLedger.map((Ledger ledger) {
              return DropdownMenuItem<String>(
                value: ledger.id,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: isDesktopBody ? width * 0.2 : 350,
                        child: Text(
                          ledger.name,
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        ledger.debitBalance.toStringAsFixed(2),
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            searchMatchFn: (item, searchValue) {
              final itemMLimit =
                  suggestedLedger.firstWhere((e) => e.id == item.value).name;
              return itemMLimit
                  .toLowerCase()
                  .contains(searchValue.toLowerCase());
            },
          ),
        ),
        Container(
          width: isDesktopBody ? width * 0.3 : 500,
          height: 40,
          decoration: BoxDecoration(border: Border.all()),
          child: TextFormField(
            controller: rowDataList[index].remarksController,
            onChanged: (value) {
              setState(() {
                rowDataList[index].remarks = value;
              });
            },
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: isDesktopBody ? width * 0.1 : 200,
          height: 40,
          decoration: BoxDecoration(border: Border.all()),
          child: TextFormField(
            enabled: rowDataList[index].isDebit,
            controller: rowDataList[index].debitController,
            onFieldSubmitted: (value) {
              setState(() {
                rowDataList[index].debit = value;
                saveValues(rowDataList[index].toMap());
                calculateTotalDebitAmount();
                openDialog1(
                  context,
                  rowDataList[index].ledger ?? '',
                  suggestedLedger
                      .firstWhere(
                          (element) => element.id == rowDataList[index].ledger)
                      .name,
                  double.tryParse(rowDataList[index].debit) ?? 0.0,
                  () {
                    addNewRowCr();
                    _searchController.clear();
                  },
                );
              });
            },
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
            ],
          ),
        ),
        Container(
          width: isDesktopBody ? width * 0.1 : 200,
          height: 40,
          decoration: BoxDecoration(border: Border.all()),
          child: TextFormField(
            enabled: rowDataList[index].isCredit,
            controller: rowDataList[index].creditController,
            onFieldSubmitted: (value) {
              setState(() {
                rowDataList[index].credit = value;
                saveValues(rowDataList[index].toMap());
                calculateTotalCreditAmount();
                if (totalCreditAmount < totalDebitAmount) {
                  addNewRowCr();
                } else if (totalCreditAmount > totalDebitAmount) {
                  addNewRow();
                }
                _searchController.clear();
              });
            },
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
            ],
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
          return _buildTabletWidget();
        } else if (constraints.maxWidth >= 600 && constraints.maxWidth < 1200) {
          return _buildTabletWidget();
        } else {
          return _buildDesktopWidget();
        }
      },
    );
  }

  Widget _buildTabletWidget() {
    var mediaQuery = MediaQuery.of(context);

    final List<Map<String, dynamic>> menuItems = [
      {'text': 'List', 'icon': Icons.list},
      {'text': 'Print', 'icon': Icons.print},
      {'text': 'Contra', 'icon': Icons.contrast},
      {'text': 'Receipt', 'icon': Icons.receipt},
      {'text': 'Journal', 'icon': Icons.receipt_rounded},
      {'text': 'Payment', 'icon': Icons.payment},
      {'text': 'C/Note', 'icon': Icons.note},
      {'text': 'D/Note', 'icon': Icons.note_add_rounded},
      {'text': 'GST Exp.', 'icon': Icons.money},
      {'text': 'Previous', 'icon': Icons.skip_previous},
      {'text': 'Next', 'icon': Icons.skip_next},
      {'text': 'Audit Trail', 'icon': Icons.book},
      {'text': 'Change Vch.', 'icon': Icons.receipt_long_sharp},
      {'text': 'Goto Date', 'icon': Icons.date_range},
      {'text': 'Attach. Img', 'icon': Icons.image},
      {'text': 'Vch Setup', 'icon': Icons.receipt_outlined},
      {'text': 'Print Setup', 'icon': Icons.print_sharp},
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35.0),
        child: AppBar(
          title: Text(
            'Payment Entry',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const DBHomePage(),
                ),
              );
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                _scaffoldKey.currentState!.openEndDrawer();
              },
              icon: const Icon(
                Icons.menu,
              ),
            )
          ],
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xffA0522D),
          centerTitle: true,
        ),
      ),
      endDrawer: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
          ),
          child: ListView(
            children: [
              ...menuItems.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    dense: true,
                    leading: Icon(item['icon'], color: Colors.black54),
                    title: Text(
                      item['text'],
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF6C0082),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      switch (item['text']) {
                        case 'List':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PaymentHome()),
                          );
                          break;
                        // Add cases for other menu items here
                        default:
                          print('Tapped on ${item['text']}');
                          break;
                      }
                    },
                  ),
                );
              }),
            ],
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: mediaQuery.size.width,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(),
                        left: BorderSide(),
                        right: BorderSide(),
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 60,
                            height: 40,
                            child: Text(
                              'No :',
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFF4B0082),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                        Container(
                          width: mediaQuery.size.width * 0.3,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          child: TextField(
                            controller: _noController,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              contentPadding:
                                  const EdgeInsets.only(left: 8.0, bottom: 5.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(),
                        left: BorderSide(),
                        right: BorderSide(),
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 60,
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Date :',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF4B0082),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: mediaQuery.size.width * 0.3,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: TextFormField(
                            controller: _dateController,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, fontSize: 17),
                            decoration: const InputDecoration(
                              hintText: 'Select Date',
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 8.0, bottom: 5.0),
                            ),
                            onTap: () {
                              _selectDate();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, top: 3),
                          child: Text(
                            formattedDay,
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF4B0082),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(),
                        left: BorderSide(),
                        right: BorderSide(),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0, top: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _horizontalController1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                'Dr/Cr ',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF4B0082),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              width: 500,
                              child: Text(
                                '        Ledger Name ',
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF4B0082),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              width: 500,
                              child: Text(
                                '        Remark',
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF4B0082),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              child: Text(
                                '        Debit',
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF4B0082),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              child: Text(
                                '        Credit',
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF4B0082),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 1500,
                    height: 400,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _horizontalController2,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 1500,
                            height: 400,
                            child: ListView.builder(
                              itemCount: rowDataList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _buildRow(index);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  showChequeDepositDetails
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border.all(),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  // decoration: BoxDecoration(
                                  //   border: Border.all(),
                                  // ),
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Cheque Deposit Details',
                                    style: GoogleFonts.poppins(
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      height: 40,
                                      alignment: Alignment.centerLeft,
                                      // decoration: BoxDecoration(
                                      //   border: Border.all(),
                                      // ),
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        'Chq No : ',
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF4B0088),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                      ),
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: TextFormField(
                                        controller: _chequeNoController,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                            bottom: 5.0,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      height: 40,
                                      alignment: Alignment.centerLeft,
                                      // decoration: BoxDecoration(
                                      //   border: Border.all(),
                                      // ),
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        'Chq Date : ',
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF4B0088),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      child: TextFormField(
                                        controller: _chequeDateController,
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17),
                                        decoration: const InputDecoration(
                                          hintText: 'Select Date',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              left: 8.0, bottom: 5.0),
                                        ),
                                        onTap: () {
                                          _selectChqDate();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      height: 40,
                                      alignment: Alignment.centerLeft,
                                      // decoration: BoxDecoration(
                                      //   border: Border.all(),
                                      // ),
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        'Depo Date : ',
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF4B0088),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      child: TextFormField(
                                        controller: _depositDateController,
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17),
                                        decoration: const InputDecoration(
                                          hintText: 'Select Date',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              left: 8.0, bottom: 5.0),
                                        ),
                                        onTap: () {
                                          _selectDepoDate();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      height: 40,
                                      alignment: Alignment.centerLeft,
                                      // decoration: BoxDecoration(
                                      //   border: Border.all(),
                                      // ),
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        'Batch No : ',
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF4B0088),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                      ),
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: TextFormField(
                                        controller: _batchNoController,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                            bottom: 5.0,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      height: 40,
                                      alignment: Alignment.centerLeft,
                                      // decoration: BoxDecoration(
                                      //   border: Border.all(),
                                      // ),
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        'Bank : ',
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF4B0088),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                      ),
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: TextFormField(
                                        controller: _bankController,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                            bottom: 5.0,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      height: 40,
                                      alignment: Alignment.centerLeft,
                                      // decoration: BoxDecoration(
                                      //   border: Border.all(),
                                      // ),
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        'Branch : ',
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF4B0088),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                      ),
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: TextFormField(
                                        controller: _branchController,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                            bottom: 5.0,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 1),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    border: const Border(
                                        bottom: BorderSide(width: 3)),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      '\$${totalDebitAmount.toStringAsFixed(2)}', // Total Dr
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF4B0082),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.01,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 1),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    border: const Border(
                                        bottom: BorderSide(width: 3)),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      '\$${totalCreditAmount.toStringAsFixed(2)}',
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF4B0082),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 1),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text('[$debitRowCount] Dr',
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.poppins(
                                            color: const Color(0xFF4B0082),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 1),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      '[$creditRowCount] Cr',
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.poppins(
                                          color: const Color(0xFF4B0082),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 120,
                                  child: Text(
                                    'Narration :',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF4B0082),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 1, top: 0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: _narrationController,
                                      style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 130,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Column(
                              children: [
                                Text(
                                  'Ledger Information',
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xFF4B0082),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Container(
                                  height: 30,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          top: BorderSide(color: Colors.black),
                                          bottom:
                                              BorderSide(color: Colors.black))),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            'Limit',
                                            style: GoogleFonts.poppins(
                                                color: const Color(0xFF4B0082),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          color: const Color.fromARGB(
                                              255, 161, 78, 53),
                                          child: Center(
                                            child: Text(
                                              '0.00',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            'Bal',
                                            style: GoogleFonts.poppins(
                                                color: const Color(0xFF4B0082),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          color: const Color.fromARGB(
                                              255, 161, 78, 53),
                                          child: Center(
                                            child: Text(
                                              ledgerAmount.toStringAsFixed(2),
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: mediaQuery.size.width,
                                  child: Text(
                                    'Cont. Person: $ledgerName',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: mediaQuery.size.width,
                                  child: Text(
                                    'M: ${ledgerMo.toString()}',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: mediaQuery.size.width,
                                  child: Text(
                                    ledgerState,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize:
                                    Size(MediaQuery.of(context).size.width, 25),
                                shape: const BeveledRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.black, width: .3)),
                                backgroundColor: Colors.yellow.shade100),
                            onPressed: savePaymentData,
                            child: const Text(
                              'Save [F4]',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize:
                                    Size(MediaQuery.of(context).size.width, 25),
                                shape: const BeveledRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.black, width: .3),
                                ),
                                backgroundColor: Colors.yellow.shade100),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize:
                                    Size(MediaQuery.of(context).size.width, 25),
                                shape: const BeveledRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.black,
                                    width: .3,
                                  ),
                                ),
                                backgroundColor: Colors.yellow.shade100),
                            onPressed: () {},
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopWidget() {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .06,
              width: MediaQuery.of(context).size.width * 1,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: const Color(0xffA0522D),
                      child: Center(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                CupertinoIcons.arrow_left,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                            const SizedBox(
                              width: 80,
                            ),
                            SizedBox(
                              width: 110,
                              child: Text(
                                'Payment',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      color: const Color(0xffB8860B),
                      child: Center(
                          child: Text(
                        'Voucher Entry',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      )),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: mediaQuery.size.width * 0.901,
                  height: 880,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: MediaQuery.of(context).size.width * 0.898,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(),
                            left: BorderSide(),
                            right: BorderSide(),
                          ),
                        ),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Text(
                                      'No :',
                                      style: GoogleFonts.poppins(
                                          color: const Color(0xFF4B0082),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: mediaQuery.size.width * 0.05,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: TextFormField(
                                    controller: _noController,
                                    enabled: true,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600),
                                    cursorHeight: 18,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          left: 8.0, bottom: 5.0),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 60,
                                    height: 40,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Date :',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF4B0082),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: mediaQuery.size.width * 0.08,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: TextFormField(
                                    controller: _dateController,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                    decoration: const InputDecoration(
                                      hintText: 'Select Date',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          left: 8.0, bottom: 5.0),
                                    ),
                                    onTap: () {
                                      _selectDate();
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 3),
                                  child: Text(
                                    formattedDay,
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF4B0082),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(),
                                left: BorderSide(),
                                right: BorderSide())),
                        width: MediaQuery.of(context).size.width * 0.898,
                        height: 45,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0, top: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                                child: Text(
                                  'Dr/Cr ',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xFF4B0082),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(
                                  '        Ledger Name ',
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xFF4B0082),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(
                                  '        Remark',
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xFF4B0082),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: Text(
                                  '        Debit',
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xFF4B0082),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: Text(
                                  '        Credit',
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xFF4B0082),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.898,
                        height: 383,
                        decoration: const BoxDecoration(
                            // border: Border(
                            //   bottom: BorderSide(
                            //     width: 1,
                            //   ),
                            // ),
                            ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: rowDataList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _buildRow(index);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      showChequeDepositDetails
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 119,
                                width: MediaQuery.of(context).size.width * 0.6,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      // decoration: BoxDecoration(
                                      //   border: Border.all(),
                                      // ),
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        'Cheque Deposit Details',
                                        style: GoogleFonts.poppins(
                                          decoration: TextDecoration.underline,
                                          decorationThickness: 2,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          height: 40,
                                          alignment: Alignment.centerLeft,
                                          // decoration: BoxDecoration(
                                          //   border: Border.all(),
                                          // ),
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            'Chq No : ',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF4B0088),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                          ),
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: TextFormField(
                                            controller: _chequeNoController,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                bottom: 5.0,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.06,
                                          height: 40,
                                          alignment: Alignment.centerLeft,
                                          // decoration: BoxDecoration(
                                          //   border: Border.all(),
                                          // ),
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            'Chq Date : ',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF4B0088),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          child: TextFormField(
                                            controller: _chequeDateController,
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17),
                                            decoration: const InputDecoration(
                                              hintText: 'Select Date',
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.only(
                                                  left: 8.0, bottom: 5.0),
                                            ),
                                            onTap: () {
                                              _selectChqDate();
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.06,
                                          height: 40,
                                          alignment: Alignment.centerLeft,
                                          // decoration: BoxDecoration(
                                          //   border: Border.all(),
                                          // ),
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            'Depo Date : ',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF4B0088),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          child: TextFormField(
                                            controller: _depositDateController,
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17),
                                            decoration: const InputDecoration(
                                              hintText: 'Select Date',
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.only(
                                                  left: 8.0, bottom: 5.0),
                                            ),
                                            onTap: () {
                                              _selectDepoDate();
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          height: 40,
                                          alignment: Alignment.centerLeft,
                                          // decoration: BoxDecoration(
                                          //   border: Border.all(),
                                          // ),
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            'Batch No : ',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF4B0088),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                          ),
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: TextFormField(
                                            controller: _batchNoController,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                bottom: 5.0,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          height: 40,
                                          alignment: Alignment.centerLeft,
                                          // decoration: BoxDecoration(
                                          //   border: Border.all(),
                                          // ),
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            'Bank : ',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF4B0088),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.26,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                          ),
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: TextFormField(
                                            controller: _bankController,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                bottom: 5.0,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.06,
                                          height: 40,
                                          alignment: Alignment.centerLeft,
                                          // decoration: BoxDecoration(
                                          //   border: Border.all(),
                                          // ),
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            'Branch : ',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF4B0088),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                          ),
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: TextFormField(
                                            controller: _branchController,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                bottom: 5.0,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(
                              height: 119,
                            ),
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(),
                          ),
                        ),
                        height: 180,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.06,
                                    child: Text(
                                      'Narration :',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF4B0082),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 1, top: 0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: _narrationController,
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18),
                                        textAlign: TextAlign.start,
                                        maxLines: 2,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height: 130,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Ledger Information',
                                        style: GoogleFonts.poppins(
                                            color: const Color(0xFF4B0082),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Container(
                                        height: 30,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .31,
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    color: Colors.black),
                                                bottom: BorderSide(
                                                    color: Colors.black))),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  'Limit',
                                                  style: GoogleFonts.poppins(
                                                      color: const Color(
                                                          0xFF4B0082),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: const Color.fromARGB(
                                                    255, 161, 78, 53),
                                                child: Center(
                                                  child: Text(
                                                    '0.00',
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  'Bal',
                                                  style: GoogleFonts.poppins(
                                                      color: const Color(
                                                          0xFF4B0082),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: const Color.fromARGB(
                                                    255, 161, 78, 53),
                                                child: Center(
                                                  child: Text(
                                                    ledgerAmount
                                                        .toStringAsFixed(2),
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: mediaQuery.size.width,
                                        child: Text(
                                          'Cont. Person: $ledgerName',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        width: mediaQuery.size.width,
                                        child: Text(
                                          'M: ${ledgerMo.toString()}',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        width: mediaQuery.size.width,
                                        child: Text(
                                          ledgerState,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 1),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                border: const Border(
                                                    bottom:
                                                        BorderSide(width: 3)),
                                                borderRadius:
                                                    BorderRadius.circular(0),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: Text(
                                                    '\$${totalDebitAmount.toStringAsFixed(2)}', // Total Dr
                                                    textAlign: TextAlign.right,
                                                    style: GoogleFonts.poppins(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 88, 0, 103),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15)),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.01,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 1),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                border: const Border(
                                                    bottom:
                                                        BorderSide(width: 3)),
                                                borderRadius:
                                                    BorderRadius.circular(0),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: Text(
                                                    '\$${totalCreditAmount.toStringAsFixed(2)}',
                                                    textAlign: TextAlign.right,
                                                    style: GoogleFonts.poppins(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 88, 0, 103),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 1),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(0),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Text(
                                                    '[$debitRowCount] Dr',
                                                    textAlign: TextAlign.right,
                                                    style: GoogleFonts.poppins(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 88, 0, 103),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 1),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(0),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Text(
                                                  '[$creditRowCount] Cr',
                                                  textAlign: TextAlign.right,
                                                  style: GoogleFonts.poppins(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 88, 0, 103),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: Size(
                                            MediaQuery.of(context).size.width *
                                                .1,
                                            25),
                                        shape: const BeveledRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.black,
                                                width: .3)),
                                        backgroundColor:
                                            Colors.yellow.shade100),
                                    onPressed: savePaymentData,
                                    child: const Text(
                                      'Save [F4]',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        .002,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          fixedSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .1,
                                              25),
                                          shape: const BeveledRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.black, width: .3),
                                          ),
                                          backgroundColor:
                                              Colors.yellow.shade100),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        .002,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: Size(
                                            MediaQuery.of(context).size.width *
                                                .1,
                                            25),
                                        shape: const BeveledRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.black,
                                            width: .3,
                                          ),
                                        ),
                                        backgroundColor:
                                            Colors.yellow.shade100),
                                    onPressed: () {},
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Shortcuts(
                  shortcuts: {
                    LogicalKeySet(LogicalKeyboardKey.f3):
                        const ActivateIntent(),
                    LogicalKeySet(LogicalKeyboardKey.f4):
                        const ActivateIntent(),
                  },
                  child: Focus(
                    autofocus: true,
                    onKey: (node, event) {
                      if (event is RawKeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.f2) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const PaymentHome(),
                          ),
                        );
                        return KeyEventResult.handled;
                      } else if (event is RawKeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.f8) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RVDesktopBody(),
                          ),
                        );
                      }
                      return KeyEventResult.ignored;
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.099,
                      child: Column(
                        children: [
                          CustomList(
                            Skey: "F2",
                            name: "List",
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const PaymentHome(),
                                ),
                              );
                            },
                          ),
                          CustomList(
                              Skey: "F8",
                              name: "Receipt",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RVDesktopBody(),
                                  ),
                                );
                              }),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          // CustomList(
                          //   Skey: "P",
                          //   name: "Print",
                          //   onTap: () {},
                          // ),
                          // CustomList(Skey: "F5", name: "Payment", onTap: () {}),
                          // CustomList(
                          //   Skey: "F6",
                          //   name: "Contra",
                          //   onTap: () {},
                          // ),
                          // CustomList(Skey: "F7", name: "Journal", onTap: () {}),

                          // CustomList(Skey: "", name: "", onTap: () {}),
                          // CustomList(
                          //   Skey: "",
                          //   name: "",
                          //   onTap: () {},
                          // ),
                          // CustomList(Skey: "", name: "", onTap: () {}),
                          // CustomList(Skey: "", name: "", onTap: () {}),
                          // CustomList(
                          //     Skey: "PgUp", name: "Previous", onTap: () {}),
                          // CustomList(Skey: "PgDn", name: "Next", onTap: () {}),
                          // CustomList(
                          //     Skey: "F12", name: "Audit Trail", onTap: () {}),
                          // CustomList(
                          //     Skey: "F10", name: "Change Vch.", onTap: () {}),
                          // CustomList(
                          //     Skey: "D", name: "Goto Date", onTap: () {}),
                          // CustomList(Skey: "", name: "", onTap: () {}),
                          // CustomList(
                          //     Skey: "G", name: "Attach. Img", onTap: () {}),
                          // CustomList(Skey: "", name: "", onTap: () {}),
                          // CustomList(
                          //     Skey: "G", name: "Vch Setup", onTap: () {}),
                          // CustomList(
                          //     Skey: "T", name: "Print Setup", onTap: () {}),
                          // CustomList(Skey: "", name: "", onTap: () {}),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
