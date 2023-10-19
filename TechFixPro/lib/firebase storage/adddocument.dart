import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AddDocument {
  String _uploadedFileURL = "";

Future<Reference?> uploadDocument(File document, String email) async {
  try {
    String fileExtension = Path.extension(document.path);
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('technician_document')
        .child('$email$fileExtension');
    UploadTask uploadTask = storageReference.putFile(document);
    await uploadTask.whenComplete(() async {
      String fileURL = await storageReference.getDownloadURL();
      _uploadedFileURL = fileURL;
    });
    return storageReference; // Return the reference to the uploaded file
  } catch (error) {
    // Handle the error, e.g., log it or show an error message
    print("Error uploading document: $error");
    _uploadedFileURL = ""; // Clear the URL in case of an error
    return null; // Return null to indicate an error
  }
}

  String get uploadedFileURL => _uploadedFileURL;

Future<void> deleteFileFromStorage(String fileUrl) async {
  try {
    // Parse the URL to get the path (excluding the storage bucket URL)

    // Get a reference to the file in Firebase Storage
    final Reference storageRef = FirebaseStorage.instance.ref().child(fileUrl);

    // Delete the file
    await storageRef.delete();

    print('File deleted successfully.');
  } catch (error) {
    print('Error deleting file: $error');
  }
}

}//end class
