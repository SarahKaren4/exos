// ignore_for_file: must_be_immutable

part of 'currency_bloc.dart';

abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();

  @override
  List<Object> get props => [];
}

class CurrencyLoadedEvent extends CurrencyEvent {
     late String amount;
  late String from;
  late String to;
  late String date;
  late var result;

  CurrencyLoadedEvent( { this.amount = "",
       this.from = "",
       this.to = "",
       this.date = "", this.result= 0.0 });
  @override
  List<Object> get props => [amount, from, to, date, result];
}

class AmountChangeEvent extends CurrencyEvent {
  double amount;
  AmountChangeEvent(this.amount);
  @override
  List<Object> get props => [amount];
}

class FromChangeEvent extends CurrencyEvent {
  String from;
  FromChangeEvent(this.from);
  @override
  List<Object> get props => [from];
}

class ToChangeEvent extends CurrencyEvent {
  String to;
  ToChangeEvent(this.to);
  @override
  List<Object> get props => [to];
}

class CurrencySetEvent extends CurrencyEvent {
  String amount;
  CurrencySetEvent({this.amount = ""});
  @override
  List<Object> get props => [amount];
}

class AddBadge extends CurrencyEvent {
   int badgeCounter;
  AddBadge({this.badgeCounter = 1});
  @override
  List<Object> get props => [badgeCounter];

}

class RemoveBadge extends CurrencyEvent {

}
class ListenConnection extends CurrencyEvent {}

class ConnectionChanged extends CurrencyEvent {
  CurrencyState connection;
  ConnectionChanged(this.connection);
}

