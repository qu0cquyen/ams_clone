part of 'on_boarding_bloc.dart';

abstract class OnBoardingEvent extends Equatable {
  const OnBoardingEvent();

  @override
  List<Object> get props => [];
}

class PhoneNumberChanged extends OnBoardingEvent {
  final String phoneNumber;

  const PhoneNumberChanged({@required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];

  @override
  String toString() => 'PhoneNumberChanged {phoneNumber: $phoneNumber}';
}

class ContinueButtonPressed extends OnBoardingEvent {
  final String phoneNumber;

  const ContinueButtonPressed({@required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];

  @override
  String toString() => 'ContinueButtonPressed {phoneNumber: $phoneNumber}';
}

class AuthenticationCode extends OnBoardingEvent {}

class TimerStarted extends OnBoardingEvent {
  final int duration;

  const TimerStarted({@required this.duration});

  @override
  List<Object> get props => [duration];

  @override
  String toString() => 'TimerStarted: $duration';
}

class TimerTicked extends OnBoardingEvent {
  final int duration;

  const TimerTicked({@required this.duration});

  @override
  List<Object> get props => [duration];

  @override
  String toString() => 'TimerTicked: $duration';
}
