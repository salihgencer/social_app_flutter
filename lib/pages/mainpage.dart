import 'package:flutter/material.dart';
import 'package:social_app/services/authentication.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Anasayfa")),
          SizedBox(height: 15.0,),
          Center(
            child: GestureDetector(
              onTap: () {
                YetkilendirmeServisi().cikisYap();
              },
              child: Text("Çıkış Yap"),
            ),
          ),

        ],
      ),
    );
  }
}
