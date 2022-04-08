import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_book_app/models/user.dart';
import 'package:x_book_app/screens/authentication/authenticate.dart';
import 'package:x_book_app/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // Get the user from Provider
    final user = Provider.of<CustomUser?>(context);
    if (user == null) {
      return const Authenticate();
    } else {
      return const Home();
    }

  }
}