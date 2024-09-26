import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/models/measurementLimit/measurement_limit_model.dart';
import '../data/repository/measurement_limit_repository.dart';
import '../logic/cubits/measurement_cubit/measurement_limit_cubit.dart';
import 'DB_responsive/DB_desktop_body.dart';
import 'sumit_screen/measurement_unit/measurement_unit.dart';

class ItemMeasurementUnitEdit extends StatefulWidget {
  const ItemMeasurementUnitEdit({super.key});

  @override
  State<ItemMeasurementUnitEdit> createState() =>
      _ItemMeasurementUnitEditState();
}

class _ItemMeasurementUnitEditState extends State<ItemMeasurementUnitEdit> {
  List<MeasurementLimit> measurementLimit = [];
  MeasurementLimitService measurementService = MeasurementLimitService();

  Future<void> fetchMeasurementLimits() async {
    final measurementLimits = await measurementService.fetchMeasurementLimits();
    setState(() {
      this.measurementLimit = measurementLimits;
    });

    print(measurementLimits.length);
  }

  Future<void> _fetchData() async {
    await Future.wait([
      BlocProvider.of<MeasurementLimitCubit>(context).getLimit(),
    ]);
  }

  @override
  void initState() {
    super.initState();
    fetchMeasurementLimits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.cyan,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const DBMyDesktopBody(),
                      ),
                    );
                  },
                  icon: const Icon(
                    CupertinoIcons.arrow_left,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.45),
                Text(
                  'ITEM MEASUREMENT LIMIT MASTER',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white10,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: measurementLimit.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: ListTile(
                      title: Text(
                        measurementLimit[index].measurement,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      subtitle: Text(measurementLimit[index].measurement,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          )),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              measurementService
                                  .fetchMeasurementById(
                                      measurementLimit[index].id)
                                  .then((value) {
                                TextEditingController nameController =
                                    TextEditingController(
                                        text: value!.measurement);
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Edit Item Brand'),
                                      content: SizedBox(
                                        width: 300,
                                        height: 280,
                                        child: StatefulBuilder(
                                          builder: (context, setState) {
                                            return Column(
                                              children: [
                                                TextField(
                                                  controller: nameController,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText:
                                                        'Item Measurement Unit',
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      measurementService
                                                          .updateMeasurementLimit(
                                                        measurement:
                                                            nameController.text,
                                                        id: value.id,
                                                      );
                                                      setState(() {
                                                        nameController.clear();
                                                      });
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const ItemMeasurementUnitEdit(),
                                                        ),
                                                      );
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.cyan,
                                                      foregroundColor:
                                                          Colors.white,
                                                      elevation: 2,
                                                      animationDuration:
                                                          const Duration(
                                                              seconds: 2),
                                                    ),
                                                    child: const Text('Submit'),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        nameController.clear();
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      foregroundColor:
                                                          Colors.white,
                                                      elevation: 2,
                                                      animationDuration:
                                                          const Duration(
                                                              seconds: 2),
                                                    ),
                                                    child: const Text('Cancel'),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              });
                            },
                            icon: const Icon(
                              CupertinoIcons.eye,
                              color: Colors.cyan,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              CupertinoIcons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete Item Brand'),
                                    content: const Text(
                                        'Are you sure you want to delete this Item Brand?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await measurementService
                                              .deleteMeasurementLimit(
                                                  measurementLimit[index].id);
                                          Navigator.of(context).pop();
                                          setState(() {
                                            measurementLimit.removeAt(index);
                                          });
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ItemMeasurementUnitEdit()));
                                        },
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Responsive_measurementunit(),
            ),
          );
        },
        child: Text('Add'),
      ),
    );
  }
}
