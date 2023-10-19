import 'package:flutter/material.dart';
import '../database/database.dart';
class RequestHistory extends StatefulWidget {
  final String? userName;

  RequestHistory({required this.userName});
  @override
  _RequestHistoryState createState() => _RequestHistoryState();
}

class _RequestHistoryState extends State<RequestHistory> {
  DataBase db = DataBase();
  List<String> customerNameList = [];
  List<String> productnameList = [];
  List<String> emailList = [];
  List<String?> phonenumberList = [];
  List<String?> problemList = [];
  List<String?> statusList = [];

  @override
  void initState() {
    super.initState();
  filtor(widget.userName!); // Call filtor directly  
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('requests history'),
      ),
      body:  ListView.builder(
  itemCount: customerNameList.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text('customer name: ${customerNameList[index]}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('product name: ${productnameList[index]}'),
          Text('email: ${emailList[index]}'), 
Text('phone number: ${phonenumberList[index] ?? 'No reply'}'),
          Text('problem: ${problemList[index]}'),
          Text('status: ${statusList[index]}'), 

        ],
      ),
    );
  },
),   
);
  }


void filtor(String name) async {
  try {
    List<Map<String, dynamic>?> result = await db.FilterRequests(name);

    if (result.isNotEmpty) {
      for (Map<String, dynamic>? documentData in result) {
        if (documentData != null) {
          // Safely access and add data from each document to the respective lists
          if (documentData.containsKey('CustomerName')) {
            customerNameList.add(documentData['CustomerName'] as String);
          } else {
            customerNameList.add('No Name'); // Handle missing 'customer name'
          }
          
          if (documentData.containsKey('Productname')) {
            productnameList.add(documentData['Productname'] as String);
          } else {
            productnameList.add('No Productname'); 
 }
          
          if (documentData.containsKey('email')) {
            emailList.add(documentData['email'] as String);
          } else {
            emailList.add('No email'); 
          }
          
          if (documentData.containsKey('phone number')) {
            phonenumberList.add(documentData['phone number'] as String?);
          } else {
            phonenumberList.add(null); // Handle missing 'reply'
          }
          if (documentData.containsKey('problem')) {
            problemList.add(documentData['problem'] as String);
          } else {
            problemList.add('No problem'); 
          }

          if (documentData.containsKey('status')) {
            statusList.add(documentData['status'] as String);
          } else {
            statusList.add('pending'); 
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
