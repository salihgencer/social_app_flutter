import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_app/services/authentication.dart';
import 'package:social_app/services/firestorageservisi.dart';
import 'package:social_app/services/firestoreservisi.dart';

class UploadPage extends StatefulWidget {

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File dosya;
  bool yukleniyor = false;

  TextEditingController aciklamaController = TextEditingController();
  TextEditingController lokasyonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return dosya == null ? yukleButonu() : gonderiFormu();
  }
  

  Widget yukleButonu(){
    return IconButton(icon: Icon(Icons.upload_rounded, size:250.0), onPressed: (){
      fotografSec();
    });
  }
  
  Widget gonderiFormu(){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(
          "Gönderi oluştur",
          style: TextStyle(
            color: Colors.black
          ),
        ),
        leading: IconButton(
          onPressed: (){
            setState(() {
              dosya = null;
            });
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        actions: [
          IconButton(icon: Icon(Icons.send), onPressed: _gonderiEkle)
        ],
      ),
      body: ListView(
        children: [
          yukleniyor ? LinearProgressIndicator() : SizedBox(height: 0.0,),
          AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: Image.file(
              dosya,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20.0,),
          TextFormField(
            controller: aciklamaController,
            decoration: InputDecoration(
              hintText: "Açıklama Ekle",
              contentPadding: EdgeInsets.only(left: 10, right:10, top: 5, bottom: 5)
            ),
          ),
          SizedBox(height: 10.0,),
          TextFormField(
            controller: lokasyonController,
            decoration: InputDecoration(
                hintText: "Lokasyon",
                contentPadding: EdgeInsets.only(left: 10, right:10, top: 5, bottom: 5)
            ),
          ),
        ],
      ),
    );
  }

  fotografSec(){
    return showDialog(
      context: context,
      builder: (context){
        return SimpleDialog(
          title: Text("Gönderi Oluştur"),
          children: [
            SimpleDialogOption(
              child: Text("Fotoğraf Çek"),
              onPressed: (){
                fotoCek();
              },
            ),
            SimpleDialogOption(
              child: Text("Video Çek"),
              onPressed: (){
                videoCek();
              },
            ),
            SimpleDialogOption(
              child: Text("Galeriden Yükle"),
              onPressed: (){
                galeridenSec();
              },
            ),
            SimpleDialogOption(
              child: Text("iptal"),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }
  
  fotoCek() async{
    Navigator.pop(context);
    var image = await ImagePicker().getImage(source: ImageSource.camera, maxWidth: 1920, maxHeight: 1080, imageQuality: 80);
    setState(() {
      dosya = File(image.path);
    });

  }

  videoCek() async{
    Navigator.pop(context);
    var video = await ImagePicker().getVideo(source: ImageSource.camera, maxDuration: Duration(seconds: 60));
    setState(() {
      dosya = File(video.path);
    });

  }

  galeridenSec() async{
    Navigator.pop(context);
    var image = await ImagePicker().getImage(source: ImageSource.gallery, maxWidth: 1920, maxHeight: 1080, imageQuality: 80);
    setState(() {
      dosya = File(image.path);
    });

  }


  _gonderiEkle() async{


    if(!yukleniyor){
      setState(() {
        yukleniyor = true;
      });

      String aktifKullaniciId = Provider.of<YetkilendirmeServisi>(context, listen: false).aktifKullaniciId;

      String aciklama = aciklamaController.text;
      String lokasyon = lokasyonController.text;
      try{
        String resimUrl = await FirabeseStorageServisi().gonderiResmiYukle(dosya, aktifKullaniciId);
        String gonderiId = await FirestoreServisi().gonderiEkle(aciklama: aciklama, lokasyon: lokasyon, userId: aktifKullaniciId, resimUrl: resimUrl);
        if(gonderiId.length > 0) {
          // sayfayı ana sayfaya gönderebiliriz.
        }
      }
      catch(e){
        print(e);
      }

      setState(() {
        yukleniyor = false;
        dosya = null;
        aciklamaController.clear();
        lokasyonController.clear();
      });
    }
  }
}
