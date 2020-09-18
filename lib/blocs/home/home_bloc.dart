import 'dart:async';

import 'package:ams/models/models.dart';
import 'package:ams/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  HomeBloc({@required HomeRepository homeRepository})
      : _homeRepository = homeRepository,
        super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeStarted) {
      yield* _mapHomeStartedToState(event);
    }
  }

  Stream<HomeState> _mapHomeStartedToState(HomeStarted event) async* {
    try {
      Transaction payment = await _homeRepository.requestTransactionDetails();
      yield HomeRequest(payment: payment);
    } catch (error) {
      print(error.toString());
    }
  }
}
