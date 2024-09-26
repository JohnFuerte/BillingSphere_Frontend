import 'dart:convert';
import 'package:billingsphere/data/models/secondaryUnit/secondary_unit_model.dart';
import 'package:billingsphere/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SecondaryUnitService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<SecondaryUnit>> fetchSecondaryUnits() async {
    try {
      String? token = await getToken();

      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/secondaryUnit/fetchAllSecondaryUnit'), // Adjust the API endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        final secondaryUnitsData = responseData['data'];

        final List<SecondaryUnit> secondaryUnits = List.from(
          secondaryUnitsData.map((entry) => SecondaryUnit.fromMap(entry)),
        );

        return secondaryUnits;
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

  Future<void> addUnitEntry(
      SecondaryUnit unitEntry, BuildContext context) async {
    String? token = await getToken();

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/secondaryUnit/createSecondaryUnit'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: unitEntry.toJson(),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      Navigator.of(context).pop();
    } else {
      throw Exception('Failed to add hsn code entry');
    }
  }

  // Fetch Item Brand by ID
  Future<SecondaryUnit> fetchSecondaryUnitById(String id) async {
    try {
      String? token = await getToken();

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/secondaryUnit/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        final secondaryData = responseData['data'];

        final SecondaryUnit secondary = SecondaryUnit.fromMap(secondaryData);

        return secondary;
      } else {
        print('${responseData['message']}');
      }
      // Return an empty list in case of failure
      return SecondaryUnit(
        id: '',
        secondaryUnit: '',
        createdOn: DateTime.now(),
        updatedOn: DateTime.now(),
      );
    } catch (error) {
      print(error.toString());
      return SecondaryUnit(
        id: '',
        secondaryUnit: '',
        createdOn: DateTime.now(),
        updatedOn: DateTime.now(),
      );
    }
  }

  Future<void> updateSecondary({
    required String id,
    required String secondaryUnit,
  }) async {
    String? token = await getToken();

    final Uri uri = Uri.parse(
        '${Constants.baseUrl}/secondaryUnit/update/$id'); // Replace with your API endpoint

    SecondaryUnit secondary = SecondaryUnit(
      id: id,
      secondaryUnit: secondaryUnit,
      createdOn: DateTime.now(),
      updatedOn: DateTime.now(),
    );

    final http.Response response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: secondary.toJson(),
    );

    // print('Response status code: ${response.body}');

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Item brand updated successfully",
        toastLength: Toast
            .LENGTH_SHORT, // Duration for which the toast should be visible
        gravity: ToastGravity.BOTTOM, // Position of the toast message
        backgroundColor: Colors.grey, // Background color of the toast
        textColor: Colors.white, // Text color of the toast
        fontSize: 16.0, // Font size of the toast message
      );
    } else {
      // Handle error
      print('Failed to update Item brand. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> deleteSecondary(String id) async {
    String? token = await getToken();

    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/secondaryUnit/delete/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );

    final responseData = json.decode(response.body);
    print(responseData);
    if (responseData['success'] == true) {
      //  Flutter toast
      Get.snackbar('Success', 'secondaryUnit Deleted Successfully');
    } else {
      throw Exception('Failed to delete secondaryUnit');
    }
  }
}
