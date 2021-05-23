import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StatusPage extends StatefulWidget {
  final String id;
  final String address;
  final double latitude;
  final double longitude;
  final int status;
  final int year;
  final String color;
  StatusPage(
      {@required this.id,
      @required this.address,
      @required this.latitude,
      @required this.longitude,
      @required this.status,
      @required this.year,
      @required this.color});
  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future<void> initMarker(color, latitude, longitude, address, id) async {
    var markerIdval = id;
    final Uint8List markerIconRed =
        await getBytesFromAsset('assets/red-light.png', 80);
    final Uint8List markerIconYellow =
        await getBytesFromAsset('assets/yellow-light.png', 60);
    final Uint8List markerIconGreen =
        await getBytesFromAsset('assets/green-light.png', 60);
    final MarkerId markerId = MarkerId(markerIdval);
    final Marker marker = Marker(
        markerId: markerId,
        icon: BitmapDescriptor.fromBytes(color == "red"
            ? markerIconRed
            : color == "yellow"
                ? markerIconYellow
                : markerIconGreen),
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(title: "สัญญาณไฟ", snippet: address));
    setState(() {
      markers[markerId] = marker;
    });
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initMarker(widget.color, widget.latitude, widget.longitude, widget.address,
        widget.id);
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
        body: ListView(
          children: [
            Container(
              width: a.width,
              height: a.width / 2.5,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300].withOpacity(0.4),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(a.width / 25)),
              margin: EdgeInsets.all(a.width / 50),
              padding: EdgeInsets.all(a.width / 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Address : ${widget.address}",
                    style: TextStyle(
                        color: Colors.grey[700], fontSize: a.width / 25),
                  ),
                  Text(
                    "Location(latitude) :  ${widget.latitude.toStringAsFixed(4)}",
                    style: TextStyle(
                        color: Colors.grey[700], fontSize: a.width / 25),
                  ),
                  Text(
                    "Location(longitude) : ${widget.longitude.toStringAsFixed(4)} ",
                    style: TextStyle(
                        color: Colors.grey[700], fontSize: a.width / 25),
                  ),
                  Text(
                    widget.status == 0
                        ? "Status : normal"
                        : widget.status == 1
                            ? "Status : repair"
                            : 'Status : damaged',
                    style: TextStyle(
                        color: Colors.grey[700], fontSize: a.width / 25),
                  ),
                  Text(
                    "Service life : ${widget.year} years",
                    style: TextStyle(
                        color: Colors.grey[700], fontSize: a.width / 25),
                  ),
                ],
              ),
            ),
            Container(
              width: a.width,
              height: a.width,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300].withOpacity(0.4),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(a.width / 25)),
              margin: EdgeInsets.all(a.width / 50),
              child: GoogleMap(
                zoomGesturesEnabled: true,
                markers: Set<Marker>.of(markers.values),
                initialCameraPosition: CameraPosition(
                    target: LatLng(widget.latitude, widget.longitude),
                    zoom: 15),
                mapType: MapType.hybrid,
                trafficEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  // myController = controller;
                  // _controller.complete(controller);
                },
              ),
            ),
            Container(
              width: a.width,
              height: a.width / 4,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300].withOpacity(0.4),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(a.width / 25)),
              margin: EdgeInsets.all(a.width / 50),
              padding: EdgeInsets.all(a.width / 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.status == 0
                        ? "Status : normal"
                        : widget.status == 1
                            ? "Status : repair"
                            : 'Status : damaged',
                    style: TextStyle(
                        color: Colors.grey[700], fontSize: a.width / 25),
                  ),
                  SizedBox(
                    height: a.width / 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          if (widget.status == 1) {
                            print('repair');
                          } else {
                            Firestore.instance
                                .collection("data")
                                .document(widget.id)
                                .updateData({"status": 1});
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          width: a.width / 4,
                          height: a.width / 12,
                          decoration: BoxDecoration(
                              color: widget.status == 1
                                  ? Color(0xff01AD23)
                                  : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[300].withOpacity(0.4),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(a.width)),
                          alignment: Alignment.center,
                          child: Text(
                            "repair",
                            style: TextStyle(
                                color: widget.status == 1
                                    ? Colors.white
                                    : Colors.grey[700]),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (widget.status == 0) {
                            print('normal');
                          } else {
                            Firestore.instance
                                .collection("data")
                                .document(widget.id)
                                .updateData({"status": 0});
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          width: a.width / 4,
                          height: a.width / 12,
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
                              color: widget.status == 0
                                  ? Color(0xff01AD23)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(a.width)),
                          alignment: Alignment.center,
                          child: Text(
                            "normal",
                            style: TextStyle(
                                color: widget.status == 0
                                    ? Colors.white
                                    : Colors.grey[700]),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (widget.status == 2) {
                            print('normal');
                          } else {
                            Firestore.instance
                                .collection("data")
                                .document(widget.id)
                                .updateData({"status": 2});
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          width: a.width / 4,
                          height: a.width / 12,
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
                              color: widget.status == 2
                                  ? Color(0xff01AD23)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(a.width)),
                          alignment: Alignment.center,
                          child: Text(
                            "damaged",
                            style: TextStyle(
                                color: widget.status == 2
                                    ? Colors.white
                                    : Colors.grey[700]),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
