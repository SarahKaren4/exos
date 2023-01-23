// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

String CurrencyToJson(Currency data) => json.encode(data.toJson());
Currency CurrencyFromJson(String str) => Currency.fromJson(json.decode(str));

class Currency {
  late String amount;
  late String from;
  late String to;
  late String date;
  late double result;
  Currency(
      { this.amount = "",
       this.from = "",
       this.to = "",
       this.date = ""});

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
      amount: json['amount'],
      from: json['from'],
      to: json['to'],
      date: json['date']);

  Map<String, dynamic> toJson() =>
      {'amount': amount, 'from': from, 'to': to, 'date': date};
}
