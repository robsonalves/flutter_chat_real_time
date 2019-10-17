import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

final googleSignIn = GoogleSignIn();
final auth = FirebaseAuth.instance;

Future<Null> _ensureLoggedIn() async {
  GoogleSignInAccount user = googleSignIn.currentUser;

  if (user == null)
    user = await googleSignIn.signInSilently();

  if (user == null)
    user = await googleSignIn.signIn();

  if (await auth.currentUser() == null){
    GoogleSignInAuthentication credentials = await googleSignIn.currentUser.authentication;
    await auth.signInWithCredential(GoogleAuthProvider.getCredential(
        idToken: credentials.idToken, accessToken: credentials.accessToken));
  }
}

_handleSubmitted(text) async{
  await _ensureLoggedIn();
  _sendMessage(text: text);
}

void _sendMessage({text, imgUrl}) {
  Firestore.instance.collection("messages").add({
    "text":text,
    "imgUrl": imgUrl,
    "senderName": googleSignIn.currentUser.displayName,
    "senderPhotoUrl" : googleSignIn.currentUser.photoUrl
  });

}

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
    return SafeArea(
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
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ChatMessage(),
                    ChatMessage(),
                    ChatMessage()
                  ],
                ),
              ),
              Divider(
                height: 1.0,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor
                ),
                child: TextComposer(),
              )
            ],
          )
      ),
    );
  }
}

class TextComposer extends StatefulWidget {
  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  bool _isComposing = false;
  final _textController = TextEditingController();


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
          ),
          Expanded(
              child: TextField(
                decoration: InputDecoration.collapsed(hintText: "Enviar uma Mensagem"),
                controller: _textController,
                onChanged: (text){
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: (text){
                  _handleSubmitted(text);
                },
              )
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Theme.of(context).platform == TargetPlatform.iOS ?
            CupertinoButton(
              child: Text("Enviar"),
              onPressed: _isComposing ? (){ _handleSubmitted(_textController.text); } : null,
            )  :
              IconButton(
                icon: Icon(Icons.send),
                onPressed: _isComposing ? (){ _handleSubmitted(_textController.text); } : null,
              )
          )
        ],
      )
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage("https://m.media-amazon.com/images/I/41W+BBtOjIL._SR500,500_.jpg"),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Daniel",
              style: Theme.of(context).textTheme.subhead
              ),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text("teste")
              )
            ],
            )
          )
        ],
      )
    );
  }
}


