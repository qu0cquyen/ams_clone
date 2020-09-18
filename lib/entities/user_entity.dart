import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class UserEntity extends Equatable{
  final String username; 

  const UserEntity({@required this.username}); 

  @override
  List<Object> get props => [username]; 

  @override
  String toString() => '''UserEntity {
    username: $username
  }
  ''';

  Map<String, dynamic> toJson() => {
    'username' : username
  }; 

  factory UserEntity.fromJson(Map<String, dynamic> json){
    return UserEntity(
      username: json['username'] as String
    );
  }
}