import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/models/Comment.dart';
import 'package:social_app/models/Kullanici.dart';
import 'package:social_app/models/Post.dart';
import 'package:social_app/services/authentication.dart';
import 'package:social_app/services/firestoreservisi.dart';
import 'package:timeago/timeago.dart' as timeago;

class Comments extends StatefulWidget {
  final Post userPost;

  const Comments({Key key, this.userPost}) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  String _aktifKullaniciId;
  TextEditingController _yorumAlani = TextEditingController();

  @override
  void initState() {
    super.initState();
    _aktifKullaniciId = Provider.of<YetkilendirmeServisi>(context, listen: false).aktifKullaniciId;
    timeago.setLocaleMessages("tr", timeago.TrMessages());
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          title: Text("Yorumlar"),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        body: Column(
          children: [
            _yorumlariGoster(),
            _yorumEkle(),
          ],
        ),
      ),
    );
  }
  
  Widget _yorumSatiri(Comment comment){
    return FutureBuilder<Kullanici>(
      future: FirestoreServisi().kullaniciGetir(comment.userId),
      builder: (context, snapshot) {
        if(!snapshot.hasData || snapshot.data == null){
          return SizedBox(height: 0.0,);
        }
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            backgroundImage: snapshot.data.fotoUrl.isNotEmpty ? NetworkImage(snapshot.data.fotoUrl) : AssetImage("assets/images/ghost_user.png"),
          ),
          title: RichText(
            text: TextSpan(
                text: snapshot.data.kullaniciAdi + " ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: comment.comment,
                    style: TextStyle(fontWeight: FontWeight.normal),
                  )
                ]),
          ),
          subtitle: Text(timeago.format(comment.createdTime.toDate(), locale: "tr") ),
        );
      },
    );
  }
  Widget _yorumlariGoster() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirestoreServisi().yorumlariGetir(widget.userPost.id),
        builder: (context, snapshot) {

          if(!snapshot.hasData || snapshot.data == null){
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              Comment yorum = Comment.documandanUret(snapshot.data.docs[index]);
              return _yorumSatiri(yorum);
            },
          );
        }
      ),
    );
  }

  Widget _yorumEkle() {
    return ListTile(
      title: TextFormField(
        controller: _yorumAlani,
        decoration: InputDecoration(
          hintText: "Yorum yazın..."
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.send),
        onPressed: (){
          String yorum = _yorumAlani.text;
          FirestoreServisi().yorumGonder(yorum: yorum, postId: widget.userPost.id, userId: _aktifKullaniciId);
          _yorumAlani.clear();
          print("Gönder...");
        },
      ),
    );
  }
}
