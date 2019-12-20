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

  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();

  double dollar;
  double euro;

  void _realChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dollarController.text = (real/dollar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dollarChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dollar).toStringAsFixed(2);
    euroController.text = (dolar * this.dollar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dollarController.text = (euro * this.euro / dollar).toStringAsFixed(2);
  }

  void _clearAll(){
    realController.text = "";
    dollarController.text = "";
    euroController.text = "";
  }
  

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
                          buildTextField("Reais", "R\$ ", realController, _realChanged),
                          Divider(),
                          //---------------------TextField para o Dollar----------------------------------------
                          buildTextField("Dólares", "US\$ ", dollarController, _dollarChanged),
                          Divider(),
                          //---------------------TextField para o Euro----------------------------------------
                          buildTextField("Euros", "€ ", euroController, _euroChanged),
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
//Função para criar o Widget de TextField e minimizar o código
Widget buildTextField(String label, String prefix, TextEditingController cont, Function f) {
  return TextField(
    onChanged: f,
    controller: cont,
    decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        prefixText: prefix,
        prefixStyle: TextStyle(color: Colors.white, fontSize: 20.0)),
    style: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
    ),
    //Funcao para entrar só com numeros
    keyboardType: TextInputType.number,
  );
}
