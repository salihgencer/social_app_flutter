import 'package:cloud_firestore/cloud_firestore.dart';

class Comment{
  final String id;
  final String comment;
  final String userId;
  final Timestamp createdTime;

  Comment({this.id, this.comment, this.userId, this.createdTime});

  factory Comment.documandanUret(DocumentSnapshot doc) {
    return Comment(
        id: doc.id,
        comment: doc["comment"],
        userId: doc["userId"],
        createdTime: doc["createdTime"]
    );
  }

}