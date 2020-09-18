part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeRequest extends HomeState {
  final Transaction payment;

  const HomeRequest({@required this.payment});

  @override
  List<Object> get props => [payment];

  @override
  String toString() => 'HomeRequest: $payment';
}
