import 'package:ams/entities/entities.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Transaction extends Equatable {
  final String transactionID;
  final String paymentID;
  final String provider;
  final String company;
  final String paymentState;
  final String action;
  final String username;
  final Map<String, dynamic> services;

  const Transaction({
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
  String toString() => '''
  Transaction {
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

  TransactionEntity toEntity() {
    return TransactionEntity(
        transactionID: transactionID,
        paymentID: paymentID,
        provider: provider,
        company: company,
        paymentState: paymentState,
        action: action,
        username: username,
        services: services);
  }

  factory Transaction.fromEntity(TransactionEntity entity) {
    return Transaction(
        transactionID: entity.transactionID,
        paymentID: entity.paymentID,
        provider: entity.provider,
        company: entity.company,
        paymentState: entity.paymentState,
        action: entity.action,
        username: entity.username,
        services: entity.services);
  }
}
