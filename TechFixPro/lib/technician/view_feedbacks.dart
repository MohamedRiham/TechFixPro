import '../database/database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ViewFeedBacks extends StatelessWidget {
  DataBase db = DataBase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("TechFixPro"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('feedbacks').snapshots(),
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
              final CustomerName = data?['cname'] ?? 'No Name'; // Handle missing 'CustomerName' field
              final TechnicianName = data?['technician name'] ?? 'No technician name';
              final Feedback = data?['feedback'] ?? 'No feedback';

              return Card(
                elevation: 3, // Add a shadow to the card
                margin: EdgeInsets.all(10), // Add some margin
                child: ListTile(
                  title: Text(
                    'Customer Name: $CustomerName',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Technician Name: $TechnicianName'),
                      Text('Feedback: $Feedback'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
