import 'package:techfixpro/database/database.dart';
import 'package:test/test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  late DataBase database;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    database = DataBase(firestore: fakeFirestore);
  });

  test('registerCustomer should insert data', () async {
    String cn = 'john';
    String em = 'john@gmail.com';
    String psw = 'password';
    String pn = '0766608412';

    // Call the registerCustomer method
    database.RegisterCustomer(cn, em, psw, pn);

    // Use FakeFirebaseFirestore to verify the data in Firestore
    var collection = fakeFirestore.collection('Customer Details');
    var documents = await collection.get();

    // Add your test assertions to verify the inserted data
    expect(documents.docs, hasLength(1)); // Assuming one document was added
    expect(documents.docs[0]['name'], cn);
    expect(documents.docs[0]['email'], em);
    expect(documents.docs[0]['password'], psw);
    expect(documents.docs[0]['phonenumber'], pn);
  });

  test('checkTechnician', () async {
    // Prepare some sample data
    String email = 'john@gmail.com';
    String password = '00000000';

    // Insert a sample technician into the fake Firestore
    final fakeTechnicianData = {
      'email': email,
      'password': password,
    };
    fakeFirestore.collection('Technician Details').add(fakeTechnicianData);

    // Call the checkTechnician method
    bool result = await database.checkTechnician(email, password);

    // Assert that the result is true (technician exists and passwords match)
    expect(result, isTrue);

    // Cleanup if necessary
  });
}
