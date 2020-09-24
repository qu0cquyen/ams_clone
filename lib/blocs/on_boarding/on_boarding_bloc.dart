import 'dart:async';

import 'package:ams/config/validators.dart';
import 'package:ams/util/ticker.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'on_boarding_event.dart';
part 'on_boarding_state.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  final Ticker _ticker;
  static const int _duration = 12;
  StreamSubscription<int> _tickerSubscription;

  OnBoardingBloc({@required Ticker ticker})
      : _ticker = ticker,
        super(OnBoardingState.empty());

  @override
  Stream<OnBoardingState> mapEventToState(
    OnBoardingEvent event,
  ) async* {
    if (event is PhoneNumberChanged) {
      yield* _mapPhoneNumberChangedToState(event);
    } else if (event is ContinueButtonPressed) {
      yield* _mapContinueButtonPressedToState(event);
    } else if (event is TimerStarted) {
      yield* _mapTimerStartedToState(event);
    } else if (event is TimerTicked) {
      yield* _mapTimerTickedToState(event);
    }
  }

  Stream<OnBoardingState> _mapPhoneNumberChangedToState(
      PhoneNumberChanged event) async* {
    yield state.update(
        isPhoneNumberValid: Validators.isValidPhoneNumber(event.phoneNumber));
  }

  Stream<OnBoardingState> _mapContinueButtonPressedToState(
      ContinueButtonPressed event) async* {
    // Will communicate with server and get back response.
    yield OnBoardingState.success();
  }

  Stream<OnBoardingState> _mapTimerStartedToState(TimerStarted event) async* {
    yield state.update(duration: _duration);
    yield OnBoardingState.timerRunInProgress(_duration);
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(tick: _duration)
        .listen((duration) => add(TimerTicked(duration: duration)));
  }

  Stream<OnBoardingState> _mapTimerTickedToState(TimerTicked event) async* {
    yield event.duration > 0
        ? state.update(duration: event.duration)
        : OnBoardingState.timerFinished();
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
