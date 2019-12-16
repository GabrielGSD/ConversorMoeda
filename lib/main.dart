import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=8c59476c";

void main() async {
  runApp(MaterialApp(
    home: Home(),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dollar;
  double euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightGreen,
        appBar: AppBar(
          title: Text(
            "\$ Conversor \$",
            style: TextStyle(fontSize: 30.0),
          ),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Text(
                      "Carregando Dados",
                      style: TextStyle(color: Colors.white, fontSize: 35.0),
                      textAlign: TextAlign.center,
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Erro ao Carregar Dados",
                        style: TextStyle(color: Colors.white, fontSize: 35.0),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    dollar =
                        snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(
                            Icons.monetization_on,
                            size: 150.0,
                            color: Colors.amber,
                          ),
                          TextField(
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                labelText: "Reais",
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                                prefixText: "R\$ ",
                                prefixStyle: TextStyle(
                                    color: Colors.white, fontSize: 20.0)),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          Divider(),
                          //---------------------TextField para o Dollar----------------------------------------
                          TextField(
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                labelText: "Dóllares",
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                                prefixText: "US\$ ",
                                prefixStyle: TextStyle(
                                    color: Colors.white, fontSize: 20.0)),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          Divider(),
                          //---------------------TextField para o Euro----------------------------------------
                          TextField(
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                labelText: "Euros",
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                                prefixText: "€ ",
                                prefixStyle: TextStyle(
                                    color: Colors.white, fontSize: 20.0)),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
              }
            },
          ),
        ));
  }
}
