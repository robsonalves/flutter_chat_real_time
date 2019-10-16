import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async{

 /* Firestore.instance.collection("mensagens").document().setData({"texto": "Ola"});
  Firestore.instance.collection("mensagens").document().setData({"texto": "Oi"});
  Firestore.instance.collection("mensagens").document().setData({"texto": "Tudo bem?"});
  Firestore.instance.collection("mensagens").document().setData({"texto": "Craro"});
  Firestore.instance.collection("usuarios").document("Robson123").setData({"cidade": "São Paulo", "nome": "Thiago"});
  Firestore.instance.collection("usuarios").document("Robson1234").setData({"cidade": "São Paulo", "nome": "Thiago2"});

 DocumentSnapshot snapshot = await Firestore.instance.collection("usuarios").document("Robson1234").get();
 QuerySnapshot snapshot = await Firestore.instance.collection("usuarios").getDocuments();

 for (DocumentSnapshot doc in snapshot.documents){
   print(doc.data);
 }


  Firestore.instance.collection("mensagens").snapshots().listen((snapshot){

    for(DocumentSnapshot doc in snapshot.documents){
      print(doc.data);
    }

  });*/
  runApp(new MyApp());

}

final ThemeData kIOSTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light
);

final ThemeData kDefault = ThemeData(
    primarySwatch: Colors.purple,
    accentColor: Colors.orangeAccent[400]
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat App",
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).platform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefault,
      home: ChatScreen()
    );
  }
}


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData(
      ),
      child: SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Chat Real Time"),
              centerTitle: true,
              elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
            ),
            body: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor
                  ),
                  child: TextComposer(),
                )
              ],
            )
        ),
      )
    );
  }
}

class TextComposer extends StatefulWidget {
  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: Theme.of(context).platform == TargetPlatform.iOS ?
        BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Colors.grey[200]
                )
            )
        ) : null,
      child: Row(
        children: <Widget>[
          Container(
            child: IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () {},
            ),
          )
        ],
      )
      ),
    );
  }
}

