
import 'package:qr_reader_app/src/Providers/db_provider.dart';


import 'package:flutter/material.dart';



class MapaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold (
      appBar: AppBar(
        title: Text('Coordenadas'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){

            },
          )
        ],
      ),
      body: Center(
        child: Text("scan.id: ${scan.id} scan.tipo: ${scan.tipo} scan.valor: ${scan.valor}") 
      )
    );
  }
}