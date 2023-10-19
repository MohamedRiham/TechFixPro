import 'package:http/http.dart' as http;

class PredictPrice {
  Future<String> predictRepairCost(String pname, String problem) async {
    final String url = "http://192.168.22.69:5000/predict"; // Replace with your API URL

    final Map<String, String> requestBody = {
      "productname": pname,
      "problem": problem,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final responseData = response.body;
        
        // Handle the response data based on your API's actual structure
        return responseData ?? "No data received from the server";
      } else {
        return "Error: ${response.statusCode}";
      }
    } catch (error) {
      return "Error: $error";
    }
  }
}
