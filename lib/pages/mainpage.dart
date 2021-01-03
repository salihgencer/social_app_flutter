import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/pages/Search.dart';
import 'package:social_app/pages/announcements.dart';
import 'package:social_app/pages/flow.dart';
import 'package:social_app/pages/profile.dart';
import 'package:social_app/pages/upload.dart';
import 'package:social_app/services/authentication.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _activeBottomPage = 0;
  PageController pageCommand;

  @override
  void initState() {
    super.initState();
    pageCommand = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    pageCommand.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _yetkilendirmeServisi = Provider.of<YetkilendirmeServisi>(context,listen: false);
    print(_yetkilendirmeServisi.aktifKullaniciId);
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageCommand,
        onPageChanged: (changeIndex){
          setState(() {
            _activeBottomPage = changeIndex;
          });
        },
        children: [
          FlowPage(),
          SearchPage(),
          UploadPage(),
          AnnouncementsPage(),
          ProfilePage(profileId: _yetkilendirmeServisi.aktifKullaniciId,)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activeBottomPage,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(label: "Akış", icon: Icon(Icons.bubble_chart)),
          BottomNavigationBarItem(label: "Arama", icon: Icon(Icons.search)),
          BottomNavigationBarItem(label: "Yükle", icon: Icon(Icons.upload_file)),
          BottomNavigationBarItem(label: "Duyurular", icon: Icon(Icons.announcement)),
          BottomNavigationBarItem(label: "Profil", icon: Icon(Icons.person_rounded)),
        ],
        onTap: (secilenSayfa){
          setState(() {
            _activeBottomPage = secilenSayfa;
            pageCommand.jumpToPage(secilenSayfa);
          });
        },
      ),
    );
  }
}
