import 'package:firebase_core/firebase_core.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DataBase {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print("Error initializing Firebase: $e");
    }
  }

void RegisterCustomer(String name, String email, String password, String phonenumber) {
          firestore.collection("Customer Details").add({
            "name": name,
            "email": email,
            "password": password,
"phonenumber": phonenumber,
          });
}

  void addData(String cname, String email, String phonenumber, String pname, String problem, String PImage) {
String status = 'pending';
    firestore.collection("booked service").add({
      "CustomerName": cname,
"email": email,
"phone number": phonenumber,
      "Productname": pname,
      "problem": problem,
"product image": PImage,
"status": status
    });
  }
void registerTechnician(String name, String email, String password, String phonenumber, String documentUrl, String uploadedFileReference) {
  bool? status = null;
          firestore.collection("Technician Details").add({
            "name": name,
            "email": email,
            "password": password,
"phonenumber": phonenumber,
"document": documentUrl,
            "status": status,
"document reference": uploadedFileReference,
          });
}
Future<void> TechnicianStatus(String technicianId, bool newValue) async {
  try {
    final docReference = firestore.collection("Technician Details").doc(technicianId);

    // Read the current value of the "status" field
    DocumentSnapshot snapshot = await docReference.get();

    if (snapshot.exists) {
      // Update the "status" field with the new boolean value
      await docReference.update({"status": newValue});
    } else {
      // Document does not exist, handle it accordingly
      print("Document does not exist.");
    }
  } catch (error) {
    print("Error updating column: $error");
  }
}
  Future<bool> checkTechnician(String email, String password) async {
    final query = firestore.collection("Technician Details").where("email", isEqualTo: email);

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      final userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      String storedPassword = userData['password'];

      if (storedPassword == password) {
        // Email and password exist and match
        return true;
      }
    }

    // Email or password doesn't exist or doesn't match
    return false;
  }

  Future<bool> VerifyTechnicianStatus(String email) async {
    bool status = false;

    final query = firestore.collection("Technician Details").where(
        "email", isEqualTo: email);
    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      final userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      status = userData['status'];
      if (status) {
        return true;
      } else {
        return false;
      }
    }
    return status;
  }

  void AskQuestion(String? cname, String? email, String question) {
String QuestionStatus = "unread";
    firestore.collection("questions").add({
      "customer name": cname,
"email": email,
      "question": question,
      "question status": QuestionStatus,
    });

  }

  Future<void> UpdateQuestionStatus(String questionId, String newValue) async {
    try {
      final docReference = firestore.collection("questions").doc(questionId);

      // Read the current value of the "status" field
      DocumentSnapshot snapshot = await docReference.get();

      if (snapshot.exists) {
        // Update the "status" field with the new boolean value
        await docReference.update({"question status": newValue});
      } else {
        // Document does not exist, handle it accordingly
        print("Document does not exist.");
      }
    } catch (error) {
      print("Error updating column: $error");
    }
  }


  Future<List<Map<String, dynamic>?>> FilterQuestions(String cname) async {
    final query = firestore.collection("questions").where("customer name", isEqualTo: cname);

    QuerySnapshot querySnapshot = await query.get();

List<Map<String, dynamic>?> result = [];

    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        final userData = document.data() as Map<String, dynamic>;
        result.add(userData);
print(result);
      }
    }

    return result;
  }

  Future<void> ReplyToQuestions(String questionId, String reply) async {
    try {
      final docReference = firestore.collection("questions").doc(questionId);

      // Read the current value of the "status" field
      DocumentSnapshot snapshot = await docReference.get();

      if (snapshot.exists) {
        // Update the "reply" field with the new value
        await docReference.update({"reply": reply});
        print("Reply added successfully.");
      } else {
        // Document does not exist, handle it accordingly
        print("Document does not exist.");
      }
    } on FirebaseException catch (error) {
      // Handle Firestore-related errors (e.g., network errors, permission errors)
      print("Firestore Error: $error");
    } catch (error) {
      // Handle other exceptions
      print("Error: $error");
    }
  }

Future<bool> CheckTechnicianExists(String email) async {
  String? matching = "";
  bool result = false;
  final query = firestore.collection("Technician Details").where(
    "email",
    isEqualTo: email,
  );
  QuerySnapshot querySnapshot = await query.get();

  if (querySnapshot.docs.isNotEmpty) {
    final userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
    matching = userData['email'];

    if (matching == email) {
      result = true;
    } else {
      result = false;
    }
  }

  return result; // Don't forget to return the result
}


Future<void> RejectTechnician(String email) async {
  final query = firestore.collection("Technician Details").where(
    "email",
    isEqualTo: email,
  );
  QuerySnapshot querySnapshot = await query.get();

  if (querySnapshot.docs.isNotEmpty) {
    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      // Delete each document in the query result
      await documentSnapshot.reference.delete();
    }
}
  }


  Future<String> checkCustomer(String email) async {
String PhoneNumber = ""; 

    final query = firestore.collection("Customer Details").where("email", isEqualTo: email);

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      final userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      PhoneNumber = userData['phonenumber'];
    }
return PhoneNumber; 
print(PhoneNumber);
  }

void AddFeedback(String? cname, String technicianname, String feedback) {
          firestore.collection("feedbacks").add({
            "cname": cname,
            "technician name": technicianname,
            "feedback": feedback,
          });
}

Future<void> UpdateRequest(String requestId, String newValue) async {
  try {
    final docReference = firestore.collection("booked service").doc(requestId);

    // Read the current value of the "status" field
    DocumentSnapshot snapshot = await docReference.get();

    if (snapshot.exists) {
      // Update the "status" field with the new boolean value
      await docReference.update({"status": newValue});
    } else {
      // Document does not exist, handle it accordingly
      print("Document does not exist.");
    }
  } catch (error) {
    print("Error updating column: $error");
  }
}

  Future<List<Map<String, dynamic>?>> FilterRequests(String cname) async {
    final query = firestore.collection("booked service").where("CustomerName", isEqualTo: cname);

    QuerySnapshot querySnapshot = await query.get();

List<Map<String, dynamic>?> result = [];

    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        final userData = document.data() as Map<String, dynamic>;
        result.add(userData);
print(result);
      }
    }

    return result;
  }

void TechnicianRepairs(String? temail, String cname, String cemail, String productname, String problem, String cphonenumber) {
          firestore.collection("technician repairs").add({
            "technician email": temail,
"customer name": cname,
            "customer email": cemail,
            "product name": productname,
"problem": problem,
"customer phonenumber": cphonenumber,
          });
}

  Future<List<Map<String, dynamic>?>> FilterRepairs(String temail) async {
    final query = firestore.collection("technician repairs").where("technician email", isEqualTo: temail);

    QuerySnapshot querySnapshot = await query.get();

List<Map<String, dynamic>?> result = [];

    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        final userData = document.data() as Map<String, dynamic>;
        result.add(userData);
print(result);
      }
    }

    return result;
  }

} //end class