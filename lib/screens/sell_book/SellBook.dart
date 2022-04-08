import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:x_book_app/screens/home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

// void main() {
//   runApp(SellBook());
// }

class SellBook extends StatelessWidget {
  SellBook({Key? key}) : super(key: key);

// class SellBook extends StatelessWidget {
//   SellBook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Input Book Name';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
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
  // Firebase auth = FirebaseAuth.instance;
  // String uid = auth.

  // test mic
  bool micButtonPressed = true;

  // book info from text field
  String title = "";
  String author = "";
  String edition = "";
  double price = 0.0;
  String contact = "";

  // STT
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
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
      _fillTextField;
      print("STT: $_lastWords");
    });
  }

  // controller to edit TextField after STT
  final TextEditingController _controller = TextEditingController();

  // This function is triggered when the mic button is pressed
  void _fillTextField() {
    // Clear everything in the text field
    _controller.clear();
    // set TextField
    _controller.text = _lastWords.toString();
    // Call setState to update the UI
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: _controller,
            onChanged: (value){
              title = value;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter book title',

              suffixIcon: IconButton(
                icon: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
                onPressed:
                // If not yet listening for speech start, otherwise stop
                _speechToText.isNotListening ? _startListening : _stopListening,
                tooltip: 'Listen',

              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            onChanged: (value){
              author = value;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter author name',
              suffixIcon: IconButton(
                icon: Icon(Icons.mic),
                onPressed: (){
                  micButtonPressed = !micButtonPressed;
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            onChanged: (value){
              edition = value;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter edition',
              suffixIcon: IconButton(
                icon: Icon(Icons.mic),
                onPressed: (){
                  micButtonPressed = !micButtonPressed;
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            onChanged: (value){
              price = double.parse(value);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter Price',
              suffixIcon: IconButton(
                icon: Icon(Icons.mic),
                onPressed: (){
                  micButtonPressed = !micButtonPressed;
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            onChanged: (value){
              contact = value;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter Contact Info',
              suffixIcon: IconButton(
                icon: Icon(Icons.mic),
                onPressed: (){
                  micButtonPressed = !micButtonPressed;
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: ElevatedButton(
            child: Text('Submit'),
            onPressed: () async {

              await books.add({
              'uid': uid,
              'title': title,
              'author': author,
              'edition': edition,
              'price': price,
              'contact': contact
              }).then((value) => print("Book Added"))
                  .catchError((error) => print("Failed to add book info: $error"));
              _navigateToHomeScreen(context);
              },
          ),
        ),
        // RaisedButton(
        //   child: Text('Submit'),
        //   onPressed: () {_navigateToHomeScreen(context);},
        // ),
      ],
    );
  }
  void _navigateToHomeScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
  }
}
