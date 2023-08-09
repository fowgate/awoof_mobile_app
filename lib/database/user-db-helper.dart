import 'dart:async';
import 'dart:io' as io;
import 'package:awoof_app/model/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// This creates and controls a sqlite database for the logged in user's details
class DatabaseHelper {

  /// Instantiating this class to make it a singleton
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  /// Instantiating database from the sqflite package
  static Database? _db;

  /// A string value to hold the name of the table in the database
  final String USER_TABLE = "User";

  /// A string value to hold the name of the table in the database
  final String MAGAZINE_TABLE = "Magazine";

  /// A function to get the database [_db] if it exists or wait to initialize
  /// a new database by calling [initDb()] and return [_db]
  Future<Database> get db async {
    if(_db != null){
      return _db!;
    }  
    _db = await initDb();
    return _db!;
  }

  DatabaseHelper.internal();

  /// Creating a new database in the device located in [path] with the
  /// [_onCreate()] function to create its table and fields
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "user.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  /// Function to execute sqlite statement to create a new table and its fields
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE $USER_TABLE("
            "id TEXT PRIMARY KEY,"
            "balance TEXT,"
            "token TEXT NOT NULL,"
            "isPinSet INTEGER,"
            "isAccountSet INTEGER,"
            "isVerified INTEGER,"
            "isAdmin INTEGER,"
            "firstName TEXT,"
            "lastName TEXT,"
            "phoneNumber TEXT,"
            "email TEXT,"
            "userName TEXT,"
            "signupDate TEXT,"
            "userRef TEXT,"
            "gender TEXT,"
            "location TEXT,"
            "image TEXT,"
            "stars TEXT,"
            "following TEXT,"
            "followers TEXT,"
            "giveawaysWon TEXT,"
            "giveawaysAmountWon TEXT,"
            "giveawaysParticipated TEXT,"
            "giveawaysDone TEXT)"
    );
    print("Created tables");
  }

  /// This function insert user's details into the database records
  Future<int> saveUser(User user) async {
    var dbClient = await db;
    await dbClient.delete(USER_TABLE);
    int res = await dbClient.insert(USER_TABLE, user.toMap());
    return res;
  }

  /// This function update user's details in the database records
  Future<int> updateUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.update(USER_TABLE, user.toMap());
    return res;
  }

  /// This function get user's details from the database
  Future<User?> getUser () async {
    var dbConnection = await db;
    List<Map> users = await dbConnection.rawQuery('SELECT * FROM $USER_TABLE');
    User? userVal;
    for(int i = 0; i < users.length; i++){
      User user = User(
          users[0]['id'],
          users[0]['balance'],
          users[0]['token'],
          users[0]['isPinSet'] == 0 ? false : true,
          users[0]['isAccountSet'] == 0 ? false : true,
          users[0]['isVerified'] == 0 ? false : true,
          users[0]['isAdmin'] == 0 ? false : true,
          users[0]['firstName'],
          users[0]['lastName'],
          users[0]['phoneNumber'],
          users[0]['email'],
          users[0]['userName'],
          users[0]['signupDate'],
          users[0]['userRef'],
          users[0]['gender'],
          users[0]['location'],
          users[0]['image'],
          users[0]['stars'],
          users[0]['following'],
          users[0]['followers'],
          users[0]['giveawaysWon'],
          users[0]['giveawaysAmountWon'],
          users[0]['giveawaysParticipated'],
          users[0]['giveawaysDone']
      );
      userVal = user;
    }
    return userVal;
  }

  /// This function deletes user's details from the database records
  Future<int> deleteUsers() async {
    var dbClient = await db;
    int res = await dbClient.delete(USER_TABLE);
    return res;
  }

  /// This function checks if a user exists in the database by querying the
  /// database to check the length of the records and returns true if it is > 0
  /// or false if it is not
  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query(USER_TABLE);
    return res.length > 0? true: false;
  }

}