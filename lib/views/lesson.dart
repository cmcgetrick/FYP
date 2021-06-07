import 'package:flutter/material.dart';
import 'package:flutter3/services/database.dart';
import 'package:flutter3/views/flashcards.dart';
import 'package:flutter3/views/game.dart';
import 'package:flutter3/views/pronounce.dart';
import 'package:flutter3/views/lesson_feature.dart';
import 'package:flutter3/widget/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter3/views/chatscreen.dart';
import 'package:flutter3/usage/authenticate.dart';

import 'categories.dart';
import 'grammar.dart';

class Lesson extends StatefulWidget {
  @override
  _LessonState createState() => _LessonState();
}

class _LessonState extends State<Lesson> {
  int _selectedIndex = 1;
  List<Widget> _widgetOptions = <Widget>[
    Categories(),
    Lesson(),
    FlashCards(),
    Game(),
    Grammar()
  ];
  Stream lessonStream;
  DatabaseService databaseService = new DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget quizList() {
    return Container(
      child: Column(
        children: [
          StreamBuilder(
            stream: lessonStream,
            builder: (context, snapshot) {
              return snapshot.data == null
                  ? Container()
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemBuilder: (context, index) {
                        return QuizTile(
                            noOfQuestions: snapshot.data.docs.length,
                            imageUrl:
                                snapshot.data.docs[index].data()["quizImgUrl"],
                            description:
                                snapshot.data.docs[index].data()["quizDesc"],
                            title:
                                snapshot.data.docs[index].data()["quizTitle"],
                            id: snapshot.data.docs[index].data()["quizId"]);
                      });
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    databaseService.getQuizData().then((value) {
      lessonStream = value;
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
      body: quizList(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.house),
              label: ('Lesson'),
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

class QuizTile extends StatelessWidget {
  final String imageUrl, title, id, description;
  final int noOfQuestions;

  QuizTile(
      {@required this.title,
      @required this.imageUrl,
      @required this.description,
      @required this.id,
      @required this.noOfQuestions});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LessonFeature(id)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        height: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                color: Colors.black26,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        description,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
