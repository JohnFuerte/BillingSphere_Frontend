// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:billingsphere/data/models/ledger/ledger_model.dart';
import 'package:billingsphere/data/models/user/user_group_model.dart';
import 'package:billingsphere/utils/constant.dart';
import 'package:billingsphere/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../views/LG_responsive/LG_HOME.dart';
import 'user_group_repository.dart';

class LedgerService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<String>?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('companies');
  }

  Future<String?> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('usergroup');
  }


  

  Future<Ledger?> createLedger({
    required String name,
    required String printName,
    required String aliasName,
    required String ledgerGroup,
    required String date,
    required String bilwiseAccounting,
    required int creditDays,
    required double openingBalance,
    required double debitBalance,
    required String ledgerType,
    required String priceListCategory,
    required String remarks,
    required String status,
    required int ledgerCode,
    required String mailingName,
    required String address,
    required String city,
    required String region,
    required String state,
    required int pincode,
    required int tel,
    required int fax,
    required int mobile,
    required int sms,
    required String email,
    required String contactPerson,
    required String bankName,
    required String branchName,
    required String ifsc,
    required String accName,
    required String accNo,
    required String panNo,
    required String gst,
    required String gstDated,
    required String cstNo,
    required String cstDated,
    required String lstNo,
    required String lstDated,
    required String serviceTaxNo,
    required String serviceTaxDated,
    required String registrationType,
    required String registrationTypeDated,
    required BuildContext context,
  }) async {
    try {
      String? token = await getToken();
      final String? userType = await getUserType();

      Ledger ledger = Ledger(
        id: '',
        name: name,
        printName: printName,
        aliasName: aliasName,
        ledgerGroup: ledgerGroup,
        date: date,
        bilwiseAccounting: bilwiseAccounting,
        creditDays: creditDays,
        openingBalance: openingBalance,
        debitBalance: debitBalance,
        ledgerType: ledgerType,
        priceListCategory: priceListCategory,
        remarks: remarks,
        status: status,
        ledgerCode: ledgerCode,
        mailingName: mailingName,
        address: address,
        city: city,
        region: region,
        state: state,
        pincode: pincode,
        tel: tel,
        fax: fax,
        mobile: mobile,
        sms: sms,
        email: email,
        contactPerson: contactPerson,
        bankName: bankName,
        branchName: branchName,
        ifsc: ifsc,
        accName: accName,
        accNo: accNo,
        panNo: panNo,
        gst: gst,
        gstDated: gstDated,
        cstNo: cstNo,
        cstDated: cstDated,
        lstNo: lstNo,
        lstDated: lstDated,
        serviceTaxNo: serviceTaxNo,
        serviceTaxDated: serviceTaxDated,
        registrationType: registrationType,
        registrationTypeDated: registrationTypeDated,
      );
      UserGroupServices userGroupServices = UserGroupServices();

      final List<UserGroup> usersGroups =
          await userGroupServices.getUserGroups();

      bool canCreateMaster = usersGroups.any((userGroup) =>
          userGroup.userGroupName == userType && userGroup.addMaster == "Yes");

      if (!canCreateMaster) {
        showSnackBar(
            context, "You do not have permission to create Ledger data.");
        return null;
      } else {
        final response = await http.post(
          Uri.parse('${Constants.baseUrl}/ledger/create-ledger'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': '$token',
          },
          body: ledger.toJson(),
        );

        final responseData = json.decode(response.body);

        // print(responseData);

        if (responseData['success'] == true) {
          ledger = Ledger(
            id: responseData['data']['_id'],
            name: name,
            printName: printName,
            aliasName: aliasName,
            ledgerGroup: ledgerGroup,
            date: date,
            bilwiseAccounting: bilwiseAccounting,
            creditDays: creditDays,
            openingBalance: openingBalance,
            debitBalance: debitBalance,
            ledgerType: ledgerType,
            priceListCategory: priceListCategory,
            remarks: remarks,
            status: status,
            ledgerCode: ledgerCode,
            mailingName: mailingName,
            address: address,
            city: city,
            region: region,
            state: state,
            pincode: pincode,
            tel: tel,
            fax: fax,
            mobile: mobile,
            sms: sms,
            email: email,
            contactPerson: contactPerson,
            bankName: bankName,
            branchName: branchName,
            ifsc: ifsc,
            accName: accName,
            accNo: accNo,
            panNo: panNo,
            gst: gst,
            gstDated: gstDated,
            cstNo: cstNo,
            cstDated: cstDated,
            lstNo: lstNo,
            lstDated: lstDated,
            serviceTaxNo: serviceTaxNo,
            serviceTaxDated: serviceTaxDated,
            registrationType: registrationType,
            registrationTypeDated: registrationTypeDated,
          );
          return ledger;
        } else {
          showSnackBar(context, responseData['message']);
          return null;
        }
      }
    } catch (error) {
      showSnackBar(context, error.toString());
      return null;
    }
  }

  
  
  
  
  
  
  Future<List<Ledger>> fetchLedgers({
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      String? token = await getToken();
      List<String>? companyCode = await getCompanyCode();

      String url =
          '${Constants.baseUrl}/ledger/get-all-ledger/${companyCode!.first}';

      Response response = await Dio().get(
        url,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': '$token',
          },
        ),
      );

      final responseData = response.data;
      // print(responseData);

      if (responseData['success'] == true) {
        final ledgerData = responseData['data'];

        final List<Ledger> ledgers = List.from(
          ledgerData.map((entry) => Ledger.fromMap(entry)),
        );

        return ledgers;
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

  Future<Ledger?> fetchLedgerById(String id) async {
    try {
      String? token = await getToken();

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/ledger/get-single-ledger/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      // print('Leger by id $responseData');
      if (responseData['success'] == true) {
        final ledgerData = responseData['data'];

        // Check if the ledger data is not null
        if (ledgerData != null) {
          return Ledger.fromMap(ledgerData);
        } else {
          // If ledger data is null, return null
          return null;
        }
      } else {
        print('${responseData['message']}');
        // Return null in case of failure
        return null;
      }
    } catch (error) {
      print(error.toString());
      // Return null in case of an error
      return null;
    }
  }

  // Function to update ledger data
  Future<void> updateLedger(Ledger updatedLedger, BuildContext context) async {
    try {
      String? token = await getToken();
      final String? userType = await getUserType();

      UserGroupServices userGroupServices = UserGroupServices();

      final List<UserGroup> usersGroups =
          await userGroupServices.getUserGroups();

      bool canEditMaster = usersGroups.any((userGroup) =>
          userGroup.userGroupName == userType && userGroup.editMaster == "Yes");

      if (!canEditMaster) {
        showSnackBar(
            context, "You do not have permission to edit Ledger data.");
        return;
      } else {
        // Convert the updated ledger object to a map
        Map<String, dynamic> ledgerMap = updatedLedger.toMap();

        final response = await http.patch(
          Uri.parse(
              '${Constants.baseUrl}/ledger/update-ledger/${updatedLedger.id}'),
          body: json.encode(ledgerMap),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': '$token',
          },
        );

        final responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LedgerHome(),
            ),
          );
        } else {
          print('Failed to update ledger: ${responseData['message']}');
        }
      }
    } catch (error) {
      print('Error updating ledger: $error');
    }
  }

  Future<void> updateLedger2(Ledger updatedLedger, BuildContext context) async {
    try {
      String? token = await getToken();

      // Convert the updated ledger object to a map
      Map<String, dynamic> ledgerMap = updatedLedger.toMap();

      final response = await http.patch(
        Uri.parse(
            '${Constants.baseUrl}/ledger/update-ledger/${updatedLedger.id}'),
        body: json.encode(ledgerMap),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
// Do something...
      } else {
        print('Failed to update ledger: ${responseData['message']}');
      }
    } catch (error) {
      print('Error updating ledger: $error');
    }
  }

  Future<void> deleteLedger(String ledgerId, BuildContext context) async {
    try {
      String? token = await getToken();
      final String? userType = await getUserType();

      UserGroupServices userGroupServices = UserGroupServices();

      final List<UserGroup> usersGroups =
          await userGroupServices.getUserGroups();

      bool canDeleteMaster = usersGroups.any((userGroup) =>
          userGroup.userGroupName == userType &&
          userGroup.deleteMaster == "Yes");

      if (!canDeleteMaster) {
        // Check if the user has permission to delete ledger data
        showSnackBar(
            context, "You do not have permission to delete Ledger data.");
        return;
      } else {
        final response = await http.delete(
          Uri.parse('${Constants.baseUrl}/ledger/delete-ledger/$ledgerId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': '$token',
          },
        );

        final responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          Navigator.of(context).pop(); // Close loading dialog
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LedgerHome(),
            ),
          );
        } else {
          Navigator.of(context).pop();
          print('Failed to delete ledger: ${responseData['message']}');
        }
      }
    } catch (error) {
      Navigator.of(context).pop(); // Close loading dialog
      print('Error deleting ledger: $error');
    }
  }
}
