import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file_plus/open_file_plus.dart';
import '../database/database.dart';
import '../emails/email_sender.dart';
import '../firebase storage/adddocument.dart';
class ViewTechnicians extends StatefulWidget {
  @override
  _ViewTechniciansState createState() => _ViewTechniciansState();
}

class _ViewTechniciansState extends State<ViewTechnicians> {
AddDocument ad = AddDocument();
  final EmailSender es = EmailSender();
final  DataBase db = DataBase();
  File? downloadedFile;
  String? downloadMessage;
String TechnicianId = "";
String emailaddress = "";
String DUrl = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey<ScaffoldState>(), // Add this line to set a key
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("TechFixPro"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Technician Details').snapshots(),
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
                final TechnicianName = data?['name'] ?? 'No Name';
                final email = data?['email'] ?? 'No email';
                final password = data?['password'] ?? 'No password';
                final phonenumber = data?['phonenumber'] ?? 'No phonenumber';
                final documentUrl = (data?['document'] ?? 'NodocumentURL')
                    .replaceAll('"', '');
                final TechnicianStatus = data?['status'] ?? 'No status';
                final FileReference = data?['document reference'] ?? 'No reference';

                return ListTile(
                  title: Text('TechnicianName: $TechnicianName'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('email: $email'),
                      Text('password: $password'),
                      Text('phonenumber: $phonenumber'),

                      Text('status: $TechnicianStatus'),
                      ElevatedButton(
                        onPressed: () async {
                          await _requestStoragePermission();
                          String fileExtension = '.docx';
                          String finalFileName = email + fileExtension;
                          downloadFile(url: documentUrl, filename: finalFileName);
                        },
                        child: Text('Open Document'),
                      ),
                    ],
                  ),
                  onLongPress: () {
                    TechnicianId = documentId;
                    emailaddress = email;
DUrl = FileReference;
                    _showActionDialog(); // Function to show the dialog
                  },
                );
              });


        },
      ),
    );
  }
  void _showActionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Action"),
          content: Text("Do you want to reject or accept this technician?"),
          actions: <Widget>[
            TextButton(
              child: Text("Reject"),
              onPressed: () {
                print(DUrl);
 ad.deleteFileFromStorage(DUrl);
db.RejectTechnician(emailaddress);
                String subject = "your request has been rejected";
                String body = "please work more with repairing electronics to gain more experiences and re submit another document with plausible information";
                bool reject = false;
db.TechnicianStatus(TechnicianId, reject);
es.sendEmail(subject, body, emailaddress);
print(es);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Accept"),
              onPressed: () {
                bool accept = true;
                db.TechnicianStatus(TechnicianId, accept);
                Navigator.of(context).pop(); // Close the dialog
                // Perform the accept action here
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> downloadFile({
    required String url,
    required String filename,
  }) async {
    try {
      HttpClient client = HttpClient();
      List<Uint8List> downloadData = [];

      Directory downloadDirectory;

      if (Platform.isIOS) {
        downloadDirectory = await getApplicationDocumentsDirectory();
      } else {
        downloadDirectory = Directory('/storage/emulated/0/Download');
        if (!await downloadDirectory.exists()) downloadDirectory = (await getExternalStorageDirectory())!;
      }

      String filePathName = "${downloadDirectory.path}/$filename";
      print(downloadDirectory);
      print(filename);
      File savedFile = File(filePathName);
      bool fileExists = await savedFile.exists();

      if (fileExists) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("File already downloaded")));
        OpenFile.open(filePathName);

      } else {
        final request = await client.getUrl(Uri.parse(url));
        final response = await request.close();

        await response.forEach((List<int> data) {
          downloadData.add(Uint8List.fromList(data));
        });

        savedFile.writeAsBytes(downloadData.expand((byteList) => byteList).toList());
        OpenFile.open(filePathName);
        setState(() {
          downloadedFile = savedFile;
        });
      }
    } catch (error) {
      setState(() {
        downloadMessage = "Some error occurred -> $error";
      });
    }
  }
  _requestStoragePermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Permission granted; you can open files.
    } else {
      // Permission denied; handle accordingly.
    }
  }

}//end class
