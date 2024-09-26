import 'dart:convert';

import 'package:billingsphere/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/dailyCash/daily_cash_model.dart';

class DailyCashServices {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<DailyCashEntry>> fetchDailyCash() async {
    String? token = await getToken();

    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/daily-cash/get-all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      // print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          final dailyData = responseData['data'];
          final List<DailyCashEntry> user = List.from(dailyData.map((entry) {
            return DailyCashEntry.fromMap(entry);
          }));

          return user;
        } else {
          print('${responseData['message']}');
        }
      } else {
        print('Failed to load daily cash');
      }
      return [];
    } catch (ex) {
      print(ex.toString());
      return [];
    }
  }

  Future<bool> createDailyCash(DailyCashEntry dailycash) async {
    String? token = await getToken();

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/daily-cash/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: dailycash.toJson(),
    );

    // print(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<DailyCashEntry?> fetchDailyCashById(String id) async {
    String? token = await getToken();
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/daily-cash/get-single/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);
      // print(responseData);

      if (responseData['success'] == true) {
        final dailycash = responseData['data'];
        if (dailycash != null) {
          // Ensure that the data is a Map<String, dynamic> before parsing
          if (dailycash is Map<String, dynamic>) {
            return DailyCashEntry.fromMap(dailycash);
          }
        }
      }
      return null; // Return null if any condition fails
    } catch (error) {
      print('Error fetching daily cash entry: $error');
      return null;
    }
  }

  Future<void> updateDailyCashEntry(
      DailyCashEntry dailycash, BuildContext context) async {
    String? token = await getToken();

    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/daily-cash/update/${dailycash.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: dailycash.toJson(),
    );
    final responseData = json.decode(response.body);

    print(responseData);
    if (responseData['success'] == true) {
    } else {
      throw Exception('Failed to update Daily Cash entry');
    }
  }

  Future<void> deleteDailyCash(String id, BuildContext context) async {
    final String? token = await getToken();
    try {
      final response = await http.delete(
        Uri.parse('${Constants.baseUrl}/daily-cash/delete/$id'),
        headers: {
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        Fluttertoast.showToast(
          msg: 'Item deleted successfully',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER_LEFT,
          backgroundColor: Colors.purple,
          textColor: Colors.white,
        );
      } else {
        Navigator.of(context).pop();
        print('Failed to delete item: ${responseData['message']}');
      }
    } catch (error) {
      Navigator.of(context).pop(); // Close loading dialog
      print('Error deleting ledger: $error');
    }
  }
}
