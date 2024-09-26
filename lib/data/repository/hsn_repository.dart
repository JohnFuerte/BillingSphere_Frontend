// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:billingsphere/data/models/hsn/hsn_model.dart';
import 'package:billingsphere/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../views/NI_responsive.dart/NI_desktopBody.dart';

class HSNCodeService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<HSNCode>> fetchItemHSN() async {
    try {
      String? token = await getToken();

      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/hsnCode/fetchAllHsncode'), // Adjust the API endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        final hsnCodesData = responseData['data'];

        final List<HSNCode> hsnCodes = List.from(
          hsnCodesData.map((entry) => HSNCode.fromMap(entry)),
        );

        return hsnCodes;
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

  Future<void> addHsnCodeEntry(
      HSNCode hsnCodeEntry, BuildContext context) async {
    String? token = await getToken();

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/hsnCode/createHsnCode'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: hsnCodeEntry.toJson(),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      Navigator.of(context).pop();
    } else {
      throw Exception('Failed to add hsn code entry');
    }
  }

  Future<HSNCode?> fetchHsnById(String id) async {
    String? token = await getToken();
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/hsnCode/get/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        var sundryData = responseData['data'];

        if (sundryData != null) {
          return HSNCode.fromMap(sundryData);
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

  Future<void> updateItemHsn({
    required String id,
    required String hsn,
    required String description,
    required String unit,
  }) async {
    String? token = await getToken();

    final Uri uri = Uri.parse('${Constants.baseUrl}/hsnCode/update/$id');

    HSNCode hsnCode = HSNCode(
      id: id,
      hsn: hsn,
      description: description,
      unit: unit,
      createdOn: DateTime.now(),
      updatedOn: DateTime.now(),
    );

    final http.Response response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: hsnCode.toJson(),
    );

    print('Response status code: ${response.body}');

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "HSN Code updated successfully",
        toastLength: Toast
            .LENGTH_SHORT, // Duration for which the toast should be visible
        gravity: ToastGravity.BOTTOM, // Position of the toast message
        backgroundColor: Colors.grey, // Background color of the toast
        textColor: Colors.white, // Text color of the toast
        fontSize: 16.0, // Font size of the toast message
      );
    } else {
      // Handle error
      print('Failed to update HSN Code. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> deleteHsnCode(String id) async {
    String? token = await getToken();

    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/hsnCode/delete/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );

    final responseData = json.decode(response.body);
    print(responseData);
    if (responseData['success'] == true) {
      //  Flutter toast
      Get.snackbar('Success', 'HSN Code Deleted Successfully');
    } else {
      throw Exception('Failed to delete HSN Code');
    }
  }
}
