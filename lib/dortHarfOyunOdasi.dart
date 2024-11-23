import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/IP.dart';
import 'package:flutter_application_1/message_manager.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class dortHarfOyunOdasi extends StatefulWidget {
  final String tumString;
  final String arananString;
  dortHarfOyunOdasi(
      {super.key, required this.tumString, required this.arananString});

  @override
  State<dortHarfOyunOdasi> createState() => _dortHarfOyunOdasiState();
}

class _dortHarfOyunOdasiState extends State<dortHarfOyunOdasi> {
  int asilSayi = 4;
  Color color1 = Colors.black;
  Color color2 = Colors.black;
  Color color3 = Colors.black;
  Color color4 = Colors.black;

  Color color11 = Colors.black;
  Color color22 = Colors.black;
  Color color33 = Colors.black;
  Color color44 = Colors.black;

  Color color111 = Colors.black;
  Color color222 = Colors.black;
  Color color333 = Colors.black;
  Color color444 = Colors.black;

  Color color1111 = Colors.black;
  Color color2222 = Colors.black;
  Color color3333 = Colors.black;
  Color color4444 = Colors.black;

  Color color11111 = Colors.black;
  Color color22222 = Colors.black;
  Color color33333 = Colors.black;
  Color color44444 = Colors.black;

  int rowCount = 0;
  List<Color> colorList1 = [];
  List<Color> colorList2 = [];

  List<Color> colorList3 = [];

  List<Color> colorList4 = [];

  List<List<Color>> colorLists = [];

  TextEditingController controller = new TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse(IP.adres),
  );
  late String mesajj;

  List<List<TextEditingController>> controllers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    colorList1 = [color1, color2, color3, color4];
    colorList2 = [color11, color22, color33, color44];
    colorList3 = [color111, color222, color333, color444];
    colorList4 = [color1111, color2222, color3333, color4444];

    colorLists = [colorList1, colorList2, colorList3, colorList4];

    _sendMessage(widget.arananString);

    controllers = List.generate(asilSayi,
        (_) => List.generate(asilSayi, (_) => TextEditingController()));
  }

  void word(String text, int row) {
    if (text == mesajj.split("&")[6]) {
      //her hucre yesil
      for (int i = 0; i < text.length; i++) {
        setState(() {
          colorLists[row][i] = Colors.green;
        });
      }
    } else {
      //10 //5
      //harf harf karşılaştır
      for (int i = 0; i < mesajj.split("&")[6].length; i++) {
        if (text[i] == mesajj.split("&")[6][i]) {
          //bu harfe sahip ve doğru yerde    // yesil
          setState(() {
            colorLists[row][i] = Colors.green;
          });
        } else if (mesajj.split("&")[6].contains(text[i])) {
          //mesela text = kalem
          //mesajj = selam
          //silginin ilk harfi k değil peki içinde k var mı? yoksa kırmızı eğer varsa mavi
          // a ikinci harf mi hayır peki bi daha bak a harfi içeriyor mu evet o zaman mavi
          setState(() {
            colorLists[row][i] = Colors.blue;
          });
        } else if (!text[i].contains(mesajj.split("&")[6])) {
          //kırmızı çünkü o harfi içermiyor bile
          setState(() {
            colorLists[row][i] = Colors.red;
          });
        }
        ;
      }
    }
//    int puan = 0;
    setState(() {
      if (rowCount < asilSayi - 1) {
        //KELIME_TAHMIN%normalmod%5harf%satır1%10p%5p%0p%10p

        //    `KELIME_GELDI&i&${recipientId}&u&${senderId}&kelime&${kelime}`
/*
        for (int m = 0; m < 5; m++) {
          if (colorLists[rowCount][m] == Colors.green) {
            puan += 10;
          } else if (colorLists[rowCount][m] == Colors.blue) {
            puan += 5;
          }
        }
        _sendMessage(
            "KELIME_TAHMIN%normal%5%${rowCount}%${puan}%i%${mesajj.split('&')[2]}%u${mesajj.split('&')[4]}");
        //eger hepsi10 p ise bitti,
*/
        rowCount++;
      }
    });
// girilen textle aranan kelimenin harflerine bak
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            itemCount: asilSayi, // Toplamda 5 adet container oluşturulacak
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: asilSayi, // Yatayda 5 container yan yana gelecek
              mainAxisSpacing: 5.0, // Containerlar arası dikey boşluk
              crossAxisSpacing: 6.0, // Containerlar arası yatay boşluk
            ),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: 20,
                height: 20,
                color: colorLists[0][index],
                margin: EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    'Container $index',
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: asilSayi, // Toplamda 5 adet container oluşturulacak
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: asilSayi, // Yatayda 5 container yan yana gelecek
              mainAxisSpacing: 5.0, // Containerlar arası dikey boşluk
              crossAxisSpacing: 6.0, // Containerlar arası yatay boşluk
            ),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: 20,
                height: 20,
                color: colorLists[1][index],
                margin: EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    'Container $index',
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: asilSayi, // Toplamda 5 adet container oluşturulacak
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: asilSayi, // Yatayda 5 container yan yana gelecek
              mainAxisSpacing: 5.0, // Containerlar arası dikey boşluk
              crossAxisSpacing: 6.0, // Containerlar arası yatay boşluk
            ),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: 20,
                height: 20,
                color: colorLists[2][index],
                margin: EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    'Container $index',
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: asilSayi, // Toplamda 5 adet container oluşturulacak
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: asilSayi, // Yatayda 5 container yan yana gelecek
              mainAxisSpacing: 5.0, // Containerlar arası dikey boşluk
              crossAxisSpacing: 6.0, // Containerlar arası yatay boşluk
            ),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: 20,
                height: 20,
                color: colorLists[3][index],
                margin: EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    'Container $index',
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: asilSayi, // Toplamda 5 adet container oluşturulacak
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: asilSayi, // Yatayda 5 container yan yana gelecek
              mainAxisSpacing: 5.0, // Containerlar arası dikey boşluk
              crossAxisSpacing: 6.0, // Containerlar arası yatay boşluk
            ),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: 20,
                height: 20,
                color: colorLists[4][index],
                margin: EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    'Container $index',
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              );
            },
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Material(
              child: TextField(
                controller: controller,
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                // _controller.text, girilen metni alır
                word(controller.text, rowCount);
              },
              child: Text("gonder"),
            ),
            StreamBuilder(
              stream: MessageManager().messageStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  mesajj = snapshot.data.toString();
                  if (mesajj.startsWith("KELIME_GELDI")) {
                    // KELIME_GELDI
                    // `KELIME_GELDI&i&${recipientId}&u&${senderId}&kelime&${kelime}`
                    return Text("a");
                  } else {
                    // Eğer başka bir veri varsa veya durum başka bir duruma dönüşüyorsa burada bir Widget dön
                    return Text("ssss"); // veya herhangi bir Widget
                  }
                } else {
                  // Eğer snapshot.data null ise veya stream henüz bir veri göndermemişse burada bir Widget dön
                  return Text("nooooop"); // veya herhangi bir Widget
                }
              },
            ),
          ],
        ),
      ],
    );
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
