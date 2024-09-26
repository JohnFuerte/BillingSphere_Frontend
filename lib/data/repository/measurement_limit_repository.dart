import 'dart:convert';
import 'package:billingsphere/data/models/measurementLimit/measurement_limit_model.dart';
import 'package:billingsphere/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../views/NI_responsive.dart/NI_desktopBody.dart';

class MeasurementLimitService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> addMeasurementUnitEntry(
      MeasurementLimit unitEntry, BuildContext context) async {
    String? token = await getToken();

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/measurementLimit/createmeasurement'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: unitEntry.toJson(),
    );

    // print(response.body);
    // print(response.statusCode);

    if (response.statusCode == 201 || response.statusCode == 200) {
      Navigator.of(context).pop();
    } else {
      throw Exception('Failed to add hsn code entry');
    }
  }

  Future<List<MeasurementLimit>> fetchMeasurementLimits() async {
    try {
      String? token = await getToken();

      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/measurementLimit/fetchAllmeasurement'), // Adjust the API endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        final List<MeasurementLimit> measurementLimits =
            (responseData['data'] as List<dynamic>?)
                    ?.map((entry) => MeasurementLimit.fromMap(entry))
                    .toList() ??
                [];

        return measurementLimits;
      } else {
        // print('${responseData['message']}');
      }

      // Return an empty list in case of failure or null data
      return [];
    } catch (error) {
      print(error.toString());
      return [];
    }
  }

  Future<MeasurementLimit?> fetchMeasurementById(String id) async {
    String? token = await getToken();
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/measurementLimit/get/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        final measurementdata = responseData['data'];
        if (measurementdata != null) {
          return MeasurementLimit.fromMap(measurementdata);
        } else {
          return null;
        }
      } else {
        // print('${responseData['message']}');
        return null;
      }
    } catch (error) {
      print(error.toString());
      // Return null in case of an error
      return null;
    }
  }

  Future<void> updateMeasurementLimit({
    required String id,
    required String measurement,
  }) async {
    String? token = await getToken();

    final Uri uri = Uri.parse(
        '${Constants.baseUrl}/measurementLimit/update/$id'); // Replace with your API endpoint

    MeasurementLimit measurements = MeasurementLimit(
      id: id,
      measurement: measurement,
      createdOn: DateTime.now(),
      updatedOn: DateTime.now(),
    );

    final http.Response response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: measurements.toJson(),
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
      print(
          'Failed to update Measurement limit. Status code: ${response.statusCode}');
      // print('Response body: ${response.body}');
    }
  }

  Future<void> deleteMeasurementLimit(String id) async {
    String? token = await getToken();

    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/measurementLimit/delete/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );

    final responseData = json.decode(response.body);
    // print(responseData);
    if (responseData['success'] == true) {
      //  Flutter toast
      Get.snackbar('Success', 'measurementLimit Deleted Successfully');
    } else {
      throw Exception('Failed to delete measurementLimit');
    }
  }
}
