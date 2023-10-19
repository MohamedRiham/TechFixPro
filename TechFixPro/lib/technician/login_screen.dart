import '../SharedPreferences/AddData.dart';
import '../network/network_utils.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'options.dart';
import 'signup_screen.dart';

import '../helper/validator.dart';
import '../database/database.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AddData ad = AddData();
  final DataBase db = DataBase();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    autologin(); // Automatically attempt to log in when the screen is first loaded
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          title: Text('Technician Login'), // Added 'Technician Login' as the title
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 30.0, top: 12),
                  child: Text(
                    'Welcome to TechFixPro',
                    style: TextStyle(color: Colors.black, fontSize: 40),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailTextController,
                        focusNode: _focusEmail,
                        validator: (value) =>
                            Validator.validateEmail(email: value),
                        decoration: InputDecoration(
                          hintText: "Email",
                          errorStyle:
                              TextStyle(color: Colors.white), // Set the error text color
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: _passwordTextController,
                        focusNode: _focusPassword,
                        obscureText: true,
                        validator: (value) =>
                            Validator.validatePassword(password: value),
                        decoration: InputDecoration(
                          hintText: "Password",
                          errorStyle:
                              TextStyle(color: Colors.white), // Set the error text color
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.0),
                      _isProcessing
                          ? CircularProgressIndicator()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      _focusEmail.unfocus();
                                      _focusPassword.unfocus();
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

                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _isProcessing = true;
                                        });

                                        String email = _emailTextController.text;
                                        String password =
                                            _passwordTextController.text;
                                        bool accuracy =
                                            await db.checkTechnician(email, password);
                                        if (accuracy) {
                                          ad.insertTechnician(email, password);
                                          setState(() {
                                            _isProcessing = false;
                                          });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "login successful!"),
                                          ),
                                        );

                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => Options(),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text("Invalid details!"),
                                            ),
                                          );
                                          setState(() {
                                            _isProcessing = false;
                                          });
                                        }
                                      }
                                    },
                                    child: Text(
                                      'Sign In',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(Colors.deepOrangeAccent),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 24.0),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SignUpScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(Colors.deepOrangeAccent),
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

  @override
  void autologin() async {
    Map<String, String> credentials = await ad.getCredentials();
    String email = credentials['email'] ?? ''; // Get email, use an empty string as a default value if not found
    String password = credentials['password'] ?? ''; // Get password, use an empty string as a default value if not found
    bool accuracy = await db.checkTechnician(email, password);

    if (email.isNotEmpty && password.isNotEmpty && accuracy) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Options(),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SignUpScreen(),
        ),
      );
    }
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
