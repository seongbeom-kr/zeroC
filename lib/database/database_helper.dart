import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:zero_c/data/post_data.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'feeds.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE feeds(
        feed_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        challenge_id INTEGER,
        username TEXT,
        content TEXT,
        profile_image BLOB,
        feed_image BLOB,
        create_at DATETIME
      )
    ''');
    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    List<PostData> initialPosts = [
      PostData(userId: "test1", challengeId: "1", username: 'User1', content: '첫 번째 게시글', profileImage: null, feedImage: null, createAt: DateTime.now().toIso8601String()),
      PostData(userId: "test2", challengeId: "2", username: 'User2', content: '두 번째 게시글', profileImage: null, feedImage: null, createAt: DateTime.now().toIso8601String()),
      PostData(userId: "test3", challengeId: "3", username: 'User3', content: '세 번째 게시글', profileImage: null, feedImage: null, createAt: DateTime.now().toIso8601String()),
    ];

    for (var post in initialPosts) {
      await db.insert('feeds', post.toMap());
    }
  }

  Future<List<PostData>> getPosts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('feeds', orderBy: 'feed_id DESC');
    return List.generate(maps.length, (i) {
      return PostData(
        feedId: maps[i]['feed_id'],
        userId: maps[i]['user_id'],
        challengeId: maps[i]['challenge_id'],
        username: maps[i]['username'],
        content: maps[i]['content'],
        profileImage: maps[i]['profile_image'],
        feedImage: maps[i]['feed_image'],
        createAt: maps[i]['create_at'],
      );
    });
  }

  Future<void> insertPost(PostData post) async {
    final db = await database;
    await db.insert('feeds', post.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
