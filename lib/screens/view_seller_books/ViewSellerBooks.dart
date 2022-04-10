import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewSellerBooks extends StatefulWidget{
  const ViewSellerBooks({Key? key}) : super(key: key);

  @override
  _ViewSellerBooksState createState() => _ViewSellerBooksState();
}

class _ViewSellerBooksState extends State<ViewSellerBooks> {
  String? uid = FirebaseAuth.instance.currentUser?.uid.toString();
  String title= "";
  String author= "";
  String edition= "";
  String price="";
  String contact ="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('All Books to be sold'),
        ),
      body: StreamBuilder<QuerySnapshot>(
        stream: (title!= "" && title!= null ||  uid!="" && uid!=null)
            ? FirebaseFirestore.instance
            .collection("books")
            .where("uid", isEqualTo: uid)
            .snapshots()
            :FirebaseFirestore.instance.collection("books").snapshots(),
        builder: (context, snapshot){
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index){
              DocumentSnapshot data = snapshot.data!.docs[index];
              return Container(
                padding: EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(data['title'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      subtitle: Text(data['edition'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      isThreeLine: true,
                    ),
                    Divider(
                      thickness: 2,
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
