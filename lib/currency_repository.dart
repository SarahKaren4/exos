import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:exos/model/currency.dart';
import 'package:http/http.dart' as http;

class CurrencyRepository {
  Future<String> getCurrency(
      String amount, String from, String to, String date) async {
    var headers = {"apikey": "g3YyO0x9f0g4pAWCYhzshYyEoCItuw3d"};

    final String url =
        "https://api.apilayer.com/exchangerates_data/convert?to=$to&from=$from&amount=$amount";
    print(url);
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var result = (jsonResponse['result']).toString();
      print("Conversion" + (jsonResponse['result']).toString());
      //print(response.body);
      return result;
    } else {
      print(response.statusCode);
      print("cannot call api");
      throw Exception("Failed to load joke");
    }
  }

/*
  Future<Currency> fetchMovies(double amount, String from, String to, String date) async {
    Map<String, String> requestHeaders = {
       'Content-type': 'application/json',
       'Accept': 'application/json',
       'Authorization': 'g3YyO0x9f0g4pAWCYhzshYyEoCItuw3d'
     };
    final url = Uri(
      scheme: 'https',
      host: 'api.apilayer.com',
      path: '/exchangerates_data/convert?$to=USD&from=$from&amount=$amount',
     
    ).toString();
    final response = await Dio().get(
      
      url,
      options: Options(
        headers: {
          Headers.wwwAuthenticateHeader :'g3YyO0x9f0g4pAWCYhzshYyEoCItuw3d'
        }
      )
      
    
    );
    return Currency.fromJson(response.data);
  }
  */
}
