import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import '../technician/view_feedbacks.dart';
import 'ask_a_question.dart';
import 'add_feedback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../select_user.dart';
import '../helper/firebase_auth.dart';

import 'BookService.dart'; // Import the BookService screen

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User _currentUser;
  final firestore = FakeFirebaseFirestore(); 
  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text('HomeScreen'),
        centerTitle: true,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

      Text(
                'NAME: ${_currentUser.displayName}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: 16.0),
              Text(
                'EMAIL: ${_currentUser.email}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => SelectUser(),
                    ),
                  );
                },
                child: const Text('Sign out'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                ),
              ),
              SizedBox(height: 16.0), // Add spacing
              ElevatedButton(
                onPressed: () {
                  // Navigate to the BookService screen when the button is pressed
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BookService(userName: _currentUser.displayName, email: _currentUser.email),
                    ),
                  );
                },
                child: const Text('Book Service'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                ),

              ),
TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AskQuestion(userName: _currentUser.displayName, email: _currentUser.email),
      ),
    );
  },
                child: const Text('ask a question'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                ),
),
              ElevatedButton(
                onPressed: () {
        
          Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddFeedback(userName: _currentUser.displayName),
                    ),
                  );
                },
                child: const Text('add feedback'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                ),
),
              ElevatedButton(
                onPressed: () async {

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ViewFeedBacks(),
                    ),
                  );
                },
                child: const Text('view feedbacks'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                ),
              ),


    ],
          ),


);

  }

  Future<dynamic> Logout() async {

    await FirebaseAuth.instance.signOut();
  Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SelectUser(),
      ),
    );
return true;
  }
}
