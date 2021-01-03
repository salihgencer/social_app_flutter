import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/Kullanici.dart';
import 'package:social_app/pages/profile.dart';
import 'package:social_app/services/firestorageservisi.dart';
import 'package:social_app/services/firestoreservisi.dart';

class ProfileEdit extends StatefulWidget {
  final String userId;

  const ProfileEdit({Key key, this.userId}) : super(key: key);

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final _profileEditFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _username;
  String _about;
  String _photoUrl;
  File dosya;
  bool _yukleniyor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Profil Düzenleme"),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.send_sharp),
            onPressed: () async {
              //Klavyeyi kaptıyoruz.
              FocusScope.of(context).requestFocus(new FocusNode());
              // Validate Ediyoruz.
              if (_profileEditFormKey.currentState.validate()) {
                setState(() {
                  _yukleniyor = true;
                });
                // Girilen bilgileir değişkene gidiyor.
                _profileEditFormKey.currentState.save();
                // Kullanıcıyı bilgilendirici bir mesaj çıkartıyoruz.
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text('Güncelleme işlemi başlatıldı.'),
                ));

                if(dosya != null){
                  _photoUrl = await FirabeseStorageServisi().profilResmiYukle(dosya, widget.userId);
                }

                await FirestoreServisi().kullaniciGuncelle(id: widget.userId, kullaniciAdi: _username, hakkinda: _about, fotoUrl: _photoUrl);
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text('Güncelleme işlemi tamamlandı.'),
                ));
                setState(() {
                  _yukleniyor = false;
                });
                Navigator.pop(context);
              }
              else {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text('Lütfen hataları kontrol ediniz.'),
                ));
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Kullanici>(
          future: FirestoreServisi().kullaniciGetir(widget.userId),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            }

            _photoUrl = snapshot.data.fotoUrl;

            return Form(
              key: _profileEditFormKey,
              child: Column(
                children: [
                  _yukleniyor ? LinearProgressIndicator() : SizedBox(height: 0.0,),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: InkWell(
                      onTap: (){
                        galeridenSec();
                      },
                      child: CircleAvatar(
                        backgroundImage: dosya == null ? NetworkImage(snapshot.data.fotoUrl): FileImage(dosya),
                        radius: 55.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    initialValue: snapshot.data.kullaniciAdi,
                    decoration: InputDecoration(
                      hintText: "Kullanıcı Adı...",
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Lütfen boş bırakmayınız.";
                      } else if (value.length < 3) {
                        return "Lütfen en az 3 karakter giriniz.";
                      }

                      return null;
                    },
                    onSaved: (newValue) {
                      _username = newValue;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    initialValue: snapshot.data.hakkinda,
                    decoration: InputDecoration(
                      hintText: "Hakkında...",
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Lütfen boş bırakmayınız.";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _about = newValue;
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }

  galeridenSec() async{
    var image = await ImagePicker().getImage(source: ImageSource.gallery, maxWidth: 1920, maxHeight: 1080, imageQuality: 80);
    setState(() {
      dosya = File(image.path);
    });

  }
}
