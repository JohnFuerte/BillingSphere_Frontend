import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/ledger/ledger_model.dart';
import '../data/models/payment/payment_model.dart';
import '../data/models/purchase/purchase_model.dart';
import '../data/repository/ledger_repository.dart';
import '../data/repository/payment_respository.dart';
import '../data/repository/purchase_repository.dart';
import '../views/PM_responsive/payment_receipt2.dart';
import '../views/searchable_dropdown.dart';

class PaymentPopUpFormPA extends StatefulWidget {
  const PaymentPopUpFormPA({super.key, required this.data, required this.id});

  final Map<String, dynamic> data;
  final String id;

  @override
  State<PaymentPopUpFormPA> createState() => _ChequeReturnEntryState();
}

class _ChequeReturnEntryState extends State<PaymentPopUpFormPA> {
  int? selectedRadio;
  bool isLoading = false;
  String formattedDay = '';
  int _generatedNumber = 0;

  LedgerService ledgerService = LedgerService();
  final TextEditingController searchController2 = TextEditingController();
  String? selectedId;
  String? selectedId2;
  List<Ledger> fetchedLedgers = [];
  List<Payment> fetchedPayment = [];
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _noController = TextEditingController();
  final TextEditingController _narrationController = TextEditingController();
  final formatter = DateFormat('dd/MM/yyyy');
  PaymentService paymentService = PaymentService();
  PurchaseServices purchaseService = PurchaseServices();

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

  Future<void> fetchLedgers() async {
    setState(() {
      isLoading = true;
    });
    try {
      final List<Ledger> ledger = await ledgerService.fetchLedgers();
      ledger.removeWhere((element) => element.status == "No");

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
        fetchedLedgers =
            ledger.where((element) => element.status == 'Yes').toList();

        selectedId = fetchedLedgers[0].id;

        isLoading = false;
      });
    } catch (error) {
      print('Failed to fetch ledger name: $error');
    }
  }

  Future<void> fetchAllPayment() async {
    final List<Payment> payment = await paymentService.fetchPayments();

    setState(() {
      fetchedPayment = payment;

      if (fetchedPayment.isNotEmpty) {
        selectedId2 = fetchedPayment[0].id;
      }
    });
  }

  Future<void> savePaymentData() async {
    try {
      // Prepare entries for the payment
      List<Entry> entries = [];
      List<Billwise> billwise = [];

      // Add entries for each selected purchase
      double totalDebit = widget.data.values
          .map<double>((e) => double.parse(e['adjustmentAmount'].toString()))
          .reduce((value, element) => value + element);

      entries.add(
        Entry(
          account: 'Dr',
          ledger: widget.id,
          remark: '',
          debit: totalDebit,
          credit: 0,
        ),
      );

      entries.add(
        Entry(
          account: 'Cr',
          ledger: selectedId!,
          remark: '',
          debit: 0,
          credit: totalDebit,
        ),
      );

      widget.data.forEach((key, value) {
        billwise.add(
          Billwise(
            date: _dateController.text,
            purchase: value['id'],
            amount: double.parse(value['adjustmentAmount'].toString()),
            billNo: value['billNumber'],
          ),
        );
      });

      // Create the Payment object
      Payment payment = Payment(
        id: '', // Generate an ID for the payment
        companyCode: companyCode!.first,
        totalamount: totalDebit,
        no: int.parse(_noController.text),
        date: _dateController.text,
        entries: entries,
        billwise: billwise,
        narration: _narrationController.text,
      );

      // Save the payment object to the database or use it as needed
      print(payment.toJson()); // Replace this with your actual saving logic
      // Save the payment
      await paymentService.createPayment(payment, context).then((value) async {
        // Update each purchase
        for (var entry in widget.data.entries) {
          var key = entry.key;
          var value = entry.value;
          var purchaseId = key; // Assuming 'key' is the purchase ID
          var adjustmentAmount =
              double.parse(value['adjustmentAmount'].toString());

          Purchase? purchase =
              await purchaseService.fetchPurchaseById(purchaseId);
          if (purchase != null) {
            double? dueAmount = double.tryParse(purchase.dueAmount ?? '');
            if (dueAmount != null) {
              dueAmount -= adjustmentAmount;
              purchase.dueAmount = dueAmount.toString();
              await purchaseService.updatePurchase(purchase, context);
            } else {
              // Handle the case when the conversion from String to double fails
              print('Error: Unable to parse dueAmount.');
            }
          }
        }

        double totalAdjustmentAmount = widget.data.values
            .map<double>((e) => double.parse(e['adjustmentAmount'].toString()))
            .reduce((value, element) => value + element);

        Ledger? ledger = await ledgerService.fetchLedgerById(widget.id);

        if (ledger != null) {
          ledger.debitBalance -= totalAdjustmentAmount;
          await ledgerService.updateLedger2(ledger, context);
        } else {
          // Handle the case when the conversion from String to double fails
          print('Error: Unable to update Ledger.');
        }
        Ledger? ledger2 = await ledgerService.fetchLedgerById(selectedId!);

        if (ledger2 != null) {
          ledger2.debitBalance += totalAdjustmentAmount;
          await ledgerService.updateLedger2(ledger2, context);
        } else {
          // Handle the case when the conversion from String to double fails
          print('Error: Unable to update Ledger.');
        }

        setState(() {
          isLoading = false;
        });

        // Clear all controllers, values and widgets
        _noController.clear();
        _dateController.clear();

        fetchAllPayment().then((_) {
          final newReceipt = fetchedPayment.firstWhere(
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
                content: const Text("Do you want to print the receipt?"),
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
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      // Add code to handle printing here
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
    } catch (e) {
      print('Error in savePaymentData: $e');
    }
  }

  // Generate Random Numbers
  void _generateRandomNumber() {
    setState(() {
      _generatedNumber = Random().nextInt(9000) + 100;
      _noController.text = _generatedNumber.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    selectedRadio = 1;
    fetchLedgers();
    _generateRandomNumber();
    _dateController.text = formatter.format(DateTime.now());
    setCompanyCode();
    print(widget.data);
    print(widget.id);
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
                  color: Colors.blue[900],
                ),
                child: const Text(
                  "Generate Receipt",
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
                        Row(
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Text(
                                "Voucher Type",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: SizedBox(
                                height: 30,
                                child: TextField(
                                  cursorHeight: 15,
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
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  "Cash/Bank",
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  height: 30,
                                  child: SearchableDropDown(
                                    controller: searchController2,
                                    searchController: searchController2,
                                    value: selectedId,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedId = newValue;
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
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  "Date",
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: SizedBox(
                                  height: 30,
                                  child: TextField(
                                    cursorHeight: 15,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            0.0), // Adjust the border radius as needed
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  "Narration",
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: SizedBox(
                                  height: 30,
                                  child: TextField(
                                    controller: _narrationController,
                                    cursorHeight: 15,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            0.0), // Adjust the border radius as needed
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 180.0),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: ElevatedButton(
                                onPressed: savePaymentData,
                                child: Text("Print Receipt"),
                              ),
                            ),
                          ],
                        )
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
}
