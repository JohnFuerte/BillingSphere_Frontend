// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:billingsphere/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/utils.dart';
import '../models/purchase/purchase_model.dart';

class PurchaseServices {
  PurchaseServices() {
    _initPrefs();
  }

  late SharedPreferences _prefs;

  // Initialize SharedPreferences
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<List<String>?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('companies');
  }

  Future<void> createPurchase(Purchase purchase, BuildContext context) async {
    String? token = await getToken();

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/purchase/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: json.encode(purchase.toMap()),
    );
    print(response.body);

    var responseData = json.decode(response.body);

    httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(responseData['message']),
          ));
        });
  }

  Future<List<Purchase>> fetchPurchaseEntries() async {
    String? token = await getToken();

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/purchase/get-all'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );
    final responseData = json.decode(response.body);
    // print('Sales get all ' + response.body);
    if (responseData['success'] == true) {
      final purchaseEntriesData = responseData['data'];

      final List<Purchase> purchaseEntries = List.from(
          purchaseEntriesData.map((entry) => Purchase.fromMap(entry)));

      return purchaseEntries;
    } else {
      throw Exception('${responseData['message']}');
    }
  }

  Future<List<Purchase>> getPurchase() async {
    String? token = await getToken();
    List<String>? code = await getCompanyCode();

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/purchase/fetchAll/${code?[0]}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );
    final responseData = json.decode(response.body);

    if (response.statusCode == 200 ||
        responseData['status'] == 'success' ||
        response.statusCode == 201) {
      final purchaseData = responseData['data'];
      await _prefs.setString("purchaseLength", "${purchaseData.length}");
      final List<Purchase> purchase = List.from(purchaseData.map((entry) {
        return Purchase.fromMap(entry);
      }));

      return purchase;
    } else {
      throw Exception('Failed to load purchase');
    }
  }

  Future<Purchase?> fetchPurchaseById(String id) async {
    try {
      String? token = await getToken();

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/purchase/get/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      print(responseData);

      if (responseData['success'] == true) {
        final purchaseData = responseData['data'];
        if (purchaseData != null) {
          return Purchase.fromMap(purchaseData);
        } else {
          return null;
        }
      } else {
        print('${responseData['message']}');
        // Return null in case of failure
        return null;
      }
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Fetch all purchases by billNumber
  Future<Purchase?> fetchPurchaseByBillNumber(String billNumber) async {
    String? token = await getToken();

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/purchase/getByBillNumber/$billNumber'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );

    final responseData = json.decode(response.body);

    if (responseData['success'] == true) {
      final purchaseData = responseData['data'];
      return Purchase.fromMap(purchaseData);
    } else {
      print('Failed to fetch purchase: ${responseData['message']}');
      return null;
    }
  }

  Future<void> updatePurchase(Purchase purchase, BuildContext context) async {
    String? token = await getToken();

    // Convert the updated ledger object to a map
    Map<String, dynamic> purchaseMap = purchase.toMap();

    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/purchase/update/${purchase.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '$token',
      },
      body: json.encode(purchaseMap),
    );
    final responseData = json.decode(response.body);

    print(responseData);

    if (responseData['success'] == true) {
      // Give me FlutterToast
      Fluttertoast.showToast(
        msg: "Purchase updated successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      print('Failed to update ledger: ${responseData['message']}');
    }
  }

  Future<void> updateDueAmount(
      String purchaseId, double newDueAmount, BuildContext context) async {
    String? token = await getToken();

    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/purchase/update/$purchaseId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '$token',
      },
      body: json.encode({'dueAmount': newDueAmount}),
    );

    final responseData = json.decode(response.body);

    if (responseData['success'] == true) {
      // Show a toast message to indicate successful update
      showToast("Purchase updated successfully!");
    } else {
      print('Failed to update purchase: ${responseData['message']}');
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black.withOpacity(0.8),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> deletePurchase(String id, BuildContext context) async {
    String? token = await getToken();

    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/purchase/delete/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );

    final responseData = json.decode(response.body);

    if (responseData['success'] == true) {
      // Show a toast message to indicate successful deletion
      showToast("Purchase deleted successfully!");
    } else {
      print('Failed to delete purchase: ${responseData['message']}');
    }
  }
}
