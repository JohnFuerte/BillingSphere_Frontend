// ignore_for_file: public_member_api_docs

import 'package:billingsphere/data/repository/item_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../data/models/item/item_model.dart';
import 'NI_responsive.dart/NI_edit.dart';

class DataTablePaginationExample extends StatefulWidget {
  const DataTablePaginationExample({super.key});

  @override
  State<DataTablePaginationExample> createState() =>
      _DataTablePaginationExampleState();
}

class _DataTablePaginationExampleState
    extends State<DataTablePaginationExample> {
  ItemsService itemsService = ItemsService();
  List<Item> items = [];
  late bool visible;

  final TextEditingController _controller = TextEditingController();

  Future<void> searchItems() async {
    final List<Item> items =
        await itemsService.searchItemsByBarcode(_controller.text);

    setState(() {
      this.items = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      onVisibilityChanged: (VisibilityInfo info) {
        visible = info.visibleFraction > 0;
      },
      key: const Key('visible-detector-key'),
      child: BarcodeKeyboardListener(
        bufferDuration: const Duration(milliseconds: 200),
        onBarcodeScanned: (barcode) {
          if (!visible) return;
          print(barcode);
          _controller.text = barcode;
          searchItems().then((value) {
            if (items.isNotEmpty) {
              // Push to another page
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return NIMyDesktopBodyE(
                    id: items.first.id,
                  );
                },
              ));
            } else {
              // Show Snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Item not found',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  backgroundColor: Colors.red,
                ),
              );

              return;
            }
          });
        },
        useKeyDownEvent: kIsWeb,
        child: Scaffold(
          body: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 215, 208, 15),
                ),
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
                    SizedBox(width: MediaQuery.of(context).size.width * 0.45),
                    Text(
                      'FIND ITEMS BY BARCODE',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 200,
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
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType
                              .number, // Set keyboard type to number
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ], // Only allow digits
                          decoration: InputDecoration(
                            hintText: 'Enter Barcode',
                            hintStyle: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text('Enter the barcode of the item you are looking for',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          )),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          searchItems().then((value) {
                            _controller.clear();

                            if (items.isNotEmpty) {
                              // Push to another page
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return NIMyDesktopBodyE(
                                    id: items.first.id,
                                  );
                                },
                              ));
                            } else {
                              // Show Snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Item not found',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );

                              return;
                            }
                          });
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 215, 208, 15),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                'Search',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
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
      ),
    );
  }
}
