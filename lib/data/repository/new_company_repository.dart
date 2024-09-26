import 'dart:convert';

import 'package:billingsphere/data/models/newCompany/new_company_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/constant.dart';
import 'package:http/http.dart' as http;

class NewCompanyRepository {
  Future<void> createNewCompany(NewCompany newCompany) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/company/create'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(newCompany.toMap()),
    );

    final responseData = json.decode(response.body);
    if (responseData['success'] == true) {
      Fluttertoast.showToast(
        msg: responseData['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    } else {
      Fluttertoast.showToast(
        msg: responseData['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
  }

  Future<List<NewCompany>> getAllCompanies() async {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/company/all'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final responseData = json.decode(response.body);

    // print('DATA $responseData');
    List<NewCompany> companies = [];

    if (responseData['success'] == true) {
      for (var company in responseData['data']) {
        companies.add(NewCompany.fromMap(company));
      }

      // print('COMPANY $companies');
    } else {
      Fluttertoast.showToast(
        msg: responseData['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }

    return companies;
  }

  Future<void> updateNewCompany(
      NewCompany newcompany, BuildContext context) async {
    // String? token = await getToken();

    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/company/update/${newcompany.id}'),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': '$token',
      },
      body: json.encode(newcompany.toMap()),
    );

    final responseData = json.decode(response.body);

    print(responseData);

    if (responseData['success'] == true) {
      Fluttertoast.showToast(
        msg: 'Company updated successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      ).then((value) => {
            Navigator.pop(context),
          });
    } else {
      Fluttertoast.showToast(
        msg: 'Failed to update company',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
  }

  Future<void> deleteCompany(String id) async {
    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/company/delete/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final responseData = json.decode(response.body);

    if (responseData['success'] == true) {
      Fluttertoast.showToast(
        msg: responseData['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    } else {
      Fluttertoast.showToast(
        msg: responseData['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
  }

  // Get company by id
  Future<NewCompany> getCompanyById(String id) async {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/company/get/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final responseData = json.decode(response.body);
    // print(responseData);
    if (responseData['success'] == true) {
      return NewCompany.fromMap(responseData['data']);
    } else {
      Fluttertoast.showToast(
        msg: responseData['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      return NewCompany(
        id: '',
        country: '',
        email: '',
        gstin: '',
        pan: '',
        companyName: '',
        companyType: '',
        taxation: '',
        acYear: '',
        acYearTo: '',
        password: '',
        logo1: [],
      );
    }
  }
}
