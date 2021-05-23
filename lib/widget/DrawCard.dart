import 'package:flutter/material.dart';

class Drawgard extends StatefulWidget {
  final String text;
  Drawgard({@required this.text});
  @override
  _DrawgardState createState() => _DrawgardState();
}

class _DrawgardState extends State<Drawgard> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
      width: a.width / 3,
      height: a.width / 5,
      color: Colors.green,
      alignment: Alignment.center,
      child: Text(widget.text),
    );
  }
}
