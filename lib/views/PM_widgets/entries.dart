import 'package:billingsphere/data/models/ledger/ledger_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../searchable_dropdown.dart';

class Entries extends StatefulWidget {
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

  Entries({
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
  State<Entries> createState() => _EntriesState();
}

class _EntriesState extends State<Entries> {
  late String _selectedDropdownValue;
  late TextEditingController? _remarkController1;
  late TextEditingController _creditController;
  late TextEditingController _debitController;
  bool isCredit = false;
  bool isDebit = true;
  final TextEditingController _searchController = TextEditingController();

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

  // Method to delete entry
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

  // Method to retrieve all controller values
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
              Container(
                width: MediaQuery.of(context).size.width * 0.05,
                height: 40,
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
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w600),
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
                        _creditController.clear();
                        _debitController.clear();
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
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: SearchableDropDown(
                  controller: _searchController,
                  searchController: _searchController,
                  value: _selectedDropdownValue,
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
                        child: Text(
                          ledger.name,
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  }).toList(),
                  searchMatchFn: (item, searchValue) {
                    final itemMLimit = widget.suggestionItems5
                        .firstWhere((e) => e.id == item.value)
                        .name;
                    return itemMLimit
                        .toLowerCase()
                        .contains(searchValue.toLowerCase());
                  },
                ),
                // child: DropdownButtonHideUnderline(
                //   child: DropdownButton<String>(
                //     value: _selectedDropdownValue,
                //     underline: Container(),
                //     onChanged: (String? newValue) {
                //       setState(() {
                //         _selectedDropdownValue = newValue!;
                //       });
                //     },
                //     items: widget.suggestionItems5.map((Ledger ledger) {
                //       return DropdownMenuItem<String>(
                //         value: ledger.id,
                //         child: Padding(
                //           padding: const EdgeInsets.all(2.0),
                //           child: Text(
                //             ledger.name,
                //             style: GoogleFonts.poppins(
                //                 fontWeight: FontWeight.w600),
                //           ),
                //         ),
                //       );
                //     }).toList(),
                //   ),
                // ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: TextFormField(
                  cursorHeight: 18,
                  controller: _remarkController1,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(8.0),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: TextFormField(
                  cursorHeight: 18,
                  enabled: isCredit,
                  controller: _creditController,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(8.0),
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                  ],
                  onChanged: (value) {
                    _saveValues();
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: TextFormField(
                  cursorHeight: 18,
                  enabled: isDebit,
                  controller: _debitController,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(8.0),
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                  ],
                  onChanged: (value) {
                    _saveValues();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
