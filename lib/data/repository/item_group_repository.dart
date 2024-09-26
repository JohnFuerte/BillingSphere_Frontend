import 'dart:convert';
import 'package:billingsphere/data/models/itemGroup/item_group_model.dart';
import 'package:billingsphere/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/item/item_model.dart';

class ItemsGroupService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<List<ItemsGroup>> fetchItemGroups() async {
    try {
      String? token = await getToken();

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/item-group/get'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);
      if (responseData['success'] == true) {
        final itemGData = responseData['data'];

        final List<ItemsGroup> itemsGroup = List.from(itemGData.map((entry) {
          entry.remove('images');
          return ItemsGroup.fromMap(entry);
        }));

        return itemsGroup;
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

  Future<ItemsGroup?> fetchItemGroupById(String id) async {
    try {
      String? token = await getToken();

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/item-group/get/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);
      // print(responseData);

      if (responseData['success'] == true) {
        final itemGroupData = responseData['data'];

        // itemGroupData.remove('images');

        if (itemGroupData != null) {
          return ItemsGroup.fromMap(itemGroupData);
        } else {
          return null;
        }

        // return itemGroup;
      } else {
        throw Exception('${responseData['message']}');
      }
    } catch (error) {
      print(error.toString());
      throw Exception('Failed to fetch item group by ID: $id');
    }
  }

  Future<void> createItemsGroup({
    required String name,
    required String desc,
    required List<ImageData>? images,
  }) async {
    String? token = await getToken();

    final Uri uri = Uri.parse(
        '${Constants.baseUrl}/item-group/create'); // Replace with your API endpoint

    ItemsGroup itemGroup = ItemsGroup(
      id: '',
      name: name,
      desc: desc,
      images: images,
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
      print('ItemsGroup created successfully');
    } else {
      // Handle error
      print('Failed to create ItemsGroup. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> updateItemGroup({
    required String id,
    required String name,
    required String desc,
    required ImageData? images,
  }) async {
    String? token = await getToken();

    final Uri uri = Uri.parse('${Constants.baseUrl}/item-group/update/$id');

    ItemsGroup itemGroup;

    if (images != null) {
      itemGroup = ItemsGroup(
        id: id,
        name: name,
        desc: desc,
        createdAt: DateTime.now(),
        updatedOn: DateTime.now(),
        images: [images],
      );
    } else {
      // If images is null, create ItemsGroup without images
      itemGroup = ItemsGroup(
        id: id,
        name: name,
        desc: desc,
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
      body: itemGroup.toJson(),
    );

    print('Response status code: ${response.body}');

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

  Future<void> deleteItemGroup(String id) async {
    String? token = await getToken();

    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/item-group/delete/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );

    final responseData = json.decode(response.body);
    print(responseData);
    if (responseData['success'] == true) {
      //  Flutter toast
      Get.snackbar('Success', 'Item Group Deleted Successfully');
    } else {
      throw Exception('Failed to delete Item Group');
    }
  }
}
