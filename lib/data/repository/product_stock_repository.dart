import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constant.dart';
import '../models/stock/product_stock_model.dart';

class ProductStockService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Get all product stock
  Future<List<ProductStockModel>> getAllProductStock() async {
    String? token = await getToken();
    final Uri uri = Uri.parse('${Constants.baseUrl}/product-stock/fetchAll');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );

    final responseData = json.decode(response.body);
    if (responseData['success'] == true) {
      final itemData = responseData['data'];

      final List<ProductStockModel> loadedProductStock = List.from(itemData)
          .map((productStock) => ProductStockModel.fromMap(productStock))
          .toList();

      return loadedProductStock;
    } else {
      throw Exception('Failed to load product stock');
    }
  }
}
