// services/database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  /// Getter pour accéder à la base de données SQLite
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialise la base de données avec création ou migration
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'certificat.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        // Gère les conflits liés à d'anciennes tables en cas de mise à jour
        await db.execute('DROP TABLE IF EXISTS users');
        await _onCreate(db, newVersion);
      },
    );
  }

  /// Création des tables lors de la première initialisation
  Future<void> _onCreate(Database db, int version) async {
    // 🔐 Table des utilisateurs (remplace 'users')
    await db.execute('''
      CREATE TABLE utilisateurs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role TEXT NOT NULL,         -- 'admin', 'agent', 'citoyen'
        is_active INTEGER DEFAULT 0
      )
    ''');

    // ✅ Insertion de l'administrateur par défaut
    await db.insert('utilisateurs', {
      'username': 'admin',
      'email': 'admin@gmail.com',
      'password': 'admin123',
      'role': 'admin',
      'is_active': 1,
    });

    // ⚠️ Ancienne table utilisateurs (à supprimer si inutile)
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL
      )
    ''');

    // 📍 Table des quartiers
    await db.execute('''
      CREATE TABLE quartiers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // 🏠 Table des maisons
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

    // 👤 Table des personnes (citoyens, propriétaires...)
    await db.execute('''
      CREATE TABLE personnes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        prenom TEXT NOT NULL,
        telephone TEXT NOT NULL,
        date_naissance TEXT NOT NULL,
        lieu_naissance TEXT NOT NULL,
        role TEXT NOT NULL,
        maison_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY(maison_id) REFERENCES maisons(id)
      )
    ''');

    // 📄 Table des certificats de domicile
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