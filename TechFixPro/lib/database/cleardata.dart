import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClearData {
  Future<void> clearBookedService(BuildContext context) async { // Make the method async
    try {
      CollectionReference bookedServiceCollection =
          FirebaseFirestore.instance.collection('booked service');

      // Get all documents in the collection
      QuerySnapshot querySnapshot = await bookedServiceCollection.get();

      // Create a batch to perform batch delete
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Iterate through documents and add delete operations to the batch
      querySnapshot.docs.forEach((document) {
        batch.delete(document.reference);
      });

      // Commit the batch to delete all documents
      await batch.commit();

      // Inform the user that all data has been deleted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All data deleted successfully.'),
        ),
      );
    } catch (e) {
      print('Error deleting data: $e');
    }
  }
}
