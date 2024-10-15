import 'dart:convert';

import 'package:billingsphere/views/RV_responsive/RV_Master.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:billingsphere/utils/constant.dart';

import '../models/receiptVoucher/receipt_voucher_model.dart';

class ReceiptVoucherService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Future<void> createReciptVoucher(ReceiptVoucher receiptVch, {
  //   required ReceiptVoucher receipt,
  // }) async {
  //   try {
  //     String? token = await getToken();
  //     final response = await http.post(
  //       Uri.parse(
  //           '${Constants.baseUrl}/receipt-voucher/create'), // Replace with your API endpoint
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': '$token',
  //       },
  //       body: receipt.toJson(),
  //     );
  //     print(response.body);
  //     if (response.statusCode == 201) {
  //       // Payment created successfully
  //       Fluttertoast.showToast(
  //         msg: "Receipt Voucher created successfully!",
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.CENTER_RIGHT,
  //         webPosition: "right",
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.black,
  //         textColor: Colors.white,
  //       );
  //     } else {
  //       // Failed to create payment
  //       Fluttertoast.showToast(
  //         msg: 'Failed to create Receipt Voucher: ${response.reasonPhrase}',
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.CENTER_RIGHT,
  //         webPosition: "right",
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.black,
  //         textColor: Colors.white,
  //       );
  //     }
  //   } catch (error) {
  //     Fluttertoast.showToast(
  //       msg: 'Error creating Receipt Voucher: $error',
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.CENTER_RIGHT,
  //       webPosition: "right",
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.black,
  //       textColor: Colors.white,
  //     );
  //   }
  // }

  Future<void> createReciptVoucher(
      ReceiptVoucher receiptVch, BuildContext context) async {
    String? token = await getToken();

    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/receipt-voucher/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
        body: jsonEncode(receiptVch.toJson()),
      );

      var responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(msg: 'Created');
      } else {
        Fluttertoast.showToast(msg: 'Not Created');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<ReceiptVoucher>> fetchReceiptVoucherEntries() async {
    String? token = await getToken();

    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/receipt-voucher/receipt'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          final receiptVoucherData = responseData['data'];
          final List<ReceiptVoucher> receiptVoucher =
              List.from(receiptVoucherData.map((entry) {
            return ReceiptVoucher.fromMap(entry);
          }));

          return receiptVoucher;
        } else {
          print('${responseData['message']}');
        }
      } else {
        print('Failed to load receipt vocuher cash');
      }
      return [];
    } catch (ex) {
      print(ex.toString());
      return [];
    }
  }

  Future<ReceiptVoucher?> fetchReceiptVchById(String id) async {
    String? token = await getToken();
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/receipt-voucher/receipt/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['success'] == true) {
        final receiptVoucherData = responseData['data'];
        if (receiptVoucherData != null) {
          return ReceiptVoucher.fromMap(receiptVoucherData);
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

  Future<void> updateReceipt(
      ReceiptVoucher updatedReceipt, BuildContext context, String id) async {
    try {
      String? token = await getToken();
      final response = await http.put(
        Uri.parse('${Constants.baseUrl}/receipt-voucher/update/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
        body: jsonEncode(updatedReceipt.toJson()),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ReceiptVoucherHome(),
          ),
        );
        print('receipt updated successfully');
      } else {
        // Failed to update receipt
        print('Failed to update receipt: ${response.reasonPhrase}');
      }
    } catch (error) {
      // Error updating receipt
      print('Error updating receipt: $error');
    }
  }

  Future<void> deleteReceipt(String paymentId, BuildContext context) async {
    try {
      print(paymentId);
      String? token = await getToken();

      final response = await http.delete(
        Uri.parse('${Constants.baseUrl}/receipt-voucher/delete/$paymentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);
      print(responseData);
      print(response.statusCode);
      if (responseData['success'] == true) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ReceiptVoucherHome(),
          ),
        );
        print("success");
        // Show success toast
        Fluttertoast.showToast(
          msg: 'Receipt deleted successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        print("fail");

        Navigator.of(context).pop();
        print('Failed to delete Receipt: ${responseData['message']}');

        // Show error toast
        Fluttertoast.showToast(
          msg: 'Failed to delete Receipt: ${responseData['message']}',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (error) {
      Navigator.of(context).pop();

      print('Error deleting Receipt: $error');

      Fluttertoast.showToast(
        msg: 'Error deleting Receipt: $error',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
