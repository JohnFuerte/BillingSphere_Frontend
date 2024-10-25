import 'dart:convert';

import 'package:billingsphere/data/models/purchaseReturn/purchase_return_model.dart';
import 'package:billingsphere/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseReturnService {
  PurchaseReturnService() {
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

  Future<void> createPurchaseReturn(PurchaseReturn purchaseReturn) async {
    String? token = await getToken();

    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/purchase-return/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
        body: json.encode(purchaseReturn.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          print(
              "Purchase Return created successfully: ${responseData['message']}");
        } else {
          print("Failed to create Purchase Return: ${responseData['message']}");
        }
      } else {
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception caught: $e");
    }
  }

  Future<List<PurchaseReturn>> getAllPurchaseReturns() async {
    try {
      String? token = await getToken();
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/purchase-return/get-all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          List<PurchaseReturn> purchaseReturns = (data['data'] as List)
              .map((item) => PurchaseReturn.fromJson(item))
              .toList();
          return purchaseReturns;
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to load purchase returns');
      }
    } catch (ex) {
      print('Error fetching all purchase returns: $ex');
      return [];
    }
  }

  Future<List<PurchaseReturn>> fetchAllPurchaseReturns() async {
    try {
      String? token = await getToken();
      List<String>? code = await getCompanyCode();

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/purchase-return/fetch-all/${code?[0]}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          await _prefs.setString(
              "purchaseReturnLength", "${data['data'].length}");
          List<PurchaseReturn> purchaseReturns = (data['data'] as List)
              .map((item) => PurchaseReturn.fromJson(item))
              .toList();
          return purchaseReturns;
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to fetch purchase returns by company code');
      }
    } catch (ex) {
      print('Error fetching purchase returns by company code: $ex');
      return [];
    }
  }
}
