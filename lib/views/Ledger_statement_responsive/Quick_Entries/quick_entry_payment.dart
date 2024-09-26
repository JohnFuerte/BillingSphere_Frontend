import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/ledger/ledger_model.dart';
import '../../../data/repository/ledger_repository.dart';
import '../../searchable_dropdown.dart';
import 'quick_entry_billwise_payment.dart';

class QuickEntryPayment extends StatefulWidget {
  const QuickEntryPayment(
      {super.key,
      required this.lid,
      required this.amount,
      this.startDate,
      this.endDate});

  final Ledger lid;
  final double amount;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  State<QuickEntryPayment> createState() => _ChequeReturnEntryState();
}

class _ChequeReturnEntryState extends State<QuickEntryPayment> {
  bool isLoading = false;
  String formattedDay = '';

  LedgerService ledgerService = LedgerService();
  String? selectedId;
  String? selectedIdLedgerName;
  String? voucherBal;
  String? selectedId2;
  String? selectedId2LedgerName;
  String? cashbankBal;

  List<Ledger> fetchedLedgers = [];
  List<Ledger> fetchedLedgers2 = [];
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchController2 = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _noController = TextEditingController();
  final TextEditingController _narrationController = TextEditingController();
  final TextEditingController _voucherTypeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final formatter = DateFormat('dd/MM/yyyy');

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

  Future<void> fetchLedgers() async {
    setState(() {
      isLoading = true;
    });
    try {
      final List<Ledger> ledger = await ledgerService.fetchLedgers();

      ledger.insert(
        0,
        Ledger(
          id: '',
          name: '',
          printName: '',
          aliasName: '',
          ledgerGroup: '',
          date: '',
          bilwiseAccounting: '',
          creditDays: 0,
          openingBalance: 0,
          debitBalance: 0,
          ledgerType: '',
          priceListCategory: '',
          remarks: '',
          status: 'Yes',
          ledgerCode: 0,
          mailingName: '',
          address: '',
          city: '',
          region: '',
          state: '',
          pincode: 0,
          tel: 0,
          fax: 0,
          mobile: 0,
          sms: 0,
          email: '',
          contactPerson: '',
          bankName: '',
          branchName: '',
          ifsc: '',
          accName: '',
          accNo: '',
          panNo: '',
          gst: '',
          gstDated: '',
          cstNo: '',
          cstDated: '',
          lstNo: '',
          lstDated: '',
          serviceTaxNo: '',
          serviceTaxDated: '',
          registrationType: '',
          registrationTypeDated: '',
        ),
      ); // Modify this line according to your Ledger class

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        fetchedLedgers = ledger
            .where((element) =>
                element.status == 'Yes' &&
                element.ledgerGroup == '662f97d2a07ec73369c237b0')
            .toList();
        fetchedLedgers2 = ledger;
        selectedId = widget.lid.id;
        selectedIdLedgerName = widget.lid.name;
        voucherBal = (widget.lid.debitBalance).toStringAsFixed(2);
        selectedId2 = fetchedLedgers[0].id;
        cashbankBal = (fetchedLedgers[0].debitBalance).toStringAsFixed(2);
        selectedId2LedgerName = fetchedLedgers[0].name;

        isLoading = false;
      });
    } catch (error) {
      print('Failed to fetch ledger name: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLedgers();
    _dateController.text = formatter.format(DateTime.now());
    _voucherTypeController.text = 'Payment';
    _amountController.text = (widget.amount).toStringAsFixed(2);
  }

  @override
  void dispose() {
    searchController2.dispose();
    _dateController.dispose();
    _noController.dispose();
    _narrationController.dispose();
    _voucherTypeController.dispose();
    _amountController.dispose();
    super.dispose();
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
                  color: Colors.brown[700],
                ),
                child: const Text(
                  "QUICK VOUCHER ENTRY - Payment",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
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
                        //date
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: 45,
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "Date",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 45,
                              width: MediaQuery.of(context).size.width * 0.08,
                              child: TextField(
                                cursorHeight: 18,
                                controller: _dateController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        0.0), // Adjust the border radius as needed
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 5),

                        //voucher Type
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: 45,
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "Voucher Type",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 45,
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: TextField(
                                cursorHeight: 18,
                                controller: _voucherTypeController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        0.0), // Adjust the border radius as needed
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),

                        //Partyledger
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: 45,
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "Party (Cr)",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(border: Border.all()),
                              height: 45,
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: SearchableDropDown(
                                controller: searchController,
                                searchController: searchController,
                                value: selectedId,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedId = newValue;
                                    final selectedLedger =
                                        fetchedLedgers.firstWhere(
                                            (ledger) => ledger.id == newValue);
                                    selectedIdLedgerName = selectedLedger.name;
                                  });
                                },
                                items: fetchedLedgers.map((Ledger ledger) {
                                  return DropdownMenuItem<String>(
                                    value: ledger.id,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(ledger.name),
                                    ),
                                  );
                                }).toList(),
                                searchMatchFn: (item, searchValue) {
                                  final itemMLimit = fetchedLedgers
                                      .firstWhere((e) => e.id == item.value)
                                      .name;
                                  return itemMLimit
                                      .toLowerCase()
                                      .contains(searchValue.toLowerCase());
                                },
                              ),
                            ),
                          ],
                        ),
                        voucherBal != null
                            ? Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    height: 45,
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      "",
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 45,
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Bal: $voucherBal',
                                      style: const TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),

                        const SizedBox(height: 5),

                        //Cash/Bank
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: 45,
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "Cash/Bank (Dr)",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(border: Border.all()),
                              height: 45,
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: SearchableDropDown(
                                controller: searchController2,
                                searchController: searchController2,
                                value: selectedId2,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedId2 = newValue;
                                    final selectedLedger =
                                        fetchedLedgers2.firstWhere(
                                            (ledger) => ledger.id == newValue);
                                    cashbankBal = selectedLedger.debitBalance
                                        .toStringAsFixed(2);
                                    selectedId2LedgerName = selectedLedger.name;
                                  });
                                },
                                items: fetchedLedgers2.map((Ledger ledger) {
                                  return DropdownMenuItem<String>(
                                    value: ledger.id,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(ledger.name),
                                    ),
                                  );
                                }).toList(),
                                searchMatchFn: (item, searchValue) {
                                  final itemMLimit = fetchedLedgers2
                                      .firstWhere((e) => e.id == item.value)
                                      .name;
                                  return itemMLimit
                                      .toLowerCase()
                                      .contains(searchValue.toLowerCase());
                                },
                              ),
                            ),
                          ],
                        ),
                        cashbankBal != null
                            ? Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    height: 45,
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      "",
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 45,
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Bal: $cashbankBal',
                                      style: const TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),

                        const SizedBox(height: 5),

                        //date
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: 45,
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
                            SizedBox(
                              height: 45,
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: TextField(
                                cursorHeight: 18,
                                controller: _amountController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        0.0), // Adjust the border radius as needed
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        //Narration
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: 45,
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "Narration",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 45,
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: TextField(
                                cursorHeight: 18,
                                controller: _narrationController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        0.0), // Adjust the border radius as needed
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //Buttons
                        Row(
                          children: [
                            SizedBox(
                              height: 45,
                              width: MediaQuery.of(context).size.width * 0.48,
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
                                    onPressed: () {
                                      openDialog1(context);
                                    },
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
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openDialog1(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => QuickEntryBillwisePayment(
        startDate: widget.startDate,
        endDate: widget.endDate,
        lid: widget.lid,
        id: selectedId!,
        id2: selectedId2!,
        ledgerName: selectedIdLedgerName!,
        ledgerName2: selectedId2LedgerName!,
        totalamount: double.parse(_amountController.text),
        narration: _narrationController.text,
      ),
    );
  }
}
