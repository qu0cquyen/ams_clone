import 'package:ams/entities/entities.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable{
  final String username; 

  const User({@required this.username});

  @override
  List<Object> get props => [username]; 

  @override
  String toString() => '''User {
    username: $username
  }
  ''';

  UserEntity toEntity(){
    return UserEntity(username: username);
  }

  factory User.fromEntity(UserEntity entity){
    return User(username: entity.username);
  }

  
}