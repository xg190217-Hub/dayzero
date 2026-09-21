import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

/// Opens the app database on every platform:
///  - iOS/Android: sqflite (native).
///  - Web: sqflite_common_ffi_web in main-thread mode (no worker / COOP-COEP
///    headers required — verified recipe from the previous project).
///  - Windows desktop (tests & screenshots): ffi backed by winsqlite3.
///
/// Tests pass [factory] explicitly (e.g. databaseFactoryFfi with an in-memory
/// path) instead of relying on debug platform overrides.
Future<sqflite.Database> openAppDatabase(String path,
    {sqflite.DatabaseFactory? factory}) async {
  sqflite.DatabaseFactory f;
  if (factory != null) {
    f = factory;
  } else if (kIsWeb) {
    f = databaseFactoryFfiWebNoWebWorker;
  } else if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux) {
    sqfliteFfiInit();
    f = databaseFactoryFfi;
  } else {
    f = sqflite.databaseFactory;
  }
  return f.openDatabase(
    path,
    options: sqflite.OpenDatabaseOptions(
      version: 2,
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE lapses (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              habit_id INTEGER NOT NULL,
              date TEXT NOT NULL,
              trigger TEXT,
              note TEXT
            )
          ''');
        }
      },
    ),
  );
}

Future<void> _createTables(sqflite.DatabaseExecutor db) async {
        await db.execute('''
          CREATE TABLE habits (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT NOT NULL,
            name TEXT NOT NULL,
            quit_date INTEGER NOT NULL,
            daily_spend REAL NOT NULL DEFAULT 0,
            daily_amount REAL NOT NULL DEFAULT 0,
            created_at INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE check_ins (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            habit_id INTEGER NOT NULL,
            date TEXT NOT NULL,
            mood INTEGER NOT NULL,
            craving INTEGER NOT NULL,
            trigger TEXT,
            note TEXT,
            UNIQUE (habit_id, date)
          )
        ''');
        await db.execute('''
          CREATE TABLE achievements (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            habit_id INTEGER NOT NULL,
            key TEXT NOT NULL,
            achieved_at INTEGER NOT NULL,
            UNIQUE (habit_id, key)
          )
        ''');
        await db.execute('''
          CREATE TABLE lapses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            habit_id INTEGER NOT NULL,
            date TEXT NOT NULL,
            trigger TEXT,
            note TEXT
          )
        ''');
}

/// Default DB filename inside the app documents directory.
String defaultDbPath(String documentsDir) => p.join(documentsDir, 'dayzero.db');
