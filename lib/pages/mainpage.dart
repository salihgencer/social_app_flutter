import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/services/authentication.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final _yetkilendirmeServisi = Provider.of<YetkilendirmeServisi>(context,listen: false);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Anasayfa")),
          SizedBox(height: 15.0,),
          Center(
            child: GestureDetector(
              onTap: () {
                _yetkilendirmeServisi.cikisYap();
              },
              child: Text("Çıkış Yap"),
            ),
          ),

        ],
      ),
    );
  }
}
