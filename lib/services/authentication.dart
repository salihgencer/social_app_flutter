import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_app/models/Kullanici.dart';

class YetkilendirmeServisi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String aktifKullaniciId;

  Kullanici _kullaniciOlustur(User kullanici){
    return kullanici == null ? null : Kullanici.firebasedenUret(kullanici);
  }

  dynamic get durumTakipcisi{
    return _firebaseAuth.authStateChanges().map(_kullaniciOlustur);
  }


  Future<Kullanici> mailIleKayit(String eposta, String sifre) async{
    var girisKarti = await _firebaseAuth.createUserWithEmailAndPassword(email: eposta, password: sifre);
    return _kullaniciOlustur(girisKarti.user);
  }

  Future<Kullanici> mailIleGiris(String eposta, String sifre) async{
    var girisKarti = await _firebaseAuth.signInWithEmailAndPassword(email: eposta, password: sifre);
    return _kullaniciOlustur(girisKarti.user);
  }

  Future<Kullanici> googleIleGiris() async{
    // Google hesabına giriş yapıyorum.
    GoogleSignInAccount googleAccount = await GoogleSignIn().signIn();
    // Google yetki kartımı alıyorum
    GoogleSignInAuthentication googleAuthentication = await googleAccount.authentication;
    // Google yetki kartımı onaylatmam gerekiyor.
    OAuthCredential googleAccountDocument = GoogleAuthProvider.credential(idToken: googleAuthentication.idToken, accessToken: googleAuthentication.accessToken);
    // Giriş yetki kartı alındıktan sorna bunu firebase tarafına iletmemiz gerekiyor.
    UserCredential firebaseCredentials = await _firebaseAuth.signInWithCredential(googleAccountDocument);
    return _kullaniciOlustur(firebaseCredentials.user);

  }


  Future<void> cikisYap(){
    return _firebaseAuth.signOut();
  }

}