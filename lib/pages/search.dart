import 'package:flutter/material.dart';
import 'package:social_app/models/Kullanici.dart';
import 'package:social_app/services/firestoreservisi.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController _searchInput = TextEditingController();
  Future<List<Kullanici>> _kullanicilar;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(),
      body: _kullanicilar != null ? _aramaSonuclari() : _sonucYok(),
    );
  }

  Widget _appBar() {
    return AppBar(
      elevation: 0,
      titleSpacing: 0.0,
      title: TextFormField(
        onFieldSubmitted: (newValue){
          print(newValue);
          if(newValue.isEmpty){
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Lütfen arama alanını boş bırakmayınız.'),
            ));
          }
          else {
            setState((){
              _kullanicilar = FirestoreServisi().kullanicilariSorgula(newValue);
            });
          }
        },
        controller: _searchInput,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.black,),
          suffixIcon: IconButton(
            color: Colors.black,
            icon: Icon(Icons.cancel_rounded),
            onPressed: (){
              _searchInput.clear();
            },
          ),
          border: InputBorder.none,
          hintText: "Kullanıcı Arama",
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget _aramaSonuclari() {
    return FutureBuilder<List<Kullanici>>(
        future: _kullanicilar,
        builder:(context, snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }

          if(snapshot.data.length < 1){
            return Center(child: Text("Kullanıcı Bulunamadı."));
          }

          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context,index){
              Kullanici kullanici = snapshot.data[index];
              return Text(kullanici.id);
            },
          );
        }
    );
  }

  Widget _sonucYok() {
    return Center(child: Text("Sonuç bulunamadı..."));
  }
}
