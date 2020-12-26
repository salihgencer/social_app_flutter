import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/models/Kullanici.dart';
import 'package:social_app/services/authentication.dart';
import 'package:social_app/services/firestoreservisi.dart';

class ProfilePage extends StatefulWidget {
  final String profileId;

  const ProfilePage({Key key, this.profileId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey[100],
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            color: Colors.black,
            onPressed: _logOut,
          ),
        ],
      ),
      body: FutureBuilder<Object>(
        future: FirestoreServisi().kullaniciGetir(widget.profileId),
        builder: (context, snapshot) {

          if(!snapshot.hasData){
            print("adasdas" + widget.profileId);
            return CircularProgressIndicator();
          }
          else {
            print("asdasdada");
          }

          return ListView(
            children: [
              _profileDetail(snapshot.data),
            ],
          );
        }
      ),
    );
  }

  Widget _profileDetail(Kullanici profileData) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 50.0,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _sosyalSayac("Asd 1", 23),
                    _sosyalSayac("Asd 2", 34),
                    _sosyalSayac("Asd 3", 45),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            profileData.kullaniciAdi,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(profileData.hakkinda),
          SizedBox(
            height: 10.0,
          ),
          _profileEditButton(),
        ],
      ),
    );
  }

  Widget _sosyalSayac(String title, int sayi) {
    return Column(
      children: [
        Text(
          sayi.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 2.0,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _profileEditButton() {
    return Container(
      width: double.infinity,
      child: OutlineButton(
        onPressed: () {},
        child: Text("Düzenle"),
      ),
    );
  }

  void _logOut() {
    Provider.of<YetkilendirmeServisi>(context, listen: false).cikisYap();
  }
}
