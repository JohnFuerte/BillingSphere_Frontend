import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class BarcodePrintingPageTest extends StatelessWidget {
  const BarcodePrintingPageTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final pdf = pw.Document();

            // Calculate dimensions in PDF points (1 inch = 72 points)
            const double paperWidth = 8.8 * PdfPageFormat.cm;
            const double pageHeight = 1.6 * PdfPageFormat.cm;

            const double stickerWidth = 3.5 * PdfPageFormat.cm;
            const double stickerHeight = 0.8 * PdfPageFormat.cm;

            const double stickerText = 0.2 * PdfPageFormat.cm;
            const double stickerTextPrice2 = 0.3 * PdfPageFormat.cm;

            const double gap = 0.58 * PdfPageFormat.cm;
            const double stickerTextgap = 0.05 * PdfPageFormat.cm;
            const double stickerPricegap = 0.08 * PdfPageFormat.cm;
            const double gapBetween2Sticker = 0.9 * PdfPageFormat.cm;

            // Calculate total height based on stickers and gaps
            double totalHeight = (pageHeight) + (gap);

            // Add page to the PDF document with dynamically calculated height
            pdf.addPage(
              pw.Page(
                pageFormat: PdfPageFormat(paperWidth, totalHeight),
                build: (context) {
                  return pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Row(
                        children: [
                          pw.SizedBox(width: gap),
                          // pw.Container(
                          //   width: stickerWidth,
                          //   height: stickerHeight,
                          //   child: pw.Center(
                          //     child: pw.BarcodeWidget(
                          //       data:
                          //           '312805481736', // Replace with your barcode data
                          //       barcode: pw.Barcode.code128(),
                          //       width: stickerWidth,
                          //       height: stickerbarcode,
                          //     ),
                          //   ),
                          // ),
                          pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.SizedBox(
                                height: stickerText,
                                child: pw.Text(
                                  'JAI VELNATH MARKETING'.toUpperCase(),
                                  style: pw.TextStyle(
                                    fontSize: 6,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                              pw.SizedBox(
                                height: stickerText,
                                child: pw.Text(
                                  '1200 MM lum kraze-425'
                                      .toUpperCase(), //20 char allowed
                                  style: pw.TextStyle(
                                    fontSize: 6,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                              pw.SizedBox(
                                height: stickerTextgap,
                              ),
                              pw.Container(
                                width: stickerWidth,
                                height: stickerHeight,
                                child: pw.Center(
                                  child: pw.BarcodeWidget(
                                    data: '312805481736',
                                    textStyle: pw.TextStyle(
                                        fontSize: 8,
                                        fontWeight: pw.FontWeight.bold,
                                        fontNormal: pw.Font.times()),
                                    barcode: pw.Barcode.code128(),
                                    width: stickerWidth,
                                    height: stickerHeight,
                                  ),
                                ),
                              ),
                              pw.Row(
                                children: [
                                  pw.Container(
                                    decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                        top: pw.BorderSide(),
                                        bottom: pw.BorderSide(),
                                      ),
                                    ),
                                    height: stickerTextPrice2,
                                    child: pw.Text(
                                      'Retail :1000000',
                                      style: pw.TextStyle(
                                        fontSize: 7,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  pw.SizedBox(width: stickerPricegap),
                                  pw.Container(
                                    decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                        top: pw.BorderSide(),
                                        bottom: pw.BorderSide(),
                                      ),
                                    ),
                                    height: stickerTextPrice2,
                                    child: pw.Text(
                                      'MRP :1000000',
                                      style: pw.TextStyle(
                                        fontSize: 7,
                                        fontWeight: pw.FontWeight.bold,
                                        decoration:
                                            pw.TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          pw.SizedBox(width: gapBetween2Sticker),
                          pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.SizedBox(
                                height: stickerText,
                                child: pw.Text(
                                  'H.N.GRUH UDHYOG'.toUpperCase(),
                                  style: pw.TextStyle(
                                    fontSize: 6,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                              pw.SizedBox(
                                height: stickerText,
                                child: pw.Text(
                                  '1200 MM lum kraze-425'
                                      .toUpperCase(), //20 char allowed
                                  style: pw.TextStyle(
                                    fontSize: 6,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                              pw.SizedBox(
                                height: stickerTextgap,
                              ),
                              pw.Container(
                                width: stickerWidth,
                                height: stickerHeight,
                                child: pw.Center(
                                  child: pw.BarcodeWidget(
                                    data: '312805481736',
                                    textStyle: pw.TextStyle(
                                        fontSize: 7,
                                        fontWeight: pw.FontWeight.bold,
                                        fontNormal: pw.Font.times()),
                                    barcode: pw.Barcode.code128(),
                                    width: stickerWidth,
                                    height: stickerHeight,
                                  ),
                                ),
                              ),
                              pw.Row(
                                children: [
                                  pw.Container(
                                    decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                        top: pw.BorderSide(),
                                        bottom: pw.BorderSide(),
                                      ),
                                    ),
                                    height: stickerTextPrice2,
                                    child: pw.Text(
                                      'Retail :1000000',
                                      style: pw.TextStyle(
                                        fontSize: 7,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  pw.SizedBox(width: stickerPricegap),
                                  pw.Container(
                                    decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                        top: pw.BorderSide(),
                                        bottom: pw.BorderSide(),
                                      ),
                                    ),
                                    height: stickerTextPrice2,
                                    child: pw.Text(
                                      'MRP :1000000',
                                      style: pw.TextStyle(
                                        fontSize: 7,
                                        fontWeight: pw.FontWeight.bold,
                                        decoration:
                                            pw.TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            );

            // Save and print the PDF
            final Uint8List bytes = await pdf.save();
            await Printing.layoutPdf(onLayout: (PdfPageFormat format) => bytes);
          },
         
          child: const Text('Print Barcodes'),
        ),
      ),
    );
  }
}
