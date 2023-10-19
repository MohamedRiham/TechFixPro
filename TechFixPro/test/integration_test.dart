
import 'package:techfixpro/screens/home_screen.dart';
import 'package:techfixpro/screens/customer_login_screen.dart';
import 'package:techfixpro/admin/view_registered_technicians.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techfixpro/main.dart';
import 'package:techfixpro/select_user.dart';
import 'package:techfixpro/admin/options.dart';
import 'package:techfixpro/screens/signup_screen.dart';

void main() {
  testWidgets('App should load and display the customer login screen', (WidgetTester tester) async {
    await Firebase.initializeApp();
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Tap the 'Customer' button
    await tester.tap(find.byKey(const Key('customerButton')));

    await tester.pumpAndSettle();
    // Verify that the customer login screen is displayed
    expect(find.byType(CustomerLoginScreen), findsOneWidget);

    await tester.tap(find.byKey(const Key('register')));

    await tester.pumpAndSettle();

      expect(find.byType(SignUpScreen ), findsOneWidget);

  });
  testWidgets('App should load and display the admin options', (WidgetTester tester) async {
    await Firebase.initializeApp();
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Tap the 'Customer' button
    await tester.tap(find.byKey(const Key('adminButton')));

    await tester.pumpAndSettle();    

    expect(find.byType(DeleteData), findsOneWidget);

    await tester.tap(find.byKey(const Key('viewtechnicians')));
    await tester.pumpAndSettle();    


    expect(find.byType(ViewTechnicians), findsOneWidget);
  });
}
