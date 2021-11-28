import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trojang/model/contact_class.dart';

class ContactDatabase {
  static final ContactDatabase instance = ContactDatabase._init();
  static Database? _database;
  ContactDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('contact.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableContact ( 
  ${ContactFields.id} $idType, 
  ${ContactFields.name} $textType,
  ${ContactFields.image} $textType,
  ${ContactFields.phonenumber} $textType
  )
''');
  }

  Future<MyContact> create(MyContact contact) async {
    final db = await instance.database;

    final id = await db.insert(tableContact, contact.toJson());
    return contact.copy(id: id);
  }

  Future<MyContact> readContact(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableContact,
      columns: ContactFields.values,
      where: '${ContactFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return MyContact.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<MyContact>> readAllContacts() async {
    final db = await instance.database;

    final orderBy = '${ContactFields.name} ASC';

    final result = await db.query(tableContact, orderBy: orderBy);

    return result.map((json) => MyContact.fromJson(json)).toList();
  }

  Future<int> update(MyContact contact) async {
    final db = await instance.database;

    return db.update(
      tableContact,
      contact.toJson(),
      where: '${ContactFields.id} = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableContact,
      where: '${ContactFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
