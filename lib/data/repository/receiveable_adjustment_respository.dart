import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../utils/constant.dart';
import '../models/ledger/ledger_model.dart';

class ReceiveableAdjustmentService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Ledger>?> fetchReceiveable(String location, String? id) async {
    try {
      String? token = await getToken();

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/receiveable/$location/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        final ledgerList = responseData['data'];

        // Check if the ledger list is not null
        if (ledgerList != null) {
          // Process each ledger in the list
          List<Ledger> ledgers = [];
          for (var ledgerData in ledgerList) {
            ledgers.add(Ledger.fromMap(ledgerData));
          }
          return ledgers;
        } else {
          // If ledger list is null, return null
          return null;
        }
      } else {
        print('${responseData['message']}');
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
