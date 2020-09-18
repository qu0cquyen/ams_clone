import 'dart:async';
import 'dart:convert';

import 'package:ams/blocs/blocs.dart';
import 'package:ams/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/semantics.dart';
import 'package:meta/meta.dart';
import 'package:ams/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final TransactionRepository _transactionRepository;

  PaymentBloc({@required TransactionRepository transactionRepository})
      : _transactionRepository = transactionRepository,
        super(PaymentStateInitial());

  @override
  Stream<PaymentState> mapEventToState(
    PaymentEvent event,
  ) async* {
    if (event is PaymentPageStart) {
      yield* _mapPaymentPageStartToState();
    } else if (event is TipSelectionChange) {
      yield* _mapTipSelectionChangeToState(event);
    } else if (event is TipInputChange) {
      yield* _mapTipInputChangeToState(event);
    } else if (event is AddPromoPressed) {
      yield* _mapAddPromoPressedToState();
    } else if (event is PromoSelectionChange) {
      yield* _mapPromoSelectionChangeToState(event);
    } else if (event is CardSelectionChange) {
      yield* _mapCardSelectionChangeToState();
    } else if (event is ConfirmPressed) {
      yield* _mapConfirmPressedToState(event);
    } else if (event is ChangeCardPressed) {
      yield* _mapChangeCardPressedToState();
    }
  }

  Future<Map<String, dynamic>> prefLoading() async {
    final _prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> _cardPref =
        jsonDecode(_prefs.getString("preferred_card"));
    print("Payment Bloc - $_cardPref");
    return _cardPref;
    // Map<String, dynamic> _cardPref =
    //     jsonDecode(_prefs.getString("preferred_card"));
  }

  Stream<PaymentState> _mapPaymentPageStartToState() async* {
    // print("PAGE START");
    // yield PaymentStateLoading();
    // yield PaymentStatePrefLoaded(cardPref: await prefLoading());
    // yield PaymentStateLoaded();
  }

  Stream<PaymentState> _mapTipSelectionChangeToState(
      TipSelectionChange event) async* {}

  Stream<PaymentState> _mapTipInputChangeToState(TipInputChange event) async* {}

  Stream<PaymentState> _mapAddPromoPressedToState() async* {}

  Stream<PaymentState> _mapPromoSelectionChangeToState(
      PromoSelectionChange event) async* {}

  Stream<PaymentState> _mapCardSelectionChangeToState() async* {
    yield PaymentStatePrefLoaded(cardPref: await prefLoading());
    //yield PaymentStateBottom1SheetShowed();
  }

  Stream<PaymentState> _mapConfirmPressedToState(ConfirmPressed event) async* {
    yield PaymentStateBottom1SheetShowed();
    yield PaymentStatePrefLoaded(cardPref: await prefLoading());
  }

  Stream<PaymentState> _mapChangeCardPressedToState() async* {
    yield PaymentStateBottom2SheetShowed();
    // Preserved access to Repo to load user's bank cards
  }
}
