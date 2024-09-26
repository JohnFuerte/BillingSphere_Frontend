// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:billingsphere/core/api.dart';
import 'package:billingsphere/data/models/user/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../utils/constant.dart';
import '../models/user/new_user_model.dart';

class UserRepository {
  final _api = API();

  late SharedPreferences _prefs;

  // Constructor to initialize SharedPreferences
  UserRepository() {
    _initPrefs();
  }

  Future<String?> getToken() async {
    await _initPrefs();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('usergroup');
  }

  // Initialize SharedPreferences
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //For Creating Account of User
  Future<UserModel> createAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      Response response = await _api.sendRequest.post("/user/createAccount",
          data: jsonEncode(
              {"email": email, "password": password, "fullName": name}));
      APIResponse apiResponse = APIResponse.fromResponse(response);

      print(apiResponse.message);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      //If api response is success then convert raw data to model
      return UserModel.fromJson(apiResponse.data);
    } catch (ex) {
      rethrow;
    }
  }

//For SignIn
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      Response response = await _api.sendRequest.post("/user/signIn",
          data: jsonEncode({"email": email, "password": password}));
      APIResponse apiResponse = APIResponse.fromResponse(response);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }

      await _prefs.setString('token', apiResponse.token!);
      await _prefs.setString("user_id", apiResponse.data["_id"]);
      await _prefs.setString("usergroup", apiResponse.data["usergroup"]);
      await _prefs.setString("email", apiResponse.data["email"]);
      await _prefs.setString("fullName", apiResponse.data["fullName"]);
      // Iterate over the companies and set the company code
      await _prefs.setStringList(
          "companies", apiResponse.data["companies"].cast<String>());

      return UserModel.fromJson(apiResponse.data);
    } catch (ex) {
      print('SignIn Error: $ex');

      rethrow;
    }
  }

  // For Create Account (Other User)
  Future<void> createAccountByAdmin({
    required String email,
    required String password,
    // required String hintpassword,
    required List<String> companies,
    required String name,
    required String userGroup,
    required String dashboardAccess,
    required String dashboardCategory,
    required String backDateEntry,
    required BuildContext context,
  }) async {
    try {
      NUserModel user = NUserModel(
        email: email,
        password: password,
        hintpassword: password,
        companies: companies,
        fullName: name,
        userGroup: userGroup,
        dashboardAccess: dashboardAccess,
        dashboardCategory: dashboardCategory,
        backDateEntry: backDateEntry,
      );

      String? userType = await getUserType();
      String? id = _prefs.getString("user_id");

      print(userType);

      if (userType != "Owner" && userType != "Admin") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You are not authorized to create user"),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/user/createAccount2/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: user.toJson(),
      );

      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message']),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message']),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (ex) {
      rethrow;
    }
  }

  // Fetch Users
  Future<List<NUserModel>> fetchUsers() async {
    String? token = await getToken();

    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/user/getUser'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      // print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          final itemData = responseData['data'];
          final List<NUserModel> user = List.from(itemData.map((entry) {
            return NUserModel.fromMap(entry);
          }));

          return user;
        } else {
          print('${responseData['message']}');
        }
      } else {
        print('Failed to load users');
      }
      return [];
    } catch (ex) {
      print(ex.toString());
      return [];
    }
  }

  //fetch by ID
  Future<NUserModel?> fetchUserById(String id) async {
    String? token = await getToken();
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/user/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);
      // print('ID $responseData');
      if (responseData['success'] == true) {
        final usersData = responseData['data'];
        if (usersData != null) {
          return NUserModel.fromMap(usersData);
        } else {
          return null;
        }
      } else {
        print('${responseData['message']}');
        return null;
      }
    } catch (error) {
      print(error.toString());
      // Return null in case of an error
      return null;
    }
  }

  Future<void> updateUser(NUserModel userdata, BuildContext context) async {
    try {
      String? token = await getToken();
      final response = await http.put(
        Uri.parse('${Constants.baseUrl}/user/update/${userdata.sId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
        body: userdata.toJson(),
      );

      final responseData = json.decode(response.body);
      print(response.body);
      if (responseData['success'] == true) {
      } else {
        print('Failed to update user: ${responseData['message']}');
      }
    } catch (error) {
      print('Error updating ledger: $error');
    }
  }

  Future<void> deleteUser(String id, BuildContext context) async {
    final String? token = await getToken();
    try {
      final response = await http.delete(
        Uri.parse('${Constants.baseUrl}/user/delete-user/$id'),
        headers: {
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      print(responseData);

      if (responseData['success'] == true) {
        Fluttertoast.showToast(
          msg: 'User deleted successfully',
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
