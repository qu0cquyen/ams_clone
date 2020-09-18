import 'package:ams/models/models.dart';
import 'package:ams/repositories/repositories.dart';

abstract class BaseHomeRepository extends BaseRepository {
  Future<Transaction> requestTransactionDetails();
}
