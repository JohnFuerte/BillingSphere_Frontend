import 'package:billingsphere/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../data/models/item/item_model.dart';
import '../data/repository/item_repository.dart';

class ExportExcel extends StatefulWidget {
  const ExportExcel({super.key});

  @override
  State<ExportExcel> createState() => _ExportExcelState();
}

ItemsService itemsService = ItemsService();
List<Item> fectedItems = [];
String? selectedId;

class _ExportExcelState extends State<ExportExcel> {
  Future<void> fetchItems() async {
    try {
      final List<Item> items = await itemsService.fetchItems();
      setState(() {
        fectedItems = items;
      });
    } catch (error) {
      print('Failed to fetch Item: $error');
    }
    print(fectedItems);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        backgroundColor: Colors.green,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.arrow_left,
            color: Colors.white,
            size: 18,
          ),
        ),
        title: Center(
          child: Text(
            "Export TO EXCEL",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 640,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Center(
                  child: Container(
                    height: 600,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Search",
                                    style: GoogleFonts.poppins(
                                      color: Colors.deepPurple,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    color: Colors.black,
                                    height: 20,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          height: 0.8,
                                        ),
                                        // cursorHeight: 15,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(0.0),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                0.0), // Adjust the border radius as needed
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                            // borderSide:
                                            //     const BorderSide(
                                            //         color:
                                            //             Colors.grey),
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
                        SingleChildScrollView(
                          child: SizedBox(
                            height: 50,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              elevation: 1,
                              child: ListTile(
                                hoverColor:
                                    const Color.fromARGB(255, 4, 12, 241),
                                title: Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
                                      child: Text(
                                        "Item",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () async {
                                        var response = await http.get(Uri.parse(
                                            '${Constants.baseUrl}/excel/export-to-excel-item'));
                                        if (response.statusCode == 200) {
                                          // Request successful, launch the URL to download the file
                                          var url =
                                              '${Constants.baseUrl}/excel/export-to-excel-item';
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        } else {
                                          // Request failed, handle the error
                                        }
                                      },
                                      icon:
                                          const Icon(Icons.import_export_sharp),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
