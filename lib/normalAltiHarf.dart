import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/IP.dart';
import 'package:flutter_application_1/kelimeGir.dart';
import 'package:flutter_application_1/message_manager.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class normalAltiHarf extends StatefulWidget {
  final String mod;
  const normalAltiHarf({super.key, required this.mod});

  @override
  State<normalAltiHarf> createState() => _normalAltiHarfState();
}

class _normalAltiHarfState extends State<normalAltiHarf> {
  int asilSayi = 6;
  MessageManager messageManager = MessageManager();

  final _channel = WebSocketChannel.connect(
    Uri.parse(IP.adres),
  );

  String mevcutUserId = "";
  String yeniUserId = "";
  late String asciiMessage;
  @override
  void initState() {
    _sendMessage("JOIN_ROOM:${asilSayi}");
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    messageManager.addMessage(asciiMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: Container(
                color: Colors.pink,
                child: Text("${asilSayi} harrff"),
              ),
            ),
            StreamBuilder(
                stream: _channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    asciiMessage = snapshot.data.toString();
                    messageManager.addMessage(asciiMessage);
                    if (asciiMessage
                            .startsWith("ISTEK_KABUL_ETTIN_OYUN_BASLIYOR") ||
                        asciiMessage
                            .startsWith("ISTEK_KABUL_ETTI_OYUN_BASLIYOR")) {
                      // KELIME AL, OYUN ODASINA GİT
                      //burada i: kendi id si
                      // ,5 gibi bir şekilde bitecek en sonuncu harfe bak onu da gonder
                      //u karşının idsi bunları da yeni sayfaya gonder, tüm stringi gonder orda parçalarsın
                      return Text(asciiMessage);
                    } else if (asciiMessage.startsWith("KELIME_GELDI")) {
                      //besharf oyunodasi
                    }
                    return Text(asciiMessage);
                  } else {
                    return Text('');
                  }
                }),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => kelimeGir(
                            harfSayisi: asciiMessage.characters.last,
                            tumString: asciiMessage,
                            mod: widget.mod)),
                  );
                },
                child: Text("oyuna basllaa")),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    mevcutUserId = parseMessage(asciiMessage)[0];
                    yeniUserId = parseMessage(asciiMessage)[1];
                  });
                  _sendMessage("ISTEK_GONDER,$mevcutUserId,to,$yeniUserId");
                },
                child: Text("İstek Gönder")),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    mevcutUserId = parseMessage(asciiMessage)[0];
                    yeniUserId = parseMessage(asciiMessage)[1];
                  });
                  _sendMessage("ISTEK_REDDET,$mevcutUserId,to,$yeniUserId");
                },
                child: Text("İsteği Reddet")),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    mevcutUserId = parseMessage(asciiMessage)[0];
                    yeniUserId = parseMessage(asciiMessage)[1];
                  });
                  _sendMessage(
                      "ISTEK_KABUL_ET,$mevcutUserId,to,$yeniUserId,${asilSayi}");
                },
                child: Text("İsteği Kabul Et")),
          ],
        ),
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

  void _sendMessage(String message) {
    _channel.sink.add(message);
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
