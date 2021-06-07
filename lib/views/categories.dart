import 'package:flutter/material.dart';
import 'package:flutter3/main.dart';
import 'package:flutter3/services/database.dart';
import 'package:flutter3/widget/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter3/views/chatscreen.dart';
import 'package:flutter3/usage/authenticate.dart';

import 'grammar.dart';
import 'lesson.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Stream catStream;
  DatabaseService databaseService = new DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget categoryList() {
    return Container(
      child: Column(
        children: [
          StreamBuilder(
            stream: catStream,
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
                        return CategoryTile(
                            imageUrl:
                                snapshot.data.docs[index].data()["catImgUrl"],
                            description:
                                snapshot.data.docs[index].data()["catDesc"],
                            title: snapshot.data.docs[index].data()["catTitle"],
                            id: snapshot.data.docs[index].data()["catId"]);
                      });
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    databaseService.getCategoryData().then((value) {
      catStream = value;
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
          IconButton(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
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
      body: categoryList(),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String imageUrl, title, id, description;

  CategoryTile(
      {@required this.title,
      @required this.imageUrl,
      @required this.description,
      @required this.id});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Lesson()));
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
