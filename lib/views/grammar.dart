import 'package:flutter/material.dart';
import 'package:flutter3/main.dart';
import 'package:flutter3/models/verb.dart';
import 'package:flutter3/services/database.dart';
import 'package:flutter3/views/categories.dart';
import 'package:flutter3/views/flashcards.dart';
import 'package:flutter3/views/game.dart';
import 'package:flutter3/views/lesson.dart';
import 'package:flutter3/views/pronounce.dart';
import 'package:flutter3/widget/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter3/views/chatscreen.dart';
import 'package:flutter3/usage/authenticate.dart';

class Grammar extends StatefulWidget {
  @override
  _GrammarState createState() => _GrammarState();
}

class _GrammarState extends State<Grammar> {
  int _selectedIndex = 4;
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

  List<Verb> _verbs = [];

  Widget VerbTable() {
    List<TableRow> rows = [
      TableRow(children: [
        Text('verb',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            textAlign: TextAlign.center),
        Text('yo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text('tú', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text('él/ella/Ud.',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text('nosotros',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text('vosotros',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text('ellos/ellas/Uds.',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ]),
      TableRow(children: [
        Text('comer',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            textAlign: TextAlign.center),
        Text('como',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text('comes',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text('come',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text('comemos',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Text('coméis',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text('comen',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ]),
      TableRow(children: [
        Text('leer',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            textAlign: TextAlign.center),
        Text('leo',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text('lees',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text('lee',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text('leemos',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Text('leéis',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text('leen',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ])
    ];

    for (var i in _verbs) {
      rows.add(TableRow(children: [
        Text(i.verb,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            textAlign: TextAlign.center),
        Text(i.yo, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Text(i.tu, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Text(i.them,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Text(i.we, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Text(i.wesp,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Text(i.themF,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
      ]));
      return Table(children: rows);
    }
  }

  @override
  void initState() {
    databaseService.getGrammar().then((value) {
      value.docs.forEach((f) {
        Verb obj = new Verb();
        obj.verb = f.data()['verb'];
        obj.yo = f.data()['yo'];
        obj.tu = f.data()['tú'];
        obj.them = f.data()['él/ella/Ud.'];
        obj.we = f.data()['nosotros'];
        obj.wesp = f.data()['vosotros'];
        obj.themF = f.data()['ellos/ellas/Uds.'];

        _verbs.add(obj);
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
      body: VerbTable(),
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
