import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart.';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

nowDateTime() {
  var now = new DateTime.now();
  return (now.day.toString() +
      "." +
      now.month.toString() +
      "." +
      now.year.toString());
}

Future<Post> fetchPost() async {
  final response = await http.get(
      'https://api.privatbank.ua/p24api/exchange_rates?json&date=' +
          nowDateTime());

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Post {
  String date;
  List<ExchangeRate> exchanges;

  Post({this.date, this.exchanges});

  factory Post.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['exchangeRate'] as List;
    List<ExchangeRate> exchangeList =
        list.map((i) => ExchangeRate.fromJson(i)).toList();

    return Post(
      date: parsedJson['date'] as String,
      exchanges: exchangeList,
    );
  }
}

class ExchangeRate {
  String currency;
  double saleRateNB;

  ExchangeRate({
    this.currency,
    this.saleRateNB,
  });

  factory ExchangeRate.fromJson(Map<String, dynamic> parsedJson) {
    return ExchangeRate(
        currency: parsedJson['currency'] as String,
        saleRateNB: parsedJson['saleRateNB'] as double,
    );
  }
}

void main() => runApp(MyApp(post: fetchPost()));

class MyApp extends StatelessWidget {
  final Future<Post> post;

  MyApp({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Виберіть валюту',
      theme: ThemeData(
        primaryColor: Colors.amber[700],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Курс гривні на ' + nowDateTime()),
        ),
        body: Center(

            child: Container(
              color: Colors.grey[900],
              child: FutureBuilder<Post>(
                future: post,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List myDataCurrency = new List();
                    List myDataSale = new List();
                    for (var i = 1; i < snapshot.data.exchanges.length; i++) {
                      myDataCurrency.add(snapshot.data.exchanges[i].currency);
                      myDataSale
                          .add(
                          snapshot.data.exchanges[i].saleRateNB.toString());
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.all(1.0),
                      itemCount: myDataCurrency.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                                child: ListTile(
                                    leading: Image.asset(
                                      'assets/images/' +
                                          myDataCurrency[index].toString() +
                                          '.png',
                                      width: 75,
                                      height: 75,
                                    ),
                                    title: Text(
                                        currencyName(myDataCurrency[index]),
                                        style: TextStyle(
                                            color: Colors.white)),
                                    subtitle: Text(myDataSale[index].toString(),
                                        style: TextStyle(
                                            color: Colors.white)),
                                    trailing: Container(
                                      width: 60,
                                      height: 40,
                                      child: Container(
                                          decoration: new BoxDecoration(
                                              color: Colors.amber[800],
                                              borderRadius:
                                              new BorderRadius.circular(50)),
                                          child: Center(
                                              child: Text(
                                                  myDataCurrency[index]
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  )))),
                                    )));
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  // By default, show a loading spinner
                  return CircularProgressIndicator();
                },
              ),
            )
        ),
      ),
    );
  }
}

currencyName(String name) {
  switch (name) {
    case "CAD":
      {
        return ("Канадський долар");
      }
      break;

    case "CNY":
      {
        return("Юань Женьміньбі");
      }
      break;

    case "CZK":
      {
        return("Чеська крона");
      }
      break;

    case "DKK":
      {
        return("Данська крона");
      }
      break;

    case "HUF":
      {
        return("Угорський форинт");
      }
      break;

    case "ILS":
      {
        return("Ізраїльський новий шекель");
      }
      break;

    case "JPY":
      {
        return("Японска єна");
      }
      break;

    case "KZT":
      {
        return("Казахстанський теньге");
      }
      break;

    case "MDL":
      {
        return("Молдовський лей");
      }
      break;

    case "NOK":
      {
        return("Норвезька крона");
      }
      break;

    case "SGD":
      {
        return("Сінгапурський долар");
      }
      break;

    case "SEK":
      {
        return("Шведська крона");
      }
      break;

    case "CHF":
      {
        return("Швейцарський франк");
      }
      break;

    case "RUB":
      {
        return("Російський рубль");
      }
      break;

    case "GBP":
      {
        return("Фунт стерлінгів");
      }
      break;

    case "USD":
      {
        return("Долар США");
      }
      break;

    case "UZS":
      {
        return("Узбецький сом");
      }
      break;

    case "BYN":
      {
        return("Білоруський рубель");
      }
      break;

    case "TMT":
      {
        return("Туркменський манат");
      }
      break;

    case "AZN":
      {
        return("Азербайджанський манат");
      }
      break;

    case "TRY":
      {
        return("Турецька ліра");
      }
      break;

    case "EUR":
      {
        return("Євро");
      }
      break;

    case "UAH":
      {
        return("Гривня");
      }
      break;

    case "GEL":
      {
        return("Грузинський ларі");
      }
      break;

    case "PLZ":
      {
        return("Злотий");
      }
      break;

    default:
      {
        return("Invalid choice");
      }
      break;
  }
}