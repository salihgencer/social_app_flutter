import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/Kullanici.dart';
import 'package:social_app/models/Post.dart';

class PostCard extends StatefulWidget {
  final Post userPost;
  final Kullanici kullanici;

  const PostCard({Key key, this.userPost, this.kullanici}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
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
        backgroundImage: widget.kullanici.fotoUrl.isNotEmpty ? NetworkImage(widget.kullanici.fotoUrl) : AssetImage("assets/images/ghost_user.png"),
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
    return Image.network(
      widget.userPost.postPhotoUrl,
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
    );
  }

  Widget _gonderiAltKisim(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(icon: Icon(Icons.favorite_border),),
            IconButton(icon: Icon(Icons.message),),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left:10.0),
          child: Text("${widget.userPost.likeCount} Beğeni", style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        SizedBox(height: 2.0,),
        widget.userPost.description.isNotEmpty ? Padding(
          padding: const EdgeInsets.only(left:10.0,),
          child: RichText(
            text: TextSpan(
              text: widget.kullanici.kullaniciAdi,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: " "+widget.userPost.description,
                  style: TextStyle(
                    fontWeight: FontWeight.normal
                  ),
                )
              ]
            ),
          ),
        ) : SizedBox(height: 0.0,),
      ],
    );
  }
}
