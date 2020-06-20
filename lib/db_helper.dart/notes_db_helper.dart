
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as db;


class DBHelper{

static Future<db.Database> getDB() async{
  final dbPath=await db.getDatabasesPath();
  final db.Database notesDB= await db.openDatabase(path.join(dbPath,'notes_db.db'),onCreate: (db,version){
    db.execute('CREATE TABLE notes(id TEXT PRIMARY KEY, title TEXT, description TEXT,date TEXT)');
  },version: 1);
return notesDB;
}

static Future<void> insertData(Map<String,String> data) async{
  final notesDB=await DBHelper.getDB();
  await notesDB.insert('notes', data);
}

static Future<void> updateData(String id,Map<String,String> data) async{
  final notesDB=await DBHelper.getDB();
  await notesDB.update('notes', data,where: 'id = ?',whereArgs: [id]);
}

static Future<void> deleteData(String id) async{
  final notesDB=await DBHelper.getDB();
  await notesDB.delete('notes',where: 'id = ?',whereArgs: [id]);
}

static Future<List<Map<String,dynamic>>> getData() async{
final notesDB=await DBHelper.getDB();
final List<Map<String,dynamic>> data=await notesDB.query('notes');
return data;
}





}