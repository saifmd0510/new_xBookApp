import 'package:flutter/material.dart';
import 'package:x_book_app/models/user.dart';
import 'package:x_book_app/screens/authentication/authenticate.dart';
import 'package:x_book_app/screens/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:x_book_app/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CustomUser?>(
      stream: AuthService().user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const MaterialApp(
            home: Home(),
          );
        } else {
          return const MaterialApp(
          home: Authenticate(),
          );
        }
      },
    );
  }
}
