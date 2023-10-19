import '../network/network_utils.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import '../database/database.dart';

class AddFeedback extends StatefulWidget {
  final String? userName;
  AddFeedback({required this.userName});

  @override
  _AddFeedbackState createState() => _AddFeedbackState();
}

class _AddFeedbackState extends State<AddFeedback> {
  DataBase db = DataBase();
  String tname = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey<ScaffoldState>(), // Add this line to set a key
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("TechFixPro"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Technician Details').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              final document = snapshot.data!.docs[index];
              final data = document.data() as Map<String, dynamic>;
              final documentId = document.id; // Get the document ID
              final TechnicianName = data?['name'] ?? 'No Name';
              final email = data?['email'] ?? 'No email';
              final phonenumber = data?['phonenumber'] ?? 'No phonenumber';

              final TechnicianStatus = data?['status'] ?? 'No status';
              if (TechnicianStatus == true) {
                return ListTile(
                  title: Text('TechnicianName: $TechnicianName'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('email: $email'),
                      Text('phonenumber: $phonenumber'),
                    ],
                  ),
                  onLongPress: () {
tname = TechnicianName;

                    _showActionDialog(); // Function to show the dialog
                  },
                );
              } else {
                // If 'status' is not true, return an empty Container or null
                return Container(); // Or return null if you want to skip this item
              }
            },
          );
        },
      ),
    );
  }

  void _showActionDialog() {
    TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("feedback"),
          content: TextField(
            controller: feedbackController,
            decoration: InputDecoration(
              labelText: 'Enter your feedback',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Submit"),
              onPressed: () async {
                                      bool hasNetwork =
                                          await CheckNetworkConnection();
                                      if (!hasNetwork) {
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Semantics(
      label: "No network access. Please check your connection.",
      child: Text("No network access. Please check your connection."),
    ),
  ),
);
                Navigator.of(context).pop(); // Close the dialog

                                        return; // Return early to prevent further execution
                                      }

                String feedback = feedbackController.text;
if (feedback.isNotEmpty) {
db.AddFeedback(widget.userName, tname, feedback);
                  feedbackController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text("feedback added!"),
    ),
    );

                Navigator.of(context).pop(); // Close the dialog
} else {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text("the field can not be empty"),
    ),
    );

                Navigator.of(context).pop(); // Close the dialog

}
              },
            ),
          ],
        );
      },
    );
  }


  Future<bool> CheckNetworkConnection() async {
    bool hasNetwork = await NetworkUtils.isNetworkAvailable();
    if (hasNetwork) {
      // Network access is available, perform your function
      return true;
    } else {
      // No network access, handle accordingly (e.g., show an error message)
      return false;
    }
  }
}