// services/database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'certificat.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {

    //gestion de mes utilisateurs
    await db.execute('''
      CREATE TABLE utilisateurs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role TEXT NOT NULL,         -- 'admin', 'agent', 'citoyen'
        is_active INTEGER DEFAULT 0
      )
    ''');

    // ✅ Insérer l'admin par défaut
    // await db.insert('utilisateurs', {
    //   'username': 'admin',
    //   'password': 'admin123',
    //   'role': 'admin',
    //   'is_active': 1,
    // });


    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL
      )
    ''');


    await db.execute('''
      CREATE TABLE quartiers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )

    ''');

    await db.execute('''
      CREATE TABLE maisons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        adresse TEXT NOT NULL,
        quartier_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY(quartier_id) REFERENCES quartiers(id)
      )

    ''');
    
    // CREATE TABLE personnes
    await db.execute('''
      CREATE TABLE personnes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        telephone TEXT NOT NULL,
        email TEXT NOT NULL,
        role TEXT NOT NULL,
        maison_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY(maison_id) REFERENCES maisons(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE certificats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        personne_id INTEGER NOT NULL,
        numero TEXT NOT NULL,
        date_emission TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY(personne_id) REFERENCES personnes(id)
      )
    ''');
  }
}