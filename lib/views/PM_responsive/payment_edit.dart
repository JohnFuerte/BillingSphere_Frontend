import 'package:billingsphere/data/models/ledger/ledger_model.dart';
import 'package:billingsphere/data/models/payment/payment_model.dart';
import 'package:billingsphere/data/models/purchase/purchase_model.dart';
import 'package:billingsphere/data/repository/ledger_repository.dart';
import 'package:billingsphere/data/repository/payment_respository.dart';
import 'package:billingsphere/data/repository/purchase_repository.dart';
import 'package:billingsphere/helper/constants.dart';
import 'package:billingsphere/views/Daily_cash_resposive/daily_cash_create.dart';
import 'package:billingsphere/views/PM_responsive/payment_billwise.dart';
import 'package:billingsphere/views/PM_responsive/payment_receipt2.dart';
import 'package:billingsphere/views/PM_widgets/entries.dart';
import 'package:billingsphere/views/PM_widgets/PM_desktopappbar.dart';
import 'package:billingsphere/views/RA_widgets/RA_D_side_buttons.dart';
import 'package:billingsphere/views/searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class PMMyPaymentDesktopBodyE extends StatefulWidget {
  final String id;
  const PMMyPaymentDesktopBodyE({super.key, required this.id});

  @override
  State<PMMyPaymentDesktopBodyE> createState() =>
      _PMMyPaymentDesktopBodyState();
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

class _PMMyPaymentDesktopBodyState extends State<PMMyPaymentDesktopBodyE> {
  var items = ['Dr', 'Cr'];

  List<String> types = [
    'Dr',
    'Cr',
  ];
  final formatter = DateFormat.yMd();
  List<Ledger> suggestionItems5 = [];
  String? selectedLedgerName;
  DateTime? _selectedDate;
  DateTime? _selectedChqDate;
  DateTime? _selectedDepoDate;
  bool showChequeDepositDetails = false;
  List<RowData> rowDataList = [];

  // TextControllers
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _noController = TextEditingController();
  final TextEditingController _narrationController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  TextEditingController _chequeNoController = TextEditingController();
  TextEditingController _chequeDateController = TextEditingController();
  TextEditingController _depositDateController = TextEditingController();
  TextEditingController _batchNoController = TextEditingController();
  TextEditingController _bankController = TextEditingController();
  TextEditingController _branchController = TextEditingController();

  String formattedDay = '';
  double totalDebit = 0;
  double totalCredit = 0;
  double debitCount = 0;
  double creditCount = 0;
  String type = '';
  String? ledger;
  double ledgerAmount = 0;
  String ledgerName = '';
  int ledgerMo = 0;
  String ledgerState = '';
  List<Ledger> suggestedLedger = [];

  double totalDebitAmount = 0.0;
  int debitRowCount = 0;

  double totalCreditAmount = 0.0;
  int creditRowCount = 0;
  bool isLoading = false;

  final List<Map<String, dynamic>> _allValues = [];
  final List<Map<String, dynamic>> _allValuesBillwise = [];

  // Services
  LedgerService ledgerService = LedgerService();
  PaymentService paymentService = PaymentService();
  PurchaseServices purchaseServices = PurchaseServices();

  @override
  void initState() {
    super.initState();
    setCompanyCode();

    _initializeData();
  }

  // Calculate total debit and credit
  void calculateTotal() {
    totalDebit = 0;
    totalCredit = 0;
    debitCount = 0;
    creditCount = 0;
    for (var values in _allValues) {
      String? dropdownValue = values['dropdownValue'];
      String? selectedAccount = values['account'];
      double debit = double.tryParse(values['debit'].toString()) ?? 0;
      double credit = double.tryParse(values['credit'].toString()) ?? 0;

      if (dropdownValue == 'Dr' || selectedAccount == 'Dr') {
        totalDebit += debit;
        debitCount++;
      } else if (dropdownValue == 'Cr' || selectedAccount == 'Cr') {
        totalCredit += credit;
        creditCount++;
      }
    }

    setState(() {
      totalDebit = totalDebit;
      totalCredit = totalCredit;
      debitCount = debitCount;
      creditCount = creditCount;
    });
  }

  // API Call to fetch ledgers
  Future<void> fetchLedger() async {
    try {
      final List<Ledger> ledger = await ledgerService.fetchLedgers();
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

  Future<void> fetchAndSetPayment() async {
    try {
      final Payment? payment = await paymentService.fetchPaymentById(widget.id);

      rowDataList.clear();

      setState(() {
        _noController.text = (payment!.no).toString();
        _dateController.text = payment.date;
        _narrationController.text = payment.narration ?? '';

        for (var entry in payment.entries) {
          rowDataList.add(RowData(
            type: entry.account,
            ledger: entry.ledger,
            remarks: entry.remark,
            debit: entry.debit.toString(),
            credit: entry.credit.toString(),
            isCredit: entry.account == 'Cr',
            isDebit: entry.account == 'Dr',
            debitController:
                TextEditingController(text: entry.debit.toString()),
            creditController:
                TextEditingController(text: entry.credit.toString()),
            remarksController: TextEditingController(text: entry.remark),
            ledgerGroup: '',
          ));
        }

        if (payment.chequeDetails != null) {
          _chequeNoController =
              TextEditingController(text: payment.chequeDetails!.chequeNo);
          _chequeDateController =
              TextEditingController(text: payment.chequeDetails!.chequeDate);
          _depositDateController =
              TextEditingController(text: payment.chequeDetails!.depositDate);
          _branchController.text = payment.chequeDetails!.branch!;
          _batchNoController.text = payment.chequeDetails!.batchNo!;
          _bankController.text = payment.chequeDetails!.bank!;
          setState(() {
            showChequeDepositDetails = true;
          });
        }
      });

      calculateTotalDebitAmount();
      calculateTotalCreditAmount();
    } catch (error) {
      print('Failed to fetch payment: $error');
    }
  }

  Widget _buildRow(int index) {
    final double width = MediaQuery.of(context).size.width;
    final bool isDesktopBody = width >= 1200;
    bool isFetchedRow = rowDataList[index].uniqueKey.isNotEmpty;

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

                  // Clear the row data when type is changed
                  rowDataList[index].ledger = null;
                  rowDataList[index].remarks = '';
                  rowDataList[index].debit = '';
                  rowDataList[index].credit = '';
                  rowDataList[index].debitController.clear();
                  rowDataList[index].creditController.clear();
                  rowDataList[index].remarksController.clear();

                  if (newValue == 'Cr') {
                    rowDataList[index].isCredit = true;
                    rowDataList[index].isDebit = false;
                  } else {
                    rowDataList[index].isCredit = false;
                    rowDataList[index].isDebit = true;
                  }

                  calculateTotalDebitAmount();
                  calculateTotalCreditAmount();
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
            items: (rowDataList[index].type == 'Cr'
                    ? suggestedLedger
                        .where((ledger) => [
                              "662f9807a07ec73369c237ba",
                              "662f9832a07ec73369c237c2",
                              "662f9878a07ec73369c237d0",
                              "662f988ba07ec73369c237d4"
                            ].contains(ledger.ledgerGroup))
                        .toList()
                    : suggestedLedger)
                .map((Ledger ledger) {
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

                final selectedLedger = suggestedLedger.firstWhere(
                  (element) => element.id == rowDataList[index].ledger,
                );

                if (selectedLedger.bilwiseAccounting == "Yes") {
                  openDialog1(
                    context,
                    rowDataList[index].ledger ?? '',
                    selectedLedger.name,
                    double.tryParse(rowDataList[index].debit) ?? 0.0,
                    () {
                      if (totalCreditAmount < totalDebitAmount) {
                        addNewRowCr();
                      }
                      _searchController.clear();
                    },
                  );
                } else {
                  if (totalCreditAmount < totalDebitAmount) {
                    addNewRowCr();
                  }
                  _searchController.clear();
                }
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

  void openDialog1(BuildContext context, String ledgerID, String ledgerName,
      double debitAmount, VoidCallback onSave,
      [String? paymentID]) {
    showDialog(
      context: context,
      builder: (context) => PaymentBillwise(
        ledgerID: ledgerID,
        ledgerName: ledgerName,
        debitAmount: debitAmount,
        allValuesCallback: (List<Map<String, dynamic>> newValues) {
          setState(() {
            for (var newValue in newValues) {
              double amount = double.tryParse(newValue['amount']) ?? 0.0;

              if (amount > 0) {
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
            }
          });
        },
        onSave: onSave,
        paymentID: widget.id,
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

  void _updateChequeDepositDetailsFlag() {
    showChequeDepositDetails =
        rowDataList.any((row) => row.ledgerGroup == '662f9807a07ec73369c237ba');
  }

  List<String>? companyCode;
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

  void _selectChqDate() {
    _presentDatePICKER(controller: _chequeDateController);
  }

  void _selectDepoDate() {
    _presentDatePICKER(controller: _depositDateController);
  }

  void _selectDate() {
    _presentDatePICKER(controller: _dateController);
  }

  Future<void> savePaymentData() async {
    try {
      for (int i = 0; i < rowDataList.length; i++) {
        saveValues(rowDataList[i].toMap());
      }
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

      if (_allValuesBillwise.isEmpty) {
        final Payment? payment =
            await paymentService.fetchPaymentById(widget.id);

        if (payment?.billwise != null && payment!.billwise.isNotEmpty) {
          for (var billwiseEntry in payment.billwise) {
            billwise.add(
              Billwise(
                date: billwiseEntry.date,
                purchase: billwiseEntry.purchase,
                amount: billwiseEntry.amount,
                billNo: billwiseEntry.billNo,
              ),
            );
          }
        } else {
          print('No billwise data found.');
        }
      } else {
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
        id: '',
        companyCode: companyCode!.first,
        totalamount: totalDebitAmount,
        no: int.parse(_noController.text),
        date: _dateController.text,
        entries: entries,
        billwise: billwise,
        narration: _narrationController.text,
        chequeDetails: showChequeDepositDetails ? chequeDetails : null,
      );

      await restorePreviousState();
      await paymentService
          .updatePayment(payment, context, widget.id)
          .then((value) async {
        if (_allValuesBillwise.isEmpty) {
          final Payment? payment =
              await paymentService.fetchPaymentById(widget.id);

          if (payment?.billwise != null && payment!.billwise.isNotEmpty) {
            for (var billwiseEntry in payment.billwise) {
              var purchaseId = billwiseEntry.purchase;
              var adjustmentAmount = billwiseEntry.amount;

              Purchase? purchase =
                  await purchaseServices.fetchPurchaseById(purchaseId);
              if (purchase != null) {
                double? dueAmount = double.tryParse(purchase.dueAmount ?? '');
                if (dueAmount != null) {
                  dueAmount -= adjustmentAmount;

                  purchase.dueAmount = dueAmount.toString();
                  await purchaseServices.updatePurchase(
                    purchase,
                  );
                } else {
                  print('Error: Unable to parse dueAmount.');
                }
              }
            }
          } else {
            print('No billwise data found.');
          }
        } else {
          // Process data from _allValuesBillwise
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
                await purchaseServices.updatePurchase(
                  purchase,
                );
              } else {
                print('Error: Unable to parse dueAmount.');
              }
            }
          }
        }

        List<Ledger> ledgersToUpdate = [];

        for (var value in _allValues) {
          var type = value['type'];
          var ledgerId = value['ledger'];
          var debit = value['debit'];
          var credit = value['credit'];

          Ledger? ledger = await ledgerService.fetchLedgerById(ledgerId);
          if (ledger != null) {
            if (type == 'Dr') {
              print("dr");
              print(ledger);
              ledger.debitBalance += double.parse(debit);
            } else if (type == 'Cr') {
              print("cr");
              print(ledger);
              ledger.debitBalance -= double.parse(credit);
            } else {
              print('Error: Unable to update Ledger.');
            }

            ledgersToUpdate.add(ledger);
          }
        }

        if (ledgersToUpdate.isNotEmpty) {
          for (var ledger in ledgersToUpdate) {
            await ledgerService.updateLedger2(
              ledger,
            );
          }
          print('All ledgers updated successfully.');
        } else {
          print('No ledgers to update.');
        }

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
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Failed to save payment: $error'),
        //     backgroundColor: Colors.red,
        //   ),
        // );
      });
    } catch (error) {
      print('Error in saveReceiptVouchertData: $error');
    }
  }

  restorePreviousState() async {
    print("restore");
    final Payment? payment = await paymentService.fetchPaymentById(widget.id);

    if (payment?.billwise != null && payment!.billwise.isNotEmpty) {
      for (var billwiseEntry in payment.billwise) {
        var purchaseId = billwiseEntry.purchase;
        var adjustmentAmount = billwiseEntry.amount;

        Purchase? purchase =
            await purchaseServices.fetchPurchaseById(purchaseId);
        if (purchase != null) {
          double? dueAmount = double.tryParse(purchase.dueAmount ?? '');
          if (dueAmount != null) {
            dueAmount += adjustmentAmount;
            purchase.dueAmount = dueAmount.toString();
            await purchaseServices.updatePurchase(
              purchase,
            );
          } else {
            print('Error: Unable to parse dueAmount.');
          }
        }
      }
    } else {
      print('No billwise data found.');
    }

    List<Ledger> ledgersToUpdate = [];

    for (var value in payment!.entries) {
      var type = value.account;
      var ledgerId = value.ledger;
      var debit = value.debit;
      var credit = value.credit;

      Ledger? ledger = await ledgerService.fetchLedgerById(ledgerId);
      if (ledger != null) {
        if (type == 'Dr') {
          ledger.debitBalance -= debit!;
          print(
              "Updated ledger $ledgerId with debit, new balance: ${ledger.debitBalance}");
        } else if (type == 'Cr') {
          ledger.debitBalance += credit!;
          print(
              "Updated ledger $ledgerId with credit, new balance: ${ledger.debitBalance}");
        } else {
          print('Error: Unable to update Ledger.');
        }
        ledgersToUpdate.add(ledger);
      }
    }

    if (ledgersToUpdate.isNotEmpty) {
      for (var ledger in ledgersToUpdate) {
        await ledgerService.updateLedger2(ledger);
      }
      print('All ledgers updated successfully.');
    } else {
      print('No ledgers to update.');
    }
    print("exit restore");
  }

  @override
  void _initializeData() async {
    isLoading = true;
    await fetchLedger();
    await fetchAndSetPayment();
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
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

    // Check if an entry with the same uniqueKey exists
    final existingEntryIndex =
        _allValues.indexWhere((entry) => entry['uniqueKey'] == uniqueKey);

    setState(() {
      if (existingEntryIndex != -1) {
        _allValues.removeAt(existingEntryIndex);
      }

      // Add the latest values
      _allValues.add(values);
    });
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

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
    _noController.dispose();
    _narrationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.brown[500],
              ),
            ),
          )
        : Scaffold(
            backgroundColor: white,
            body: SingleChildScrollView(
              child: Opacity(
                opacity: isLoading ? 0.5 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PMDesktopAppbar(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0, left: 0),
                          child: Container(
                            width: mediaQuery.size.width * 0.901,
                            height: 880,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                    bottom:
                                                        BorderSide(width: 1)),
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.898,
                                              height: 55,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 40,
                                                      child: Text(
                                                        'No :',
                                                        style: GoogleFonts.poppins(
                                                            color: const Color(
                                                                0xFF4B0082),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        mediaQuery.size.width *
                                                            0.05,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                    ),
                                                    child: TextFormField(
                                                      controller: _noController,
                                                      enabled: false,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                      cursorHeight: 18,
                                                      decoration:
                                                          const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                left: 8.0,
                                                                bottom: 5.0),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                          width: 60,
                                                          height: 40,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            'Date :',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              color: const Color(
                                                                  0xFF4B0082),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: mediaQuery
                                                                .size.width *
                                                            0.08,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(0),
                                                        ),
                                                        child: TextFormField(
                                                          controller:
                                                              _dateController,
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 17),
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText:
                                                                'Select Date',
                                                            border: InputBorder
                                                                .none,
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    left: 8.0,
                                                                    bottom:
                                                                        5.0),
                                                          ),
                                                          onTap: () {
                                                            _selectDate();
                                                          },
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 5,
                                                                top: 3),
                                                        child: Text(
                                                          formattedDay,
                                                          style: GoogleFonts.poppins(
                                                              color: const Color(
                                                                  0xFF4B0082),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.898,
                                              height: 45,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0, top: 10),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      child: Text(
                                                        'Dr/Cr ',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts.poppins(
                                                            color: const Color(
                                                                0xFF4B0082),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                      child: Text(
                                                        '        Ledger Name ',
                                                        style: GoogleFonts.poppins(
                                                            color: const Color(
                                                                0xFF4B0082),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                      child: Text(
                                                        '        Remark',
                                                        style: GoogleFonts.poppins(
                                                            color: const Color(
                                                                0xFF4B0082),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                      child: Text(
                                                        '        Debit',
                                                        style: GoogleFonts.poppins(
                                                            color: const Color(
                                                                0xFF4B0082),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                      child: Text(
                                                        '        Credit',
                                                        style: GoogleFonts.poppins(
                                                            color: const Color(
                                                                0xFF4B0082),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.898,
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
                                                      itemCount:
                                                          rowDataList.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return _buildRow(index);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            showChequeDepositDetails
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      height: 119,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.6,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.15,
                                                            // decoration: BoxDecoration(
                                                            //   border: Border.all(),
                                                            // ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 8.0),
                                                            child: Text(
                                                              'Cheque Deposit Details',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                decorationThickness:
                                                                    2,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.05,
                                                                height: 40,
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                // decoration: BoxDecoration(
                                                                //   border: Border.all(),
                                                                // ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0),
                                                                child: Text(
                                                                  'Chq No : ',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    color: const Color(
                                                                        0xFF4B0088),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.1,
                                                                height: 40,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      _chequeNoController,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    contentPadding:
                                                                        EdgeInsets
                                                                            .only(
                                                                      bottom:
                                                                          5.0,
                                                                    ),
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                                height: 40,
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                // decoration: BoxDecoration(
                                                                //   border: Border.all(),
                                                                // ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0),
                                                                child: Text(
                                                                  'Chq Date : ',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    color: const Color(
                                                                        0xFF4B0088),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.1,
                                                                height: 40,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .black),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0),
                                                                ),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      _chequeDateController,
                                                                  style: GoogleFonts.poppins(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          17),
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    hintText:
                                                                        'Select Date',
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    contentPadding: EdgeInsets.only(
                                                                        left:
                                                                            8.0,
                                                                        bottom:
                                                                            5.0),
                                                                  ),
                                                                  onTap: () {
                                                                    _selectChqDate();
                                                                  },
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                                height: 40,
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                // decoration: BoxDecoration(
                                                                //   border: Border.all(),
                                                                // ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0),
                                                                child: Text(
                                                                  'Depo Date : ',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    color: const Color(
                                                                        0xFF4B0088),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.1,
                                                                height: 40,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .black),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0),
                                                                ),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      _depositDateController,
                                                                  style: GoogleFonts.poppins(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          17),
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    hintText:
                                                                        'Select Date',
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    contentPadding: EdgeInsets.only(
                                                                        left:
                                                                            8.0,
                                                                        bottom:
                                                                            5.0),
                                                                  ),
                                                                  onTap: () {
                                                                    _selectDepoDate();
                                                                  },
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.05,
                                                                height: 40,
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                // decoration: BoxDecoration(
                                                                //   border: Border.all(),
                                                                // ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0),
                                                                child: Text(
                                                                  'Batch No : ',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    color: const Color(
                                                                        0xFF4B0088),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.05,
                                                                height: 40,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      _batchNoController,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    contentPadding:
                                                                        EdgeInsets
                                                                            .only(
                                                                      bottom:
                                                                          5.0,
                                                                    ),
                                                                    border:
                                                                        InputBorder
                                                                            .none,
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
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.05,
                                                                height: 40,
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                // decoration: BoxDecoration(
                                                                //   border: Border.all(),
                                                                // ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0),
                                                                child: Text(
                                                                  'Bank : ',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    color: const Color(
                                                                        0xFF4B0088),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.26,
                                                                height: 40,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      _bankController,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    contentPadding:
                                                                        EdgeInsets
                                                                            .only(
                                                                      bottom:
                                                                          5.0,
                                                                    ),
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                                height: 40,
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                // decoration: BoxDecoration(
                                                                //   border: Border.all(),
                                                                // ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0),
                                                                child: Text(
                                                                  'Branch : ',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    color: const Color(
                                                                        0xFF4B0088),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.2,
                                                                height: 40,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      _branchController,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    contentPadding:
                                                                        EdgeInsets
                                                                            .only(
                                                                      bottom:
                                                                          5.0,
                                                                    ),
                                                                    border:
                                                                        InputBorder
                                                                            .none,
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
                                              height: 130,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.895,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                      width: 120,
                                                      child: Text(
                                                        'Narration :',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: const Color(
                                                              0xFF4B0082),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 1, top: 10),
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextField(
                                                          controller:
                                                              _narrationController,
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 18),
                                                          textAlign:
                                                              TextAlign.start,
                                                          maxLines: 2,
                                                          decoration:
                                                              const InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 1),
                                                            child: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.08,
                                                              height: 25,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: const Border(
                                                                    bottom: BorderSide(
                                                                        width:
                                                                            3)),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            5),
                                                                child: Text(
                                                                  '\$${totalDebitAmount.toStringAsFixed(2)}', // Total Dr
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    color: const Color(
                                                                        0xFF4B0082),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.01,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 1),
                                                            child: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.08,
                                                              height: 25,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: const Border(
                                                                    bottom: BorderSide(
                                                                        width:
                                                                            3)),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            5),
                                                                child: Text(
                                                                  '\$${totalCreditAmount.toStringAsFixed(2)}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    color: const Color(
                                                                        0xFF4B0082),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 8.0),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 1),
                                                            child: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.08,
                                                              height: 25,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 5),
                                                                child: Text(
                                                                    '[$debitRowCount] Dr',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                    style: GoogleFonts.poppins(
                                                                        color: const Color(
                                                                            0xFF4B0082),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize:
                                                                            15)),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 1),
                                                            child: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.08,
                                                              height: 25,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 5),
                                                                child: Text(
                                                                  '[$creditRowCount] Cr',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                  style: GoogleFonts.poppins(
                                                                      color: const Color(
                                                                          0xFF4B0082),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.898,
                                              height: 50,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed:
                                                              savePaymentData,
                                                          style: ElevatedButton.styleFrom(
                                                              fixedSize: Size(
                                                                  MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .1,
                                                                  25),
                                                              shape: const BeveledRectangleBorder(
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .black,
                                                                      width:
                                                                          .3)),
                                                              backgroundColor:
                                                                  Colors.yellow
                                                                      .shade100),
                                                          child: const Text(
                                                            'Save [F4]',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .002,
                                                        ),
                                                        ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    fixedSize: Size(
                                                                        MediaQuery.of(context).size.width *
                                                                            .1,
                                                                        25),
                                                                    shape:
                                                                        const BeveledRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: Colors
                                                                              .black,
                                                                          width:
                                                                              .3),
                                                                    ),
                                                                    backgroundColor: Colors
                                                                        .yellow
                                                                        .shade100),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .002,
                                                        ),
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  fixedSize: Size(
                                                                      MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          .1,
                                                                      25),
                                                                  shape:
                                                                      const BeveledRectangleBorder(
                                                                    side:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .black,
                                                                      width: .3,
                                                                    ),
                                                                  ),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow
                                                                          .shade100),
                                                          onPressed: () async {
                                                            await restorePreviousState();
                                                            await paymentService
                                                                .deletePayment(
                                                                    widget.id,
                                                                    context);
                                                          },
                                                          child: const Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
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
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.099,
                          child: Column(
                            children: [
                              DSideBUtton(
                                onTapped: () {},
                                text: 'F2 List',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: 'P Print',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: 'F5 Payment',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: 'F6 Receipt',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: 'F7 Journal',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: 'F8 Contra',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: 'F12 Create New',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: '',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: '',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: '',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: 'PgUp Previous',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: 'PgDn Next',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: 'F12 Audit Trail',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: 'F10 Change Vch.',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: 'D Goto Date',
                              ),
                              DSideBUtton(
                                onTapped: () {
                                  print(_allValues);
                                },
                                text: 'Save Entries',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: 'G Attach. Img',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: '',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: 'G Vch Setup',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: 'T Print Setup',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: '',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: '',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: '',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: '',
                              ),
                              DSideBUtton(
                                onTapped: () {},
                                text: '',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
