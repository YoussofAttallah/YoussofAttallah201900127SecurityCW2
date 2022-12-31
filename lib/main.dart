import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:cw_1/mongodb.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var mongoDataBase = MongoDb();
  await mongoDataBase.connect();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login Screen ",
      home: LoginScreen(mongoDataBase),
    ),
  );
}
