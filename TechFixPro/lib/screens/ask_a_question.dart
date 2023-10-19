import '../network/network_utils.dart';

import 'question_history.dart';
import 'package:flutter/material.dart';
import '../database/database.dart';
class AskQuestion extends StatefulWidget {
  final String? userName;  
final String? email;

  AskQuestion({required this.userName, required this.email});

@override
  _AskQuestionState createState() => _AskQuestionState();
}

class _AskQuestionState extends State<AskQuestion> {

  final _questionTextController = TextEditingController();

  DataBase db = DataBase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ask a Question'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _questionTextController,

                decoration: InputDecoration(
                  labelText: 'Enter your question',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                                      bool hasNetwork =
                                          await CheckNetworkConnection();
                                      if (!hasNetwork) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "No network access. Please check your connection."),
                                          ),
                                        );
                                        return; // Return early to prevent further execution
                                      }

                String question = _questionTextController.text;

                // Check if the question is not empty before submitting
                if (question.isNotEmpty) {
                  // Call the method in the database class to submit the question
                  db.AskQuestion(widget.userName, widget.email, question);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "question added successfully!"),
                                              ),
                                            );

                  // Clear the text field after submission
                  _questionTextController.clear();

                } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "the field cannot be empty"),
                                          ),
                                        );

                }
                },
              child: Text('Submit'),
            ),

            ElevatedButton(
              onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuestionHistory(userName: widget.userName)),
          );

                },
              child: Text('history'),
            ),
          ],
        ),
      ),
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

