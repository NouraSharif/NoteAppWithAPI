import 'package:flutter/material.dart';
import 'package:noteapp/app/auth/login.dart';
import 'package:noteapp/app/auth/signup.dart';
import 'package:noteapp/app/auth/success.dart';
import 'package:noteapp/app/home.dart';
import 'package:noteapp/app/notes/add.dart';

import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: prefs.getString("id") == null ? "login" : "home",

      routes: {
        "login": (context) => Login(),
        "signup": (context) => SignUp(),
        "home": (context) => Home(),
        "success": (context) => Success(),
        "addnotes": (context) => AddNotes(),
      },
    );
  }
}
