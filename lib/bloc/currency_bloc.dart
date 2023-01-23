import 'package:bloc/bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:equatable/equatable.dart';
import 'package:exos/model/currency.dart';
import 'package:exos/currency_repository.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

part 'currency_event.dart';
part 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final CurrencyRepository currency_repository;

  CurrencyBloc(this.currency_repository) : super(CurrencyInitial()) {
    on<ListenConnection>((event, emit) async {
      await DataConnectionChecker().hasConnection
          ? emit(CurrencyLoadedState(
              amount: "0", from: 'EUR', to: 'USD', date: '2020-01-20'))
          : emit(ConnectionFailure(errorword: "Aucune connexion"));
    });

    on<CurrencyLoadedEvent>((event, emit) async {
      emit(CurrencyLoadedState(
          amount: "0", from: 'EUR', to: 'USD', date: '2020-01-20'));
/*
      try {
        final parite = await currency_repository.get);
        emit(CurrencyLoadedState(parite));
      } catch (e) {
        emit(CurrencyErrorState(e.toString()));
      }
      */
    });

    on<AmountChangeEvent>((event, emit) async {
      final state = this.state as CurrencyLoadedState;
      /*
      emit(CurrencyLoadedState(
          amount: event.amount,
          from: state.from,
          to: state.to,
          date: '')));
           */
    });

    on<FromChangeEvent>((event, emit) async {
      final state = this.state as CurrencyLoadedState;

      emit(CurrencyLoadedState(
          amount: state.amount, from: event.from, to: state.to, date: ''));
      print("Devise de départ");
      print(event.from);
    });

    on<ToChangeEvent>((event, emit) async {
      final state = this.state as CurrencyLoadedState;

      emit(CurrencyLoadedState(
          amount: state.amount, from: state.from, to: event.to, date: ''));
      print("Devise d\'arrivée");
      print(event.to);
    });

    on<CurrencySetEvent>((event, emit) async {
      final state = this.state as CurrencyLoadedState;
      try {
        final parite = await currency_repository.getCurrency(
            event.amount, state.from, state.to, "2022-01-20");
        emit(CurrencyLoadedState(
            amount: state.amount,
            from: state.from,
            to: state.to,
            result: parite,
            date: ''));
      } catch (e) {
        print(e);
        //emit(CurrencyErrorState(e.toString()));
      }
/*
      emit(CurrencyLoadedState(
          amount: state.amount,
          from: state.from,
          to: state.to,
          date: '')));
          */
    });

    on<AddBadge>((event, emit) async {
      final state = this.state as CurrencyLoadedState;

      FlutterAppBadger.updateBadgeCount(event.badgeCounter);
      FlutterAppBadger.isAppBadgeSupported();
      print("Badge ajouté${event.badgeCounter}");
    });

    on<RemoveBadge>((event, emit) async {
      FlutterAppBadger.removeBadge();
      print("Badge supprimé");
    });
  }
}
