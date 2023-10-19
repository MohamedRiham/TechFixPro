import 'package:flutter/material.dart';
import '../database/database.dart';

class MyRepairs extends StatefulWidget {
  final String? userName;

  MyRepairs({required this.userName});
  @override
  _MyRepairsState createState() => _MyRepairsState();
}

class _MyRepairsState extends State<MyRepairs> {
  DataBase db = DataBase();
  List<String> customerNameList = [];
  List<String> customeremailList = [];
  List<String> technicianemailList = [];

  List<String> productnameList = [];
  List<String?> customerphonenumberList = [];
  List<String?> problemList = [];

  @override
  void initState() {
    super.initState();
  filtor(widget.userName!); // Call filtor directly  
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('my repairs'),
      ),
      body:  ListView.builder(
  itemCount: customerNameList.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text('technician email: ${technicianemailList[index]}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('customer email: ${customeremailList[index]}'), 

          Text('customer name: ${customerNameList[index]}'), 

          Text('product name: ${productnameList[index]}'),
Text('phone number: ${customerphonenumberList[index] ?? 'No reply'}'),
          Text('problem: ${problemList[index]}'),

        ],
      ),
    );
  },
),   
);
  }


void filtor(String email) async {
  try {
    List<Map<String, dynamic>?> result = await db.FilterRepairs(email);

    if (result.isNotEmpty) {
      for (Map<String, dynamic>? documentData in result) {
        if (documentData != null) {
          // Safely access and add data from each document to the respective lists
          if (documentData.containsKey('customer name')) {
            customerNameList.add(documentData['customer name'] as String);
          } else {
            customerNameList.add('No Name'); // Handle missing 'customer name'
          }
          
          if (documentData.containsKey('product name')) {
            productnameList.add(documentData['product name'] as String);
          } else {
            productnameList.add('No Productname'); 
 }
          
          if (documentData.containsKey('technician email')) {
            technicianemailList.add(documentData['technician email'] as String);
          } else {
            technicianemailList.add('No email'); 
          }
          
          if (documentData.containsKey('customer phonenumber')) {
            customerphonenumberList.add(documentData['customer phonenumber'] as String?);
          } else {
            customerphonenumberList.add(null); 
          }
          if (documentData.containsKey('problem')) {
            problemList.add(documentData['problem'] as String);
          } else {
            problemList.add('No problem'); 
          }

          if (documentData.containsKey('customer email')) {
            customeremailList.add(documentData['customer email'] as String);
          } else {
            customeremailList.add('no customer email'); 
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
