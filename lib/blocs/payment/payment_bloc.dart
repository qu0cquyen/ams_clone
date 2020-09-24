import 'dart:async';
import 'dart:convert';

import 'package:ams/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';
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
    if (event is PaymentPageStarted) {
      yield* _mapPaymentPageStartToState();
    } else if (event is PaymentPageTipSelectionChanged) {
      yield* _mapTipSelectionChangeToState(event);
    } else if (event is PaymentPageTipInputChanged) {
      yield* _mapTipInputChangeToState(event);
    } else if (event is PaymentPageAddPromoPressed) {
      yield* _mapAddPromoPressedToState();
    } else if (event is PaymentPagePromoSelectionChanged) {
      yield* _mapPromoSelectionChangeToState(event);
    } else if (event is PaymentPageCardSelectionChanged) {
      yield* _mapCardSelectionChangeToState(event);
    } else if (event is PaymentPageConfirmPressed) {
      yield* _mapConfirmPressedToState(event);
    } else if (event is PaymentPageChangeCardPressed) {
      yield* _mapChangeCardPressedToState();
    } else if (event is PaymentPagePayButtonSlided) {
      yield* _mapPaymentPagePayButtonSlided();
    }
  }

  Future<Map<String, dynamic>> prefLoading() async {
    final _prefs = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> _cardPref =
          jsonDecode(_prefs.getString("preferred_card"));
      return _cardPref;
    } catch (Exception) {
      return null;
    }

    // print("Payment Bloc - $_cardPref");

    // Map<String, dynamic> _cardPref =
    //     jsonDecode(_prefs.getString("preferred_card"));
  }

  Stream<PaymentState> _mapPaymentPageStartToState() async* {
    // The codes below are used for the sake of demo purposes.
    final _prefs = await SharedPreferences.getInstance();
    _prefs.clear();
    // print("PAGE START");
    // yield PaymentStateLoading();
    // yield PaymentStatePrefLoaded(cardPref: await prefLoading());
    // yield PaymentStateLoaded();
  }

  Stream<PaymentState> _mapTipSelectionChangeToState(
      PaymentPageTipSelectionChanged event) async* {}

  Stream<PaymentState> _mapTipInputChangeToState(
      PaymentPageTipInputChanged event) async* {}

  Stream<PaymentState> _mapAddPromoPressedToState() async* {}

  Stream<PaymentState> _mapPromoSelectionChangeToState(
      PaymentPagePromoSelectionChanged event) async* {}

  Stream<PaymentState> _mapCardSelectionChangeToState(
      PaymentPageCardSelectionChanged event) async* {
    // Over-written new card to Pref
    // Load pref card back
    // Show in bottom Sheet
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setString("preferred_card", jsonEncode(event.cardPref));
    yield PaymentStatePrefLoaded(cardPref: await prefLoading());
    yield PaymentStateBottom1SheetShowed();

    // final _pref = await SharedPreferences.getInstance();
    // _pref.setString("preferred_card", jsonEncode(event.cardPref));
  }

  Stream<PaymentState> _mapConfirmPressedToState(
      PaymentPageConfirmPressed event) async* {
    yield PaymentStateBottomSheetShowedUp();
    yield PaymentStatePrefLoaded(cardPref: await prefLoading());
    yield PaymentStateBottom1SheetShowed();
  }

  Stream<PaymentState> _mapChangeCardPressedToState() async* {
    yield PaymentStateBottom2SheetShowed();
    // Preserved access to Repo to load user's bank cards
  }

  Stream<PaymentState> _mapPaymentPagePayButtonSlided() async* {
    yield PaymentStateLoading();

    // Stimulate delay environment
    await Future.delayed(const Duration(seconds: 3));
    yield PaymentStateLoaded();

    //yield PaymentStatePaySuccess();
    yield PaymentStatePayFailure();
  }
}
