import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String postPhotoUrl;
  final String description;
  final String userId;
  final String likeCount;
  final String location;

  Post(
      {this.id,
      this.postPhotoUrl,
      this.description,
      this.userId,
      this.likeCount,
      this.location});

  factory Post.dokumandanUret(DocumentSnapshot doc){
    return Post(
      id: doc.id,
      description: doc["descriptioon"],
      likeCount: doc["likeCount"],
      location: doc["location"],
      postPhotoUrl: doc["photoUrl"],
      userId: doc["userId"]
    );
  }
}