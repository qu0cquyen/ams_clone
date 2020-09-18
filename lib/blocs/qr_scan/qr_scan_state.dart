part of 'qr_scan_bloc.dart';

abstract class QrScanState extends Equatable {
  const QrScanState();

  @override
  List<Object> get props => [];
}

class QrScanStateInitial extends QrScanState {}

class QrScanStateFound extends QrScanState {
  final Transaction transaction;

  const QrScanStateFound({@required this.transaction});

  @override
  List<Object> get props => [transaction];

  @override
  String toString() => 'ScanStateFound: {transaction: $transaction}';
}

class QrScanStateLoading extends QrScanState {}

class QrScanStateQueryInfoSuccess extends QrScanState {
  final String successMessage;

  const QrScanStateQueryInfoSuccess({@required this.successMessage});

  @override
  List<Object> get props => [successMessage];

  @override
  String toString() => 'ScanStateSuccess: {successMessage: $successMessage}';
}

class QrScanStateQueryInfoFailure extends QrScanState {
  final String errorMessage;

  const QrScanStateQueryInfoFailure({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'ScanStateFailure: {errorMessage: $errorMessage}';
}

class QrScanStatePaymentSuccess extends QrScanState {
  final String successMessage;

  const QrScanStatePaymentSuccess({@required this.successMessage});

  @override
  List<Object> get props => [successMessage];

  @override
  String toString() =>
      'QrScanStatePaymentSuccess: {successMessage: $successMessage}';
}

class QrScanStatePaymentFailure extends QrScanState {
  final String errorMessage;

  const QrScanStatePaymentFailure({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() =>
      'QrScanStatePaymentFailure: {errorMessage: $errorMessage}';
}

class QrScanStateLoaded extends QrScanState {}
