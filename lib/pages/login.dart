import 'package:flutter/material.dart';
import 'package:social_app/pages/register.dart';
import 'package:social_app/services/authentication.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool yukleniyor = false;
  String email, sifre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          _formElemanlari(),
          _yuklemeAnimasyonu()
        ],
      ),
    );
  }

  Widget _yuklemeAnimasyonu(){
    if(yukleniyor) {
      return  Center(child: CircularProgressIndicator(backgroundColor: Colors.red.withOpacity(0.3),),);
    }
    else {
      return Center();
    }
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
          FlutterLogo(size: 90,),
          SizedBox(height: 50,),
          TextFormField(
            autocorrect: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Lütfen email adresinizi giriniz.",
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
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Register()));
                  },
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
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: FlatButton(
                  onPressed: _girisYap,
                  child: Text(
                    "Giriş Yap",
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
          ),
          SizedBox(height: 20.0,),
          Center(child: Text("veya")),
          SizedBox(height: 20.0,),
          Center(child: Text("Google ile giriş yap")),
          SizedBox(height: 20.0,),
          Center(child: Text("Şİfremi Unuttum ")),
        ],
      ),
    );
  }

  void _girisYap() async{


    if(_formAnahtari.currentState.validate()){
      _formAnahtari.currentState.save();
      setState(() {
        yukleniyor = true;
      });

      try{
        await YetkilendirmeServisi().mailIleGiris(email, sifre);
        //Navigator.of(context).pop();
      }
      catch(error){



        setState(() {
          yukleniyor = false;
        });
      }
    }
  }

  uyariGoster({hataKodu}){
    /*
        * **invalid-email**:
  ///  - Thrown if the email address is not valid.
  /// - **user-disabled**:
  ///  - Thrown if the user corresponding to the given email has been disabled.
  /// - **user-not-found**:
  ///  - Thrown if there is no user corresponding to the given email.
  /// - **wrong-password**:
        * */
    String message = "";

    if(hataKodu == "user-disabled"){
      message = "Bu E-mail adresi ile giriş yapamazsınız.";
    }
    else if(hataKodu == "invalid-email"){
      message = "Geçersiz E-mail adresi";
    }
    else if(hataKodu == "user-not-found"){
      message = "Bu mail adresi ile kullanıcı bulunamadı.";
    }
    else if(hataKodu == "wrong-password"){
      message = "Şifre uyuşmuyor, Lütfen tekrar deneyiniz.";
    }
    else {
      message = "Bilinmeyen bir hata";
    }
    var snackbar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
