import 'package:flutter/material.dart';
import 'package:flutter_application_1/normalAltiHarf.dart';
import 'package:flutter_application_1/normalBesHarf.dart';
import 'package:flutter_application_1/normalDortHarf.dart';
import 'package:flutter_application_1/normalYediHarf.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class normalHarfKelimeGir extends StatefulWidget {
  const normalHarfKelimeGir({super.key});

  @override
  State<normalHarfKelimeGir> createState() => _normalHarfKelimeGirState();
}

class _normalHarfKelimeGirState extends State<normalHarfKelimeGir> {
  late int harfSayisi = 0;

  String originalMessage = "";
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            children: List.generate(4, (index) {
              return Center(
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ElevatedButton(
                      onPressed: () {
                        if (index == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => normalDortHarf(mod: "normal")),
                          );
                        } else if (index == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => normalBesHarf(mod: "normal")),
                          );
                        } else if (index == 2) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => normalAltiHarf(mod: "normal")),
                          );
                        } else if (index == 3) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => normalYediHarf(mod: "normal")),
                          );
                        }
                      },
                      child: Text("${index + 4}")),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
