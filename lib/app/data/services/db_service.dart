import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
//创建SQLite服务

//创建SQLite服务
class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;

  DBService._internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'user_database.db');

    await deleteDatabase(path); // 强制删除旧数据库（如果存在）
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        // 创建 users 表
        db.execute(
          '''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            account TEXT UNIQUE,
            password TEXT
          )
          ''',
        );
        // 创建订单表
        await db.execute('''
        CREATE TABLE orders(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          manufacturer TEXT,
          productName TEXT,
          price REAL,
          origin TEXT,
          unit TEXT,
          info TEXT,
          address TEXT,
          contact TEXT,
          orderNumber TEXT,
          image TEXT,
          quantity INTEGER,
           orderTime TEXT
          
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // 如果数据库版本小于2，则添加 image 字段
          await db.execute('''
          ALTER TABLE orders ADD COLUMN image TEXT
        ''');
        }
      },
    );
  }

  // 用户注册
  Future<int> registerUser(String account, String password) async {
    final dbClient = await db;
    return await dbClient.insert(
      'users',
      {'account': account, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 用户登录
  Future<Map<String, dynamic>?> loginUser(
      String account, String password) async {
    final dbClient = await db;
    final result = await dbClient.query(
      'users',
      where: 'account = ? AND password = ?',
      whereArgs: [account, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // 获取登录状态
  Future<void> setLoginStatus(bool status, {String? account}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', status);
    if (status && account != null) {
      await prefs.setString('currentUserAccount', account);
    } else {
      await prefs.remove('currentUserAccount');
    }
  }

  // 获取登录状态
  Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // 获取当前登录的用户
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final dbClient = await db;
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      final account = prefs.getString('currentUserAccount');
      if (account != null) {
        final result = await dbClient.query(
          'users',
          where: 'account = ?',
          whereArgs: [account],
          limit: 1,
        );
        return result.isNotEmpty ? result.first : null;
      }
    }
    return null;
  }

  // 插入订单
  Future<int> insertOrder(Map<String, dynamic> order) async {
    final dbClient = await db;
    return await dbClient.insert(
      'orders',
      order,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 查询所有订单
  Future<List<Map<String, dynamic>>> getOrders() async {
    final dbClient = await db;
    return await dbClient.query('orders');
  }

  // 删除订单
  Future<int> deleteOrder(int id) async {
    final dbClient = await db;
    return await dbClient.delete('orders', where: 'id = ?', whereArgs: [id]);
  }
}
