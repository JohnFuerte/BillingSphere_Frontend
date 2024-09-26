import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../utils/constant.dart';
import '../models/salesPos/sales_pos_model.dart';

class SalesPosRepository {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<String>?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('companies');
  }

  Future<void> createPosEntry(SalesPos salesPos) async {
    String? token = await getToken();

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/sales-pos/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: jsonEncode(salesPos.toMap()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw Exception(response.body);
    }
  }

  // Get all pos

  Future<List<SalesPos>> fetchSalesPos() async {
    try {
      final String? token = await getToken();
      final List<String>? code = await getCompanyCode();

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/sales-pos/all/${code![0]}'),
        headers: {
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        final salesData = responseData['data'];

        print(salesData);

        final List<SalesPos> salesPos = List.from(salesData.map((entry) {
          return SalesPos.fromMap(entry);
        }));
        return salesPos;
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

  // Update pos entry
  Future<void> updatePosEntry(SalesPos salesPos) async {
    String? token = await getToken();

    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/sales-pos/update/${salesPos.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: jsonEncode(salesPos.toMap()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw Exception(response.body);
    }
  }
}
