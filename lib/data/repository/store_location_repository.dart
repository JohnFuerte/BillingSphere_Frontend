import 'dart:convert';
import 'package:billingsphere/data/models/storeLocation/store_location_model.dart';
import 'package:billingsphere/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../views/NI_responsive.dart/NI_desktopBody.dart';

class StoreLocationService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<StoreLocation>> fetchStoreLocations() async {
    String? token = await getToken();

    try {
      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/store/fetchAllStore'), // Adjust the API endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      print(responseData);

      if (responseData['success'] == true) {
        final List<StoreLocation> storeLocations =
            (responseData['data'] as List<dynamic>?)
                    ?.map((entry) => StoreLocation.fromMap(entry))
                    .toList() ??
                [];

        return storeLocations;
      } else {
        print('${responseData['message']}');
      }

      // Return an empty list in case of failure or null data
      return [];
    } catch (error) {
      print(error.toString());
      return [];
    }
  }

  Future<void> addStoreLocationEntry(
      StoreLocation unitEntry, BuildContext context) async {
    String? token = await getToken();

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/store/createStoreLocation'),
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

  Future<StoreLocation?> fetchStoreLocationById(String id) async {
    String? token = await getToken();

    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/store/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        final storeLocationData = responseData['data'];

        final StoreLocation storeLocation =
            StoreLocation.fromMap(storeLocationData);

        return storeLocation;
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
