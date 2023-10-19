import 'package:flutter/material.dart';
import '../database/database.dart';
class QuestionHistory extends StatefulWidget {
  final String? userName;

  QuestionHistory({required this.userName});
  @override
  _QuestionHistoryState createState() => _QuestionHistoryState();
}

class _QuestionHistoryState extends State<QuestionHistory> {
  DataBase db = DataBase();
  List<String> customerNameList = [];
  List<String> emailList = [];

  List<String> questionList = [];
  List<String> questionStatusList = [];
  List<String?> replyList = [];

  @override
  void initState() {
    super.initState();
  filtor(widget.userName!); // Call filtor directly  
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Question History'),
      ),
      body:  ListView.builder(
  itemCount: customerNameList.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text('customer name: ${customerNameList[index]}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('email: ${emailList[index]}'), 

          Text('question: ${questionList[index]}'),
          Text('question status: ${questionStatusList[index]}'), // This will be displayed below the question
Text('reply: ${replyList[index] ?? 'No reply'}'),

        ],
      ),
    );
  },
),   
);
  }


void filtor(String name) async {
  try {
    List<Map<String, dynamic>?> result = await db.FilterQuestions(name);

    if (result.isNotEmpty) {
      for (Map<String, dynamic>? documentData in result) {
        if (documentData != null) {
          // Safely access and add data from each document to the respective lists
          if (documentData.containsKey('customer name')) {
            customerNameList.add(documentData['customer name'] as String);
          } else {
            customerNameList.add('No Name'); // Handle missing 'customer name'
          }

          if (documentData.containsKey('email')) {
            emailList.add(documentData['email'] as String);
          } else {
            emailList.add('No email'); 
          }
          
          if (documentData.containsKey('question')) {
            questionList.add(documentData['question'] as String);
          } else {
            questionList.add('No question'); // Handle missing 'question'
          }
          
          if (documentData.containsKey('question status')) {
            questionStatusList.add(documentData['question status'] as String);
          } else {
            questionStatusList.add('No status'); // Handle missing 'question status'
          }
          
          if (documentData.containsKey('reply')) {
            replyList.add(documentData['reply'] as String?);
          } else {
            replyList.add(null); // Handle missing 'reply'
          }
        }
      }
      setState(() {});
    } else {
      print("No documents found for the specified customer name.");
    }
  } catch (e) {
    print("Error retrieving data from Firestore: $e");
  }
}

}
