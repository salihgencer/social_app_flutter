import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/Kullanici.dart';
import 'package:social_app/models/Post.dart';

class FirestoreServisi {
  final FirebaseFirestore  _firestore = FirebaseFirestore.instance;
  final DateTime zaman = DateTime.now();
  final String _userCollectionName = "users";
  final String _userFollowCollectionName = "userFollow";
  final String _userFollowersCollectionName = "userFollowers";
  final String _userFollowingCollectionName = "userFollowing";

  Future<void> kullaniciOlustur({id,email,kullaniciAdi, fotoUrl=""}) async{
    await _firestore.collection(_userCollectionName).doc(id).set({
      "userName" : kullaniciAdi,
      "email" : email,
      "photoUrl" : fotoUrl,
      "about" : "",
      "createTime": zaman
    });
  }

  Future<Kullanici> kullaniciGetir(id) async{
    DocumentSnapshot doc = await _firestore.collection(_userCollectionName).doc(id).get();
    if(doc.exists){
      Kullanici kullanici = Kullanici.documandanUret(doc);
      return kullanici;
    }
    return null;
  }

  Future<int> takipciSayisi(userId) async{
    var snapshot = await _firestore.collection(_userFollowCollectionName).doc(userId).collection(_userFollowersCollectionName).get();
    return snapshot.docs.length;
  }

  Future<int> takipEdilenSayisi(userId) async{
    QuerySnapshot snapshot = await _firestore.collection(_userFollowCollectionName).doc(userId).collection(_userFollowingCollectionName).get();
    return snapshot.docs.length;
  }
  
  Future<String> gonderiEkle({String aciklama, String lokasyon, String resimUrl, String userId}) async{
    Map<String, dynamic> postData = {
      "description": aciklama,
      "likeCount":0,
      "location": lokasyon,
      "photoUrl": resimUrl,
      "userId": userId,
      "createdTime": zaman
    };
    DocumentReference snapshot = await _firestore.collection("userPosts").doc(userId).collection("user-post").add(postData);
    return snapshot.id;
  }

  Future<List<Post>> gonderileriGetir(userId) async{
    QuerySnapshot snapshot = await _firestore.collection("userPosts").doc(userId).collection("user-post").orderBy("createdTime", descending: true).get();
    List<Post> userPosts = snapshot.docs.map((doc) => Post.dokumandanUret(doc)).toList();
    return userPosts;
  }

  gonderiBegen(Post userPost, activeUserId, {favType="arttir"}) async{
    DocumentReference docRef = await _firestore.collection("userPosts").doc(userPost.userId).collection("user-post").doc(userPost.id);
    DocumentSnapshot snapshot = await docRef.get();
    int yeniBegeni = 0;

    if(snapshot.exists){
      Post userp = Post.dokumandanUret(snapshot);

      if(favType == "arttir"){
        yeniBegeni = userp.likeCount + 1;
      }
      else {
        yeniBegeni = userp.likeCount - 1;
      }

      await docRef.update({
        "likeCount": yeniBegeni,
      });
      
      // Kullanıcı gönderiyi beğendi yada beğenmekten vazgeçti buna göre 
      // kullanıcının bilgisini tutalım
      if(favType == "arttir"){
        _firestore.collection("userLikes").doc(userp.id).collection("postLikes").doc(activeUserId).set({});
      }
      else {
        DocumentSnapshot docbegeni = await _firestore.collection("userLikes").doc(userp.id).collection("postLikes").doc(activeUserId).get();
        if(docbegeni.exists) {
          _firestore.collection("userLikes").doc(userp.id).collection("postLikes").doc(activeUserId).delete();
        }
      }
    }
  }


  Future<bool> begeniVarmi(Post userPost, activeUserId) async{
    DocumentSnapshot userLike = await _firestore.collection("userLikes").doc(userPost.id).collection("postLikes").doc(activeUserId).get();
    if(userLike.exists){
      return true;
    }
    return false;
  }

  Stream<QuerySnapshot> yorumlariGetir(String postId) {
    return _firestore.collection("comments").doc(postId).collection("post-comments").orderBy("createdTime", descending: true).snapshots();
  }

  Future<void> yorumGonder({String yorum, String postId, String userId}) async{
    print("deneme " + userId);
     await _firestore.collection("comments").doc(postId).collection("post-comments").add({
      "comment":yorum,
      "createdTime": zaman,
      "userId": userId,
    });
  }
}