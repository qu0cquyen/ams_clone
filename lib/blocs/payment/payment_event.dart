part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class PaymentPageStart extends PaymentEvent {}

class TipSelectionChange extends PaymentEvent {
  final double tipSelection;

  const TipSelectionChange({@required this.tipSelection});

  @override
  List<Object> get props => [tipSelection];

  @override
  String toString() => 'TipSelectionChange: {tip: $tipSelection}';
}

class TipInputChange extends PaymentEvent {
  final int customTip;

  const TipInputChange({@required this.customTip});

  @override
  List<Object> get props => [customTip];

  @override
  String toString() => 'TipInputChange: {tip: $customTip}';
}

class AddPromoPressed extends PaymentEvent {}

class PromoSelectionChange extends PaymentEvent {
  final String promo;

  const PromoSelectionChange({@required this.promo});

  @override
  List<Object> get props => [promo];

  @override
  String toString() => 'PromoSelectionChange: {promo: $promo}';
}

// This event should be placed in Wallet and Reused in Payment Bloc
// For the sake of demo puposes, it is placed temporary here
class CardSelectionChange extends PaymentEvent {}

class ConfirmPressed extends PaymentEvent {}

class ChangeCardPressed extends PaymentEvent {}
