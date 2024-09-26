import 'package:billingsphere/data/models/brand/item_brand_model.dart';
import 'package:billingsphere/data/models/item/item_model.dart';
import 'package:billingsphere/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ItemsBrandsService {
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

  Future<List<ItemsBrand>> fetchItemBrands() async {
    try {
      String? token = await getToken();

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/item-brand/get'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);
      // print(responseData);
      if (responseData['success'] == true) {
        final itemBrandsData = responseData['data'];

        final List<ItemsBrand> itemBrands = List.from(
          itemBrandsData.map((entry) => ItemsBrand.fromMap(entry)),
        );

        return itemBrands;
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

  Future<String> fetchBrandNameById(String id) async {
    try {
      String? token = await getToken();

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/item-brand/get/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        final brandData = responseData['data'];

        final brandName = brandData['name'];

        print(brandName);

        return brandName;
      } else {
        print('${responseData['message']}');
      }
      // Return null in case of failure
      return '';
    } catch (error) {
      print(error.toString());
      return '';
    }
  }

  Future<void> createItemBrand({
    required String name,
  }) async {
    String? token = await getToken();

    final Uri uri = Uri.parse(
        '${Constants.baseUrl}/item-brand/create'); // Replace with your API endpoint

    ItemsBrand itemGroup = ItemsBrand(
      id: '',
      name: name,
      images: [],
      createdAt: DateTime.now(),
      updatedOn: DateTime.now(),
    );

    final http.Response response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: itemGroup.toJson(),
    );

    print('Response status code: ${response.body}');

    if (response.statusCode == 200) {
      // ItemsGroup created successfully
      print('Item brand created successfully');
    } else {
      // Handle error
      print('Failed to create Item brand. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  // Fetch Item Brand by ID
  Future<ItemsBrand> fetchItemBrandById(String id) async {
    try {
      String? token = await getToken();

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/item-brand/get/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        final itemBrandData = responseData['data'];

        final ItemsBrand itemBrand = ItemsBrand.fromMap(itemBrandData);

        return itemBrand;
      } else {
        print('${responseData['message']}');
      }
      // Return an empty list in case of failure
      return ItemsBrand(
        id: '',
        name: '',
        createdAt: DateTime.now(),
        updatedOn: DateTime.now(),
      );
    } catch (error) {
      print(error.toString());
      return ItemsBrand(
        id: '',
        name: '',
        createdAt: DateTime.now(),
        updatedOn: DateTime.now(),
      );
    }
  }

  // Update Item Brand
  Future<void> updateItemBrand({
    required String id,
    required String name,
    required ImageData? images,
  }) async {
    String? token = await getToken();

    final Uri uri = Uri.parse(
        '${Constants.baseUrl}/item-brand/update/$id'); // Replace with your API endpoint

    ItemsBrand itemBrand;

    if (images != null) {
      itemBrand = ItemsBrand(
        id: id,
        name: name,
        createdAt: DateTime.now(),
        updatedOn: DateTime.now(),
        images: [images],
      );
    } else {
      itemBrand = ItemsBrand(
        id: id,
        name: name,
        createdAt: DateTime.now(),
        updatedOn: DateTime.now(),
        images: [],
      );
    }
    final http.Response response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: itemBrand.toJson(),
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
      print('Failed to update Item brand. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> deleteItemBrands(String id) async {
    String? token = await getToken();

    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/item-brand/delete/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );

    final responseData = json.decode(response.body);
    print(responseData);
    if (responseData['success'] == true) {
      //  Flutter toast
      Get.snackbar('Success', 'Item Brand Deleted Successfully');
    } else {
      throw Exception('Failed to delete Item Brand');
    }
  }
}
