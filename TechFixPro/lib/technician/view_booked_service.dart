  import '../SharedPreferences/AddData.dart';

import '../database/database.dart';
import '../phone call/phone_call_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ViewBookedService extends StatelessWidget {
  AddData ad = AddData();
  DataBase db = DataBase();
PhoneCallService pcs = PhoneCallService();


String cn = '';
String cemail = '';
String productname = '';
String Problem = '';
String pn = '';
String RequestId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("TechFixPro"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('booked service').snapshots(),
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
              final CustomerName = data?['CustomerName'] ?? 'No Name'; // Handle missing 'CustomerName' field
              final email = data?['email'] ?? 'No email'; 
              final phonenumber = data?['phone number'] ?? 'No number'; 

              final Productname = data?['Productname'] ?? 'No Productname'; // Handle missing 'Productname' field
              final problem = data?['problem'] ?? 'No problem'; // Handle missing 'problem' field
              final imageUrl = data?['product image'] ?? 'No Image URL'; // Retrieve the image URL
              final status = data?['status'] ?? 'No status'; 
if (status == 'pending') {
              return ListTile(
                title: Text('CustomerName: $CustomerName'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Productname: $Productname'),
                    Text('email: $email'),
                    Text('phonenumber: $phonenumber'),

                    Text('Problem: $problem'),
                    // Display the image using Image.network widget
                    Image.network(imageUrl),
                      ElevatedButton(
                        onPressed: () async {
  Map<String, String> credentials = await ad.getCredentials();
  String? temail = credentials['email'];

cn = CustomerName;
cemail = email;
productname = Productname ;
Problem = problem;
pn = phonenumber;
print('phone number: $pn');
db.TechnicianRepairs(temail, cn, cemail, productname, Problem, pn);
                    RequestId = documentId;
await db.UpdateRequest(RequestId, 'reserved');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("successfully reserved!"),
        ),
      );
                        },
                        child: Text('reserve service'),
                      ),

                  ],
                ),

                  onLongPress: () async {
pn = phonenumber;
await pcs.makingPhoneCall(pn);
                  },

              );
              } else {

                return Container(); // Or return null if you want to skip this item
              }

            }); 
        },

      ),
    );
  }
}
