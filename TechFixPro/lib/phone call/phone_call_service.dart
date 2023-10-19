import 'package:url_launcher/url_launcher.dart';

class PhoneCallService {
  Future<void> makingPhoneCall(String phoneNumber) async {
    var url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
