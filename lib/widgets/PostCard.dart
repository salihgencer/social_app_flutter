import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/models/Kullanici.dart';
import 'package:social_app/models/Post.dart';
import 'package:social_app/pages/comments.dart';
import 'package:social_app/services/authentication.dart';
import 'package:social_app/services/firestoreservisi.dart';

class PostCard extends StatefulWidget {
  final Post userPost;
  final Kullanici kullanici;

  const PostCard({Key key, this.userPost, this.kullanici}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int _begeniSayisi;
  bool _begenme = false;
  String _aktifKullaniciId;

  begenmeVarmi() async{
    bool begeniVarmi = await FirestoreServisi().begeniVarmi(widget.userPost, _aktifKullaniciId);

    if(begeniVarmi){
      setState(() {
        _begenme = true;
      });
    }
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    _aktifKullaniciId = Provider.of<YetkilendirmeServisi>(context, listen: false).aktifKullaniciId;
    _begeniSayisi = widget.userPost.likeCount;
    begenmeVarmi();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: [
            _gonderiBasligi(),
            _gonderiResmi(),
            _gonderiAltKisim(),
          ],
        ),
      ),
    );
  }

  Widget _gonderiBasligi() {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        backgroundImage: widget.kullanici.fotoUrl.isNotEmpty
            ? NetworkImage(widget.kullanici.fotoUrl)
            : AssetImage("assets/images/ghost_user.png"),
      ),
      title: Text(
        widget.kullanici.kullaniciAdi,
        style: TextStyle(fontSize: 14.0),
      ),
      trailing: IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: null,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _gonderiResmi() {
    return GestureDetector(
      onDoubleTap: _begeniDegistir,
      child: Image.network(
        widget.userPost.postPhotoUrl,
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
      ),
    );
  }

  Widget _gonderiAltKisim() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon:
                  _begenme ? Icon(Icons.favorite, color: Colors.red,) : Icon(Icons.favorite_border),
              onPressed: _begeniDegistir,
            ),
            IconButton(
              icon: Icon(Icons.message),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Comments(userPost: widget.userPost,)));
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            "$_begeniSayisi Beğeni",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 2.0,
        ),
        widget.userPost.description.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                ),
                child: RichText(
                  text: TextSpan(
                      text: widget.kullanici.kullaniciAdi,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: " " + widget.userPost.description,
                          style: TextStyle(fontWeight: FontWeight.normal),
                        )
                      ]),
                ),
              )
            : SizedBox(
                height: 0.0,
              ),
      ],
    );
  }

  void _begeniDegistir() {
    if(_begenme){
      // Begenme kaldırma işlemi yapılacak

      if (mounted) {
        setState(() {
          _begeniSayisi = _begeniSayisi - 1;
          _begenme = false;
        });
      }
      FirestoreServisi().gonderiBegen(widget.userPost, _aktifKullaniciId, favType: "azalt");
    }
    else {
      // Begenme işlemi yapılacak

      if (mounted) {
        setState(() {
          _begeniSayisi = _begeniSayisi + 1;
          _begenme = true;
        });
      }
      FirestoreServisi().gonderiBegen(widget.userPost, _aktifKullaniciId);
    }
  }
}
