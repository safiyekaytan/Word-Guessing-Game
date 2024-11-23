import 'package:flutter/material.dart';
import 'package:flutter_application_1/normalAltiHarf.dart';
import 'package:flutter_application_1/normalBesHarf.dart';
import 'package:flutter_application_1/normalDortHarf.dart';
import 'package:flutter_application_1/normalYediHarf.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class sabitHarfKelimeGir extends StatefulWidget {
  const sabitHarfKelimeGir({super.key});

  @override
  State<sabitHarfKelimeGir> createState() => _sabitHarfKelimeGirState();
}

class _sabitHarfKelimeGirState extends State<sabitHarfKelimeGir> {
  late int harfSayisi = 0;
  TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.1.33:3000'),
  );

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
                                builder: (context) => normalDortHarf(mod: "sabit")),
                          );
                        } else if (index == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => normalBesHarf(mod: "sabit")),
                          );
                        } else if (index == 2) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => normalAltiHarf(mod: "sabit")),
                          );
                        } else if (index == 3) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => normalYediHarf(mod: "sabit")),
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
