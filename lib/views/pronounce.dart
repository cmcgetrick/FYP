import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter3/services/database.dart';
import 'package:flutter3/views/record.dart';
import 'package:flutter3/widget/widget.dart';

class Pronounce extends StatefulWidget {
  @override
  _PronounceState createState() => _PronounceState();
}

class _PronounceState extends State<Pronounce> {
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
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
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
            child: Text('Pronunciation Practice'),
            style: TextButton.styleFrom(
              primary: Colors.black,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: PronounceList(),
    );
  }
}

class PronounceTile extends StatelessWidget {
  final String wordID, english, spanish;

  PronounceTile(
      {@required this.wordID, @required this.english, @required this.spanish});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Record()));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Container(
                color: Colors.green.shade800,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        spanish,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        english,
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
