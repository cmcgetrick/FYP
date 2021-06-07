import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter3/widget/message_form.dart';
import 'package:flutter3/widget/message_wall.dart';
import 'package:flutter3/widget/widget.dart';

class ChatScreen extends StatefulWidget {
  final store = FirebaseFirestore.instance.collection('chat_messages');

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {});
    });
  }

  void _addMessage(String value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await widget.store.add({
        'author': user.displayName ?? 'Anonymous',
        'author_id': user.uid,
        'photo_url': user.photoURL ?? 'https://placehold.it/100x100',
        'timestamp': Timestamp.now().millisecondsSinceEpoch,
        'value': value,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LogoWidget(),
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color(0xffdee2d6),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: widget.store.orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.docs.isEmpty) {
                    return Center(child: Text('There are no messages'));
                  }
                }

                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          MessageForm(
            onSubmit: _addMessage,
          )
        ],
      ),
    );
  }
}
