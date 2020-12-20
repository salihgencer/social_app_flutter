import 'package:flutter/material.dart';
import 'package:social_app/services/authentication.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool yukleniyor = false;
  String kullaniciAdi, sifre, email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Hesap Oluştur"),
      ),
      body: Stack(
        children: [
          _formElemanlari()
        ],
      ),
    );
  }

  Widget _formElemanlari() {
    return Form(
      key: _formAnahtari,
      child: ListView(
        padding: EdgeInsets.only(
          left:   20.0,
          right: 20.0
        ),
        children: [
          yukleniyor ? LinearProgressIndicator() : Center(),
          FlutterLogo(size: 90,),
          SizedBox(height: 50,),
          TextFormField(
            autocorrect: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Kullanıcı adızını giriniz.",
              labelText: "Kullanıcı Adı",
              prefixIcon: Icon(Icons.email),
            ),
            validator: (girilenDeger){
              if(girilenDeger.isEmpty){
                return "E-mail alanı boş bırakılamaz";
              }
              else if(girilenDeger.trim().length < 4 && girilenDeger.trim().length > 10){
                return "Lütfen en az 4 en fazla 10 karaker yazınız.";
              }

              return null;
            },
            onSaved: (girilenDeger){
              kullaniciAdi = girilenDeger;
            },
          ),
          SizedBox(height: 40,),
          TextFormField(
            autocorrect: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Lütfen email adresinizi giriniz.",
              labelText: "Email",
              prefixIcon: Icon(Icons.email),
            ),
            validator: (girilenDeger){
              if(girilenDeger.isEmpty){
                return "E-mail alanı boş bırakılamaz";
              }
              else if(!girilenDeger.contains("@")){
                return "Lütfen geçerli bir email adresi yazınız.";
              }

              return null;
            },
            onSaved: (girilenDeger){
              email = girilenDeger;
            },
          ),
          SizedBox(height: 40,),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Lütfen şifrenizi giriniz.",
              labelText: "Şifre",
              prefixIcon: Icon(Icons.adjust),
            ),
            validator: (girilenDeger){
              if(girilenDeger.isEmpty){
                return "Şifre alanı boş bırakılamaz";
              }
              else if(girilenDeger.trim().length < 4){
                return "Lütfen  en az 4 karakterli bir şifre giriniz.";
              }

              return null;
            },
            onSaved: (girilenDeger){
              sifre = girilenDeger;
            },
          ),
          SizedBox(height: 40,),
          Row(
            children: [
              Expanded(
                child: FlatButton(
                  onPressed: _kullaniciOlustur,
                  child: Text(
                    "Hesap oluştur",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
              ),

            ],
          )
        ],
      ),
    );
  }

  void _kullaniciOlustur() async{
    var formState = _formAnahtari.currentState;
    if(formState.validate()){
      formState.save();
      setState(() {
        yukleniyor = true;
      });

      try{
        await YetkilendirmeServisi().mailIleKayit(email, sifre);
        Navigator.pop(context);
      }catch(error){
        setState(() {
          yukleniyor = false;
        });
        print(error.code);
        uyariGoster(hataKodu: error.code);

      }

    }
  }

  uyariGoster({hataKodu}){
    /*
    * - **email-already-in-use**:
  ///  - Thrown if there already exists an account with the given email address.
  /// - **invalid-email**:
  ///  - Thrown if the email address is not valid.
  /// - **operation-not-allowed**:
  ///  - Thrown if email/password accounts are not enabled. Enable
  ///    email/password accounts in the Firebase Console, under the Auth tab.
  /// - **weak-password**:
    * */
    String message = "";

    if(hataKodu == "email-already-in-use"){
      message = "Bu mail adresi ile kullanımdadır.";
    }
    else if(hataKodu == "invalid-email"){
      message = "Geçersiz E-mail adresi";
    }
    else if(hataKodu == "operation-not-allowed"){
      message = "Sistemsel bir problem";
    }
    else if(hataKodu == "weak-password"){
      message = "Şifreniz çok kısa lütfen daha güvenli bir şifre oluşturunuz.";
    }
    else {
      message = "Bilinmeyen bir hata";
    }
    var snackbar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
