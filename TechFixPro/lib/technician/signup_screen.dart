
import 'package:firebase_storage/firebase_storage.dart';

  import 'dart:io';
import 'options.dart';

import '../firebase storage/adddocument.dart';

import '../file picker/FileSelectionService.dart';
import '../network/network_utils.dart';
import 'package:flutter/material.dart';
import '../helper/validator.dart';
import '../helper/firebase_auth.dart';
import '../SharedPreferences/AddData.dart';
import '../database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'view_booked_service.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _registerFormKey = GlobalKey<FormState>();
final AddDocument ad = AddDocument();
  String uploadedFileURL = ""; // Variable to store the uploaded file URL

  final FileSelectionService fileSelectionService = FileSelectionService();
File? document;

  final AddData sp = AddData();
  final DataBase db = DataBase();
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _phoneNumberTextController = TextEditingController(); // Added for phone number
  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _focusPhoneNumber = FocusNode(); // Added for phone number
  final firestore = FirebaseFirestore.instance;
  get data => null;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
        _focusPhoneNumber.unfocus(); // Added for phone number
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          title: Text('Create Account'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _registerFormKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _nameTextController,
                        focusNode: _focusName,
                        validator: (value) =>
                            Validator.validateName(name: value),
                        decoration: InputDecoration(
                          hintText: "Name",
errorStyle: TextStyle(color: Colors.white),
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      TextFormField(
                        controller: _emailTextController,
                        focusNode: _focusEmail,
                        validator: (value) =>
                            Validator.validateEmail(email: value),
                        decoration: InputDecoration(
                          hintText: "Email",
errorStyle: TextStyle(color: Colors.white),
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      TextFormField(
                        controller: _passwordTextController,
                        focusNode: _focusPassword,
                        obscureText: true,
                        validator: (value) =>
                            Validator.validatePassword(password: value),
                        decoration: InputDecoration(
                          hintText: "Password",
errorStyle: TextStyle(color: Colors.white),
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      TextFormField(
                        controller: _phoneNumberTextController,
                        focusNode: _focusPhoneNumber, // Added for phone number
                        validator: (value) =>
                            Validator.validatePhoneNumber(phoneNumber: value),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "Phone Number",
errorStyle: TextStyle(color: Colors.white),
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32.0),
                      _isProcessing
                          ? CircularProgressIndicator()
                          : Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      bool hasNetwork =
                                          await CheckNetworkConnection();
                                      if (!hasNetwork) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "No network access. Please check your connection."),
                                          ),
                                        );
                                        return; // Return early to prevent further execution
                                      }

                                      setState(() {
                                        _isProcessing = true;
                                      });

                                      if (_registerFormKey.currentState!
                                          .validate()) {
                                        try {
    String name =
    _nameTextController.text;
    String email =
    _emailTextController.text;
    String password =
    _passwordTextController.text;
    String phoneNumber =
    _phoneNumberTextController.text; // Added phone number
    bool? existence = await db.CheckTechnicianExists(email);
    if (existence == true) {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text("email allready exists, please use another!"),
    ),
    );
    setState(() {
      _isProcessing = false;
    });

    return;
    }
      Reference? uploadedFileReference = await ad.uploadDocument(document!, email);
String uploadedFileReferenceStr = uploadedFileReference?.fullPath ?? ''; // Get the full path as a String
      uploadedFileURL = ad.uploadedFileURL;
      if (uploadedFileURL.isNotEmpty) {
        sp.insertTechnician(email, password);

        db.registerTechnician(
            name, email, password, phoneNumber, uploadedFileURL, uploadedFileReferenceStr);
print(uploadedFileReferenceStr);
        _nameTextController.clear();

        _emailTextController.clear();
        _passwordTextController.clear();
        _phoneNumberTextController.clear();
        uploadedFileURL = "";
        document = null;
        setState(() {
          _isProcessing = false;
        });
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text("registration successful!"),
    ),
    );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Options(),
          ),
        );

                                      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("fill all the details!"),
          ),
        );
}

                                        } catch (error) {
                                          // Handle other registration errors
                                          print("Error: $error");
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "Registration failed. Please try again."),
                                            ),
                                          );

                                          setState(() {
                                            _isProcessing = false;
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          _isProcessing = false;
                                        });
                                      }
                                    },
                                    child: Text(
                                      'Sign up',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.deepOrangeAccent),
                                    ),
                                  ),
                                ),
                  ElevatedButton(
                    onPressed: () async {
    String? selectedFilePath = await fileSelectionService.SelectDocument();
    if (selectedFilePath != null) {
      // Check if the selected file has a .docx extension
      if (selectedFilePath.toLowerCase().endsWith('.docx')) {
        setState(() {
          document = File(selectedFilePath);
        });
      } else {
        // Display an error message if the file is not a .docx file
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please select a .docx file."),
          ),
        );
      }
    }
},
                    child: Text("Add document"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                              ],
                            )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> CheckNetworkConnection() async {
    bool hasNetwork = await NetworkUtils.isNetworkAvailable();
    if (hasNetwork) {
      // Network access is available, perform your function
      return true;
    } else {
      // No network access, handle accordingly (e.g., show an error message)
      return false;
    }
  }
}
