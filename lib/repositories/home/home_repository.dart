import 'dart:convert';

import 'package:ams/config/paths.dart';
import 'package:ams/entities/entities.dart';
import 'package:ams/models/models.dart';
import 'package:ams/repositories/repositories.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class HomeRepository extends BaseHomeRepository {
  @override
  void dispose() {}

  @override
  Future<Transaction> requestTransactionDetails() async {
    try {
      print("Start making a request.....");
      final secureStorage = FlutterSecureStorage();
      final String accessToken = await secureStorage.read(key: "accessToken");
      print(accessToken);
      final response = await http.get(Paths.URL_TRANSACTION_USER, headers: {
        "authorization": accessToken,
      });

      if (response.statusCode == 401) {
        print("Failed to Request");
        return null;
      } else {
        Map<String, dynamic> json = jsonDecode(response.body);
        print(json);
        return Transaction.fromEntity(TransactionEntity.fromJson(json));
      }
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
