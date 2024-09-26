import 'dart:convert';
import 'dart:js';
import 'package:billingsphere/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/utils.dart';
import '../../views/SE_responsive/SE_master.dart';
import '../models/salesEntries/sales_entrires_model.dart';
import '../models/user/user_group_model.dart';
import 'user_group_repository.dart';

class SalesEntryService {
  SalesEntryService() {
    _initPrefs();
  }

  late SharedPreferences _prefs;

  // Initialize SharedPreferences
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<String?> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('usergroup');
  }

  Future<List<String>?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('companies');
  }

  // SalesEntryService();

  Future<List<SalesEntry>> fetchSalesEntries() async {
    String? token = await getToken();

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/sales/get-all'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );
    final responseData = json.decode(response.body);
    // print('Sales get all ' + response.body);
    if (responseData['success'] == true) {
      final salesEntriesData = responseData['data'];

      final List<SalesEntry> salesEntries =
          List.from(salesEntriesData.map((entry) => SalesEntry.fromMap(entry)));

      return salesEntries;
    } else {
      throw Exception('${responseData['message']}');
    }
  }

  Future<List<SalesEntry>> getSales() async {
    String? token = await getToken();
    List<String>? code = await getCompanyCode();

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/sales/fetchAll/${code?[0]}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );
    final responseData = json.decode(response.body);

    if (response.statusCode == 200 ||
        responseData['status'] == 'success' ||
        response.statusCode == 201) {
      final salesData = responseData['data'];
      await _prefs.setString("purchaseLength", "${salesData.length}");
      final List<SalesEntry> sales = List.from(salesData.map((entry) {
        return SalesEntry.fromMap(entry);
      }));

      return sales;
    } else {
      throw Exception('Failed to load Sales');
    }
  }

  // Future<List<SalesEntry>> fetchSalesPage() async {
  //   try {
  //     final String? token = await getToken();
  //     final List<String>? code = await getCompanyCode();

  //     // print(code);

  //     final response = await http.get(
  //       Uri.parse('${Constants.baseUrl}/items/get-items/${code![0]}'),
  //       headers: {
  //         'Authorization': '$token',
  //       },
  //     );

  //     final responseData = json.decode(response.body);
  //     // print(response.body);
  //     if (responseData['success'] == true) {
  //       final itemData = responseData['data'];
  //       totalPages = responseData['totalPages'];

  //       final List<SalesEntry> items = List.from(itemData.map((entry) {
  //         entry.remove('images');
  //         return SalesEntry.fromMap(entry);
  //       }));
  //       return items;
  //     } else {
  //       print('${responseData['message']}');
  //     }

  //     // Return an empty list in case of failure
  //     return [];
  //   } catch (error) {
  //     print(error.toString());
  //     return [];
  //   }
  // }

  Future<bool> addSalesEntry(
      SalesEntry salesEntry, BuildContext context) async {
    String? token = await getToken();
    String? id = await getID();
    final String? userType = await getUserType();

    UserGroupServices userGroupServices = UserGroupServices();

    final List<UserGroup> usersGroups = await userGroupServices.getUserGroups();

    bool canCreateMaster = usersGroups.any((userGroup) =>
        userGroup.userGroupName == userType && userGroup.addMaster == "Yes");

    if (!canCreateMaster) {
      showSnackBar(context, "You do not have permission to create Item data.");
      return false;
    } else {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/sales/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
        body: jsonEncode(salesEntry.toJson()),
        // body: salesEntry.toJson(),
      );

      print(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<void> deleteSalesEntry(String id) async {
    String? token = await getToken();

    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/sales/delete/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );

    final responseData = json.decode(response.body);
    print(responseData);
    if (responseData['success'] == true) {
      //  Flutter toast
      Get.snackbar('Success', 'Sales Entry Deleted Successfully');
    } else {
      throw Exception('Failed to delete sales entry');
    }
  }

  Future<SalesEntry?> fetchSalesById(String id) async {
    String? token = await getToken();
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/sales/get-single/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        final salesData = responseData['data'];
        if (salesData != null) {
          return SalesEntry.fromMap(salesData);
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

  // Write Update Sales Repository
  Future<void> updateSalesEntry(
      SalesEntry salesEntry, BuildContext context) async {
    String? token = await getToken();

    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/sales/update/${salesEntry.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: jsonEncode(salesEntry.toJson()),
    );
    final responseData = json.decode(response.body);

    print(responseData);

    if (responseData['success'] == true) {
      Navigator.of(context).pop();
    } else {
      throw Exception('Failed to update sales entry');
    }
  }
}
