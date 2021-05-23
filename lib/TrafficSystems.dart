import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:traf/trafpage.dart';

class TrafficStystem extends StatefulWidget {
  @override
  _TrafficStystemState createState() => _TrafficStystemState();
}

class _TrafficStystemState extends State<TrafficStystem> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: StreamBuilder(
          stream: Firestore.instance.collection('group').snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if (snapshot.data.documents[index]['num'] == 0) {
                          if (snapshot.data.documents[index]['type'] == '3') {
                            Firestore.instance
                                .collection('group')
                                .document(
                                    '${snapshot.data.documents[index].documentID}')
                                .updateData({
                              'dataCar': [1520, 642, 1200]
                            });
                          } else {
                            Firestore.instance
                                .collection('group')
                                .document(
                                    '${snapshot.data.documents[index].documentID}')
                                .updateData({
                              'dataCar': [1520, 642, 1200, 300]
                            });
                          }
                          Firestore.instance
                              .collection('group')
                              .document(
                                  '${snapshot.data.documents[index].documentID}')
                              .updateData({'num': 1});
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Trafpage(
                                  traffone:
                                      "${snapshot.data.documents[index]['1']}",
                                  trafftwo:
                                      "${snapshot.data.documents[index]['2']}",
                                  traffthree:
                                      "${snapshot.data.documents[index]['3']}",
                                  car1: snapshot.data.documents[index]
                                      ['dataCar'][0],
                                  car2: snapshot.data.documents[index]
                                      ['dataCar'][1],
                                  car3: snapshot.data.documents[index]
                                      ['dataCar'][2],
                                ),
                              ));
                          print('0');
                        } else {
                          Navigator.push(
                              //dss
                              context,
                              MaterialPageRoute(
                                builder: (context) => Trafpage(
                                  traffone:
                                      "${snapshot.data.documents[index]['1']}",
                                  trafftwo:
                                      "${snapshot.data.documents[index]['2']}",
                                  traffthree:
                                      "${snapshot.data.documents[index]['3']}",
                                  car1: snapshot.data.documents[index]
                                      ['dataCar'][0],
                                  car2: snapshot.data.documents[index]
                                      ['dataCar'][1],
                                  car3: snapshot.data.documents[index]
                                      ['dataCar'][2],
                                ),
                              ));
                          print('1');
                        }
                      },
                      child: Container(
                        width: a.width,
                        height: a.width / 4,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300].withOpacity(0.4),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ], color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${snapshot.data.documents[index]['1']}" ==
                                    "null"
                                ? ''
                                : '${snapshot.data.documents[index]['1']}'),
                            Text("${snapshot.data.documents[index]['2']}" ==
                                    "null"
                                ? ''
                                : '${snapshot.data.documents[index]['2']}'),
                            Text("${snapshot.data.documents[index]['3']}" ==
                                    "null"
                                ? ''
                                : '${snapshot.data.documents[index]['3']}'),
                            Text("${snapshot.data.documents[index]['4']}" ==
                                    "null"
                                ? ''
                                : '${snapshot.data.documents[index]['4']}'),
                          ],
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}
