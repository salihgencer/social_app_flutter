import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/redirect.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_app/services/authentication.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<YetkilendirmeServisi>(
      create: (_) => YetkilendirmeServisi(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Sosyal",
        home: Redirect(),
      ),
    );
  }
}
