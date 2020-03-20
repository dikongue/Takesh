import 'dart:async';
import 'dart:io' as io;

import 'package:etakesh_client/Models/clients.dart';
import 'package:etakesh_client/Models/commande.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "etakesh_client_v.db");
    var theDb = await openDatabase(path, version: 13, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    //after this
    // drop table if already exist
    await db.execute(" DROP TABLE IF EXISTS Client");
    await db.execute(" DROP TABLE IF EXISTS User");
    await db.execute(" DROP TABLE IF EXISTS CmdVal");
    await db.execute(" DROP TABLE IF EXISTS Home");
    await db.execute(" DROP TABLE IF EXISTS Office");
    //then

    // create table client where store the connected account informations
    await db.execute("CREATE TABLE Client("
        "id INTEGER PRIMARY KEY, "
        "client_id INTEGER NOT NULL UNIQUE, "
        "user_id INTEGER NOT NULL UNIQUE, "
        "nom TEXT, "
        "prenom TEXT, "
        "email TEXT NOT NULL, "
        "phone TEXT, "
        "date_naissance TEXT, "
        "pays TEXT, "
        "ville TEXT, "
        "date_creation TEXT, "
        "image TEXT, "
        "code TEXT, "
        "status TEXT, "
        "positionId INTEGER, "
        "adresse TEXT "
        ")");

    // create table user where store the connected credentials informations
    await db.execute("CREATE TABLE Office("
        "id INTEGER PRIMARY KEY, "
        "latitude REAL NOT NULL UNIQUE, "
        "longitude REAL NOT NULL UNIQUE, "
        "nom  TEXT, "
        "adresse TEXT, "
        "place_id TEXT "
        ")");

    // create table home where store the home adress of customer informations
    await db.execute("CREATE TABLE Home("
        "id INTEGER PRIMARY KEY, "
        "latitude REAL NOT NULL UNIQUE, "
        "longitude REAL NOT NULL UNIQUE, "
        "nom  TEXT, "
        "adresse TEXT, "
         "place_id TEXT "
        ")");

    // create table client where store the office adress of customer informations
    await db.execute("CREATE TABLE User("
        "id INTEGER PRIMARY KEY, "
        "userId INTEGER NOT NULL UNIQUE, "
        "token TEXT, "
        "date TEXT, "
        "ttl INTEGER "
        ")");

    // create table cmdvalide where store the validated orders
    await db.execute("CREATE TABLE CmdVal("
        "id INTEGER PRIMARY KEY, "
        "clientId INTEGER NOT NULL, "
        "prestataireId INTEGER NOT NULL, "
        "cmdId INTEGER NOT NULL UNIQUE, "
        "prestationId INTEGER NOT NULL, "
        "date_debut TEXT, "
        "date_fin TEXT, "
        "date TEXT, "
        "montant INTEGER, "
        "status TEXT, "
        "position_prise_en_charge TEXT, "
        "position_destination TEXT, "
        "distance_client_prestataire TEXT, "
        "duree_client_prestataire TEXT, "
        "date_acceptation TEXT, "
        "date_prise_en_charge TEXT, "
        "position_priseId TEXT, "
        "position_destId TEXT, "
        "rate_comment TEXT, "
        "rate_date TEXT, "
        "rate_value INTEGER, "
        "code TEXT, "
        "is_created TEXT, "
        "is_accepted TEXT, "
        "is_refused TEXT, "
        "is_terminated TEXT, "
        "is_started TEXT "
        ")");
  }

  Future<int> clearClient() async {
    var tbClient = await db;
    int res = await tbClient.rawDelete('DELETE FROM Client');
    return res;
  }

  Future<int> clearUser() async {
    var tbUser = await db;
    int res = await tbUser.rawDelete('DELETE FROM User');
    return res;
  }

  Future<int> clearCmdVal() async {
    var tbCmd = await db;
    int res = await tbCmd.rawDelete('DELETE FROM CmdVal');
    return res;
  }

  Future<int> clearHomeAdd() async {
    var tbCmd = await db;
    int res = await tbCmd.rawDelete('DELETE FROM Home');
    return res;
  }

  Future<int> clearOfficeAdd() async {
    var tbCmd = await db;
    int res = await tbCmd.rawDelete('DELETE FROM Office');
    return res;
  }

  Future<int> saveUser(Login2 l) async {
    var tbUser = await db;
    String sql = 'INSERT INTO User(userId, token, date, ttl) VALUES(' +
        l.userId.toString() +
        ',\'' +
        l.token +
        '\',\'' +
        l.date +
        '\',\'' +
        l.ttl.toString() +
        '\')';
    await tbUser.rawInsert(sql);
    print("saved user infos " + sql.toString());
    return 0;
  }

  Future<int> saveHome(LocalAdress l) async {
    var tbHome = await db;
    String sql = 'INSERT INTO Home(latitude, longitude, nom, adresse,place_id) VALUES(' +
        l.latitude.toString() +
        ',\'' +
        l.longitude.toString() +
        '\',\'' +
        l.nom +
        '\',\'' +
        l.adresse +
         '\',\'' +
        l.place_id +
        '\')';
    await tbHome.rawInsert(sql);
    print("saved user infos " + sql.toString());
    return 0;
  }

  Future<int> saveOffice(LocalAdress l) async {
    var tbOffice = await db;
    String sql =
        'INSERT INTO Office(latitude, longitude, nom, adresse,place_id) VALUES(' +
            l.latitude.toString() +
            ',\'' +
            l.longitude.toString() +
            '\',\'' +
            l.nom +
            '\',\'' +
            l.adresse +
             '\',\'' +
            l.place_id +
            '\')';
    await tbOffice.rawInsert(sql);
    print("saved user infos " + sql.toString());
    return 0;
  }

  Future<int> saveClient(Client1 c) async {
    var tbClient = await db;
    String sql =
        'INSERT INTO Client(client_id, user_id, nom, prenom, email, phone, date_naissance, pays, ville, date_creation, image, code, status, positionId, adresse) VALUES(' +
            c.client_id.toString() +
            ',\'' +
            c.user_id.toString() +
            '\',\'' +
            c.nom +
            '\',\'' +
            c.prenom +
            '\',\'' +
            c.email +
            '\',\'' +
            c.phone +
            '\',\'' +
            c.date_naissance +
            '\',\'' +
            c.pays +
            '\',\'' +
            c.ville +
            '\',\'' +
            c.date_creation +
            '\',\'' +
            c.image +
            '\',\'' +
            c.code +
            '\',\'' +
            c.status +
            '\',\'' +
            c.positionId.toString() +
            '\',\'' +
            c.adresse +
            '\')';
    await tbClient.rawInsert(sql);
    print("saved client infos " + sql.toString());
    return 0;
  }

  Future<bool> updateClient(Client1 client) async {
    print("update client  = " + client.toMap().toString());
    var dbClient = await db;
    int res = await dbClient.update("Client", client.toMap(),
        where: "client_id = ?", whereArgs: <int>[client.client_id]);
    return res > 0;
  }

  Future<int> saveCmdVal(CommandeDetail cmd) async {
    var tbClient = await db;
    String sql =
        'INSERT INTO CmdVal(clientId, prestataireId, cmdId, prestationId, date_debut, date_fin, date, montant, status, '
            'position_prise_en_charge, position_destination, distance_client_prestataire, '
            'duree_client_prestataire, date_acceptation, date_prise_en_charge,'
            ' position_priseId, position_destId, rate_comment, rate_date, rate_value, code, is_created, is_accepted, is_refused, is_terminated, is_started) VALUES(' +
            cmd.clientId +
            ',\'' +
            cmd.prestation.prestataire.prestataireid.toString() +
            '\',\'' +
            cmd.commandeid.toString() +
            '\',\'' +
            cmd.prestationId.toString() +
            '\',\'' +
            cmd.date_debut.toString() +
            '\',\'' +
            cmd.date_fin.toString() +
            '\',\'' +
            cmd.date.toString() +
            '\',\'' +
            cmd.montant.toString() +
            '\',\'' +
            cmd.status.toString() +
            '\',\'' +
            cmd.position_prise_en_charge.toString() +
            '\',\'' +
            cmd.position_destination.toString() +
            '\',\'' +
            cmd.distance_client_prestataire.toString() +
            '\',\'' +
            cmd.duree_client_prestataire.toString() +
            '\',\'' +
            cmd.date_acceptation.toString() +
            '\',\'' +
            cmd.date_prise_en_charge.toString() +
            '\',\'' +
            cmd.position_priseId.toString() +
            '\',\'' +
            cmd.position_destId.toString() +
            '\',\'' +
            cmd.rate_comment.toString() +
            '\',\'' +
            cmd.rate_date.toString() +
            '\',\'' +
            cmd.rate_value.toString() +
            '\',\'' +
            cmd.code.toString() +
            '\',\'' +
            cmd.is_created.toString() +
            '\',\'' +
            cmd.is_accepted.toString() +
            '\',\'' +
            cmd.is_refused.toString() +
            '\',\'' +
            cmd.is_terminated.toString() +
            '\',\'' +
            cmd.is_started.toString() +
            '\')';
    await tbClient.rawInsert(sql);
    print("saved cmd valide " + sql.toString());
    return 0;
  }

  Future<Client1> getClient() async {
    var tbClient = await db;
    List<Map> list = await tbClient
        .rawQuery('SELECT * FROM Client ORDER BY id DESC LIMIT 1');
    print("Content DBClient");
    print(list);
    Client1 client;
    if (list.length != 0) {
      client = new Client1.fromJson2(list[0]);
      return client;
    } else {
      return null;
    }
  }
Future<List<Client1>> getAllClient() async {
    var tbClient = await db;
    List<Map> list = await tbClient
        .rawQuery('SELECT * FROM Client ORDER BY id DESC LIMIT 1');
    print("Content DBClient");
    print(list);
  
    if (list.length != 0) {
      print("Cmd val loc db:" + list.toString());
      List<Client1> client = new List();
      for (int i = 0; i < list.length; i++) {
        var cmd = new Client1.fromJson(list[0]);
        client.add(cmd);
      }
      return client;
    } else {
      return null as List<Client1>;
    }
  }

  Future<LocalAdress> getHomeAdresse() async {
    var tbHome = await db;
    List<Map> list =
        await tbHome.rawQuery('SELECT * FROM Home ORDER BY id DESC LIMIT 1');
    print("Content DBHome");
    print(list);
    LocalAdress home;
    if (list.length != 0) {
      home = new LocalAdress.fromJson(list[0]);
      return home;
    } else {
      return null;
    }
  }

  Future<LocalAdress> getOfficeAdresse() async {
    var tbOffice = await db;
    List<Map> list = await tbOffice
        .rawQuery('SELECT * FROM Office ORDER BY id DESC LIMIT 1');
    print("Content DBOffice");
    print(list);
    LocalAdress office;
    if (list.length != 0) {
      office = new LocalAdress.fromJson(list[0]);
      return office;
    } else {
      return null;
    }
  }

  Future<Login2> getUser() async {
    var tbUser = await db;
    List<Map> list =
        await tbUser.rawQuery('SELECT * FROM User ORDER BY id DESC LIMIT 1');
    Login2 user;
    print("Content DBUser");
    print(list);
    if (list.length != 0) {
      user = new Login2.fromJson2(list[0]);
      return user;
    } else {
      return null;
    }
  }



  Future<List<CommandeLocal>> getCmdVal() async {
    var tbCmd = await db;
    List<Map> list =
        await tbCmd.rawQuery('SELECT * FROM CmdVal ORDER BY id DESC LIMIT 1');

    print("Content DBCmdValide");
    print(list);
    if (list.length != 0) {
      print("Cmd val loc db:" + list.toString());
      List<CommandeLocal> cmds = new List();
      for (int i = 0; i < list.length; i++) {
        var cmd = new CommandeLocal.fromJson(list[0]);
        cmds.add(cmd);
      }
      return cmds;
    } else {
      return null as List<CommandeLocal>;
    }
  }
  /// commande qui a ete créer et qui n'a pas encore commencer .........
  Future<List<CommandeLocal>> getCmdIsStartedVal() async {
    var tbCmd = await db;
    List<Map> list =
    await tbCmd.rawQuery('SELECT * FROM CmdVal where is_started=false');

    print("Content DBCmdValide et une commande en cour......");
    print(list);
    if (list.length != 0) {
      print("Cmd val loc db:" + list.toString());
      List<CommandeLocal> cmds = new List();
      for (int i = 0; i < list.length; i++) {
        var cmd = new CommandeLocal.fromJson(list[0]);
        cmds.add(cmd);
      }
      return cmds;
    } else {
      return null as List<CommandeLocal>;
    }
  }
//
//  Future<List<CommandeLocal>> getCmdRef() async {
//    var tbCmd = await db;
//    List<Map> list =
//        await tbCmd.rawQuery('SELECT * FROM CmdRef ORDER BY id DESC LIMIT 1');
//
//    print("Content DBCmdRef");
//    print(list);
//    if (list.length != 0) {
//      print("Cmd ref loc db:" + list.toString());
//      List<CommandeLocal> cmds = new List();
//      for (int i = 0; i < list.length; i++) {
//        var cmd = new CommandeLocal.fromJson(list[0]);
//        cmds.add(cmd);
//      }
//      return cmds;
//    } else {
//      return null as List<CommandeLocal>;
//    }
//  }
}
