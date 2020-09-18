part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentStateInitial extends PaymentState {}

class PaymentStateLoading extends PaymentState {}

class PaymentStateLoaded extends PaymentState {}

class PaymentStatePrefLoaded extends PaymentState {
  final Map<String, dynamic> cardPref;

  const PaymentStatePrefLoaded({@required this.cardPref});

  @override
  List<Object> get props => [cardPref];

  @override
  String toString() => 'PaymentStatePrefLoaded: {cardPref: $cardPref}';
}

class PaymentStateBottom1SheetShowed extends PaymentState {}

class PaymentStateBottom2SheetShowed extends PaymentState {}

class PaymentStateQuerySuccess extends PaymentState {}

class PaymentStateQueryFailure extends PaymentState {}
