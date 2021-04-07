import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'models/data.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        accentColor: Colors.red,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
            onPrimary: Colors.black,
          ),
        ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      title: 'Eventos Acelerometro',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Eventos Acelerometro'),
        ),
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Uri _url =
      Uri.parse('https://apiproductorcesar.azurewebsites.net/api/Data');
  String acelerometro = 'Esperando...';

  Future<String> _sendData(String evento) async {
    Data data = Data(
      eventDate: DateTime.now(),
      eventDescription: evento,
      nameDevice: "Xiaomi Mi 9 - Acelerometro",
    );
    var response = await http.post(
      _url,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
      body: dataToJson(data),
    );
    print("${response.statusCode}: ${response.body}");
    return response.body;
  }

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        acelerometro = event.toString();
      });
      _sendData(event.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(acelerometro),
      ),
    );
  }
}
