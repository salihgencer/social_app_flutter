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

  int _gonderiSayisi = 0;
  int _takipciSayisi = 0;
  int _takipSayisi = 0;

  _takipciSayisiGetir() async {
    int takipci = await FirestoreServisi().takipciSayisi(widget.profileId);
    print(takipci);
    setState(() {
      _takipciSayisi = takipci;
    });
  }

  _takipEdilenSayisiGetir() async {
    int takipEdilen = await FirestoreServisi().takipEdilenSayisi(widget.profileId);
    setState(() {
      _takipSayisi = takipEdilen;
    });
  }

  @override
  void initState() {
    super.initState();
    _takipciSayisiGetir();
    _takipEdilenSayisiGetir();
  }

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
            return CircularProgressIndicator();
          }
          else {
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
    var userPhoto = profileData.fotoUrl.isNotEmpty ? NetworkImage(profileData.fotoUrl) : AssetImage("assets/images/ghost_user.png");
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
                backgroundImage: userPhoto,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _sosyalSayac(title:"Gönderiler", count:_gonderiSayisi),
                    _sosyalSayac(title:"Takipçi", count:_takipciSayisi),
                    _sosyalSayac(title:"Takip", count:_takipSayisi),
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

  Widget _sosyalSayac({String title, int count}) {
    return Column(
      children: [
        Text(
          count.toString(),
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
