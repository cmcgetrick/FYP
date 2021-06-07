import 'package:flutter/material.dart';

class OtherUser extends StatelessWidget {
  final int count;
  final Map<String, dynamic> messages;
  final bool showAvatar;

  const OtherUser({Key key, this.count, this.messages, this.showAvatar = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAvatar)
            CircleAvatar(
              backgroundImage: NetworkImage('https://placehold.it/100x100'),
            )
          else
            SizedBox(width: 40),
          SizedBox(width: 10),
          Container(
            constraints: BoxConstraints(
              maxWidth: 300,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(messages['value']),
              ],
            ),
          )
        ],
      ),
    );
  }
}
