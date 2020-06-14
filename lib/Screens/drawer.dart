import 'package:app/Screens/general_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerClass extends StatelessWidget {
  GeneralStyle style = GeneralStyle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: style.colorScheme[0],
      body: Column(
        children: <Widget>[
          SizedBox(height: 35),
          avatar(context),
          SizedBox(height: 35),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Column(
                children: [
                  element(Icons.home, "Home",
                      () => Navigator.pushReplacementNamed(context, "/home")),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.blueGrey.withAlpha(30),
                  ),
                  element(
                      Icons.info_outline,
                      "Profile",
                      () =>
                          Navigator.pushReplacementNamed(context, "/profile")),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.blueGrey.withAlpha(30),
                  ),
                  element(
                      Icons.message,
                      "Help & Support",
                      () => Navigator.pushReplacementNamed(
                          context, "/helpsupport")),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Column(
                children: [
                  element(
                      Icons.settings,
                      "Settings",
                      () => Navigator.pushReplacementNamed(
                          context, "/profileSettings")),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.blueGrey.withAlpha(30),
                  ),
                  element(
                      Icons.help,
                      "Help",
                      () => Navigator.pushReplacementNamed(
                          context, "/helpsupport")),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.blueGrey.withAlpha(30),
                  ),
                  element(
                      Icons.message,
                      "Help ",
                      () => Navigator.pushReplacementNamed(
                          context, "/helpsupport")),
                ],
              ),
            ),
          ),
          logOut(context),
        ],
      ),
    );
  }

  sizeBox() {
    return SizedBox(
      height: 15.0,
    );
  }

  element(IconData icon, String text, Function navigat) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: navigat,
      child: Container(
        color: style.colorScheme[3],
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.blueGrey,
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    text,
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.blueGrey),
            ],
          ),
        ),
      ),
    );
  }

  avatar(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => Navigator.pushReplacementNamed(context, "/profile"),
        child: Container(
          decoration: BoxDecoration(
            color: style.colorScheme[3],
            borderRadius: BorderRadius.circular(10)
          ),
          height: 80,
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image(
                          image: AssetImage("assets/images/profile1.png"),
                          width: 50.0,
                        )),
                    SizedBox(width: 10.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ELMASLOUHY Mouaad",
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "Morocco",
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.blueGrey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  logOut(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Column(
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, "/Logout"), // log out
              child: Container(
                color: style.colorScheme[3],
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.power_settings_new,
                            color: Colors.blueGrey,
                          ),
                          SizedBox(width: 20.0),
                          Text(
                            "Log Out",
                            style: TextStyle(
                                fontSize: 18.0, color: Colors.redAccent),
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.blueGrey),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
