import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../data/models/ledger/ledger_model.dart';

class RVMyRow extends StatefulWidget {
  final List<String> dropdownItems;
  List<Ledger> suggestionItems5 = [];
  String? selectedLedgerName;
  String? remark;
  String dropdownValue;
  final Function(Map<String, dynamic>) onSaveValues; // Function to save values
  final Function(String) onDelete;
  double? credit;
  double? debit;
  final String entryId;
  RVMyRow({
    super.key,
    required this.dropdownItems,
    required this.suggestionItems5,
    required this.dropdownValue,
    required this.selectedLedgerName,
    required this.onSaveValues,
    required this.onDelete,
    required this.entryId,
    this.remark,
    this.credit,
    this.debit,
  });

  @override
  // ignore: library_private_types_in_public_api
  _RVMyRowState createState() => _RVMyRowState();
}

class _RVMyRowState extends State<RVMyRow> {
  late String _selectedDropdownValue;
  late TextEditingController? _remarkController1;
  late TextEditingController _creditController;
  late TextEditingController _debitController;
  bool isCredit = false;
  bool isDebit = true;

  void _initialize() {
    _selectedDropdownValue = widget.selectedLedgerName!;
    _remarkController1 = TextEditingController();
    _creditController = TextEditingController();
    _debitController = TextEditingController();

    if (widget.dropdownValue == 'Cr') {
      setState(() {
        isCredit = true;
        isDebit = false;
      });
    } else {
      setState(() {
        isCredit = false;
        isDebit = true;
      });
    }

    if (widget.remark != null) {
      _remarkController1?.text = widget.remark ?? 'No remark';
    }

    if (widget.credit != null) {
      _creditController.text = widget.credit.toString();
    }

    if (widget.debit != null) {
      _debitController.text = widget.debit.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _deleteEntry() {
    widget.onDelete(widget.entryId);
    Fluttertoast.showToast(
      msg: "Entry deleted successfully!",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER_RIGHT,
      webPosition: "right",
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  void _saveValues() {
    if (_creditController.text.isEmpty && _debitController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill entries properly!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER_RIGHT,
        webPosition: "right",
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      return;
    }
    final values = {
      'uniqueKey': widget.entryId,
      'dropdownValue': widget.dropdownValue,
      'selectedLedgerName': _selectedDropdownValue,
      'remark':
          _remarkController1!.text.isEmpty ? ' ' : _remarkController1?.text,
      'credit': _creditController.text.isEmpty ? '0' : _creditController.text,
      'debit': _debitController.text.isEmpty ? '0' : _debitController.text,
    };

    Fluttertoast.showToast(
      msg: "Values added to list successfully!",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER_RIGHT,
      webPosition: "right",
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
    widget.onSaveValues(values);
  }

  @override
  void dispose() {
    super.dispose();
    _remarkController1?.dispose();
    _creditController.dispose();
    _debitController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // padding: const EdgeInsets.only(top: 10),
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: 25,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Center(
                    child: DropdownButton(
                      underline: Container(),
                      style: const TextStyle(
                        fontSize: 15,
                        backgroundColor: Colors.transparent,
                      ),
                      items: widget.dropdownItems.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 15,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          widget.dropdownValue = newValue!;

                          if (widget.dropdownValue == 'Cr') {
                            setState(() {
                              isCredit = true;
                              isDebit = false;
                            });
                          } else {
                            setState(() {
                              isCredit = false;
                              isDebit = true;
                            });
                          }
                        });
                      },
                      value: widget.dropdownValue,
                      icon: const Icon(
                        Icons.arrow_drop_down_sharp,
                      ),
                      iconSize: 25,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 4,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: 25,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedDropdownValue,
                      underline: Container(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedDropdownValue = newValue!;
                        });
                      },
                      items: widget.suggestionItems5.map((Ledger ledger) {
                        return DropdownMenuItem<String>(
                          value: ledger.id,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(ledger.name),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 4,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: 25,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: TextFormField(
                    controller: _remarkController1,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: 25,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: TextFormField(
                    enabled: isCredit,
                    controller: _creditController,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      _saveValues();
                    },
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: 25,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: TextFormField(
                    enabled: isDebit,
                    controller: _debitController,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      _saveValues();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
