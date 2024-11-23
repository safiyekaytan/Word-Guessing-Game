import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/IP.dart';
import 'package:flutter_application_1/altiHarfOyunOdasi.dart';
import 'package:flutter_application_1/besHarfOyunOdasi.dart';
import 'package:flutter_application_1/dortHarfOyunOdasi.dart';
import 'package:flutter_application_1/yediHarfOyunOdasi.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class kelimeGir extends StatefulWidget {
  final String harfSayisi;
  final String tumString;
  final String mod;
  kelimeGir(
      {super.key,
      required this.harfSayisi,
      required this.tumString,
      required this.mod});

  @override
  State<kelimeGir> createState() => _kelimeGirState();
}

class _kelimeGirState extends State<kelimeGir> {
  int _secondsRemaining = 60;
  late Timer _timer;

  String mevcutUserId = "";
  String yeniUserId = "";
  late int sayi;
  String aranan = "";
  TextEditingController controller1 = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  TextEditingController controller3 = new TextEditingController();
  TextEditingController controller4 = new TextEditingController();
  TextEditingController controller5 = new TextEditingController();
  TextEditingController controller6 = new TextEditingController();
  TextEditingController controller7 = new TextEditingController();

  List<TextEditingController> controllers = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
        }
      });
    });

    sayi = int.tryParse(widget.harfSayisi)!;
    if (sayi == 4) {
      controllers.add(controller1);
      controllers.add(controller2);
      controllers.add(controller3);
      controllers.add(controller4);
    } else if (sayi == 5) {
      controllers.add(controller1);
      controllers.add(controller2);
      controllers.add(controller3);
      controllers.add(controller4);
      controllers.add(controller5);
    } else if (sayi == 6) {
      controllers.add(controller1);
      controllers.add(controller2);
      controllers.add(controller3);
      controllers.add(controller4);
      controllers.add(controller5);
      controllers.add(controller6);
    } else if (sayi == 7) {
      controllers.add(controller1);
      controllers.add(controller2);
      controllers.add(controller3);
      controllers.add(controller4);
      controllers.add(controller5);
      controllers.add(controller6);
      controllers.add(controller7);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: sayi,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.all(8),
                  color: Colors.pink,
                  child: TextField(
                    decoration: widget.mod == "sabit" && index == 2
                        ? InputDecoration(
                            hintText:
                                's', // 3. textfield'in içinde sabit 's' harfini göstermek için kullanılır
                          )
                        : null,
                    controller: controllers[index],
                    onChanged: (value) {
                      if (widget.mod != "sabit") {
                        setState(() {
                          aranan += value;
                        });
                      } else if (widget.mod == "sabit") {
                        setState(() {
                          aranan += value;
                        });
                        if (index == 1) {
                          setState(() {
                            aranan += "s";
                          });
                        }
                      }
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            //oyun odasına git sayıya göre
            onPressed: () {
              //  //KELIME_GONDER&i&kendiuserıdsi&u&digeruserid&odadakikelimesayısı&oyunmodu

              mevcutUserId = parseMessage(widget.tumString)[0];
              yeniUserId = parseMessage(widget.tumString)[1];
              //    _sendMessage("KELIME_GONDER&i&${mevcutUserId}&u&${yeniUserId}&${sayi}&normal&${aranan}");

              if (sayi == 4) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => dortHarfOyunOdasi(
                          tumString: widget.tumString,
                          arananString:
                              "KELIME_GONDER&i&${mevcutUserId}&u&${yeniUserId}&${sayi}&normal&${aranan}")),
                );
              } else if (sayi == 5) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => besHarfOyunOdasi(
                          tumString: widget.tumString,
                          arananString:
                              "KELIME_GONDER&i&${mevcutUserId}&u&${yeniUserId}&${sayi}&normal&${aranan}")),
                );
              } else if (sayi == 6) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => altiHarfOyunOdasi(
                          tumString: widget.tumString,
                          arananString:
                              "KELIME_GONDER&i&${mevcutUserId}&u&${yeniUserId}&${sayi}&normal&${aranan}")),
                );
              } else if (sayi == 7) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => yediHarfOyunOdasi(
                          tumString: widget.tumString,
                          arananString:
                              "KELIME_GONDER&i&${mevcutUserId}&u&${yeniUserId}&${sayi}&normal&${aranan}")),
                );
              }
            },
            child: Text('Kayıt Et'),
          ),
          Text(
            '$_secondsRemaining',
          ),
        ],
      ),
    );
  }

  List<String> parseMessage(String asciiMessage) {
    List<String> stringList = [];
    if (asciiMessage.contains("u")) {
      List<String> parts = asciiMessage.split(',');
      for (String part in parts) {
        List<String> subParts = part.split(':');
        if (subParts[0] == 'u') {
          stringList.add(subParts[1]);
        } else if (subParts[0] == 'i') {
          stringList.add(subParts[1]);
        }
      }
    }
    return stringList;
  }
}
