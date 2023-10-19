import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AddImage {
  String _uploadedFileURL = "";

  Future<void> uploadImage(File image) async { // Add async keyword here
    Reference storageReference = FirebaseStorage.instance.ref()
        .child('customer_images/${Path.basename(image.path)}'); // Use image.path to get the file path
    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() async {
      String fileURL = await storageReference.getDownloadURL(); // Use await here to get the fileURL
      _uploadedFileURL = fileURL;
    });
  }

  String get uploadedFileURL => _uploadedFileURL; // Getter to access the uploaded file URL






}//end class