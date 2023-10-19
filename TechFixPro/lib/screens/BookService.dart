import 'requests_history.dart';
import '../machine learning/predict_price.dart';
import '../file picker/FileSelectionService.dart';
import '../machine learning/enums.dart';
import '../network/network_utils.dart';

import 'dart:io';

import '../database/database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import '../firebase storage/addimage.dart';

class BookService extends StatefulWidget {
  final String? userName;  
final String? email;
  BookService({required this.userName, required this.email});

  @override
  _BookServiceState createState() => _BookServiceState();
}

class _BookServiceState extends State<BookService> {
String presult = '';
final PredictPrice pp = PredictPrice();
  final FileSelectionService fileSelectionService = FileSelectionService();
  File _image = File(""); // Initialize with an empty File
final AddImage ai = AddImage();
  final DataBase db = DataBase();
  ProductName selectedProduct = ProductName.laptop;
  Problem selectedProblem = Problem.noPower;

  String uploadedFileURL = ""; // Variable to store the uploaded file URL
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Book Service',
                    style: TextStyle(fontSize: 28),
                  ),
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Select Product',
      style: TextStyle(fontSize: 16),
    ),
    DropdownButtonFormField<ProductName>(
      value: selectedProduct,
      onChanged: (newValue) {
        setState(() {
          selectedProduct = newValue!;
        });
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        hintText: 'Choose a product',
        labelText: 'Product',
      ),
      items: ProductName.values.map((product) {
        return DropdownMenuItem<ProductName>(
          value: product,
          child: Text(product.toString().split('.').last),
        );
      }).toList(),
    ),
  ],
),
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Select Problem',
      style: TextStyle(fontSize: 16),
    ),
    DropdownButtonFormField<Problem>(
      value: selectedProblem,
      onChanged: (newValue) {
        setState(() {
          selectedProblem = newValue!;
        });
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        hintText: 'Choose a problem',
        labelText: 'Problem',
      ),
      items: Problem.values.map((problem) {
        return DropdownMenuItem<Problem>(
          value: problem,
          child: Text(problem.toString().split('.').last),
        );
      }).toList(),
    ),
  ],
),                  ElevatedButton(
                    onPressed: () async {
                      // Handle adding an image here
      String? selectedFilePath = await fileSelectionService.selectFile();
      if (selectedFilePath != null) {
        setState(() {
          _image = File(selectedFilePath);
        });
}
                    },
                    child: Text("Add Image"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

ElevatedButton(
  onPressed: () async {
    bool hasNetwork = await CheckNetworkConnection();
    if (!hasNetwork) {
      // Handle the case when there's no network access, e.g., show an error message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No network access. Please check your connection."),
        ),
      );
      return; // Return early to prevent further execution
    }
    if (_image != null && _image.existsSync()) {
      String? customerName = widget.userName;
String? email = widget.email;
print(email);
if (email != null) {
String? phonenumber = await db.checkCustomer(email);
String sl = selectedProduct.toString().split('.').last;
ProductName selectedProductEnum = mapProductToEnum(sl);
  int productValue = customProductValues[selectedProductEnum] ?? 0;
String sp = selectedProblem.toString().split('.').last;

Problem selectedProblemEnum = mapProblemToEnum(sp);
  int problemValue = customProblemValues[selectedProblemEnum] ?? 0;

      // Show a loading indicator while the image is being uploaded
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text("Uploading image..."),
            ],
          ),


        ),
      );
presult = await pp.predictRepairCost(productValue.toString(), problemValue.toString());
print('jaws$presult');
      setState(() {});
      // Upload the image and wait for the URL
      await ai.uploadImage(_image);

      // Retrieve the uploaded file URL
      uploadedFileURL = ai.uploadedFileURL;

      // Check if the URL is not empty (indicating a successful upload)
      if (uploadedFileURL.isNotEmpty) {
        db.addData(customerName!, email, phonenumber, sl, sp, uploadedFileURL);

        // Remove the loading indicator
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Image upload failed. Please try again."),
          ),
        );
      }
}
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all required fields and select an image."),
        ),
      );
    }
  },

                    child: Text("Submit Details"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
Text(
  'estimated Repair Cost: lkr $presult', // Display the result here
  style: TextStyle(fontSize: 16),
),

_image != null && _image.existsSync()
    ? Image.file(
        _image,
        height: 150,
      )
    : Container(),
                  ElevatedButton(
                    onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RequestHistory(userName: widget.userName)),
          );

                    },
                    child: Text("Service History"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
),
                ],
              ),
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