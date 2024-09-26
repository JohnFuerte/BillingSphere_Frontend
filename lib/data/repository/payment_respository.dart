// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:billingsphere/data/models/payment/payment_model.dart';
import 'package:billingsphere/utils/constant.dart';
import 'package:billingsphere/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../views/PM_responsive/payment_home.dart';

class PaymentService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  // Future<void> createPayment({
  //   required Payment payment,
  // }) async {
  //   try {
  //     String? token = await getToken();
  //     print('Token: $token');
  //     print('Payment JSON: ${payment.toJson()}');
  //     final response = await http.post(
  //       Uri.parse('${Constants.baseUrl}/payment/create'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode(payment.toJson()), // Ensure proper JSON encoding
  //     );
  //     print('Response status: ${response.statusCode}');
  //     print('Response body: ${response.body}');
  //     if (response.statusCode == 201) {
  //       Fluttertoast.showToast(
  //         msg: "Payment created successfully!",
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.CENTER_RIGHT,
  //         webPosition: "right",
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.black,
  //         textColor: Colors.white,
  //       );
  //     } else {
  //       Fluttertoast.showToast(
  //         msg: 'Failed to create payment: ${response.reasonPhrase}',
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
  //       msg: 'Error creating payment: $error',
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.CENTER_RIGHT,
  //       webPosition: "right",
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.black,
  //       textColor: Colors.white,
  //     );
  //   }
  // }

  Future<void> createPayment(Payment payment, BuildContext context) async {
    String? token = await getToken();

    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/payment/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
        body: jsonEncode(payment.toJson()),
      );

      var responseData = json.decode(response.body);
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(msg: 'Created');
      } else {
        Fluttertoast.showToast(msg: 'Not Created');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<Payment>> fetchPayments() async {
    String? token = await getToken();

    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/payment/payments'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          final paymentVoucherData = responseData['data'];
          final List<Payment> paymentVoucher =
              List.from(paymentVoucherData.map((entry) {
            return Payment.fromMap(entry);
          }));

          return paymentVoucher;
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

  Future<Payment?> fetchPaymentById(String id) async {
    String? token = await getToken();

    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/payment/payments/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);
      print('Response Body: ${response.body}');

      if (responseData['success'] == true) {
        final paymentVoucherData = responseData['data'];
        // print('Payment Voucher Data: $paymentVoucherData');

        if (paymentVoucherData != null) {
          try {
            Payment payment = Payment.fromMap(paymentVoucherData);
            // print('Deserialized Payment: $payment');
            return payment;
          } catch (e) {
            // print('Error deserializing Payment: $e');
            return null;
          }
        } else {
          // print('Payment Voucher Data is null');
          return null;
        }
      } else {
        // print('Success is false');
        return null;
      }
    } catch (error) {
      print('Error fetching payment: $error');
      return null;
    }
  }

  // Future<void> updatePayment(
  //     Payment updatedPayment, BuildContext context) async {
  //   try {
  //     String? token = await getToken();
  //     final response = await http.put(
  //       Uri.parse(
  //           '${Constants.baseUrl}/payment/update/${updatedPayment.id}'), // Replace with your API endpoint
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': '$token',
  //       },
  //       body: jsonEncode(
  //           updatedPayment.toMap()), // Convert Payment object to JSON
  //     );
  //     if (response.statusCode == 200) {
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(
  //           builder: (context) => const PaymentHome(),
  //         ),
  //       );
  //       print('Payment updated successfully');
  //     } else {
  //       // Failed to update payment
  //       print('Failed to update payment: ${response.reasonPhrase}');
  //     }
  //   } catch (error) {
  //     // Error updating payment
  //     print('Error updating payment: $error');
  //   }
  // }

  Future<void> deletePayment(String paymentId, BuildContext context) async {
    try {
      String? token = await getToken();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text("Deleting Payment..."),
                ],
              ),
            ),
          );
        },
      );

      final response = await http.delete(
        Uri.parse('${Constants.baseUrl}/payment/delete/$paymentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        Navigator.of(context).pop(); // Close loading dialog
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const PaymentHome(),
          ),
        );
      } else {
        Navigator.of(context).pop();
        print('Failed to delete payment: ${responseData['message']}');
      }
    } catch (error) {
      Navigator.of(context).pop(); // Close loading dialog
      print('Error deleting payment: $error');
    }
  }
}
