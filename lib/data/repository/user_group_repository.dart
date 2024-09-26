// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../NU_responsive/user_group_master.dart';
import '../../utils/constant.dart';
import '../../utils/utils.dart';
import '../models/user/user_group_model.dart';

class UserGroupServices {
  // Constructor
  UserGroupServices();

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('usergroup');
  }

  // Create a new user group
  Future<void> createUserGroup({
    required String companyCode,
    required String userGroupName,
    required String ownerGroup,
    required String misReport,
    required String report,
    required String addMaster,
    required String editMaster,
    required String deleteMaster,
    required String purchase,
    required String sales,
    required String purchaseReturn,
    required String salesReturn,
    required String stock,
    required String shortage,
    required String jobcard,
    required String receiptNote,
    required String deliveryNote,
    required String purchaseOrder,
    required String salesOrder,
    required String salesQuotation,
    required String purchaseEnquiry,
    required String journal,
    required String conta,
    required String receipt2,
    required String payment,
    required BuildContext context,
  }) async {
    final String? token = await getToken();
    final String url = '${Constants.baseUrl}/user-group/create-user-group';

    UserGroup userGroup = UserGroup(
      companyCode: companyCode,
      userGroupName: userGroupName,
      ownerGroup: ownerGroup,
      misReport: misReport,
      report: report,
      addMaster: addMaster,
      editMaster: editMaster,
      deleteMaster: deleteMaster,
      purchase: purchase,
      sales: sales,
      purchaseReturn: purchaseReturn,
      salesReturn: salesReturn,
      stock: stock,
      shortage: shortage,
      jobcard: jobcard,
      receiptNote: receiptNote,
      deliveryNote: deliveryNote,
      purchaseOrder: purchaseOrder,
      salesOrder: salesOrder,
      salesQuotation: salesQuotation,
      purchaseEnquiry: purchaseEnquiry,
      journal: journal,
      conta: conta,
      receipt2: receipt2,
      payment: payment,
    );

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: userGroup.toJson(),
    );
    final responseData = json.decode(response.body);

    print(responseData);

    if (responseData['success'] == true) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const UserGroupMaster(),
        ),
      );
    } else {
      showSnackBar(context, responseData['message']);
    }
  }

  // Get all user groups
  Future<List<UserGroup>> getUserGroups() async {
    final String? token = await getToken();
    final String url = '${Constants.baseUrl}/user-group/get-all-user-group';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );
    final responseData = json.decode(response.body);

    if (responseData['success'] == true) {
      final userGroupData = responseData['data'];
      final List<UserGroup> userGroups =
          List.from(userGroupData.map((entry) => UserGroup.fromMap(entry)));

      return userGroups;
    } else {
      print('${responseData['message']}');
    }

    return [];
  }

  // Get a user group by id
  Future<UserGroup> getUserGroupById(String userGroupId) async {
    final String? token = await getToken();
    final String url =
        '${Constants.baseUrl}/user-group/get-single-user-group/$userGroupId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );

    final responseData = json.decode(response.body);

    if (responseData['success'] == true) {
      final userGroupData = responseData['data'];
      final UserGroup userGroup = UserGroup.fromMap(userGroupData);

      return userGroup;
    } else {
      print('${responseData['message']}');
    }

    return UserGroup();
  }

  // Update a user group
  Future<void> updateUserGroup({
    required String id,
    required String userGroupName,
    required String ownerGroup,
    required String misReport,
    required String report,
    required String addMaster,
    required String editMaster,
    required String deleteMaster,
    required String purchase,
    required String sales,
    required String purchaseReturn,
    required String salesReturn,
    required String stock,
    required String shortage,
    required String jobcard,
    required String receiptNote,
    required String deliveryNote,
    required String purchaseOrder,
    required String salesOrder,
    required String salesQuotation,
    required String purchaseEnquiry,
    required String journal,
    required String conta,
    required String receipt2,
    required String payment,
    required BuildContext context,
  }) async {
    final String? token = await getToken();
    final String url = '${Constants.baseUrl}/user-group/update-user-group/$id';

    UserGroup userGroup = UserGroup(
      userGroupName: userGroupName,
      ownerGroup: ownerGroup,
      misReport: misReport,
      report: report,
      addMaster: addMaster,
      editMaster: editMaster,
      deleteMaster: deleteMaster,
      purchase: purchase,
      sales: sales,
      purchaseReturn: purchaseReturn,
      salesReturn: salesReturn,
      stock: stock,
      shortage: shortage,
      jobcard: jobcard,
      receiptNote: receiptNote,
      deliveryNote: deliveryNote,
      purchaseOrder: purchaseOrder,
      salesOrder: salesOrder,
      salesQuotation: salesQuotation,
      purchaseEnquiry: purchaseEnquiry,
      journal: journal,
      conta: conta,
      receipt2: receipt2,
      payment: payment,
    );

    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: userGroup.toJson(),
    );
    final responseData = json.decode(response.body);

    print(responseData);

    if (responseData['success'] == true) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const UserGroupMaster(),
        ),
      );
    } else {
      showSnackBar(context, responseData['message']);
    }
  }

  // Delete a user group
  Future<void> deleteUserGroup(String id, BuildContext context) async {
    final String? token = await getToken();
    final String url = '${Constants.baseUrl}/user-group/delete-user-group/$id';

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );
    final responseData = json.decode(response.body);

    if (responseData['success'] == true) {
      Fluttertoast.showToast(
        msg: responseData['message'],
        toastLength: Toast
            .LENGTH_SHORT, // Duration for which the toast should be visible
        gravity: ToastGravity.BOTTOM, // Position of the toast message
        backgroundColor: Colors.grey, // Background color of the toast
        textColor: Colors.white, // Text color of the toast
        fontSize: 16.0, // Font size of the toast message
      );
    } else {
      showSnackBar(context, responseData['message']);
    }
  }
}
