import 'dart:convert';

import 'package:billingsphere/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/sundry/sundry_model.dart';

class SundryService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Sundry>> fetchSundry() async {
    String? token = await getToken();

    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/sundry/fetchAllSundry'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        final ledgerData = responseData['data'];

        final List<Sundry> sundry =
            List.from(ledgerData.map((entry) => Sundry.fromMap(entry)));

        return sundry;
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

  Future<Sundry?> fetchSundryById(String id) async {
    String? token = await getToken();

    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/sundry/get/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        var sundryData = responseData['data'];

        if (sundryData != null) {
          return Sundry.fromMap(sundryData);
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
}
