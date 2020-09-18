part of 'qr_scan_bloc.dart';

abstract class QrScanEvent extends Equatable {
  const QrScanEvent();

  @override
  List<Object> get props => [];
}

class QrScanTransactionRequest extends QrScanEvent {
  final String transactionID;

  const QrScanTransactionRequest({@required this.transactionID});

  @override
  List<Object> get props => [transactionID];

  @override
  String toString() =>
      'QrScanTransactionRequest {transacitonID: $transactionID}';
}

class QrScanSubmitPressed extends QrScanEvent {
  final String transactionID;

  const QrScanSubmitPressed({@required this.transactionID});

  @override
  List<Object> get props => [transactionID];

  @override
  String toString() => 'QrScanSubmitPressed {transactionID: $transactionID}';
}
