import 'dart:async';

import 'package:ams/models/models.dart';
import 'package:ams/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'qr_scan_event.dart';
part 'qr_scan_state.dart';

class QrScanBloc extends Bloc<QrScanEvent, QrScanState> {
  final TransactionRepository _transactionRepository;

  QrScanBloc({@required TransactionRepository transactionRepository})
      : _transactionRepository = transactionRepository,
        super(QrScanStateInitial());

  @override
  Stream<QrScanState> mapEventToState(QrScanEvent event) async* {
    if (event is QrScanTransactionRequest) {
      yield* _mapQrScanTransactionRequestToState(event);
    } else if (event is QrScanSubmitPressed) {
      yield* _mapQrScanSubmitPressedToState(event);
    }
  }

  Stream<QrScanState> _mapQrScanTransactionRequestToState(
      QrScanTransactionRequest event) async* {
    yield QrScanStateLoading();
    await Future.delayed(const Duration(seconds: 3));
    Transaction transaction = await _transactionRepository
        .transactionInfoRetrieving(transactionID: event.transactionID);
    yield QrScanStateLoaded();

    print(transaction);

    if (transaction == null)
      yield QrScanStateQueryInfoFailure(
          errorMessage: 'Failed to query transaction info');
    else {
      yield QrScanStateQueryInfoSuccess(
          successMessage: 'Success to query transaction info');
      yield QrScanStateFound(transaction: transaction);
    }
  }

  Stream<QrScanState> _mapQrScanSubmitPressedToState(
      QrScanSubmitPressed event) async* {
    yield QrScanStateLoading();
    await Future.delayed(const Duration(seconds: 3));
    bool paymenState = await _transactionRepository.transactionPaymentExecution(
        transactionID: event.transactionID);
    yield QrScanStateLoaded();

    if (!paymenState)
      yield QrScanStatePaymentFailure(errorMessage: 'Insufficient Balances');
    else {
      yield QrScanStatePaymentSuccess(successMessage: 'Payment has been made');
    }
  }
}
