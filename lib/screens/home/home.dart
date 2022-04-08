import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:x_book_app/models/user.dart';
import 'package:x_book_app/screens/sell_book/SellBook.dart';
import 'package:x_book_app/services/auth.dart';
import 'package:provider/provider.dart';

import '../view_seller_books/ViewSellerBooks.dart';


class Home extends StatelessWidget {

  const Home({ Key? key }) : super(key: key);
    

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final AuthService _auth = AuthService();
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        backgroundColor: Colors.indigo[400],
        elevation: 0.0,
        title: const Text('You are Logged In'),
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('logout'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
          ElevatedButton(
            child: Text('Sell Book'),
            onPressed: () {
              _navigateToSellBookScreen(context);
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
              child: Text(user!.email!, style: const TextStyle(fontSize: 20),)
          ),
          Container(

            color: Colors.red,
            child: SizedBox(height: 50,
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  primary: Colors.black,
                ),
                onPressed: () {
                  _navigateToViewSellerBookScreen(context);
                },
                child: const Text('Click to view your books'),
              ),
            ),
          )
        ],
      ),
    );
  }
  void _navigateToSellBookScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SellBook()));
  }
  void _navigateToViewSellerBookScreen(context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewSellerBooks()));
}
}