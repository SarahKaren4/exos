// @dart=2.9
import 'package:exos/bloc/currency_bloc.dart';
import 'package:exos/currency_repository.dart';
import 'package:exos/notif_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:money_formatter/money_formatter.dart';



void main() async {
  print("Last results: ${DataConnectionChecker().lastTryResults}");
  print(" ${await DataConnectionChecker().hasConnection}");
  print("Current status: ${await DataConnectionChecker().connectionStatus}");
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => CurrencyRepository(),
      child: BlocProvider(
        create: (context) =>
            CurrencyBloc(CurrencyRepository())..add(ListenConnection()),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.pink,
          ),
          home: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> devises = ["EUR", "USD", "CAD", "CHF", "JPY", "XOF"];

  TextEditingController amountcontroller = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey;

  MoneyFormatter money_format(String amount, String to) {
    return MoneyFormatter(
        amount: amount.isEmpty ? 0 : double.parse(amount),
        settings: MoneyFormatterSettings(
            symbol: to,
            thousandSeparator: '.',
            decimalSeparator: ',',
            symbolAndNumberSeparator: ' ',
            fractionDigits: 2,
            compactFormatType: CompactFormatType.long));
  }
  void init() {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');



    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Convertisseur de devises"),
        ),
        body:
            // ignore: missing_return
            BlocBuilder<CurrencyBloc, CurrencyState>(builder: (context, state) {
          print(state);
          return RefreshIndicator(
              child: state is CurrencyLoadedState
                  ? ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: amountcontroller,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Somme',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: DropdownButton(
                            value: state.from,
                            onChanged: (value) {
                              context
                                  .read<CurrencyBloc>()
                                  .add(FromChangeEvent(value));
                            },
                            items: devises.map(
                              (item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: DropdownButton(
                            value: state.to,
                            onChanged: (value) {
                              context
                                  .read<CurrencyBloc>()
                                  .add(ToChangeEvent(value));
                            },
                            items: devises.map(
                              (item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 70.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (await DataConnectionChecker().hasConnection) {
                                state.amount = amountcontroller.text;
                                context.read<CurrencyBloc>().add(
                                    CurrencySetEvent(amount: state.amount));
                              } else {
                                print("Hors ligne");
                                context
                                    .read<CurrencyBloc>()
                                    .add(ListenConnection());

                                AlertDialog(
                                  title: Text("Connexion checker"),
                                  content:
                                      Center(child: Text("Connectez-vous")),
                                  actions: [
                                    Row(
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("OK"))
                                      ],
                                    )
                                  ],
                                );
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: TextEditingController(
                                text: money_format(state.result, state.to)
                                    .output
                                    .symbolOnRight
                                    .toString()),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Conversion',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            enabled: false,
                            controller: TextEditingController(
                                text: money_format(state.result, state.to)
                                    .output
                                    .symbolOnLeft
                                    .toString()),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Conversion',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            enabled: false,
                            controller: TextEditingController(
                                text: money_format(state.result, state.to)
                                    .output
                                    .compactSymbolOnLeft
                                    .toString()),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Conversion',
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                //_showNotificationWithSound;
                                context.read<CurrencyBloc>().add(AddBadge(badgeCounter: 5));
                              },
                              child: const Text('Ajouter'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                context.read<CurrencyBloc>().add(RemoveBadge());
                              },
                              child: const Text('Supprimer'),
                            ),
                          ],
                        )
                      ],
                    )
                  : Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height / 3),
                    child: Center(
                        child: Column(
                      children: [
                        Icon(
                          Icons.offline_pin_rounded,
                          color: Colors.red,
                          size: 100,
                        ),
                        Text("Vous etes hors ligne"),
                      ],
                    )),
                  ),
              onRefresh: () {
                return Future.delayed(
                  Duration(seconds: 1),
                  () {
                    context.read<CurrencyBloc>().add(ListenConnection());
                    print("aaaa");
                  },
                );
              });
        }));
  }
}
/*

                                    */


                                    /*
                                    
          */
