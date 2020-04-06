import 'dart:io';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qr_reader_app/src/Bloc/Scans_bloc.dart';
import 'package:qr_reader_app/src/Models/scan_model.dart';


import 'package:qr_reader_app/src/pages/direcciones_page.dart';
import 'package:qr_reader_app/src/pages/mapas_page.dart';
import 'package:qr_reader_app/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc(); 

  int currentIndex = 0 ;

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Text('QR Scaner'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.borrarScansTODOS,
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar:  _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: ()=> _scanQR(context),
            backgroundColor: Theme.of(context).primaryColor
      ),
    );
  }



  _scanQR(BuildContext context )async{

  //https://www.colibri3d.com/
  //geo:20.615411570508865,-103.41829433878787


  
    String futureString = "https://www.colibri3d.com/";
    String futureString2 = "geo:20.615411570508865,-103.41829433878787";
/*
    try{
      futureString = await BarcodeScanner.scan();
    }catch(e){
      futureString = e.toString();

    }
      print("el codigo es: $futureString");
*/  
    if(futureString != null){
      final scan = ScanModel(valor: futureString);
      scansBloc.agregarScan(scan);

      final scan2 = ScanModel(valor: futureString2);
      scansBloc.agregarScan(scan2);
      
      if (Platform.isIOS){
        Future.delayed(Duration(milliseconds:750 ),(){
        utils.abrirScan(scan,context);
        });
      }else{
        utils.abrirScan(scan,context);
      }
    } 
    
  }



  Widget _callPage( int paginaActual){
    switch(paginaActual){
      
      case 0: return MapasPage();

      case 1: return DireccionPage();

      default:
        return MapasPage();

    }
  }



  Widget _crearBottomNavigationBar(){
    return BottomNavigationBar(
      currentIndex: currentIndex ,
      onTap: (index){
        setState(() {
          currentIndex = index; 
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text("Mapas")
        ) , 
        BottomNavigationBarItem(
          icon: Icon(Icons.pin_drop  ),
          title: Text("Direcciones")
        ),
      ]
    );
  }  
}