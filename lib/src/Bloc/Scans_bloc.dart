


import 'dart:async';

import 'package:qr_reader_app/src/Providers/db_provider.dart';

class ScansBloc {

  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc (){
    return _singleton;
  }

  ScansBloc._internal(){
    obtenerScans();

  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>>get scanStream => _scansController.stream;


  dispose(){
    _scansController?.close();
  }

  obtenerScans()async{
    _scansController.sink.add( await DBProvider.db.getTodosLosScans() );
  }

  agregarScan(ScanModel scan)async{
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();
  }

  borrarScans(int id)async{
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  borrarScansTODOS() async {
    await DBProvider.db.deleteAll();
    obtenerScans();
  }
  
} 