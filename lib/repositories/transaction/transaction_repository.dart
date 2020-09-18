import 'dart:convert';

import 'package:ams/config/paths.dart';
import 'package:ams/entities/entities.dart';
import 'package:ams/models/models.dart';
import 'package:ams/repositories/repositories.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class TransactionRepository extends BaseTransactionRepository {
  final secureStorage = FlutterSecureStorage();
  String accessToken;

  @override
  void dispose() {}

  @override
  Future<Transaction> transactionInfoRetrieving({String transactionID}) async {
    if (accessToken == null)
      accessToken = await secureStorage.read(key: "accessToken");
    print("Getting here");
    print(accessToken);
    final response = await http.post(Paths.URL_TRANSACTION_INFO,
        headers: {
          "Content-type": "application/json",
          "authorization": accessToken
        },
        body: jsonEncode({"transactionID": transactionID}));

    if (response.statusCode == 403) {
      print("Failed to retrieving");
      return null;
    } else if (response.statusCode == 401) {
      print("User doesn't have any pending payment");
      return null;
    } else {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Transaction.fromEntity(TransactionEntity.fromJson(json));
    }
  }

  @override
  Future<bool> transactionPaymentExecution({String transactionID}) async {
    if (accessToken == null)
      accessToken = await secureStorage.read(key: "accessToken");

    final response = await http.post(Paths.URL_TRANSACTION_PAYMENT,
        headers: {
          "Content-type": "application/json",
          "authorization": accessToken
        },
        body: jsonEncode({"transactionID": transactionID}));

    if (response.statusCode == 401) {
      print("Failed to make transaction");
      return false;
    } else {
      print("Payment has been made successful");
      //await Future.delayed(const Duration(seconds: 3));
      return true;
    }
  }
}
