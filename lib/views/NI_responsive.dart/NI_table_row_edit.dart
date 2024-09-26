import 'package:billingsphere/data/models/measurementLimit/measurement_limit_model.dart';
import 'package:billingsphere/data/repository/measurement_limit_repository.dart';
import 'package:billingsphere/views/searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NItableEdit extends StatefulWidget {
  const NItableEdit({
    super.key,
    required this.serialNo,
    required this.entryId,
    required this.oPBalanceQtyI,
    required this.oPBalanceUnitI,
    required this.oPBalanceRatetI,
    required this.oPBalanceTotaltI,
    required this.onSaveValues,
  });
  final int serialNo;
  final String entryId;
  final TextEditingController oPBalanceQtyI;
  final TextEditingController oPBalanceUnitI;
  final TextEditingController oPBalanceRatetI;
  final TextEditingController oPBalanceTotaltI;
  final Function(Map<String, dynamic>) onSaveValues;

  @override
  State<NItableEdit> createState() => _NItableEditState();
}

class _NItableEditState extends State<NItableEdit> {
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController totalController = TextEditingController();

  MeasurementLimitService measurementService = MeasurementLimitService();
  List<MeasurementLimit> measurement = [];

  String? selectedmeasurementId;

  Future<void> fetchMeasurementLimit() async {
    try {
      final List<MeasurementLimit> measurements =
          await measurementService.fetchMeasurementLimits();

      setState(() {
        measurement = measurements;
        selectedmeasurementId =
            measurement.isNotEmpty ? measurement.first.id : null;

        selectedmeasurementId = widget.oPBalanceUnitI.text.isNotEmpty
            ? widget.oPBalanceUnitI.text
            : measurement.first.id;
        unitController.text = selectedmeasurementId!;
        widget.oPBalanceUnitI.text = unitController.text;
      });

      print(measurements);
    } catch (error) {
      print('Failed to fetch Tax Rates: $error');
    }
  }

  void _saveValues() {
    final values = {
      'uniqueKey': widget.entryId,
      'qty': qtyController.text,
      'unit': unitController.text,
      'rate': rateController.text,
      'total': totalController.text,
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

  void _initializeData() async {
    fetchMeasurementLimit();
    qtyController.text = widget.oPBalanceQtyI.text;
    rateController.text = widget.oPBalanceRatetI.text;
    selectedmeasurementId = widget.oPBalanceUnitI.text;
    totalController.text = widget.oPBalanceTotaltI.text;
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    qtyController.dispose();
    rateController.dispose();
    unitController.dispose();
    totalController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 70,
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(), top: BorderSide(), left: BorderSide())),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${widget.serialNo}',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          // height: 30,
          width: 250,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(),
              top: BorderSide(),
              left: BorderSide(),
            ),
          ),
          child: TextFormField(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(12.0),
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            cursorHeight: 20,
            controller: qtyController,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 50,
          width: 130,
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(), top: BorderSide(), left: BorderSide())),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: SearchableDropDown(
              controller: unitController,
              searchController: unitController,
              value: selectedmeasurementId,
              onChanged: (String? newValue) {
                setState(() {
                  selectedmeasurementId = newValue;
                });
              },
              items: measurement.map((MeasurementLimit measurementLimit) {
                return DropdownMenuItem<String>(
                  value: measurementLimit.id,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        measurementLimit.measurement,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                );
              }).toList(),
              searchMatchFn: (item, searchValue) {
                final itemMLimit = measurement
                    .firstWhere((e) => e.id == item.value)
                    .measurement;
                return itemMLimit
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            ),
          ),
        ),
        Container(
          // height: 30,
          width: 250,
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(), top: BorderSide(), left: BorderSide())),
          child: TextFormField(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(12.0),
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
            ],
            cursorHeight: 20,
            controller: rateController,
            onChanged: (value) {
              int qty = int.tryParse(qtyController.text) ?? 0;
              double rate = double.tryParse(value) ?? 0;
              double amount = qty * rate;
              setState(() {
                totalController.text = amount.toStringAsFixed(2);
              });
              _saveValues();
            },
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          // height: 30,
          width: 250,
          decoration: BoxDecoration(border: Border.all()),
          child: TextFormField(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(12.0),
            ),
            cursorHeight: 20,
            controller: totalController,
            textAlign: TextAlign.center,
            readOnly: true,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
