import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/face.dart';
import '../models/memory_event.dart';
import '../models/person.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'mem_friend.db');

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        // Ensure foreign key constraints are enforced on every open
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create Person table
    await db.execute('''
      CREATE TABLE person (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT,
        address TEXT,
        relation TEXT,
        note TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    // Create Face table
    await db.execute('''
      CREATE TABLE face (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        person_id INTEGER NOT NULL,
        path TEXT NOT NULL,
        vector BLOB NOT NULL,
        updated_time TEXT NOT NULL,
        FOREIGN KEY (person_id) REFERENCES person (id) ON DELETE CASCADE
      )
    ''');

    // Create Memory Event table
    await db.execute('''
      CREATE TABLE memory_event (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        person_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        content TEXT,
        image_path TEXT NOT NULL,
        updated_time TEXT NOT NULL,
        FOREIGN KEY (person_id) REFERENCES person (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_face_person_id ON face(person_id)');
    await db.execute(
      'CREATE INDEX idx_memory_event_person_id ON memory_event(person_id)',
    );
  }

  // Person CRUD operations
  Future<int> insertPerson(Person person) async {
    final db = await database;
    final now = DateTime.now();
    final personWithTimestamp = person.copyWith(createdAt: now, updatedAt: now);
    return await db.insert('person', personWithTimestamp.toMap());
  }

  Future<List<Person>> getAllPersons() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'person',
      orderBy: 'updated_at DESC',
    );
    return List.generate(maps.length, (i) => Person.fromMap(maps[i]));
  }

  Future<Person?> getPersonById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'person',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Person.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Person>> searchPersons(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'person',
      where: 'name LIKE ? OR phone LIKE ? OR relation LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'updated_at DESC',
    );
    return List.generate(maps.length, (i) => Person.fromMap(maps[i]));
  }

  Future<int> updatePerson(Person person) async {
    final db = await database;
    final personWithTimestamp = person.copyWith(updatedAt: DateTime.now());
    return await db.update(
      'person',
      personWithTimestamp.toMap(),
      where: 'id = ?',
      whereArgs: [person.id],
    );
  }

  Future<int> deletePerson(int id) async {
    final db = await database;
    return await db.delete('person', where: 'id = ?', whereArgs: [id]);
  }

  // Face CRUD operations
  Future<int> insertFace(Face face) async {
    final db = await database;
    return await db.insert('face', face.toMap());
  }

  Future<List<Face>> getFacesByPersonId(int personId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'face',
      where: 'person_id = ?',
      whereArgs: [personId],
      orderBy: 'updated_time DESC',
    );
    return List.generate(maps.length, (i) => Face.fromMap(maps[i]));
  }

  Future<Face?> getLatestFaceByPersonId(int personId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'face',
      where: 'person_id = ?',
      whereArgs: [personId],
      orderBy: 'updated_time DESC',
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Face.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Face>> getAllFaces() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('face');
    return List.generate(maps.length, (i) => Face.fromMap(maps[i]));
  }

  Future<int> deleteFace(int id) async {
    final db = await database;
    return await db.delete('face', where: 'id = ?', whereArgs: [id]);
  }

  // Memory Event CRUD operations
  Future<int> insertMemoryEvent(MemoryEvent memoryEvent) async {
    final db = await database;
    return await db.insert('memory_event', memoryEvent.toMap());
  }

  Future<List<MemoryEvent>> getMemoryEventsByPersonId(int personId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'memory_event',
      where: 'person_id = ?',
      whereArgs: [personId],
      orderBy: 'updated_time DESC',
    );
    return List.generate(maps.length, (i) => MemoryEvent.fromMap(maps[i]));
  }

  Future<List<MemoryEvent>> getAllMemoryEvents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'memory_event',
      orderBy: 'updated_time DESC',
    );
    return List.generate(maps.length, (i) => MemoryEvent.fromMap(maps[i]));
  }

  Future<List<MemoryEvent>> searchMemoryEvents(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'memory_event',
      where: 'name LIKE ? OR content LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'updated_time DESC',
    );
    return List.generate(maps.length, (i) => MemoryEvent.fromMap(maps[i]));
  }

  Future<int> updateMemoryEvent(MemoryEvent memoryEvent) async {
    final db = await database;
    final eventWithTimestamp = memoryEvent.copyWith(
      updatedTime: DateTime.now(),
    );
    return await db.update(
      'memory_event',
      eventWithTimestamp.toMap(),
      where: 'id = ?',
      whereArgs: [memoryEvent.id],
    );
  }

  Future<int> deleteMemoryEvent(int id) async {
    final db = await database;
    return await db.delete('memory_event', where: 'id = ?', whereArgs: [id]);
  }

  // Utility method to close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
