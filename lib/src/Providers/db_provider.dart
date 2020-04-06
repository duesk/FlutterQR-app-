
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:qr_reader_app/src/Models/scan_model.dart';
export 'package:qr_reader_app/src/Models/scan_model.dart';


class DBProvider{

  static Database _database;
  static final DBProvider db = DBProvider.private();

  DBProvider.private();

  Future<Database> get database async{

    if (_database != null) return _database;

    _database = await initDB();
    return _database;

  }

  initDB() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join( documentsDirectory.path, "ScansDB.db");

    return await openDatabase(
      path,
      version : 1,
      onOpen: (db){},
      onCreate: (Database db, int version )async{
        await db.execute(
          "CREATE TABLE Scans ("
          "id INTEGER PRIMARY KEY,"
          "tipo TEXT,"
          "valor TEXT"
          ")"
        );

      }
      );
  }

  //Crear Registros
  nuevoScanRaw(ScanModel nuevoScan)async{

    final db = await database;

    final result = await db.rawInsert(
      "INSERT Into Scans (id, tipo, valor) "
      "VALUES ( ${ nuevoScan.id }, '${ nuevoScan.tipo }', '${ nuevoScan.valor }' )"
    );
    return result;
  }

  nuevoScan( ScanModel nuevoScan )async{
    final db = await database;
    final result = await db.insert("Scans", nuevoScan.toJson());
    return result;
  }

  //SELECT - obtener informacion 
  Future<ScanModel> getScanId(int id)async{

    final db     = await database;
    final result = await db.query("Scans ",where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? ScanModel.fromJson(result.first) : null; 

  }

  Future<List<ScanModel>> getTodosLosScans()async{

    final db      = await database;
    final result  = await db.query("Scans");

    List<ScanModel> list = result.isNotEmpty 
                              ? result.map((c)=> ScanModel.fromJson(c)).toList()
                              :[];
    return list;
  }  
  
  Future<List<ScanModel>> getScansPorTipo(String tipo )async{

    final db      = await database;
    final result  = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$tipo'");


    List<ScanModel> list = result.isNotEmpty 
                              ? result.map((c)=> ScanModel.fromJson(c)).toList()
                              :[];
    return list;
  }


  //Actualizar registros
Future<int> updatescan( ScanModel nuevoScan)async {
final db     = await database;
final result = await db.update("Scans ",  nuevoScan.toJson(), where: "id = ?",whereArgs: [nuevoScan.id]);

return result;

  }

  /// Eliminar registros.
  Future<int>deleteScan(int id)async{
    final db     = await database;
    final result = await db.delete("scans ",where: "id = ?", whereArgs: [id] );
    return result; 
  } 

  Future<int> deleteAll()async{
    final db     = await database;
    final result = await db.rawDelete("DELETE FROM Scans");
    return result;
  }



  
  }