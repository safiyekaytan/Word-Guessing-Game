import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/normalHarfKelimeGir.dart';
import 'package:flutter_application_1/sabitHarfKelimeGir.dart';

class modSec extends StatefulWidget {
  const modSec({super.key});

  @override
  State<modSec> createState() => _modSecState();
}

class _modSecState extends State<modSec> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          GestureDetector(
            onDoubleTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => sabitHarfKelimeGir()),
              );
            },
            child: SizedBox(
              height: 80,
              width: 80,
              child: Container(
                color: Colors.blue,
                child: Text('Sabit Harf Modu'),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          GestureDetector(
            onDoubleTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => normalHarfKelimeGir()),
              );
            },
            child: SizedBox(
              width: 80,
              height: 80,
              child: Container(
                color: Colors.pink,
                child: Text('Normal Harf Modu'),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
