// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            "Dont forget to 'STAR' my repo ",
            style: TextStyle(color: Color.fromARGB(255, 66, 120, 186)),
          ),
          GestureDetector(
            onTap: () {
              _openLinkInBrowser("https://github.com/NehaKushwah993");
            },
            child: Image.asset(
              "assets/images/github.webp",
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
    );
  }

  void _openLinkInBrowser(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
