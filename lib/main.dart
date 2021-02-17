import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testsqliteisNew/screens/sqlite.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      allowFontScaling: false,
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SQLTest',
        theme: ThemeData(
          primaryColor: Colors.black,
        ),
        home: TestSQLite(),
      ),
    );
  }
}
