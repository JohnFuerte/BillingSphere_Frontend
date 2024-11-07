import 'dart:convert';
import 'package:billingsphere/data/models/salesReturn/sales_return_model.dart';
import 'package:billingsphere/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SalesReturnService {
  SalesReturnService() {
    _initPrefs();
  }

  late SharedPreferences _prefs;

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

  Future<List<String>?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('companies');
  }

  Future<void> createSalesReturn(SalesReturn salesReturn) async {
    String? token = await getToken();

    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/sales-return/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
        body: json.encode(salesReturn.toJson()),
      );

      print("response : $response");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("responseData : $responseData");

        if (responseData['success'] == true) {
          Fluttertoast.showToast(
            msg: "Saales Return created successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        } else {
          Fluttertoast.showToast(
            msg: "Failed to create sales Return: ${responseData['message']}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Error: ${response.statusCode} - ${response.reasonPhrase}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Exception: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<List<SalesReturn>> getAllSalesReturns() async {
    try {
      String? token = await getToken();
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/sales-return/get-all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          List<SalesReturn> salesReturn = (data['data'] as List)
              .map((item) => SalesReturn.fromJson(item))
              .toList();
          return salesReturn;
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to load sales returns');
      }
    } catch (ex) {
      print('Error fetching all sales returns: $ex');
      return [];
    }
  }

  Future<List<SalesReturn>> fetchAllSalesReturns() async {
    try {
      String? token = await getToken();
      List<String>? code = await getCompanyCode();

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/sales-return/fetch-all/${code?[0]}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          await _prefs.setString("salesReturnLength", "${data['data'].length}");
          List<SalesReturn> salesReturn = (data['data'] as List)
              .map((item) => SalesReturn.fromJson(item))
              .toList();
          return salesReturn;
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to fetch sales returns by company code');
      }
    } catch (ex) {
      print('Error fetching sales returns by company code: $ex');
      return [];
    }
  }

  Future<SalesReturn?> fetchSalesReturnById(String id) async {
    try {
      String? token = await getToken();
      List<String>? code = await getCompanyCode();

      if (code == null || code.isEmpty) {
        throw Exception("Company code is not available.");
      }

      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/sales-return/fetch-by-id/${code[0]}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        if (data['success']) {
          return SalesReturn.fromJson(data['data']);
        } else {
          Fluttertoast.showToast(
            msg: "Failed to fetch sales Return: ${data['message']}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          return null;
        }
      } else {
        Fluttertoast.showToast(
          msg: "Error: ${response.statusCode} - ${response.reasonPhrase}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return null;
      }
    } catch (e) {
      print("Error fetching sales Return by ID: $e");
      return null;
    }
  }

  Future<void> updateSalesReturn(
      String id, SalesReturn updatedSalesReturn) async {
    String? token = await getToken();

    try {
      final response = await http.put(
        Uri.parse('${Constants.baseUrl}/sales-return/update-by-id/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
        body: json.encode(updatedSalesReturn.toJson()),
      );

      if (response.statusCode == 200) {
        print(response.statusCode);
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          Fluttertoast.showToast(
            msg: "Sales Return updated successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          print(
              "Sales Return updated successfully: ${responseData['message']}");
        } else {
          print(response.statusCode);

          Fluttertoast.showToast(
            msg: "Failed to update Sales Return: ${responseData['message']}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          print("Failed to update Purchase Return: ${responseData['message']}");
        }
      } else {
        Fluttertoast.showToast(
          msg: "Error: ${response.statusCode} - ${response.reasonPhrase}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception caught while updating Sales Return: $e");
      Fluttertoast.showToast(
        msg: "Exception: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> deleteSalesReturn(String id) async {
    String? token = await getToken();

    try {
      final response = await http.delete(
        Uri.parse('${Constants.baseUrl}/sales-return/delete-by-id/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          Fluttertoast.showToast(
            msg: "Sales Return deleted successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          print(
              "Sales Return deleted successfully: ${responseData['message']}");
        } else {
          Fluttertoast.showToast(
            msg: "Failed to delete Sales Return: ${responseData['message']}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          print("Failed to delete Sales Return: ${responseData['message']}");
        }
      } else {
        Fluttertoast.showToast(
          msg: "Error: ${response.statusCode} - ${response.reasonPhrase}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception caught while deleting Salaes Return: $e");
      Fluttertoast.showToast(
        msg: "Exception: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
