import 'package:flutter/material.dart';

class Trafpage extends StatefulWidget {
  final String traffone;
  final String trafftwo;
  final String traffthree;
  final int car1;
  final int car2;
  final int car3;
  Trafpage(
      {@required this.traffone,
      @required this.traffthree,
      @required this.trafftwo,
      @required this.car1,
      @required this.car2,
      @required this.car3});
  @override
  _TrafpageState createState() => _TrafpageState();
}

class _TrafpageState extends State<Trafpage> {
  timetraf(int d0, int d1, int d2, int d3) {
    return d0 / (d1 + d2 + d3) * 180;
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            width: a.width,
            height: a.width,
            color: Colors.blue,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
              left: a.width / 20,
              right: a.width / 20,
            ),
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: a.width / 18,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Text(widget.traffone),
          Text(widget.car1.toString()),
          Text(timetraf(widget.car1, widget.car1, widget.car2, widget.car3)
              .toStringAsFixed(0)),
          Text(widget.trafftwo),
          Text(widget.car2.toString()),
          Text(timetraf(widget.car2, widget.car1, widget.car2, widget.car3)
              .toStringAsFixed(0)),
          Text(widget.traffthree),
          Text(widget.car3.toString()),
          Text(timetraf(widget.car3, widget.car1, widget.car2, widget.car3)
              .toStringAsFixed(0))
        ],
      ),
    );
  }
}
