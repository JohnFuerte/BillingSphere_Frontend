import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BarcodePrintPDF extends StatefulWidget {
  const BarcodePrintPDF({Key? key, required this.barcodeImages})
      : super(key: key);

  final List<Uint8List> barcodeImages;

  @override
  State<BarcodePrintPDF> createState() => _BarcodePrintPDFState();
}

class _BarcodePrintPDFState extends State<BarcodePrintPDF> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
        build: (format) => _generatePdf(format),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    // final font = await PdfGoogleFonts.poppinsBold();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 20),
              pw.Wrap(
                children: widget.barcodeImages
                    .map(
                      (barcodeImage) => pw.Container(
                        width: 200,
                        height: 500,
                        child: pw.Image(
                          pw.MemoryImage(barcodeImage),
                          height: 60,
                          width: 60,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
