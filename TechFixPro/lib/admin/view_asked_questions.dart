import '../network/network_utils.dart';

import '../emails/email_sender.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../database/database.dart';

class ViewAskedQuestions extends StatefulWidget {
  @override
  _ViewAskedQuestionsState createState() => _ViewAskedQuestionsState();
}

class _ViewAskedQuestionsState extends State<ViewAskedQuestions> {
  String QuestionId = "";
  DataBase db = DataBase();
  String viewed = "read";
  final EmailSender es = EmailSender();
String emailaddress = "";
String reply = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("TechFixPro"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('questions').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              final document = snapshot.data!.docs[index];
              final data = document.data() as Map<String, dynamic>?; // Safely access document data
              final documentId = document.id; // Get the document ID

              final CustomerName = data?['customer name'] ?? 'No Name'; // Handle missing 'CustomerName' field
              final email = data?['email'] ?? 'No email'; // Handle missing 'CustomerName' field

              final question = data?['question'] ?? 'No question'; // Handle missing 'Productname' field
              final questionstatus = data?['question status'] ?? 'no status'; // Handle missing 'problem' field
              final reply = data?['reply'] ?? 'No reply';


              return ListTile(
                title: Text('CustomerName: $CustomerName'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('email: $email'),

                    Text('question: $question'),
                    Text('question status: $questionstatus'),
                    Text('reply: $reply'),

                  ],
                ),
      onTap: () {
        setState(() {
          // Update the QuestionId when the ListTile is tapped
          QuestionId = documentId;
emailaddress = email;

        });
update();
        _showActionDialog(); // Function to show the dialog
},
              );
            },
          );
        },
      ),
    );
  }
void update() {
    setState(() {
      db.UpdateQuestionStatus(QuestionId, viewed);
print('question id: $QuestionId');
    });
}

  void _showActionDialog() {
    TextEditingController replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reply"),
          content: TextField(
            controller: replyController,
            decoration: InputDecoration(
              labelText: 'Enter your reply',
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
                Navigator.of(context).pop(); // Close the dialog

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "No network access. Please check your connection."),
                                          ),
                                        );
                                        return; // Return early to prevent further execution
                                      }

                reply = replyController.text;
if (reply.isNotEmpty) {
db.ReplyToQuestions(QuestionId, reply);

                String subject = "reply to your question on TechFixPro";
es.sendEmail(subject, reply, emailaddress);
                Navigator.of(context).pop(); // Close the dialog
} else {
                Navigator.of(context).pop(); // Close the dialog
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "the fieled can not be empty"),
                                          ),
                                        );
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

}//end class

