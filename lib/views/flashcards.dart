import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter3/main.dart';
import 'package:flutter3/models/flashcard.dart';
import 'package:flutter3/services/database.dart';
import 'package:flutter3/views/game.dart';
import 'package:flutter3/views/lesson.dart';
import 'package:flutter3/views/pronounce.dart';
import 'package:flutter3/widget/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter3/views/chatscreen.dart';
import 'package:flutter3/usage/authenticate.dart';

import 'categories.dart';
import 'flashcard_view.dart';
import 'grammar.dart';

class FlashCards extends StatefulWidget {
  @override
  _FlashCardsState createState() => _FlashCardsState();
}

class _FlashCardsState extends State<FlashCards> {
  int _selectedIndex = 2;
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
  int _currentIndex = 0;

  List<Flashcard> _flashcards = [Flashcard(english: "Hello", spanish: "Hola")];

  @override
  void initState() {
    databaseService.getFlashcards().then((value) {
      value.docs.forEach((f) {
        Flashcard obj = new Flashcard();
        obj.english = f.data()['english'];
        obj.spanish = f.data()['spanish'];
        _flashcards.add(obj);
        setState(() {});
      });
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
          children: [
            SizedBox(
                width: 250,
                height: 250,
                child: FlipCard(
                    front: FlashcardView(
                      text: _flashcards[_currentIndex].english,
                    ),
                    back: FlashcardView(
                      text: _flashcards[_currentIndex].spanish,
                    ))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: showPreviousCard,
                    icon: Icon(Icons.chevron_left)),
                IconButton(
                    onPressed: showNextCard, icon: Icon(Icons.chevron_right)),
              ],
            )
          ],
        ),
      ),
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

  void showNextCard() {
    setState(() {
      _currentIndex =
          (_currentIndex + 1 < _flashcards.length) ? _currentIndex + 1 : 0;
    });
  }

  void showPreviousCard() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 >= 0) ? _currentIndex - 1 : _flashcards.length - 1;
    });
  }
}
