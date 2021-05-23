import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'widget/Bobole.dart';

class AddressNav extends StatefulWidget {
  final int col;
  final String address;
  final String latitude;
  final String longitude;
  final int life;
  final int settime;
  final String id;
  final String addressto;
  final String nal;
  final double per;
  final double aitime;
  AddressNav(
      {@required this.col,
      @required this.address,
      @required this.addressto,
      @required this.latitude,
      @required this.longitude,
      @required this.life,
      @required this.settime,
      @required this.id,
      @required this.nal,
      @required this.per,
      @required this.aitime});
  @override
  _AddressNavState createState() => _AddressNavState();
}

class _AddressNavState extends State<AddressNav> {
  int page = 1;
  String presettime = "0";
  String sta;
  TextEditingController _settext = TextEditingController();
  Future<void> _showMyDialog() async {
    Size a = MediaQuery.of(context).size;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          actions: [
            Container(
              padding: EdgeInsets.all(a.width / 30),
              width: a.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Change Time(sec)",
                    style: TextStyle(
                        fontSize: a.width / 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: a.width / 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            "${widget.aitime.toStringAsFixed(0)}",
                            style: TextStyle(
                                fontSize: a.width / 15,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: a.width / 80),
                          Text(
                            'AI Time(sec)',
                            style: TextStyle(
                              fontSize: a.width / 50,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: a.width / 10,
                            height: a.width / 10,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[300].withOpacity(0.4),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(a.width / 50),
                            ),
                            alignment: Alignment.center,
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: _settext,
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  hintText: "${widget.settime}"),
                            ),
                          ),
                          SizedBox(height: a.width / 80),
                          Text(
                            'Set Time(sec)',
                            style: TextStyle(
                              fontSize: a.width / 50,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: a.width / 20),
                  InkWell(
                    onTap: () {
                      Firestore.instance
                          .collection("data")
                          .document(widget.id)
                          .updateData({
                        "Set_Time": int.parse(_settext.text.toString())
                      });
                      Firestore.instance
                          .collection("group")
                          .document(widget.addressto)
                          .updateData({
                        "a${widget.nal}": int.parse(_settext.text.toString())
                      });
                      setState(() {
                        presettime = _settext.text.toString();
                        page = 2;
                        getV();
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: a.width,
                      padding: EdgeInsets.only(
                          left: a.width / 4, right: a.width / 4),
                      child: Container(
                        height: a.width / 10,
                        decoration: BoxDecoration(
                            color: Color(0xffFBB311),
                            borderRadius: BorderRadius.circular(a.width)),
                        alignment: Alignment.center,
                        child: Text(
                          "Enter!",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: a.width / 35,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  getV() async {
    var result = await Firestore.instance
        .collection("group")
        .document("${widget.addressto}")
        .get();

    if (result.data['type'] == "3") {
      double num1 = result.data["dataCar"][int.parse(widget.nal) - 1] /
          (result.data["dataCar"][0] +
              result.data["dataCar"][1] +
              result.data["dataCar"][2]) *
          120;
      double per1 = result.data['a${int.parse(widget.nal)}'] / num1 * 100;
      setState(() {
        sta = per1.toStringAsFixed(0);
      });
    } else {
      double num1 = result.data["dataCar"][int.parse(widget.nal) - 1] /
          (result.data["dataCar"][0] +
              result.data["dataCar"][1] +
              result.data["dataCar"][2] +
              result.data["dataCar"][3]) *
          120;
      double per2 = result.data['a${int.parse(widget.nal)}'] / num1 * 100;
      setState(() {
        sta = per2.toStringAsFixed(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
      width: a.width,
      height: a.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(a.width / 20),
          topRight: Radius.circular(a.width / 20),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xff6E6E6E).withOpacity(0.45),
            spreadRadius: 0,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.only(
          top: a.width / 10, right: a.width / 10, left: a.width / 10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: a.width / 6.5,
                height: a.width / 6.5,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(a.width)),
                child: Icon(
                  Icons.traffic,
                  size: a.width / 12,
                  color: Color(widget.col),
                ),
              ),
              SizedBox(
                width: a.width / 40,
              ),
              Container(
                height: a.width / 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Address : ${widget.address}",
                      style: TextStyle(
                          fontSize: a.width / 25, fontWeight: FontWeight.bold),
                    ),
                    Text(
                        "Location : ${widget.latitude} N ${widget.longitude} S",
                        style: TextStyle(
                            fontSize: a.width / (20 * 2),
                            color: Color(0xff898989)))
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: a.width / 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Bobole(
                    color1: 0xff4A778C,
                    icon1: Icons.memory,
                    text1: "${widget.life}",
                    text2: "Service life(years)",
                  ),
                  SizedBox(height: a.width / 20),
                  Bobole(
                    color1: 0xff92D8A6,
                    icon1: Icons.traffic,
                    text1: "${widget.aitime.toStringAsFixed(0)}",
                    text2: "AI Time(sec)",
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Bobole(
                    color1: 0xff27B5B6,
                    icon1: Icons.traffic,
                    text1: page == 1 ? "${widget.settime}" : "${presettime}",
                    text2: "Set Time(sec)",
                  ),
                  SizedBox(height: a.width / 20),
                  Bobole(
                    color1: 0xff01D298,
                    icon1: Icons.memory,
                    text1: page == 1 ? widget.per.toStringAsFixed(0) : "${sta}",
                    text2: "Stability",
                  )
                ],
              )
            ],
          ),
          SizedBox(height: a.width / 10),
          InkWell(
            onTap: () {
              _showMyDialog();
            },
            child: Container(
              width: a.width,
              padding: EdgeInsets.only(left: a.width / 10, right: a.width / 10),
              child: Container(
                height: a.width / 8,
                decoration: BoxDecoration(
                    color: Color(0xffFBB311),
                    borderRadius: BorderRadius.circular(a.width / 40)),
                alignment: Alignment.center,
                child: Text(
                  "Change Time",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: a.width / 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
