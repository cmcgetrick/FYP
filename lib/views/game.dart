import 'package:flutter/material.dart';
import 'package:flutter3/main.dart';
import 'package:flutter3/services/database.dart';
import 'package:flutter3/views/flashcards.dart';
import 'package:flutter3/views/pronounce.dart';
import 'package:flutter3/widget/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter3/views/chatscreen.dart';
import 'package:flutter3/usage/authenticate.dart';

import 'categories.dart';
import 'grammar.dart';
import 'lesson.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  int _selectedIndex = 3;
  List<Widget> _widgetOptions = <Widget>[
    Categories(),
    Lesson(),
    FlashCards(),
    Game(),
    Grammar()
  ];
  Stream wordStream;
  DatabaseService databaseService = new DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget PronounceList() {
    return Container(
      child: Column(
        children: [
          StreamBuilder(
            stream: wordStream,
            builder: (context, snapshot) {
              return snapshot.data == null
                  ? Container()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return PronounceTile(
                            english:
                                snapshot.data.docs[index].data()["english"],
                            spanish:
                                snapshot.data.docs[index].data()["spanish"],
                            wordID: snapshot.data.docs[index].data()["wordID"]);
                      });
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    databaseService.getPronounceData().then((value) {
      wordStream = value;
      setState(() {});
    });
    super.initState();
  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => _widgetOptions.elementAt(_selectedIndex)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: LogoWidget(),
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()),
              );
            },
            child: Text('Messenger'),
            style: TextButton.styleFrom(
              primary: Colors.black,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Pronounce()),
              );
            },
            child: Text('Practice'),
            style: TextButton.styleFrom(
              primary: Colors.black,
            ),
          ),
          TextButton(
            onPressed: () async {
              await _auth.signOut();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Text('Logout'),
            style: TextButton.styleFrom(
              primary: Colors.black,
            ),
          ),
        ],
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Text('Game section here')])),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.house),
              label: ('Home'),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.assessment),
              label: ('Quiz'),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.swap_horizontal_circle),
              label: ('Flashcards'),
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.videogame_asset),
              label: ('Game'),
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              icon: Icon(Icons.create_outlined),
              label: ('Grammar'),
              backgroundColor: Colors.purple),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }
}
