
import '../network/network_utils.dart';
import '../SharedPreferences/AddData.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

import '../helper/firebase_auth.dart';
import '../helper/validator.dart';

class CustomerLoginScreen extends StatefulWidget {
  @override
  _CustomerLoginScreenState createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
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
          title: Text('TechFixPro'),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
          return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0,top: 48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 150,
                      width: 150,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 30.0,top: 12),
                      child: Text(
                        'Welcome to TechFixPro',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40
                        )
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _emailTextController,
                            focusNode: _focusEmail,
                            validator: (value) => Validator.validateEmail(
                              email: value,
                            ),
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
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: _passwordTextController,
                            focusNode: _focusPassword,
                            obscureText: true,
                            validator: (value) => Validator.validatePassword(
                              password: value,
                            ),
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
                          SizedBox(height: 24.0),
                          _isProcessing
                          ? CircularProgressIndicator()
                          : Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    _focusEmail.unfocus();
                                    _focusPassword.unfocus();
    bool hasNetwork = await CheckNetworkConnection();
    if (!hasNetwork) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No network access. Please check your connection."),
        ),
      );
      return; // Return early to prevent further execution
    }

                                    if (_formKey.currentState!
                                        .validate()) {
                                      setState(() {
                                        _isProcessing = true;
                                      });

                                      User? user = await FirebaseAuthHelper
                                          .signInUsingEmailPassword(
                                        email: _emailTextController.text,
                                        password:
                                            _passwordTextController.text,
                                      );
String email = _emailTextController.text;
String password = _passwordTextController.text;

                                      setState(() {
                                        _isProcessing = false;
                                      });


                                      if (user != null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "login successful"),
                                              ),
                                            );

                                        Navigator.of(context)
                                            .pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen(user: user),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.deepOrangeAccent),
                                  ),
                                ),
                              ),
                              SizedBox(width: 24.0),
                              Expanded(
                                child: ElevatedButton(
  key: Key('register'),

                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SignUpScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'SignUp',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.deepOrangeAccent),
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

              );
            }

            return const Center(
              child: CircularProgressIndicator(),

            );
          },
        ),
),
    );
  }

Future<bool> CheckNetworkConnection() async {
  bool hasNetwork = await NetworkUtils.isNetworkAvailable();
  if (hasNetwork) {
return true;
  } else {
return false;
  }
}

}
