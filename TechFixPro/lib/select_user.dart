import 'dart:io';
import 'dart:async';
import 'technician/login_screen.dart';

import 'package:connectivity/connectivity.dart';
import 'admin/options.dart';
import 'package:flutter/material.dart';
import 'screens/customer_login_screen.dart';

class SelectUser extends StatefulWidget {
final CustomerLoginScreen cls = CustomerLoginScreen();
  @override
  _SelectUserState createState() => _SelectUserState();
}

class _SelectUserState extends State<SelectUser> {
  bool hasNetwork = false;
  StreamSubscription<ConnectivityResult>? connectivitySubscription;

  @override
  void initState() {
    super.initState();

    // Initialize the initial network status
    checkNetworkStatus().then((result) {
      setState(() {
        hasNetwork = result;
      });
    });

    // Set up a listener for network connectivity changes
    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        hasNetwork = result != ConnectivityResult.none;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    connectivitySubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text('TechFixPro'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/serkit board.jpeg'), // Display the image
            buildButton("Customer", CustomerLoginScreen(), Key('customerButton')),
            buildButton("Technician", LoginScreen(), Key("technicianButton")),
            buildButton("Admin", DeleteData(), Key("adminButton")),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String text, Widget screen, Key key) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
    key: key,
        onPressed: hasNetwork
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screen),
                );
              }
            : null, // Disable the button if no network
        style: ButtonStyle(
          backgroundColor: hasNetwork
              ? MaterialStateProperty.all(Colors.deepOrange)
              : MaterialStateProperty.all(Colors.grey),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
    );
  }

  Future<bool> checkNetworkStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      return false; // No network access
    } else {
      return true; // Network access available
    }
  }

}
