import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Blog App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  var gelenYaziBasligi = "";
  var gelenYaziIcerigi = "";

  yaziEkle() {
    FirebaseFirestore.instance
        .collection("Yazilar")
        .doc(t1.text)
        .set({'baslik': t1.text, 'icerik': t2.text}).whenComplete(
            () => print("Yazı Eklendi"));
  }

  yaziGuncelle() {
    FirebaseFirestore.instance
        .collection("Yazilar")
        .doc(t1.text)
        .update({'baslik': t1.text, 'icerik': t2.text}).whenComplete(
            () => print("Yazı Güncellendi"));
  }

  yaziSil() {
    FirebaseFirestore.instance
        .collection("Yazilar")
        .doc(t1.text)
        .delete()
        .whenComplete(() => print("Yazı Silindi"));
  }

  yaziGetir() {
    FirebaseFirestore.instance
        .collection("Yazilar")
        .doc(t1.text)
        .get()
        .then((gelenVeri) {
      setState(() {
        gelenYaziBasligi = gelenVeri.data()['baslik'];
        gelenYaziIcerigi = gelenVeri.data()['icerik'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: t1,
            ),
            TextField(
              controller: t2,
            ),
            Row(
              children: [
                ElevatedButton(onPressed: yaziEkle, child: Text("Ekle")),
                ElevatedButton(
                    onPressed: yaziGuncelle, child: Text("Güncelle")),
                ElevatedButton(onPressed: yaziSil, child: Text("Sil")),
                ElevatedButton(onPressed: yaziGetir, child: Text("Listele"))
              ],
            ),
            ListTile(
              title: Text(gelenYaziBasligi),
              subtitle: Text(gelenYaziIcerigi),
            ),
          ],
        ),
      ),
    );
  }
}
