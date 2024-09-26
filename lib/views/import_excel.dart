import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../utils/constant.dart';
import 'RA_widgets/RA_M_Button.dart';

class ImportExcel extends StatefulWidget {
  const ImportExcel({super.key});

  @override
  State<ImportExcel> createState() => _ImportExcelState();
}

class _ImportExcelState extends State<ImportExcel> {
  String? _filePath;
  List<int>? _fileBytes;

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'csv'],
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.name;
        _fileBytes = result.files.single.bytes;
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_fileBytes != null) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Constants.baseUrl}/excel/importItem'),
      );
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        _fileBytes!,
        filename: _filePath!,
      ));

      var response = await request.send();

      if (response.statusCode == 200) {
        print('File uploaded successfully');
      } else {
        print('Failed to upload file');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        backgroundColor: Colors.blueAccent,
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
            "IMPORT ITEM",
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 240,
                width: MediaQuery.of(context).size.width * 0.5,
                // width: MediaQuery.of(context).size.width * 0.9,
                child: Center(
                  child: Container(
                    height: 250,
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
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Select Excel File (xlsx format)',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 30,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (_filePath != null)
                                      Text(
                                        ' $_filePath',
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.08,
                              height: 30,
                              child: ElevatedButton(
                                onPressed: _openFilePicker,
                                style: ButtonStyle(
                                  shape:
                                      WidgetStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(1.0),
                                      side:
                                          const BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                                child: const Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Select',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_fileBytes != null)
                          Text(
                            '  File size: ${(_fileBytes!.length / 1024).toStringAsFixed(2)} KB',
                          ),
                        const SizedBox(height: 70),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RAMButtons(
                              onPressed: _uploadFile,
                              width: MediaQuery.of(context).size.width * 0.08,
                              height: 35,
                              text: 'Save',
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: RAMButtons(
                                width: MediaQuery.of(context).size.width * 0.08,
                                height: 35,
                                text: 'Cancel',
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
        ],
      ),
    );
  }
}
