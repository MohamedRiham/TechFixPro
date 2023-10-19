import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class EmailSender {
  Future<void> sendEmail(String subject, String body, String receiver) async {
    try {
      final Uri _emailLaunchUri = Uri(
        scheme: 'mailto',
        path: receiver,
        queryParameters: {
          'subject': Uri.encodeComponent(subject),
          'body': Uri.encodeComponent(body),
        },
      );

      if (Platform.isAndroid) {
        // On Android, you can specify the Gmail app's package name
        final String gmailPackageName = "com.google.android.gm";
        if (await canLaunch("package:$gmailPackageName")) {
          await launch("package:$gmailPackageName", forceSafariVC: false);
        } else {
          // If Gmail app is not installed, open the email in the user's preferred email app
          if (await canLaunch(_emailLaunchUri.toString())) {
            await launch(_emailLaunchUri.toString());
          } else {
            throw 'Could not launch email';
          }
        }
      } else {
        // On iOS and other platforms, simply launch the email using the mailto scheme
        if (await canLaunch(_emailLaunchUri.toString())) {
          await launch(_emailLaunchUri.toString());
        } else {
          throw 'Could not launch email';
        }
      }
    } catch (error) {
      print("$error");
    }
  }
}
