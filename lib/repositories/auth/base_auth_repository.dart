import 'package:ams/models/models.dart';
import 'package:ams/repositories/base_repository.dart';

abstract class BaseAuthRepository extends BaseRepository{
  Future<User> loginWithUserNameAndPassword({String username, String password});
  Future<User> loginWithAccessToken();
  Future<void> logout(); 
  Future<User> getCurrentUser(); 

  // Future<User> logIn({String username, String password});
  // void logOut();  
  
}