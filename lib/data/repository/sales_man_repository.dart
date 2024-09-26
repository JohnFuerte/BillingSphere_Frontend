// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:billingsphere/data/models/salesMan/sales_man_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/constant.dart';
import 'package:http/http.dart' as http;

import '../../utils/utils.dart';

class SalesManRepository {
  // Create New Customer
  Future<void> createNewSalesMan(
      SalesMan newCustomer, BuildContext context) async {
    final Uri uri = Uri.parse('${Constants.baseUrl}/new-salesman/create');
    try {
      final http.Response response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': '$token',
        },
        body: newCustomer.toJson(),
      );
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            Fluttertoast.showToast(
              msg: 'New SalesMan Created Successfully',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER_LEFT,
              backgroundColor: Colors.purple,
              textColor: Colors.white,
            );
          });
    } catch (e) {
      showSnackBar(context, 'Something went wrong');
    }
  }

  // Get All Customers
  Future<List<SalesMan>> fetchSalesMan() async {
    final Uri uri = Uri.parse('${Constants.baseUrl}/new-salesman/all');
    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          final customers = responseData['data'];

          final List<SalesMan> customerList = List.from(customers.map((entry) {
            return SalesMan.fromMap(entry);
          }));
          return customerList;
        } else {
          print('Error: ${responseData['message']}');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
      }

      // Return an empty list in case of failure
      return [];
    } catch (e) {
      print('Exception: $e');
      return [];
    }
  }
}
