import '../network/network_utils.dart';
import 'package:flutter/material.dart';
import '../helper/validator.dart';
import 'home_screen.dart';
import '../helper/firebase_auth.dart';
import '../database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _registerFormKey = GlobalKey<FormState>();
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
errorStyle: TextStyle(color: Colors.white), // Set the error text color
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
errorStyle: TextStyle(color: Colors.white), // Set the error text color

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
errorStyle: TextStyle(color: Colors.white), // Set the error text color

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
errorStyle: TextStyle(color: Colors.white), // Set the error text color

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
                                          // Check if the email is already in use
                                          final existingUser = await FirebaseAuth
                                              .instance
                                              .fetchSignInMethodsForEmail(
                                                  _emailTextController.text);

                                          if (existingUser.isNotEmpty) {
                                            // Email is already registered, show a message
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Email already exists. Please use another!"),
                                              ),
                                            );

                                            setState(() {
                                              _isProcessing = false;
                                            });
                                          } else {
                                            // Email is not registered, create a new user
                                            User? user =
                                                await FirebaseAuthHelper
                                                    .registerUsingEmailPassword(
                                              name:
                                                  _nameTextController.text,
                                              email:
                                                  _emailTextController.text,
                                              password:
                                                  _passwordTextController.text,
                                            );
                                            String name =
                                                _nameTextController.text;
                                            String email =
                                                _emailTextController.text;
                                            String password =
                                                _passwordTextController.text;
                                            String phoneNumber =
                                                _phoneNumberTextController.text; // Added phone number
                                            db.RegisterCustomer(
                                                name, email, password, phoneNumber);
                                            setState(() {
                                              _isProcessing = false;
                                            });

                                            if (user != null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "registration successful!"),
                                              ),
                                            );

                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeScreen(user: user),
                                                ),
                                                ModalRoute.withName('/'),
                                              );
                                            }
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
