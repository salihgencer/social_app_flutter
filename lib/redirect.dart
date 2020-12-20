import 'package:flutter/material.dart';
import 'package:social_app/models/Kullanici.dart';
import 'package:social_app/pages/login.dart';
import 'package:social_app/pages/mainpage.dart';
import 'package:social_app/services/authentication.dart';

class Redirect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: YetkilendirmeServisi().durumTakipcisi,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if(snapshot.hasData){
          Kullanici aktifKullanici = snapshot.data;
          return MainPage();
        }
        else {
          return Login();
        }


      },
    );
  }
}
