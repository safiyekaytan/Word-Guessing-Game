const express = require('express');
const http = require('http');
const { receiveMessageOnPort } = require('worker_threads');
const WebSocket = require('ws');

const app = express();

// HTTP sunucusunu oluştur
const server = http.createServer(app);

// WebSocket sunucusunu başlat
const wss = new WebSocket.Server({ server });

// Odaları ve kullanıcıları takip etmek için bir veri yapısı
const rooms = {};

// Kullanıcıları takip etmek için bir Map oluşturalım
const users = new Map();

wss.on('connection', function connection(ws) {
  console.log('Client connected');

  // Yeni bağlanan kullanıcıya bir ID atayalım
  const userId = generateUserId();

  // Kullanıcıyı kullanıcılar haritasına ekleyelim
  users.set(userId, ws);

  // Mesajı al ve geri gönder
  ws.on('message', function incoming(message) {
    console.log('Received: %s', message);

    // Eğer gelen mesaj bir Buffer ise, onu metne dönüştür
    if (message instanceof Buffer) {
      message = message.toString('utf8');
    }
    console.log(message);
    if (message.includes(':')) {
      console.log(message);
      const splitMessage = message.split(':');
      const command = splitMessage[0].trim();
      const content = splitMessage[1] ? splitMessage[1].trim() : '';
  
      if (command === 'JOIN_ROOM') {
        const roomId = content;
  
        // Odanın mevcut olup olmadığını kontrol edelim
        if (!rooms[roomId]) {
          // Yeni bir oda oluşturalım
          rooms[roomId] = [];
        }
  
        // Kullanıcıyı odaya ekle
        rooms[roomId].push(userId);
        users.get(userId).send(`Yeni bir odaya girdin,i:${userId}`);
        // Oda içindeki diğer kullanıcılara kullanıcının katıldığını bildir
        rooms[roomId].forEach(clientId => {
          if (clientId !== userId) {
           
            // Odada bulunan diğer kullanıcıları da gönder
            rooms[roomId].filter(id => id !== userId).forEach(otherUserId => {
              users.get(userId).send(`Olan bir odaya geldin,i:${userId},u:${otherUserId},o:${roomId}`);
              users.get(otherUserId).send(`Oldgn yere yeni birisi geldi,i:${otherUserId},u:${userId},o:${roomId}`);
            });
          }
        });
      } else if (command === 'LEAVE_ROOM') {
        const roomId = content;
        if (rooms[roomId]) {
          const index = rooms[roomId].indexOf(userId);
          if (index !== -1) {
            rooms[roomId].splice(index, 1);
  
            // Oda içindeki diğer kullanıcılara kullanıcının ayrıldığını bildir
            rooms[roomId].forEach(clientId => {
              users.get(clientId).send(`goes, kimlik: ${userId}`);
            });
          }
        }
      } else {
        // Doğrudan mesaj gönderme
        const recipientId = command;
        const roomId = rooms[recipientId];
        // Alıcının bulunduğu odayı kontrol et
        if (roomId) {
          rooms[roomId].forEach(clientId => {
            if (clientId !== userId) {
              users.get(clientId).send(`${content}, kimlik: ${userId}`);
            }
          });
        }
      }
    }
    else if(message.includes(',')){
      // birbirine istek atma yeri oyun için
//ISTEK GONDER
if (message.startsWith('ISTEK_GONDER')) {
  //  _channel.sink.add("ISTEK_GONDER,$mevcutUserId,to,$yeniUserId");
  const recipientId = message.split(',')[3];
  const senderId = message.split(',')[1];
  users.get(recipientId).send(`ISTEK_GELDI,i:${recipientId},to,u:${senderId}, aciklamasi soyle istek 2. den 1. ye geldi`);   //burayı to to şeklinde düzelt
  users.get(senderId).send(`ISTEK_GONDERILDI,${recipientId}`);
  console.log("istek gonderildi");
    }
//ISTEGİ KABUL ET
if (message.startsWith('ISTEK_KABUL_ET')) {
  // "ISTEK_KABUL_ET,$senderId"
  //   _channel.sink.add("ISTEK_KABUL_ET,$mevcutUserId,to,$yeniUserId,5");
  const recipientId = message.split(',')[3];
  const senderId = message.split(',')[1];
  const oda = message.split(',')[4];
  users.get(senderId).send(`ISTEK_KABUL_ETTIN_OYUN_BASLIYOR,i:${senderId},to,u:${recipientId},${oda}`); //to to şeklinde düzelt
  users.get(recipientId).send(`ISTEK_KABUL_ETTI_OYUN_BASLIYOR,i:${recipientId},to,u:${senderId},${oda}`);
  console.log("istek kabul edildi, oyun basliyor")
}
  //ISTEGİİ REDDET
    if (message.startsWith('ISTEK_REDDET')) {
    // _channel.sink.add("ISTEK_REDDET,$mevcutUserId,to,$yeniUserId");
    const recipientId = message.split(',')[3];
    const senderId = message.split(',')[1];
    users.get(senderId).send(`ISTEK_REDDETTIN`);
    users.get(recipientId).send(`ISTEK_REDDEDILDI`);
    console.log("istek reddedildi upss i did it again uuuu");
    }
  }
  else if(message.includes('&')){
    console.log("fonka girdi");
    //burada kelimeleri gondereceğiz
   // "KELIME_GONDER&i&${mevcutUserId}&u&${yeniUserId}&5&normal&${aranan}"
   if (message.startsWith('KELIME_GONDER')) {
   
    const recipientId = message.split('&')[4];
    const senderId = message.split('&')[2];
    const kelime = message.split('&')[7];

    console.log(recipientId);
    console.log(senderId);

    // Kullanıcıya cevap göndermeden önce 10 saniye bekleyelim
    setTimeout(() => {
        users.get(recipientId).send(`KELIME_GELDI&i&${recipientId}&u&${senderId}&kelime&${kelime}`);
        console.log("Kelime alıcıya gönderildi.");
    }, 5000); // 10 saniye bekletme
    console.log("kelime aliciya gonderildi");
      }
  }
  else if(message.includes('%')){

//   "KELIME_TAHMIN%normal%5%${rowCount}%${puan}%i%${mesajj.split('&')[2]}%u%${mesajj.split('&')[4]}");

if (message.startsWith('KELIME_TAHMIN')) {
  
  //PUAN DEDİĞİMİZ ŞEY BİR SATIRIN PUANIDIR, DOĞRU YERDE DOĞRU HARF 10 PUAN, YANLIS YERDE DOĞRU HARF 5 PUAN.
  const recipientId = message.split('%')[8];
  const senderId = message.split('%')[6];
  const rowCount = message.split('%')[3];
  const oyunMod = message.split('%')[1];
  const puan = message.split('%')[4];
  const oyunHarf = message.split('%')[2];
  console.log("re");
  console.log(recipientId);

  console.log("se");
  console.log(senderId);
  console.log(recipientId, senderId, oyunMod, puan);

  if(puan == oyunHarf * 10) {
    //doğru bildi

    users.get(recipientId).send(`uBILDI_KELIME_TAHMIN%i%${recipientId}%u:${senderId}%satir%${rowCount}%mod%${oyunMod}%harfSayi%${oyunHarf}`);
    users.get(senderId).send(`iBILDIN_KELIME_TAHMIN%i%${senderId}%u:${recipientId}%satir%${rowCount}%mod%${oyunMod}%harfSayi%${oyunHarf}`);

  }
  else if(rowCount == oyunHarf - 1 && puan != oyunHarf * 10){
    //tüm satırları denedi ama yapamadı
     // BİLEMEDİ
     users.get(recipientId).send(`uBILEMEDI_KELIME_TAHMIN%i${recipientId}%u:${senderId}%puan%${puan}%satir%${rowCount}%mod%${oyunMod}%harfSayi%${oyunHarf}`);
     users.get(senderId).send(`iBILEMEDIN_KELIME_TAHMIN%i${senderId}%u:${recipientId}%puan%${puan}%satir%${rowCount}%mod%${oyunMod}%harfSayi%${oyunHarf}`);

  }
else{
  users.get(recipientId).send(`uETTI_KELIME_TAHMIN%i%${recipientId}%u:${senderId}%puan%${puan}%satir%${rowCount}%mod%${oyunMod}%harfSayi%${oyunHarf}`);
  users.get(senderId).send(`iETTIN_KELIME_TAHMIN%i%${senderId}%u:${recipientId}%puan%${puan}%satir%${rowCount}%mod%${oyunMod}%harfSayi%${oyunHarf}`);
}
  


  console.log("karsi oyuncunun tahmin bilgileri rakibe gonderildi");
  }
  }

   else{
    console.log(message);
   }

  });
 
  // Bağlantı kesildiğinde
  ws.on('close', function close() {
    console.log('Client disconnected');

    // Bağlantısı kesilen kullanıcıyı kullanıcılar haritasından çıkaralım
    users.delete(userId);

    // Kullanıcıyı tüm odalardan çıkar
    for (const roomId in rooms) {
      const index = rooms[roomId].indexOf(userId);
      if (index !== -1) {
        rooms[roomId].splice(index, 1);

        // Oda içindeki diğer kullanıcılara kullanıcının ayrıldığını bildir
        rooms[roomId].forEach(clientId => {
          users.get(clientId).send(`user_left, kimlik: ${userId}`);
        });
      }
    }
  });
});

// HTTP sunucusunu dinle
const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

function generateUserId() {
  const digits = '0123456789';
  let userId = '';
  for (let i = 0; i < 5; i++) {
    const randomIndex = Math.floor(Math.random() * digits.length);
    userId += digits[randomIndex];
  }
  return userId;
}
