import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:convert/convert.dart';

class SharedP extends StatefulWidget {
  //เอาไว้เก็บค่าkey และเอามาเรียกใช้
  @override
  _SharedPState createState() => _SharedPState();
}

class _SharedPState extends State<SharedP> {
  String _haveStarted3Times = ''; // ใช้เรียกค่า 3 ครั้ง

  @override
  void initState() {
    super.initState();
    _incrementStartup();
  }

  Future<int> _getIntFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance(); //เก็บค่า
    final startupNumber = prefs.getInt('startupNumber');
    if (startupNumber == null) {
      return 0;
    }
    return startupNumber;
  }

  Future<void> _resetCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('startupNumber', 0); //เช็คตัวเลขก่อน จะกลับมาเป็น0
  }

  Future<void> _incrementStartup() async {
    final prefs = await SharedPreferences.getInstance();

    int lastStartupNumber = await _getIntFromSharedPref(); //รับตัวเลขเข้ามา
    int currentStartupNumber = ++lastStartupNumber;

    await prefs.setInt('startupNumber', currentStartupNumber);

    if (currentStartupNumber == 3) {
      setState(
          () => _haveStarted3Times = '$currentStartupNumber Times Completed');

      await _resetCounter();
    } else {
      setState(() => _haveStarted3Times = '$currentStartupNumber Times');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: Center(
        child: Text(
          _haveStarted3Times,
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}
