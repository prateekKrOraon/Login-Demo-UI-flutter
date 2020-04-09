
import 'package:flutter/material.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  File file;
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Center(
              child: Text(
                "Bas Itna hi...",
                style: TextStyle(color: Colors.blue, fontSize: 40,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
