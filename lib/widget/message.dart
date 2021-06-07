import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final int count;
  final Map<String, dynamic> messages;
  final bool pad;

  const Message({
    Key key,
    this.count,
    this.messages,
    this.pad = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: pad == true ? 15 : 5,
        bottom: 5,
        left: 10,
        right: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 300),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 12,
            ),
            child: Text(
              messages['value'],
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
