// ignore_for_file: unrelated_type_equality_checks

import 'package:billingsphere/data/models/sundry/sundry_model.dart';
import 'package:billingsphere/data/repository/sundry_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SundryRow extends StatefulWidget {
  final int serialNumber;

  const SundryRow({
    super.key,
    required this.serialNumber,
    required this.sundryControllerP,
    required this.sundryControllerQ,
    required this.onSaveValues,
    required this.onDelete,
    required this.entryId,
  });

  final TextEditingController sundryControllerP;
  final TextEditingController sundryControllerQ;
  final Function(Map<String, dynamic>) onSaveValues;
  final Function(String) onDelete;
  final String entryId;

  @override
  State<SundryRow> createState() => _SundryRowState();
}

class _SundryRowState extends State<SundryRow> {
  TextEditingController sundryController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  double amount = 0.0;
  List<Sundry> sundryList = [];
  String? selectedItemId;
  String? selectedsundryName;
  SundryService sundryService = SundryService();

  Future<void> fetchsundry() async {
    try {
      final List<Sundry> sundry = await sundryService.fetchSundry();
      setState(() {
        sundryList = sundry;

        selectedsundryName = widget.sundryControllerP.text;
        amountController.text = widget.sundryControllerQ.text;
        sundryController.text = widget.sundryControllerP.text;
        // for (var i = 0; i < sundryList.length; i++) {
        //   if (sundryList[i].id == widget.sundryControllerP.text) {
        //     selectedsundryName = sundryList[i].id;
        //   }
        // }
        // amountController.text = widget.sundryControllerQ.text;
      });

      print(amountController.text);
    } catch (error) {
      print('Failed to fetch ledger name: $error');
    }
  }

  void updateAmount(String? selectedItemId) {
    Sundry? selectedItem = sundryList.firstWhere(
      (item) => item.id == selectedItemId,
    );
    if (selectedItem != '') {
      setState(() {
        amount = selectedItem.sundryAmount as double;
      });
    }
  }

  void _saveValues() {
    final values = {
      'uniqueKey': widget.entryId,
      'sndryName': sundryController.text,
      'sundryAmount': amountController.text,
    };
    // Fluttertoast.showToast(
    //   msg: "Values added to list successfully!",
    //   toastLength: Toast.LENGTH_LONG,
    //   gravity: ToastGravity.CENTER_RIGHT,
    //   webPosition: "right",
    //   timeInSecForIosWeb: 1,
    //   backgroundColor: Colors.black,
    //   textColor: Colors.white,
    // );

    widget.onSaveValues(values);
  }

  void _deleteEntry() {
    widget.onDelete(widget.entryId);
    // Fluttertoast.showToast(
    //   msg: "Entry deleted successfully!",
    //   toastLength: Toast.LENGTH_LONG,
    //   gravity: ToastGravity.CENTER_RIGHT,
    //   webPosition: "right",
    //   timeInSecForIosWeb: 1,
    //   backgroundColor: Colors.black,
    //   textColor: Colors.white,
    // );
  }

  @override
  void initState() {
    super.initState();
    fetchsundry();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 40,
            width: 10,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                border: Border(
              right: BorderSide(
                color: Colors.transparent,
              ),
              left: BorderSide(
                color: Colors.transparent,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
              bottom: BorderSide(
                color: Colors.black,
              ),
            )),
            child: Text(
              '${widget.serialNumber}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF000000),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            height: 40,
            width: 20,
            decoration: const BoxDecoration(
                border: Border(
              right: BorderSide(
                color: Colors.transparent,
              ),
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            )),
            child: TextFormField(
              cursorHeight: 18,
              inputFormatters: const <TextInputFormatter>[],
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 1, bottom: 8),
              ),
              controller: sundryController,
              onSaved: (newValue) {
                sundryController.text = newValue!;
              },
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF000000),
              ),
              textAlign: TextAlign.center,
            ),

            // child: DropdownButtonHideUnderline(
            //   child: DropdownButton<String>(
            //     value: selectedsundryName,
            //     underline: Container(),
            //     onChanged: (String? newValue) {
            //       setState(() {
            //         selectedsundryName = newValue;
            //         // Find the selected Item
            //         Sundry? selectedItem = sundryList.firstWhere(
            //           (item) => item.id == newValue,
            //         );

            //         sundryController.text = selectedsundryName!;
            //         widget.sundryControllerP.text = sundryController.text;
            //         amount = selectedItem.sundryAmount.toDouble();
            //         amountController.text = amount.toString();
            //       });
            //     },
            //     isDense: true,
            //     isExpanded: true,
            //     items: sundryList.map((Sundry sundry) {
            //       return DropdownMenuItem<String>(
            //         value: sundry.id,
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Text(
            //               sundry.sundryName,
            //               style: const TextStyle(
            //                   fontSize: 12, fontWeight: FontWeight.bold),
            //             ),
            //           ],
            //         ),
            //       );
            //     }).toList(),
            //   ),
            // ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            height: 40,
            width: 20,
            decoration: const BoxDecoration(
                border: Border(
              right: BorderSide(
                color: Colors.transparent,
              ),
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            )),
            // child: Text(
            //   sundryAmt.toString(),
            //   textAlign: TextAlign.center,
            // ),
            child: TextFormField(
              cursorHeight: 18,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(
                    r'^\d*\.?\d*$')), // Allow digits and a single decimal point
              ],
              controller: amountController,
              onSaved: (newValue) {
                amountController.text = newValue!;
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 1, bottom: 8),
              ),
              onChanged: (value) {
                _saveValues();
              },
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF000000),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        // Flexible(
        //   child: SizedBox(
        //     width: MediaQuery.of(context).size.width * 0.01,
        //     height: 25,
        //     child: IconButton(
        //       hoverColor: Colors.transparent,
        //       splashColor: Colors.transparent,
        //       onPressed: () {
        //         _saveValues();
        //       },
        //       icon: const Icon(
        //         Icons.save,
        //         size: 15,
        //         color: Colors.green,
        //       ),
        //     ),
        //   ),
        // ),
        // Flexible(
        //   child: SizedBox(
        //     width: MediaQuery.of(context).size.width * 0.02,
        //     height: 25,
        //     child: IconButton(
        //       hoverColor: Colors.transparent,
        //       splashColor: Colors.transparent,
        //       onPressed: _deleteEntry,
        //       icon: const Icon(
        //         Icons.delete,
        //         size: 15,
        //         color: Colors.red,
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
