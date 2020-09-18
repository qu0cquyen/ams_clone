import 'package:ams/models/models.dart';
import 'package:ams/repositories/repositories.dart';

abstract class BaseTransactionRepository extends BaseRepository {
  Future<Transaction> transactionInfoRetrieving({String transactionID});
  Future<bool> transactionPaymentExecution({String transactionID});
}
