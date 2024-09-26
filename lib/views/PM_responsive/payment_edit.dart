import 'package:billingsphere/data/models/ledger/ledger_model.dart';
import 'package:billingsphere/data/models/payment/payment_model.dart';
import 'package:billingsphere/data/repository/ledger_repository.dart';
import 'package:billingsphere/data/repository/payment_respository.dart';
import 'package:billingsphere/views/PM_widgets/entries.dart';
import 'package:billingsphere/views/PM_widgets/PM_desktopappbar.dart';
import 'package:billingsphere/views/RA_widgets/RA_D_side_buttons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PMMyPaymentDesktopBodyE extends StatefulWidget {
  final String id;
  const PMMyPaymentDesktopBodyE({super.key, required this.id});

  @override
  State<PMMyPaymentDesktopBodyE> createState() =>
      _PMMyPaymentDesktopBodyState();
}

class _PMMyPaymentDesktopBodyState extends State<PMMyPaymentDesktopBodyE> {
  var items = ['Dr', 'Cr'];
  var items2 = ['Dr', 'Cr'];
  final formatter = DateFormat.yMd();
  List<Ledger> suggestionItems5 = [];
  String? selectedLedgerName;
  DateTime? _selectedDate;
  // TextControllers
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _noController = TextEditingController();
  final TextEditingController _narrationController = TextEditingController();

  String formattedDay = '';
  double totalDebit = 0;
  double totalCredit = 0;
  double debitCount = 0;
  double creditCount = 0;
  bool isLoading = false;

  List<Map<String, dynamic>> _allValues = [];
  List<Entries> _newWidget = [];

  // Services
  LedgerService ledgerService = LedgerService();
  PaymentService paymentService = PaymentService();

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
  Future<void> fetchAndSetLedgers() async {
    try {
      final List<Ledger> ledger = await ledgerService.fetchLedgers();

      setState(() {
        suggestionItems5 = ledger;
        selectedLedgerName =
            suggestionItems5.isNotEmpty ? suggestionItems5.first.id : null;
      });
    } catch (error) {
      print('Failed to fetch ledger name: $error');
    }
  }

  Future<void> fetchAndSetPayment() async {
    try {
      final Payment? payment = await paymentService.fetchPaymentById(widget.id);

      final entryId = UniqueKey().toString();

      setState(
        () {
          _noController.text = (payment!.no).toString();
          _dateController.text = payment.date;
          _narrationController.text = payment.narration!;
          _allValues = payment.entries.map((e) => e.toMap()).toList();

          _newWidget = _allValues
              .map(
                (e) => Entries(
                  dropdownItems: items,
                  suggestionItems5: suggestionItems5,
                  dropdownValue: e['account'] ?? 'Dr',
                  selectedLedgerName: e['ledger'] ?? selectedLedgerName!,
                  onSaveValues: saveValues,
                  entryId: entryId,
                  remark: e['remark'],
                  debit: e['debit'],
                  credit: e['credit'],
                  onDelete: (String entryId) {
                    setState(() {
                      _newWidget.removeWhere(
                          (widget) => widget.key == ValueKey(entryId));

                      Map<String, dynamic>? entryToRemove;
                      for (final entry in _allValues) {
                        if (entry['uniqueKey'] == entryId) {
                          entryToRemove = entry;
                          break;
                        }
                      }
                      // Remove the map from _allValues if found
                      if (entryToRemove != null) {
                        _allValues.remove(entryToRemove);
                      }
                    });
                  },
                ),
              )
              .toList();
        },
      );
      calculateTotal();
    } catch (error) {
      print('Failed to fetch payment: $error');
    }
  }

  String? companyCode;
  Future<String?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('companyCode');
  }

  Future<void> setCompanyCode() async {
    String? code = await getCompanyCode();
    setState(() {
      companyCode = code;
    });
  }

  // Future<void> updatePayment() async {
  //   try {
  //     List<Map<String, dynamic>> modifiedValues = _allValues.map((e) {
  //       e.remove('uniqueKey');
  //       return e;
  //     }).toList();

  //     final payment = Payment(
  //       id: widget.id,
  //       companyCode: companyCode!,
  //       totalamount: (creditCount - debitCount),
  //       no: _noController.text,
  //       date: _dateController.text,
  //       narration: _narrationController.text,
  //       entries: modifiedValues.map((e) {
  //         return Entry(
  //           account: e['dropdownValue'] ?? e['account'],
  //           ledger: e['selectedLedgerName'] ?? selectedLedgerName!,
  //           remark: e['remark'] ?? 'Hey',
  //           debit: double.tryParse(e['debit'].toString()) ?? 0,
  //           credit: double.tryParse(e['credit'].toString()) ?? 0,
  //         );
  //       }).toList(),
  //     );

  //     await paymentService.updatePayment(payment, context);
  //   } catch (error) {
  //     print('Failed to update payment: $error');
  //   }
  // }

  @override
  void _initializeData() async {
    isLoading = true;
    await fetchAndSetLedgers();
    await fetchAndSetPayment();
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }

  // Function to save values from Entries widget
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
  void _presentDatePICKER() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final _pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );

    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
        _dateController.text = formatter.format(_pickedDate);
        formattedDay = DateFormat('EEEE').format(_selectedDate!);
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
            backgroundColor: const Color.fromARGB(255, 215, 215, 215),
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
                            height: 756,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,

                                //                   <--- border width here
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
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                    bottom:
                                                        BorderSide(width: 1)),
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.898,
                                              height: 45,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Flexible(
                                                    child: SizedBox(
                                                      width: 40,
                                                      child: Text(
                                                        'No :',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    113,
                                                                    8,
                                                                    170),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Container(
                                                      width: mediaQuery
                                                              .size.width *
                                                          0.26,
                                                      height: 25,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextFormField(
                                                          controller:
                                                              _noController,
                                                          enabled: false,
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          decoration:
                                                              const InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        left: mediaQuery
                                                                .size.width *
                                                            0.40,
                                                      ),
                                                      child: const SizedBox(
                                                        width: 50,
                                                        child: Text(
                                                          'Date :',
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      113,
                                                                      8,
                                                                      170),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Container(
                                                      width: mediaQuery
                                                              .size.width *
                                                          0.15,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 0,
                                                                left: 10),
                                                        child: TextFormField(
                                                          controller:
                                                              _dateController,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText:
                                                                'Select Date',
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                          onTap: () {
                                                            _presentDatePICKER();
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5, top: 3),
                                                    child: Text(
                                                      formattedDay,
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 113, 8, 170),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(width: 1),
                                                ),
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.898,
                                              height: 45,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      child: const Text(
                                                        'Dr/Cr ',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 113, 8, 170),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.35,
                                                      child: const Text(
                                                        'Ledger Name ',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 113, 8, 170),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 3),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.35,
                                                        child: const Text(
                                                          'Remark',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    113,
                                                                    8,
                                                                    170),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      child: const Text(
                                                        'Credit',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 113, 8, 170),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      child: const Text(
                                                        'Debit',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 113, 8, 170),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.898,
                                              height: 383,
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(width: 1),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      child: Column(
                                                        children: [
                                                          Column(
                                                            children:
                                                                _newWidget,
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          _allValues.isEmpty
                                                              ? Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                        'No Entries Added'),
                                                                  ],
                                                                )
                                                              : OutlinedButton(
                                                                  onPressed:
                                                                      calculateTotal,
                                                                  style: OutlinedButton
                                                                      .styleFrom(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0.0),
                                                                    ),
                                                                    side: const BorderSide(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    'Save All Entries',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black,
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
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.898,
                                              height: 180,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.09,
                                                        child: const Text(
                                                          'Narration :',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    113,
                                                                    8,
                                                                    170),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.310,
                                                        decoration:
                                                            BoxDecoration(
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
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            textAlign:
                                                                TextAlign.start,
                                                            maxLines: 2,
                                                            decoration:
                                                                const InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Container(),
                                                    ),
                                                    Column(
                                                      children: [
                                                        Row(
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
                                                                  border: Border(
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
                                                                    '\$${totalDebit.toStringAsFixed(2)}', // Total Dr
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          113,
                                                                          8,
                                                                          170),
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
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
                                                                  border: Border(
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
                                                                    '\$${totalCredit.toStringAsFixed(2)}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          113,
                                                                          8,
                                                                          170),
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
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
                                                                          top:
                                                                              5),
                                                                  child: Text(
                                                                    '[$debitCount] Dr',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          113,
                                                                          8,
                                                                          170),
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
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
                                                                          top:
                                                                              5),
                                                                  child: Text(
                                                                    '[$creditCount] Cr',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          113,
                                                                          8,
                                                                          170),
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
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
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.898,
                                              height: 100,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 0),
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SizedBox(
                                                                width: 150,
                                                                height: 30,
                                                                child: SizedBox(
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed:
                                                                        () {}

                                                                    // updatePayment
                                                                    ,
                                                                    style:
                                                                        ButtonStyle(
                                                                      backgroundColor:
                                                                          MaterialStateProperty.all<
                                                                              Color>(
                                                                        const Color
                                                                            .fromARGB(
                                                                            172,
                                                                            236,
                                                                            226,
                                                                            137),
                                                                      ),
                                                                      shape: MaterialStateProperty
                                                                          .all<
                                                                              OutlinedBorder>(
                                                                        RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(1.0),
                                                                          side:
                                                                              const BorderSide(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                88,
                                                                                81,
                                                                                11),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        const Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Text(
                                                                        'Save [F4]',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w900,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            15),
                                                                child: SizedBox(
                                                                  width: 120,
                                                                  height: 30,
                                                                  child:
                                                                      SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0,
                                                                    child:
                                                                        ElevatedButton(
                                                                      onPressed:
                                                                          () {},
                                                                      style:
                                                                          ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStateProperty.all<Color>(
                                                                          const Color
                                                                              .fromARGB(
                                                                              172,
                                                                              236,
                                                                              226,
                                                                              137),
                                                                        ),
                                                                        shape: MaterialStateProperty.all<
                                                                            OutlinedBorder>(
                                                                          RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(1.0),
                                                                            side:
                                                                                const BorderSide(
                                                                              color: Color.fromARGB(255, 88, 81, 11),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          const Align(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Text(
                                                                          'Cancel',
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w900),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            15),
                                                                child: SizedBox(
                                                                  width: 120,
                                                                  height: 30,
                                                                  child:
                                                                      SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0,
                                                                    child:
                                                                        ElevatedButton(
                                                                      onPressed:
                                                                          () {},
                                                                      style:
                                                                          ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStateProperty.all<Color>(
                                                                          const Color
                                                                              .fromARGB(
                                                                              172,
                                                                              236,
                                                                              226,
                                                                              137),
                                                                        ),
                                                                        shape: MaterialStateProperty.all<
                                                                            OutlinedBorder>(
                                                                          RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(1.0),
                                                                            side:
                                                                                const BorderSide(
                                                                              color: Color.fromARGB(255, 88, 81, 11),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          const Align(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Text(
                                                                          'Delete',
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w900),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
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
                                onTapped: () {
                                  final entryId = UniqueKey().toString();
                                  setState(() {
                                    _newWidget.add(Entries(
                                      key: ValueKey(entryId),
                                      dropdownItems: items,
                                      suggestionItems5: suggestionItems5,
                                      dropdownValue: 'Dr',
                                      selectedLedgerName: selectedLedgerName,
                                      onSaveValues: saveValues,
                                      entryId: entryId,
                                      onDelete: (String entryId) {
                                        setState(() {
                                          _newWidget.removeWhere((widget) =>
                                              widget.key == ValueKey(entryId));

                                          // Find the map in _allValues that contains the entry with the specified entryId
                                          Map<String, dynamic>? entryToRemove;
                                          for (final entry in _allValues) {
                                            if (entry['uniqueKey'] == entryId) {
                                              entryToRemove = entry;
                                              break;
                                            }
                                          }

                                          // Remove the map from _allValues if found
                                          if (entryToRemove != null) {
                                            _allValues.remove(entryToRemove);
                                          }
                                        });
                                      },
                                    ));
                                  });
                                },
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
