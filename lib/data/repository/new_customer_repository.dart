// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/constant.dart';
import 'package:http/http.dart' as http;

import '../../utils/utils.dart';
import '../models/customer/new_customer_model.dart';

class NewCustomerRepository {
  // Create New Customer
  Future<void> createNewCustomer(
      NewCustomerModel newCustomer, BuildContext context) async {
    final Uri uri = Uri.parse('${Constants.baseUrl}/new-customer/create');
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
            final responseData = jsonDecode(response.body)['data'];

            //  Create the customer model from the response data
            final NewCustomerModel customer =
                NewCustomerModel.fromMap(responseData);

            Fluttertoast.showToast(
              msg: 'New Customer Created Successfully',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER_LEFT,
              backgroundColor: Colors.purple,
              textColor: Colors.white,
            );
            Navigator.pop(context, customer);
          });
    } catch (e) {
      showSnackBar(context, 'Something went wrong');
    }
  }

  // Get All Customers
  Future<List<NewCustomerModel>> getAllCustomers() async {
    final Uri uri = Uri.parse('${Constants.baseUrl}/new-customer/all');
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

          final List<NewCustomerModel> customerList =
              List.from(customers.map((entry) {
            return NewCustomerModel.fromMap(entry);
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
