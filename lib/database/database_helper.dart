import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Initialize FFI for desktop platforms
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'dawinidz.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT UNIQUE NOT NULL,
        full_name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        phone TEXT,
        date_of_birth TEXT,
        gender TEXT,
        address TEXT,
        wilaya TEXT,
        commune TEXT,
        profile_image TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Doctors table
    await db.execute('''
      CREATE TABLE doctors (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT UNIQUE NOT NULL,
        full_name TEXT NOT NULL,
        specialty TEXT NOT NULL,
        email TEXT,
        phone TEXT NOT NULL,
        address TEXT NOT NULL,
        wilaya TEXT NOT NULL,
        commune TEXT NOT NULL,
        consultation_fee REAL,
        rating REAL DEFAULT 0.0,
        years_experience INTEGER,
        profile_image TEXT,
        is_available INTEGER DEFAULT 1,
        working_hours TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Appointments table
    await db.execute('''
      CREATE TABLE appointments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT UNIQUE NOT NULL,
        user_id TEXT NOT NULL,
        doctor_id TEXT NOT NULL,
        appointment_date TEXT NOT NULL,
        appointment_time TEXT NOT NULL,
        status TEXT DEFAULT 'scheduled',
        notes TEXT,
        reminder_sent INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (uuid),
        FOREIGN KEY (doctor_id) REFERENCES doctors (uuid)
      )
    ''');

    // Medical measurements table
    await db.execute('''
      CREATE TABLE medical_measurements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT UNIQUE NOT NULL,
        user_id TEXT NOT NULL,
        measurement_type TEXT NOT NULL,
        systolic_pressure INTEGER,
        diastolic_pressure INTEGER,
        blood_sugar_level REAL,
        measurement_date TEXT NOT NULL,
        measurement_time TEXT NOT NULL,
        notes TEXT,
        sent_to_doctor INTEGER DEFAULT 0,
        doctor_id TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (uuid),
        FOREIGN KEY (doctor_id) REFERENCES doctors (uuid)
      )
    ''');

    // Health reports table
    await db.execute('''
      CREATE TABLE health_reports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT UNIQUE NOT NULL,
        user_id TEXT NOT NULL,
        doctor_id TEXT NOT NULL,
        measurement_id TEXT,
        report_title TEXT NOT NULL,
        interpretation TEXT NOT NULL,
        medical_notes TEXT,
        nutrition_advice TEXT,
        activity_advice TEXT,
        treatment_modifications TEXT,
        next_checkup_date TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (uuid),
        FOREIGN KEY (doctor_id) REFERENCES doctors (uuid),
        FOREIGN KEY (measurement_id) REFERENCES medical_measurements (uuid)
      )
    ''');

    // Tasks table
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT UNIQUE NOT NULL,
        user_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT DEFAULT 'general',
        priority TEXT DEFAULT 'medium',
        status TEXT DEFAULT 'pending',
        due_date TEXT,
        reminder_date TEXT,
        is_medical_related INTEGER DEFAULT 0,
        related_appointment_id TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (uuid),
        FOREIGN KEY (related_appointment_id) REFERENCES appointments (uuid)
      )
    ''');

    // Chat conversations table
    await db.execute('''
      CREATE TABLE chat_conversations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT UNIQUE NOT NULL,
        user_id TEXT NOT NULL,
        title TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (uuid)
      )
    ''');

    // Chat messages table
    await db.execute('''
      CREATE TABLE chat_messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT UNIQUE NOT NULL,
        conversation_id TEXT NOT NULL,
        message_text TEXT NOT NULL,
        is_user_message INTEGER NOT NULL,
        timestamp TEXT NOT NULL,
        symptoms TEXT,
        preliminary_diagnosis TEXT,
        recommendations TEXT,
        FOREIGN KEY (conversation_id) REFERENCES chat_conversations (uuid)
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_users_email ON users (email)');
    await db.execute(
      'CREATE INDEX idx_doctors_specialty ON doctors (specialty)',
    );
    await db.execute('CREATE INDEX idx_doctors_wilaya ON doctors (wilaya)');
    await db.execute(
      'CREATE INDEX idx_appointments_user_id ON appointments (user_id)',
    );
    await db.execute(
      'CREATE INDEX idx_appointments_doctor_id ON appointments (doctor_id)',
    );
    await db.execute(
      'CREATE INDEX idx_appointments_date ON appointments (appointment_date)',
    );
    await db.execute(
      'CREATE INDEX idx_measurements_user_id ON medical_measurements (user_id)',
    );
    await db.execute(
      'CREATE INDEX idx_measurements_date ON medical_measurements (measurement_date)',
    );
    await db.execute('CREATE INDEX idx_tasks_user_id ON tasks (user_id)');
    await db.execute('CREATE INDEX idx_tasks_status ON tasks (status)');
    await db.execute(
      'CREATE INDEX idx_chat_messages_conversation_id ON chat_messages (conversation_id)',
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < newVersion) {
      // Add migration logic here when needed
    }
  }

  // Generic CRUD operations
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    final db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    return await db.update(table, data, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(
    String table, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
