import 'dart:convert';
import 'dart:typed_data';

import '../../utils/constant.dart';
import 'package:http/http.dart' as http;

import '../models/barcode/barcode_model.dart';

class BarcodeRepository {
  Future<Barcode?> fetchBarcodeById(String id) async {
    try {
      // final String? token = await getToken();
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/barcode-print/get-barcode/$id'),
        headers: {
          // 'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      print(responseData);

      if (responseData['success'] == true) {
        var barcodeData = responseData['data'];

        if (barcodeData != null) {
          return Barcode.fromMap(barcodeData);
        } else {
          return null;
        }
      } else {
        print('${responseData['message']}');
        return null;
      }
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Create barcode image
  Future<List<Uint8List>?> createBarcodeImages(String id, int qty) async {
    try {
      final response = await http.post(
        Uri.parse(
            '${Constants.baseUrl}/barcode-print/create-barcode-image/$id/$qty'),
        headers: {
          // 'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        final barcodeImageStrings = responseData['barcodeImages'];

        if (barcodeImageStrings != null && barcodeImageStrings is List) {
          List<Uint8List> barcodeImages = [];
          for (var imageString in barcodeImageStrings) {
            if (imageString is String) {
              Uint8List imageBytes = base64Decode(imageString);
              barcodeImages.add(imageBytes);
            }
          }
          return barcodeImages;
        } else {
          print('Invalid barcode image data format.');
          return null;
        }
      } else {
        print('${responseData['message']}');
        return null;
      }
    } catch (error) {
      print('Failed to create barcode images: $error');
      return null;
    }
  }




}
