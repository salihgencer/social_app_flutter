import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FirabeseStorageServisi{
  Reference _storage = FirebaseStorage.instance.ref();

  Future<String> gonderiResmiYukle(File mediaDosyasi, userId) async{
    String v4uuid = Uuid().v4();
    String picturePath = "upload-post-media/$userId/images/$v4uuid.jpg";
    print(picturePath);
    UploadTask yuklemeYoneticisi = _storage.child(picturePath).putFile(mediaDosyasi);
    TaskSnapshot snapshot = await yuklemeYoneticisi;
    String yuklenenResimUrl = await snapshot.ref.getDownloadURL();
    return yuklenenResimUrl;
  }

}