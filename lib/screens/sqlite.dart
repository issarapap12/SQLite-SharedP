import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:testsqliteisNew/shared_preferences/shared_preferences.dart';

final String tableName = 'toDoTABLE';
final String Column_id = 'id';
final String Column_toDo = 'ToDo';

class ToDoModel {
  int id;
  String toDo;

  ToDoModel({this.id, this.toDo});

  Map<String, dynamic> toMap() {
    return {Column_toDo: this.toDo};
  }
  //แปลงเป็นjsonง่่าย เพราะมีkey.value เหมือนกัน
}

// Helper ทำหน้าที่ Insert และ Read All Data ของ SQLite
class Helper {
  Database database;

  Helper() {
    initDatabase();
  }
//เมืื่อทำงาน async await เอาไว้เพื่อดูว่ามีsqlite ไหม ถ้าไม่มีจะทำการสร้าง
  Future<void> initDatabase() async {
    database = await openDatabase(join(await getDatabasesPath(), "database.db"),
        onCreate: (Database database, int version) {
      return database.execute(
          'CREATE TABLE $tableName($Column_id INTEGER PRIMARY KEY AUTOINCREMENT, $Column_toDo Text)');
    }, version: 1);
  }

  Future<void> insertToDo(ToDoModel sqToDo) async {
    try {
      database.insert(tableName, sqToDo.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('Helper Error = ${e.toString()}');
    }
  }

  Future<List<ToDoModel>> getAllData() async {
    final List<Map<String, dynamic>> task = await database.query(tableName);
    return List.generate(task.length, (index) {
      return ToDoModel(
          id: task[index][Column_id], toDo: task[index][Column_toDo]);
    });
  }
}

class TestSQLite extends StatefulWidget {
  @override
  _TestSQLiteState createState() => _TestSQLiteState();
}

class _TestSQLiteState extends State<TestSQLite> {
  //Field
  TextEditingController textEditingController = TextEditingController();
  String toDoString;
  Helper toDoHelper = Helper();
  List<ToDoModel> todoMs = List();
  //Method
  @override
  void initState() {
    super.initState();
    textEditingController.addListener(() {
      toDoString = textEditingController.text;
    });
  }

  Widget toDoForm() {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.today),
        hintText: 'To Doing',
      ),
    );
  }

  Widget saveButton() {
    return Container(
      width: 250.0,
      child: OutlineButton.icon(
        onPressed: () {
          print('todoString = $toDoString');
          ToDoModel toDoModel = ToDoModel(toDo: toDoString);
          toDoHelper.insertToDo(toDoModel);
          readAllTask();
        },
        icon: Icon(Icons.save),
        label: Text(
          'Save',
        ),
      ),
    );
  }

  Widget nextButton(BuildContext context) {
    return Container(
      width: 250.0,
      child: OutlineButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return SharedP();
              },
            ),
          );
        },
        icon: Icon(Icons.skip_next),
        label: Text(
          'Next Page',
        ),
      ),
    );
  }

//สร้าง Listview และ การ Get Event จากการคลิกปุ่ม Save เพื่อ Insert Value ไปที่ SQLite
  Future<void> readAllTask() async {
    List<ToDoModel> toDos = await toDoHelper.getAllData();
    print('toDos.length = ${toDos.length}');
    setState(() {
      todoMs = toDos;
    });
  }

  Widget showListToDo() {
    return Expanded(
      child: ListView.builder(
        itemCount: todoMs.length,
        itemBuilder: (BuildContext buildContext, int index) {
          return Text(todoMs[index].toDo);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test SQLite'),
      ),
      body: Center(
        child: Container(
          width: 250.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              toDoForm(),
              saveButton(),
              nextButton(context),
              showListToDo(),
            ],
          ),
        ),
      ),
    );
  }
}
