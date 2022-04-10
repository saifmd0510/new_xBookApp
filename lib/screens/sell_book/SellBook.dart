import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:x_book_app/screens/home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SellBook extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Sell Book';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        // resizeToAvoidBottomInset: false,   //new line
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  MyCustomForm({Key? key}) : super(key: key);

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {

  // firebase instance
  CollectionReference books = FirebaseFirestore.instance.collection('books');

  // get current user id
  String? uid = FirebaseAuth.instance.currentUser?.uid.toString();

  // book info inputs initialize
  String title = "";
  String author = "";
  String edition = "";
  double price = 0.0;
  String contact = "";

  // STT
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  // controller to edit TextField after STT
  final myController_title = TextEditingController();
  final myController_author = TextEditingController();
  final myController_edition = TextEditingController();
  final myController_price = TextEditingController();
  final myController_contact = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    myController_title.dispose();
    myController_author.dispose();
    myController_edition.dispose();
    myController_price.dispose();
    myController_contact.dispose();
    super.dispose();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  // Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      print("STT: $_lastWords");
    });
  }

  // this function validates data when Submit button is pressed
  // also shows toasts if error found
  bool validate_data(){
    // check if both title and price are empty
    if(title.isEmpty && price <= 0){
      Fluttertoast.showToast(
        msg: "Book title and price cannot be empty",  // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.BOTTOM,    // location
      );
      return false;
    }
    // check if the title field is empty
    if(title.isEmpty){
      Fluttertoast.showToast(
          msg: "Book title cannot be empty",  // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.BOTTOM,    // location
      );
      return false;
    }
    // check price
    // show error if price is not numeric or price is <= 0
    if(!isNumeric(myController_price.text) || double.parse(myController_price.text)<=0){
      Fluttertoast.showToast(
        msg: "Enter a valid price",  // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.BOTTOM,    // location
      );
      return false;
    }
    return true;
  }

  // check a string is numeric
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      // children: SingleChildScrollView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Text(
            // If listening is active show the recognized words
            _speechToText.isListening
                ? 'Last recognized words: $_lastWords'
            // If lastwords is not empty then show the last word,
            // otherwise, show instruction of using STT
                : _lastWords.isNotEmpty? 'Last recognized words: $_lastWords'
                : 'Instruction: Tap the microphone to start \nlistening & paste in any Text Field',
          ),
        ),
        Ink(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          decoration: ShapeDecoration(
            color: Colors.blue,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
            color: Colors.white,
            onPressed:
            // If not yet listening for speech start, otherwise stop
            _speechToText.isNotListening ? _startListening : _stopListening,
            tooltip: 'Listen',
          ),
        ),
        // IconButton(
        //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        //   color: Colors.green,
        //   icon: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
        //   onPressed:
        //   // If not yet listening for speech start, otherwise stop
        //   _speechToText.isNotListening ? _startListening : _stopListening,
        //   tooltip: 'Listen',
        // ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: myController_title,
            onChanged: (value){
              title = value;
              // Call setState to update the UI
              setState(() {});
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter Book Title (REQUIRED)',


              suffixIcon: IconButton(
                icon: Icon(Icons.paste),
                onPressed: (){
                  String value = _lastWords.toString();
                  myController_title.text = value;
                  title = value;
                }
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: myController_author,
            onChanged: (value){
              author = value;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter Author name',

              suffixIcon: IconButton(
                  icon: Icon(Icons.paste),
                  onPressed: (){
                    String value = _lastWords.toString();
                    myController_author.text = value;
                    author = value;
                  }
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: myController_edition,
            onChanged: (value){
              edition = value;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter Edition',

              suffixIcon: IconButton(
                  icon: Icon(Icons.paste),
                  onPressed: (){
                    String value = _lastWords.toString();
                    myController_edition.text = value;
                    edition = value;
                  }
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: myController_price,
            onChanged: (value){
              price = double.parse(value);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter Price (REQUIRED)',

              suffixIcon: IconButton(
                  icon: Icon(Icons.paste),
                  onPressed: (){
                    String value = _lastWords.toString();
                    myController_price.text = value;
                    price = double.parse(value);
                  }
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: myController_contact,
            onChanged: (value){
              contact = value;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter Contact Info',

              suffixIcon: IconButton(
                  icon: Icon(Icons.paste),
                  onPressed: (){
                    String value = _lastWords.toString();
                    myController_contact.text = value;
                    contact = value;
                  }
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: ElevatedButton(
            child: Text('Submit'),
            onPressed: () async {
              // validate data and upload information if firestore database
              if(validate_data()){
                await books.add({
                'uid': uid,
                'title': title,
                'author': author,
                'edition': edition,
                'price': price,
                'contact': contact
                }).then((value) => Fluttertoast.showToast( // show toast if the book is added
                    msg: "Book added!",  // message
                    toastLength: Toast.LENGTH_SHORT, // length
                    gravity: ToastGravity.BOTTOM,    // location
                  ))
                    .catchError((error) => Fluttertoast.showToast( // show error if failed to add
                      msg: "Failed to add book info: $error",  // message
                      toastLength: Toast.LENGTH_SHORT, // length
                      gravity: ToastGravity.BOTTOM,    // location
                    ));

                // show toast
                Fluttertoast.showToast(
                  msg: "Book title cannot be empty",  // message
                  toastLength: Toast.LENGTH_SHORT, // length
                  gravity: ToastGravity.BOTTOM,    // location
                );

                _navigateToHomeScreen(context);
              }
            },
          ),
        ),
      ],
      // ),

    ),
    );
  }
  void _navigateToHomeScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
  }
}

