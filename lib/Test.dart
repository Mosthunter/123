import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traf/AITrafiic.dart';
import 'package:traf/AddressNav.dart';
import 'package:traf/Addtraffic.dart';
import 'package:traf/Consult.dart';
import 'package:traf/widget/changelight.dart';
import 'dart:math' as math;

class MapsData extends StatefulWidget {
  _MapsDataState createState() => _MapsDataState();
}

//7.009460298757617, 100.47474021941028
class _MapsDataState extends State<MapsData> {
  int type = 0;
  int page = 0;
  String address;
  String addressto;
  int oldMass;
  String dStatus;
  String nal;
  String id;
  String Colorlight = "red";
  int color = 0xffA30001;
  String col;
  int stus = 0;
  int settime2 = 0;
  double per;
  double aitime;
  var latitude;
  var longitude;
  var pinPosition = LatLng(7.009460298757617, 100.47474021941028);

  String textC = "Change";

  GoogleMapController myController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Completer<GoogleMapController> _controller = Completer();
  Future<void> initMarker(specify, specifyId) async {
    var markerIdval = specifyId;
    final Uint8List markerIconRed =
        await getBytesFromAsset('assets/red-light.png', 80);
    final Uint8List markerIconYellow =
        await getBytesFromAsset('assets/yellow-light.png', 60);
    final Uint8List markerIconGreen =
        await getBytesFromAsset('assets/green-light.png', 60);
    final MarkerId markerId = MarkerId(markerIdval);
    final Marker marker = Marker(
      markerId: markerId,
      onTap: () {
        if (specify['status'] == 0) {
          print("ปกติ");
          setState(() {
            dStatus = "normal";
            stus = 0;
          });
        } else if (specify['status'] == 1) {
          print("ปกติ");
          setState(() {
            dStatus = "repair";
            stus = 1;
          });
        } else if (specify['status'] == 2) {
          setState(() {
            dStatus = "Damaged";
            stus = 2;
          });
        }
        setState(() {
          page = 1;
          nal = '${specify['address'][3]}';
          addressto =
              "${specify['address'][0]}${specify['address'][1]}${specify['address'][2]}";
          address =
              "${specify['address'][0]}${specify['address'][1]}${specify['address'][2]}${specify['address'][3]}";
          oldMass = specify['old'];
          id = specifyId;
          col = specify['color'];
          latitude = specify['location'].latitude;
          longitude = specify['location'].longitude;
        });
      },
      icon: BitmapDescriptor.fromBytes(specify['color'] == "red"
          ? markerIconRed
          : specify['color'] == "yellow"
              ? markerIconYellow
              : markerIconGreen),
      position:
          LatLng(specify['location'].latitude, specify['location'].longitude),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() async {
    Firestore.instance.collection("data").getDocuments().then((myMockData) {
      if (myMockData.documents.isNotEmpty) {
        for (int i = 0; i < myMockData.documents.length; i++) {
          initMarker(
              myMockData.documents[i].data, myMockData.documents[i].documentID);
        }
      }
    });
  }

  getV() async {
    var result = await Firestore.instance
        .collection("group")
        .document("${addressto}")
        .get();

    if (result.data['type'] == "3") {
      double num1 = result.data["dataCar"][int.parse(nal) - 1] /
          (result.data["dataCar"][0] +
              result.data["dataCar"][1] +
              result.data["dataCar"][2]) *
          120;
      double per1 = result.data['a${int.parse(nal)}'] / num1 * 100;
      setState(() {
        settime2 = result.data['a${nal}'];
        per = per1;
        aitime = num1;
      });
    } else {
      double num2 = result.data["dataCar"][int.parse(nal) - 1] /
          (result.data["dataCar"][0] +
              result.data["dataCar"][1] +
              result.data["dataCar"][2] +
              result.data["dataCar"][3]) *
          120;
      double per2 = result.data['a${int.parse(nal)}'] / num2 * 100;
      setState(() {
        settime2 = result.data['a${nal}'];
        per = per2;
        aitime = num2;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getMarkerData();
    super.initState();
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    // these are the minimum required values to set
    // the camera position
    CameraPosition initialLocation =
        CameraPosition(zoom: 14, target: pinPosition);

    return Scaffold(
      key: _drawerKey,
      body: Stack(
        children: [
          GoogleMap(
            zoomGesturesEnabled: true,
            markers: Set<Marker>.of(markers.values),
            initialCameraPosition:
                CameraPosition(target: pinPosition, zoom: 15),
            mapType: MapType.terrain,
            trafficEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              myController = controller;
              _controller.complete(controller);
            },
          ),
          page == 3
              ? Positioned(
                  child: Container(
                  width: a.width,
                  height: a.width / 1.8,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff6E6E6E).withOpacity(0.45),
                          spreadRadius: 0,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(a.width / 20),
                          bottomRight: Radius.circular(a.width / 20))),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: a.width / 10,
                            left: a.width / 20,
                            right: a.width / 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                getMarkerData();
                                setState(() {
                                  page = 0;
                                });
                              },
                              child: Icon(
                                Icons.keyboard_backspace,
                                size: a.width / 15,
                              ),
                            ),
                            Text(
                              "Menu",
                              style: TextStyle(
                                  fontSize: a.width / 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.keyboard_backspace,
                              size: a.width / 15,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: a.width / 15),
                      Container(
                        margin: EdgeInsets.only(
                            left: a.width / 20, right: a.width / 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Addtraffic(),
                                    ));
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.archive,
                                      color: Color(0xff4A778C),
                                      size: a.width / 8),
                                  SizedBox(height: a.width / 40),
                                  Text(
                                    "Addtraffic",
                                    style: TextStyle(
                                        fontSize: a.width / 40,
                                        color: Color(0xff4A778C)),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: a.width / 5,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffE3E3E3))),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AItraffic(),
                                    ));
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.inbox,
                                      color: Color(0xff3DBCBD),
                                      size: a.width / 8),
                                  SizedBox(height: a.width / 40),
                                  Text(
                                    "AItraffic",
                                    style: TextStyle(
                                        fontSize: a.width / 40,
                                        color: Color(0xff3DBCBD)),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: a.width / 5,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffE3E3E3))),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Consult(),
                                    ));
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.android_outlined,
                                      color: Color(0xff01D298),
                                      size: a.width / 8),
                                  SizedBox(height: a.width / 40),
                                  Text(
                                    "Consult",
                                    style: TextStyle(
                                        fontSize: a.width / 40,
                                        color: Color(0xff01D298)),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ))
              : Container(),
          page == 3
              ? Container()
              : Positioned(
                  top: 0,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        page = 3;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: a.width / 10, left: a.width / 20),
                      child: Icon(
                        Icons.menu,
                        size: a.width / 15,
                      ),
                    ),
                  )),
          page == 1 || page == 2
              ? Positioned(
                  top: a.width / 4,
                  child: InkWell(
                    onTap: () {
                      print(settime2);
                      getV();
                      if (page == 1) {
                        setState(() {
                          page = 2;
                        });
                      } else {
                        setState(() {
                          page = 1;
                        });
                      }
                    },
                    child: Container(
                      width: a.width,
                      padding: EdgeInsets.only(
                          left: a.width / 7.5, right: a.width / 7.5),
                      child: Container(
                        height: a.width / 10,
                        padding: EdgeInsets.only(
                            left: a.width / 30, right: a.width / 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(a.width / 50),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff6E6E6E).withOpacity(0.45),
                                spreadRadius: 0,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: a.width / 30,
                                  color: Color(col == 'red'
                                      ? 0xffCC0000
                                      : col == 'yellow'
                                          ? 0xffCFAF19
                                          : 0xff08A923),
                                ),
                                SizedBox(width: a.width / 40),
                                Text("Address : ${address}",
                                    style: TextStyle(
                                        fontSize: a.width / 30,
                                        color: Color(0xff4A778C),
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            Transform(
                              alignment: Alignment.center,
                              transform: dStatus == "repair"
                                  ? Matrix4.rotationY(math.pi)
                                  : Matrix4.rotationY(math.pi / 50),
                              child: Icon(
                                  dStatus == "normal"
                                      ? null
                                      : dStatus == "repair"
                                          ? Icons.build
                                          : Icons.flash_off,
                                  color: Color(dStatus == "repair"
                                      ? 0xffFBB311
                                      : 0xffCC0000),
                                  size: a.width / 20),
                            )
                          ],
                        ),
                      ),
                    ),
                  ))
              : Container(),
          page == 1
              ? Positioned(
                  right: 0,
                  top: a.height / 3.5,
                  child: Container(
                    width: a.width / 5.5,
                    padding: EdgeInsets.only(
                        top: a.width / 40, bottom: a.width / 40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(a.width / 20),
                        bottomLeft: Radius.circular(a.width / 20),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff6E6E6E).withOpacity(0.45),
                          spreadRadius: 0,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        dStatus == "normal"
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    col = "red";
                                  });
                                },
                                child: Col1(
                                    text1: 'Red',
                                    icon1: Icons.swap_vertical_circle,
                                    color1:
                                        col == "red" ? 0xffCC0000 : 0xff9B9EAB),
                              )
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    dStatus = "normal";
                                    col = "red";
                                  });
                                },
                                child: Col1(
                                    text1: 'Red',
                                    icon1: Icons.swap_vertical_circle,
                                    color1: 0xff9B9EAB),
                              ),
                        SizedBox(height: a.width / 40),
                        dStatus == "normal"
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    col = "yellow";
                                  });
                                },
                                child: Col1(
                                    text1: 'Yellow',
                                    icon1: Icons.swap_vertical_circle,
                                    color1: col == "yellow"
                                        ? 0xffCFAF19
                                        : 0xff9B9EAB),
                              )
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    dStatus = "normal";
                                    col = "yellow";
                                  });
                                },
                                child: Col1(
                                    text1: 'Yellow',
                                    icon1: Icons.swap_vertical_circle,
                                    color1: 0xff9B9EAB),
                              ),
                        SizedBox(height: a.width / 40),
                        dStatus == "normal"
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    col = "green";
                                  });
                                },
                                child: Col1(
                                    text1: 'Green',
                                    icon1: Icons.swap_vertical_circle,
                                    color1: col == "green"
                                        ? 0xff08A923
                                        : 0xff9B9EAB),
                              )
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    dStatus = "normal";
                                    col = "green";
                                  });
                                },
                                child: Col1(
                                    text1: 'Grenn',
                                    icon1: Icons.swap_vertical_circle,
                                    color1: 0xff9B9EAB),
                              ),
                        SizedBox(height: a.width / 40),
                        InkWell(
                          onTap: () {
                            setState(() {
                              dStatus = "repair";
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                'repair',
                                style: TextStyle(
                                    color: Color(dStatus == "repair"
                                        ? 0xffFBB311
                                        : 0xff9B9EAB),
                                    fontSize: a.width / 30),
                              ),
                              Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(math.pi),
                                child: Icon(Icons.build,
                                    color: Color(dStatus == "repair"
                                        ? 0xffFBB311
                                        : 0xff9B9EAB),
                                    size: a.width / 10),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: a.width / 40),
                        InkWell(
                          onTap: () {
                            setState(() {
                              dStatus = "Damaged";
                            });
                          },
                          child: Col1(
                              text1: 'Damaged',
                              icon1: Icons.flash_off,
                              color1: dStatus == "Damaged"
                                  ? 0xffCC0000
                                  : 0xff9B9EAB),
                        )
                      ],
                    ),
                  ),
                )
              : Container(),
          page == 1
              ? Positioned(
                  bottom: 0,
                  child: InkWell(
                    onTap: () {
                      dStatus != "normal"
                          ? Firestore.instance
                              .collection('data')
                              .document(id)
                              .updateData({
                              //  'color': "${col}",
                              'status': dStatus == 'normal'
                                  ? 0
                                  : dStatus == 'repair'
                                      ? 1
                                      : 2
                            })
                          : Firestore.instance
                              .collection('data')
                              .document(id)
                              .updateData({
                              'color': "${col}",
                              'status': dStatus == 'normal'
                                  ? 0
                                  : dStatus == 'repair'
                                      ? 1
                                      : 2
                            });
                      getMarkerData();
                    },
                    child: Container(
                      width: a.width,
                      margin: EdgeInsets.only(bottom: a.width / 15),
                      padding: EdgeInsets.only(
                          left: a.width / 6, right: a.width / 6),
                      child: Container(
                        height: a.width / 7,
                        decoration: BoxDecoration(
                            color: Color(0xffFBB311),
                            borderRadius: BorderRadius.circular(a.width)),
                        alignment: Alignment.center,
                        child: Text(
                          "Change now!",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: a.width / 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ))
              : Container(),
          page == 2
              ? Positioned(
                  bottom: 0,
                  child: AddressNav(
                    col: col == "red"
                        ? 0xffC70607
                        : col == "yellow"
                            ? 0xffCEAE13
                            : 0xff07A924,
                    address: address,
                    latitude: latitude.toStringAsFixed(6),
                    longitude: longitude.toStringAsFixed(6),
                    life: oldMass,
                    settime: settime2,
                    id: id,
                    addressto: addressto,
                    nal: nal,
                    per: per,
                    aitime: aitime,
                  ))
              : Container()
        ],
      ),
    );
  }
}

class Col1 extends StatefulWidget {
  final String text1;
  final IconData icon1;
  final int color1;

  Col1({@required this.text1, @required this.icon1, @required this.color1});
  @override
  _Col1State createState() => _Col1State();
}

class _Col1State extends State<Col1> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          widget.text1,
          style: TextStyle(color: Color(widget.color1), fontSize: a.width / 40),
        ),
        SizedBox(height: a.width / 70),
        Icon(widget.icon1, color: Color(widget.color1), size: a.width / 10)
      ],
    );
  }
}
