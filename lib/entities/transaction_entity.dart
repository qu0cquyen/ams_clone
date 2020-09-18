import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class TransactionEntity extends Equatable {
  final String transactionID;
  final String paymentID;
  final String provider;
  final String company;
  final String paymentState;
  final String action;
  final String username;
  final Map<String, dynamic> services;

  const TransactionEntity({
    @required this.transactionID,
    @required this.paymentID,
    @required this.provider,
    @required this.company,
    @required this.paymentState,
    @required this.action,
    @required this.username,
    @required this.services,
  });

  @override
  List<Object> get props => [
        transactionID,
        paymentID,
        provider,
        company,
        paymentState,
        action,
        username,
        services
      ];

  @override
  String toString() => '''TransactionEntity {
    "transactionID": $transactionID, 
    "paymentID": $paymentID, 
    "provider": $provider, 
    "company": $company, 
    "paymentState": $paymentState, 
    "action": $action, 
    "username": $username, 
    "services": $services
  }
  ''';

  Map<String, dynamic> toJson() {
    return {
      "transactionID": transactionID,
      "paymentID": paymentID,
      "provider": provider,
      "company": company,
      "paymentState": paymentState,
      "action": action,
      "username": username,
      "services": services
    };
  }

  factory TransactionEntity.fromJson(Map<String, dynamic> json) {
    return TransactionEntity(
        transactionID: json["transactionID"] as String,
        paymentID: json["paymentID"] as String,
        provider: json["provider"] as String,
        company: json["company"] as String,
        paymentState: json["paymentState"] as String,
        action: json["action"] as String,
        username: json["username"] as String,
        services: json["services"] as Map<String, dynamic>);
  }
}
