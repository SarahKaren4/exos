part of 'currency_bloc.dart';

abstract class CurrencyState extends Equatable {
  const CurrencyState();

  @override
  List<Object> get props => [];
}

class CurrencyInitial extends CurrencyState {}

class CurrencyLoadingState extends CurrencyState {}

class CurrencyLoadedState extends CurrencyState {
  late String amount;
  late String from;
  late String to;
  late String date;
  late String result;

  CurrencyLoadedState({
    this.amount = "",
    this.from = "",
    this.to = "",
    this.date = "",
    this.result = "",
  });
  @override
  List<Object> get props => [amount, from, to, date, result];
}

class CurrencyErrorState extends CurrencyState {
  String error;
  CurrencyErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class ConnectionSuccess extends CurrencyState {}

class ConnectionFailure extends CurrencyState {
  late String errorword;
  ConnectionFailure({this.errorword = ""});
  @override
  List<Object> get props => [errorword];
}
