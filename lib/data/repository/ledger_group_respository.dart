import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constant.dart';
import '../models/ledgerGroup/ledger_group_model.dart';

class LedgerGroupService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<String?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('companyCode');
  }

  Future<List<LedgerGroup>> fetchLedgerGroups() async {
    try {
      String? token = await getToken();

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/ledger-group/get-all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);
      // print(response.body);
      if (responseData['success'] == true) {
        final ledgerGroupData = responseData['data'];

        final List<LedgerGroup> ledgerGroups = List.from(ledgerGroupData.map(
            (entry) => LedgerGroup.fromMap(entry as Map<String, dynamic>)));

        return ledgerGroups;
      } else {
        print('${responseData['message']}');
        // Return an empty list in case of failure
        return [];
      }
    } catch (error) {
      print(error.toString());
      // Return an empty list in case of an error
      return [];
    }
  }

  void addLedgerGroup(LedgerGroup ledgerGroup) async {
    try {
      String? token = await getToken();

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/ledger-group/create'),
        body: json.encode(ledgerGroup.toMap()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        print('${responseData['message']}');
      } else {
        print('${responseData['message']}');
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<LedgerGroup?> fetchLedgerGroupById(String id) async {
    try {
      String? token = await getToken();

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/ledger-group/get-single-ledger/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      // print('Request URL: ${response.request?.url}');
      // print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Check the content type to ensure it's JSON
        if (response.headers['content-type']?.contains('application/json') ??
            false) {
          final responseData = json.decode(response.body);

          // print('Ledger by id $responseData');
          if (responseData['success'] == true) {
            final ledgerGroupData = responseData['data'];

            // Check if the ledger data is not null
            if (ledgerGroupData != null) {
              return LedgerGroup.fromMap(ledgerGroupData);
            } else {
              // If ledger data is null, return null
              return null;
            }
          } else {
            print('${responseData['message']}');
            // Return null in case of failure
            return null;
          }
        } else {
          print('Unexpected content type: ${response.headers['content-type']}');
          // Return null in case of unexpected content type
          return null;
        }
      } else if (response.statusCode == 404) {
        print('Resource not found: ${response.body}');
        // Return null in case of 404 status code
        return null;
      } else {
        print(
            'Failed to load ledger group. Status code: ${response.statusCode}');
        // Return null in case of non-200 status code
        return null;
      }
    } catch (error) {
      print(error.toString());
      // Return null in case of an error
      return null;
    }
  }
}
