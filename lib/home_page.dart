import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:savvy_parking_management/authentication_service.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MapUtils {
  MapUtils._();
  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunch(googleUrl.toString())) {
      await launch(googleUrl.toString());
    } else {
      throw 'Could not open the map.';
    }
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int mothiSlots = Random().nextInt(100);
  int spSlots = Random().nextInt(100);
  int royalSlots = Random().nextInt(100);
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      mothiSlots = Random().nextInt(100);
      spSlots = Random().nextInt(100);
      royalSlots = Random().nextInt(100);
    });
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  final snackBar = SnackBar(
    content: Text('Your Slot is Successfully Booked.'),
  );
  final slotFull = SnackBar(
    content: Text('Sorry Slots Are Full. Try After Sometime.'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              GestureDetector(
                onLongPress: () {
                  setState(() {
                    mothiSlots = 87;
                    spSlots = 56;
                    royalSlots = 67;
                  });
                },
                child: ImageIcon(
                  AssetImage('assets/logo.png'),
                ),
              ),
              SizedBox(width: 10.0),
              Text('Savvy Parking Management'),
            ],
          ),
          actions: [
            //list if widget in appbar actions
            PopupMenuButton(
              color: Colors.white,
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  // color: Colors.white,

                  value: 0,
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text("Logout"),
                    ],
                  ),
                ),
              ],
              onSelected: (item) =>
                  {context.read<AuthenticationService>().signOut()},
            ),
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth <= 600) {
            return SmartRefresher(
              physics: BouncingScrollPhysics(),
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                children: cardList(context),
              ),
            );
          } else if (constraints.maxWidth <= 850) {
            return SmartRefresher(
                physics: BouncingScrollPhysics(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: cardList(context),
                ));
          } else if (constraints.maxWidth <= 1300) {
            return SmartRefresher(
                physics: BouncingScrollPhysics(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  children: cardList(context),
                ));
          } else {
            return SmartRefresher(
                physics: BouncingScrollPhysics(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 4,
                  children: cardList(context),
                ));
          }
        }));
  }

  Widget _buildPopupDialog(BuildContext context, String location) {
    return new AlertDialog(
      // insetPadding: EdgeInsets.zero,
      // contentPadding: EdgeInsets.zero,
      // clipBehavior: Clip.antiAliasWithSaveLayer,

      title: const Text('Book Parking Slot'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            location,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: Colors.grey),
          ),
          SizedBox(height: 10.0),
          Text('Select Slot Timing',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0)),
          TextField(
            decoration: InputDecoration(
                labelText: "From",
                labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]))),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0, 0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "To",
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue[900]))),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: Colors.blue)),
                style: OutlinedButton.styleFrom(
                  shape: StadiumBorder(),
                  side: BorderSide(width: 2, color: Color(0xff212121)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (location == 'Mothi Circle') {
                    if (mothiSlots == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(slotFull);
                    } else {
                      setState(() {
                        mothiSlots -= 1;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  } else if (location == 'SP Circle') {
                    if (spSlots == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(slotFull);
                    } else {
                      setState(() {
                        spSlots -= 1;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  } else if (location == 'Royal Circle') {
                    if (royalSlots == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(slotFull);
                    } else {
                      setState(() {
                        royalSlots -= 1;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }

                  Navigator.of(context).pop();
                },
                child: Text(
                  "Book",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
                style: ElevatedButton.styleFrom(shape: StadiumBorder()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> cardList(BuildContext context) {
    return [
      Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: Color(0xFFF5F5F5),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/mothi.JPG',
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                alignment: Alignment.bottomLeft,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text('Mothi Circle',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                              color: Colors.black)),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Available Slots:',
                              style: TextStyle(color: Colors.grey)),
                          Text(' $mothiSlots',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                MapUtils.openMap(15.1423139, 76.9204066);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.near_me,
                                    color: Colors.black,
                                    size: 15.0,
                                  ),
                                  SizedBox(width: 10.00),
                                  Text('View',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.black)),
                                ],
                              ),
                              style: OutlinedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  side: BorderSide(
                                      width: 1.5, color: Colors.blueAccent))),
                          OutlinedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialog(
                                          context, "Mothi Circle"),
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.car_repair,
                                    color: Colors.black,
                                    size: 15.0,
                                  ),
                                  SizedBox(width: 10.00),
                                  Text('Book',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.black)),
                                ],
                              ),
                              style: OutlinedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  side: BorderSide(
                                      width: 1.5, color: Colors.green))),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: Color(0xFFF5F5F5),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/royal.jpg',
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                alignment: Alignment.bottomLeft,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text('Royal Circle',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                              color: Colors.black)),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Available Slots:',
                              style: TextStyle(color: Colors.grey)),
                          Text(' $royalSlots',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                MapUtils.openMap(15.144913, 76.927945);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.near_me,
                                    color: Colors.black,
                                    size: 15.0,
                                  ),
                                  SizedBox(width: 10.00),
                                  Text('View',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.black)),
                                ],
                              ),
                              style: OutlinedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  side: BorderSide(
                                      width: 1.5, color: Colors.blueAccent))),
                          OutlinedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialog(
                                    context,
                                    "Royal Circle",
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.car_repair,
                                    color: Colors.black,
                                    size: 15.0,
                                  ),
                                  SizedBox(width: 10.00),
                                  Text('Book',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.black)),
                                ],
                              ),
                              style: OutlinedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  side: BorderSide(
                                      width: 1.5, color: Colors.green))),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: Color(0xFFF5F5F5),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/sp.jpg',
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                alignment: Alignment.bottomLeft,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text('SP Circle',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                              color: Colors.black)),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Available Slots:',
                              style: TextStyle(color: Colors.grey)),
                          Text(' $spSlots',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                MapUtils.openMap(15.152093, 76.921060);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.near_me,
                                    color: Colors.black,
                                    size: 15.0,
                                  ),
                                  SizedBox(width: 10.00),
                                  Text('View',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.black)),
                                ],
                              ),
                              style: OutlinedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  side: BorderSide(
                                      width: 1.5, color: Colors.blueAccent))),
                          OutlinedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialog(
                                    context,
                                    "SP Circle",
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.car_repair,
                                    color: Colors.black,
                                    size: 15.0,
                                  ),
                                  SizedBox(width: 10.00),
                                  Text('Book',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.black)),
                                ],
                              ),
                              style: OutlinedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  side: BorderSide(
                                      width: 1.5, color: Colors.green))),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ];
  }
}
