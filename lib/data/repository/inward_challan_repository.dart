import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constant.dart';
import '../models/inwardChallan/inward_challan_model.dart';

class InwardChallanServices {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Add inward challan
  Future<void> createInwardChallan(InwardChallan challan) async {
    String? token = await getToken();

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/inward-challan/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      // body: jsonEncode(challan.toJson()),
      body: challan.toJson(),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create inward challan');
    }
  }

  Future<List<InwardChallan>> fetchInwardChallan() async {
    String? token = await getToken();

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/inward-challan/inward_challans'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );
    final responseData = json.decode(response.body);
    // print('PRINT DEVLIERY CHALLAN $responseData');
    if (responseData['success'] == true) {
      final inwardChallanData = responseData['data'];

      final List<InwardChallan> items =
          List.from(inwardChallanData.map((entry) {
        return InwardChallan.fromMap(entry);
      }));

      // print(items);

      return items;
    } else {
      throw Exception('${responseData['message']}');
    }
  }

  Future<InwardChallan?> fetchInwardChallanById(String id) async {
    try {
      final String? token = await getToken();
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/inward-challan/inward_challan/$id'),
        headers: {
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      print('PRINT Inward CHALLAN BY ID $responseData');

      if (responseData['success'] == true) {
        var inwardData = responseData['data'];

        if (inwardData != null) {
          return InwardChallan.fromMap(inwardData);
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
