import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 17),
        children: <TextSpan>[
          TextSpan(
              text: 'Cómo se ',
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black54)),
          TextSpan(
              text: 'Dice',
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.green)),
        ],
      ),
    );
  }
}
