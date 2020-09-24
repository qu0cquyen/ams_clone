part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class PaymentPageStarted extends PaymentEvent {}

class PaymentPageTipSelectionChanged extends PaymentEvent {
  final double tipSelection;

  const PaymentPageTipSelectionChanged({@required this.tipSelection});

  @override
  List<Object> get props => [tipSelection];

  @override
  String toString() => 'PaymentPageTipSelectionChanged: {tip: $tipSelection}';
}

class PaymentPageTipInputChanged extends PaymentEvent {
  final int customTip;

  const PaymentPageTipInputChanged({@required this.customTip});

  @override
  List<Object> get props => [customTip];

  @override
  String toString() => 'PaymentPageTipInputChanged: {tip: $customTip}';
}

class PaymentPageAddPromoPressed extends PaymentEvent {}

class PaymentPagePromoSelectionChanged extends PaymentEvent {
  final String promo;

  const PaymentPagePromoSelectionChanged({@required this.promo});

  @override
  List<Object> get props => [promo];

  @override
  String toString() => 'PaymentPagePromoSelectionChanged: {promo: $promo}';
}

// This event should be placed in Wallet and Reused in Payment Bloc
// For the sake of demo puposes, it is placed temporary here
class PaymentPageCardSelectionChanged extends PaymentEvent {
  final Map<String, dynamic> cardPref;

  const PaymentPageCardSelectionChanged({@required this.cardPref});

  @override
  List<Object> get props => [cardPref];

  @override
  String toString() => 'PaymentPageCardSelectionChanged: {cardPref: $cardPref}';
}

class PaymentPageConfirmPressed extends PaymentEvent {}

class PaymentPageChangeCardPressed extends PaymentEvent {}

class PaymentPagePayButtonSlided extends PaymentEvent {}
