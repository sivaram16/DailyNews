import 'package:flutter/material.dart';
import 'package:bottom_bar/bottomDrawers/sports.dart';
import 'bottomDrawers/tech.dart';
import 'bottomDrawers/health.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class mainscreen extends StatefulWidget {
  @override
  _mainscreenState createState() => _mainscreenState();
}

class _mainscreenState extends State<mainscreen> {
  int IndexNum = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.white,
        backgroundColor: Colors.black,
        items: <Widget>[
          Icon(Icons.stars, size: 30),
          Icon(Icons.local_hospital, size: 30),
          Icon(Icons.live_tv, size: 30),
        ],
        onTap: (index) {
          setState(() {
            IndexNum = index;
          });
        },
      ),
      body: Container(
        color: Colors.black,
        child: operation(),
      ),
    );
  }

  Widget operation() {
    if (IndexNum == 0) {
      return Sports(post: fetchPostSports());
    } else if (IndexNum == 1) {
      return Health(post: fetchPostHealth());
    } else {
      return Technology(post: fetchPostTechnology());
    }
  }
}
