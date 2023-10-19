import 'package:techfixpro/machine learning/predict_price.dart';
import 'package:test/test.dart';

void main() {
  late PredictPrice pp;

  setUp(() {
    pp = PredictPrice();
  });

  test('predict price', () async {
    String pn = '0';
    String problem = '1';
    
    // Call the predictRepairCost method
      String predictedPriceString = await pp.predictRepairCost(pn, problem);
      print(predictedPriceString);
  String stringWithoutQuotes = predictedPriceString.replaceAll('"', '');

    // Convert the predictedPriceString to a double
  double predictedPrice = double.parse(stringWithoutQuotes);
    // Define an acceptable range or threshold for predictions
    final lowerBound = 4000; // Define your lower bound as an integer
    final upperBound = 7000; // Define your upper bound as an integer

    // Convert the double predictedPrice to an int
    int predictedPriceInt = predictedPrice.toInt();

    // Check if the predicted price (as an int) falls within the acceptable range
    expect(predictedPriceInt, greaterThanOrEqualTo(lowerBound));
    expect(predictedPriceInt, lessThanOrEqualTo(upperBound));
  });
}
