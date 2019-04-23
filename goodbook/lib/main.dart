
import 'package:flutter/material.dart';
import 'home.dart';
void main() => runApp(new MyApp());

class MyApp extends StatefulWidget{
  _MyAppState createState()=> _MyAppState();


}

class _MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Good book',
      theme: new ThemeData(
       //backgroundColor:   Colors.teal,
      ),
      home: HomePage(),
    );
  }

}