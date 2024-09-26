import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constant.dart';
import '../models/price/price_category.dart';

class PriceCategoryRepository {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('companyCode');
  }

  Future<List<PriceCategory>> fetchPriceCategories() async {
    try {
      String? token = await getToken();
      String? id = await getCompanyCode();


      print(id);

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/price/fetchAllPriceType/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        final priceCategoryData = responseData['data'];

        final List<PriceCategory> priceCategories = List.from(
            priceCategoryData.map((entry) =>
                PriceCategory.fromMap(entry as Map<String, dynamic>)));

        return priceCategories;
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

  //create
  void addPriceCategory(PriceCategory priceLsitCategory) async {
    try {
      String? token = await getToken();

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/price/createPrice'),
        body: json.encode(priceLsitCategory.toMap()),
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
}
