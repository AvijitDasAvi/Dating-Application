import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileController extends GetxController {


    Future<void> openUrlInBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // opens in browser
      );
    } else {
      throw 'Could not launch $url';
    }
  }

    Map<String, int> inchesToFeetInch(int totalInches) {
    int feet = totalInches ~/ 12; // integer division
    int inch = totalInches % 12; // remainder
    return {'feet': feet, 'inch': inch};
  }
}
