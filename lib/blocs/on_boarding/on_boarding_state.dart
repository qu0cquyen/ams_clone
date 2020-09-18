part of 'on_boarding_bloc.dart';

@immutable
class OnBoardingState {
  final bool isPhoneNumberValid;
  final bool isSuccess;
  final bool isFailure;
  final bool isTimerFinished;
  final int duration;
  final String errorMessage;

  const OnBoardingState(
      {@required this.isPhoneNumberValid,
      @required this.isSuccess,
      @required this.isFailure,
      @required this.isTimerFinished,
      @required this.duration,
      @required this.errorMessage});

  factory OnBoardingState.empty() {
    return OnBoardingState(
        isPhoneNumberValid: false,
        isSuccess: false,
        isFailure: false,
        isTimerFinished: false,
        duration: 0,
        errorMessage: '');
  }

  factory OnBoardingState.success() {
    return OnBoardingState(
        isPhoneNumberValid: true,
        isSuccess: true,
        isFailure: false,
        isTimerFinished: false,
        duration: 0,
        errorMessage: '');
  }

  factory OnBoardingState.timerFinished() {
    return OnBoardingState(
      isPhoneNumberValid: false,
      isSuccess: false,
      isFailure: false,
      isTimerFinished: true,
      duration: 0,
      errorMessage: '',
    );
  }

  factory OnBoardingState.timerRunInProgress(int duration) {
    return OnBoardingState(
      isPhoneNumberValid: false,
      isSuccess: false,
      isFailure: false,
      isTimerFinished: false,
      duration: duration,
      errorMessage: '',
    );
  }

  factory OnBoardingState.failure(String errorMessage) {
    return OnBoardingState(
        isPhoneNumberValid: false,
        isSuccess: false,
        isFailure: true,
        isTimerFinished: false,
        duration: 0,
        errorMessage: errorMessage);
  }

  OnBoardingState copyWith(
      {@required isPhoneNumberValid,
      @required isSuccess,
      @required isFailure,
      @required isTimerFinished,
      @required duration,
      @required errorMessage}) {
    return OnBoardingState(
      isPhoneNumberValid: isPhoneNumberValid ?? this.isPhoneNumberValid,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      isTimerFinished: isTimerFinished ?? this.isTimerFinished,
      duration: duration ?? this.duration,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  OnBoardingState update({bool isPhoneNumberValid, int duration}) {
    return OnBoardingState(
      isPhoneNumberValid: isPhoneNumberValid,
      isSuccess: false,
      isFailure: false,
      isTimerFinished: false,
      duration: duration,
      errorMessage: '',
    );
  }

  @override
  String toString() => '''OnBardingState {
    isPhoneNumberValid: $isPhoneNumberValid, 
    isSuccess: $isSuccess, 
    isFailure: $isFailure, 
    isTimerFinished: $isTimerFinished, 
    duration: $duration,
    errorMessage: $errorMessage
  }''';
}
