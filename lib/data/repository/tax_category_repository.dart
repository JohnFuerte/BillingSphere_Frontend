import 'package:billingsphere/data/models/taxCategory/tax_category_model.dart';
import 'package:billingsphere/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../views/NI_responsive.dart/NI_desktopBody.dart';

class TaxRateService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<TaxRate>> fetchTaxRates() async {
    String? token = await getToken();

    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/tax/fetchAllTax'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      // print(responseData);

      if (responseData['success'] == true) {
        final taxRatesData = responseData['data'];

        final List<TaxRate> taxRates = List.from(
          taxRatesData.map((entry) => TaxRate.fromMap(entry)),
        );

        return taxRates;
      } else {
        print('${responseData['message']}');
      }
      // Return an empty list in case of failure
      return [];
    } catch (error) {
      print(error.toString());
      return [];
    }
  }

  Future<void> addTaxRateEntry(
      TaxRate taxRateEntry, BuildContext context) async {
    String? token = await getToken();

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/tax/createTax'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: taxRateEntry.toJson(),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      Navigator.of(context).pop();
    } else {
      throw Exception('Failed to add hsn code entry');
    }
  }
}
