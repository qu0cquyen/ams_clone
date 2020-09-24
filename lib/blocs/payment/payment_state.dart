part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentStateInitial extends PaymentState {}

class PaymentStateLoading extends PaymentState {}

class PaymentStateLoaded extends PaymentState {}

// This should be placed in wallet Bloc
// For the sake of demo purposes - this will be put here temporarily
class PaymentStatePrefRenewed extends PaymentState {}

class PaymentStatePrefLoaded extends PaymentState {
  final Map<String, dynamic> cardPref;

  const PaymentStatePrefLoaded({@required this.cardPref});

  @override
  List<Object> get props => [cardPref];

  @override
  String toString() => 'PaymentStatePrefLoaded: {cardPref: $cardPref}';
}

class PaymentStateBottomSheetShowedUp extends PaymentState {}

class PaymentStateBottom1SheetShowed extends PaymentState {}

class PaymentStateBottom2SheetShowed extends PaymentState {}

class PaymentStateQuerySuccess extends PaymentState {}

class PaymentStateQueryFailure extends PaymentState {}

class PaymentStatePaySuccess extends PaymentState {}

class PaymentStatePayFailure extends PaymentState {}
