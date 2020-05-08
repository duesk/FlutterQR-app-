
import 'package:flutter_map/flutter_map.dart';
import 'package:qr_reader_app/src/Providers/db_provider.dart';
import 'package:latlong/latlong.dart';

import 'package:flutter/material.dart';



class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  
  final map = new MapController();

  String  tipoMapa = "streets";

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
              map.move(scan.getLatLng(), 15 );
            },
          )
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  Widget _crearBotonFlotante(BuildContext context ){

    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: (){
        if (tipoMapa == "streets"){
          tipoMapa = "dark";
        }else if(tipoMapa == "dark"){
          tipoMapa = "light";
        }else if(tipoMapa == "light"){
          tipoMapa = "outdoors";
        }else if(tipoMapa == "outdoors"){
          tipoMapa = "satellite";
        }else{
          tipoMapa = "streets";
        }
        setState((){});
      },
    );

  }

  Widget _crearFlutterMap(ScanModel scan ){
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 10.0,

      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan)
      ],
    );
  }

  _crearMapa(){
    return TileLayerOptions(
        urlTemplate: "https://api.mapbox.com/v4/"
        "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
        additionalOptions: {
          "accessToken" : "pk.eyJ1IjoiZHVlc2siLCJhIjoiY2s4bnltaGo2MGJnNDNlbXlyYmg3N2c4cCJ9.QH2s3iVavCbGgBn5XpkLWw",
          "id"          : "mapbox.$tipoMapa"
          //"id"          : 'mapbox.dark'
          //"id"          : 'mapbox.light'
          //"id"          : 'mapbox.outdoors'
          //"id"          : 'mapbox.satellite'
          //"id"          : 'mapbox.streets'
        }
    );
  }

  _crearMarcadores(ScanModel scan ){

    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width   :  100.0,
          height  :  100.0,
          point   :  scan.getLatLng(), 
          builder :  (context) => Container(
            child: Icon(
              Icons.location_off, 
              size: 45.5,
              color: Theme.of(context).primaryColor,)
          )
        )
      ]
    );

  }
}