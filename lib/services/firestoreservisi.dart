import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/Kullanici.dart';

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
    var snapshot = await _firestore.collection(_userFollowCollectionName).doc(userId).collection(_userFollowingCollectionName).get();
    return snapshot.docs.length;
  }
}