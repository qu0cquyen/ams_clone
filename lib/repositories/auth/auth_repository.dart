import 'dart:async';
import 'dart:convert';

import 'package:ams/config/paths.dart';
import 'package:ams/entities/entities.dart';
import 'package:ams/models/models.dart';
import 'package:ams/repositories/repositories.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

class AuthRepository extends BaseAuthRepository {
  User currentUser;
  final secureStorage = new FlutterSecureStorage();

  @override
  Future<User> loginWithAccessToken() async {
    await Future.delayed(const Duration(seconds: 3));

    //secureStorage.deleteAll();

    String accessToken = await secureStorage.read(key: "accessToken");

    print('Login With Access Token - $accessToken');
    final response = await http
        .get(Paths.URL_TOKEN, headers: {"authorization": accessToken});

    if (response.statusCode == 401) {
      print("Token is dead");
      return null;
    } else if (response.statusCode == 403) {
      print("Your token is expired");
      print("Trying to renew.....");
      String refreshToken = await secureStorage.read(key: "refreshToken");
      print("Refresh Token - $refreshToken");
      final refreshResponse = await http.post(Paths.URL_REFRESH_TOKEN,
          headers: {"Content-type": "application/json"},
          body: jsonEncode({"token": refreshToken}));

      if (refreshResponse.statusCode == 401) {
        print("Failed to renew");
        return null;
      } else if (refreshResponse.statusCode == 403) {
        print("Refresh Token is expired");
        return null;
      } else {
        print("Renew access Token successed");
        Map<String, dynamic> jsonToken = jsonDecode(refreshResponse.body);
        await secureStorage.write(
            key: "accessToken", value: jsonToken["accessToken"]);
        return loginWithAccessToken();
      }
    } else {
      Map<String, dynamic> json = jsonDecode(response.body)[0];
      currentUser = User.fromEntity(UserEntity.fromJson(json));
      print("Current User: $currentUser");
      return currentUser;
    }
  }

  @override
  Future<User> loginWithUserNameAndPassword(
      {@required String username, @required String password}) async {
    final response = await http.post(Paths.URL_LOGIN,
        headers: {"Content-type": "application/json"},
        body: jsonEncode({"username": username, "password": password}));
    if (response.statusCode == 401) {
      return null;
    } else {
      Map<String, dynamic> json = jsonDecode(response.body);
      String accessToken = json['accessToken'];
      String refreshToken = json['refreshToken'];

      // Securely store accessToken and refreshToken
      await secureStorage.write(key: "accessToken", value: accessToken);
      await secureStorage.write(key: "refreshToken", value: refreshToken);
      currentUser = User.fromEntity(UserEntity.fromJson(json));
      return currentUser;
    }
  }

  @override
  void dispose() {}

  @override
  Future<User> getCurrentUser() async {
    print("getCurrentUser: $currentUser");
    return currentUser;
  }

  @override
  Future<void> logout() async {
    print("Logging out");
    await secureStorage.deleteAll();
  }
}
