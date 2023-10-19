import 'view_asked_questions.dart';
import 'package:flutter/material.dart';
import '../database/cleardata.dart';
import '../database/database.dart';
import 'view_registered_technicians.dart';

class DeleteData extends StatelessWidget {
  DeleteData({Key? key}) : super(key: key);
  final ClearData cd = ClearData();
  final DataBase db = DataBase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TechFixPro'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'TechFixPro',
                style: TextStyle(fontSize: 28),
              ),
              SizedBox(height: 30),
              ElevatedButton(
  key: Key('viewtechnicians'),

                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ViewTechnicians(),
                    ),
                  );
                },
                child: Text("View Technicians"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              ElevatedButton(

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewAskedQuestions()),
                  );
                },
                child: Text('View Questions', style: TextStyle(fontSize: 20.0)),
                style: ElevatedButton.styleFrom(
                  primary: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
