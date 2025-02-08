import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static late Database database;

  // Initialize the database
  static Future<void> initialiseDatabase() async {
    String path = join(await getDatabasesPath(), "apps_library.db");

    database = await openDatabase(
      path,
      version: 2, // Increment the version number
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE AppsLibrary (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT UNIQUE,
            author TEXT,
            thumbnail TEXT,
            rating TEXT,
            downloads TEXT,
            description TEXT,
            apk_url TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Add the new column `apk_url` to the existing table
          await db.execute('ALTER TABLE AppsLibrary ADD COLUMN apk_url TEXT');
        }
      },
    );
  }

  // Add app to library
  static Future<void> addAppToLibrary(Map<String, dynamic> app) async {
    await database.insert(
      'AppsLibrary',
      {
        'title': app['title'],
        'author': app['author'],
        'thumbnail': app['thumbnail'],
        'rating': app['rating'],
        'downloads': app['downloads'],
        'description': app['description'],
        'apk_url': app['apk_url'], // Add the new field
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await getAppsFromLibrary();
  }

  // Fetch all stored apps
  static Future<List<Map<String, dynamic>>> getAppsFromLibrary() async {
    List<Map<String, dynamic>> list = await database.rawQuery('SELECT * FROM AppsLibrary');
    return list;
  }

  // Delete app from library
  static Future<void> deleteApp(int id) async {
    await database.rawDelete('DELETE FROM AppsLibrary WHERE id = ?', [id]);
    await getAppsFromLibrary();
  }
}