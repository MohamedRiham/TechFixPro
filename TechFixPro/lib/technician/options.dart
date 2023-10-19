import 'my_repairs.dart';
import 'view_feedbacks.dart';
import 'package:flutter/material.dart';
import '../SharedPreferences/AddData.dart';
import 'login_screen.dart';
import 'view_booked_service.dart';
import '../database/database.dart';

class Options extends StatefulWidget {
  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  AddData ad = AddData();
  DataBase db = DataBase();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    checkstatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text('TechFixPro'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'option1',
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('LogOut'),
                  ),
                ),
                PopupMenuDivider(),
              ];
            },
            onSelected: (String value) {
              // Handle the selected option
              switch (value) {
                case 'option1':
                  // Perform delete operation
                  ad.clearData();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen(),
                    ),
                  );
                  break;
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isButtonEnabled
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewBookedService()),
                      );
                    }
                  : null,
              style: ButtonStyle(
                backgroundColor: _isButtonEnabled
                    ? MaterialStateProperty.all(Colors.deepOrangeAccent)
                    : MaterialStateProperty.all(Colors.grey),
              ),
              child: Text('View Requests', style: TextStyle(fontSize: 20.0)),
            ),
            ElevatedButton(
              onPressed: _isButtonEnabled
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewFeedBacks()),
                      );
                    }
                  : null,
              style: ButtonStyle(
                backgroundColor: _isButtonEnabled
                    ? MaterialStateProperty.all(Colors.deepOrangeAccent)
                    : MaterialStateProperty.all(Colors.grey),
              ),
              child: Text('View Feedbacks', style: TextStyle(fontSize: 20.0)),
            ),
            ElevatedButton(
              onPressed: _isButtonEnabled
                  ? () async {
    Map<String, String> credentials = await ad.getCredentials();
    String? email = credentials['email'];
                      
Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyRepairs(userName: email)),
                      );
                    }
                  : null,
              style: ButtonStyle(
                backgroundColor: _isButtonEnabled
                    ? MaterialStateProperty.all(Colors.deepOrangeAccent)
                    : MaterialStateProperty.all(Colors.grey),
              ),
              child: Text('my repairs', style: TextStyle(fontSize: 20.0)),
            ),

          ],
        ),
      ),
    );
  }

  Future<bool> checkstatus() async {
    Map<String, String> credentials = await ad.getCredentials();
    String? email = credentials['email'];
    bool status = await db.VerifyTechnicianStatus(email!);
    setState(() {
      _isButtonEnabled = status;
    });
    if (status) {
      _isButtonEnabled = true;
    } else {
      _isButtonEnabled = false;
    }
    print(status);
    return status;
  }
}
