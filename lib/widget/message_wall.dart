import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter3/widget/other_user.dart';
import 'package:flutter3/widget/message.dart';

class MessageWall extends StatelessWidget {
  final List<QueryDocumentSnapshot> snapshot;
  final ValueChanged<String> onDelete;

  const MessageWall({
    Key key,
    this.snapshot,
    this.onDelete,
  }) : super(key: key);

  bool shouldDisplayAvatar(int idx) {
    if (idx == 0) return true;

    final previousId = snapshot[idx - 1].data()['author_id'];
    final authorId = snapshot[idx].data()['author_id'];
    return authorId != previousId;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: snapshot.length,
      itemBuilder: (context, index) {
        final returned = snapshot[index].data();
        final user = FirebaseAuth.instance.currentUser;

        if (user != null && user.uid == returned['author_id']) {
          return Dismissible(
            onDismissed: (_) {
              onDelete(snapshot[index].id);
            },
            key: ValueKey(returned['timestamp']),
            child: Message(
              count: index,
              messages: returned,
            ),
          );
        }

        return OtherUser(
          count: index,
          messages: returned,
          showAvatar: shouldDisplayAvatar(index),
        );
      },
    );
  }
}
