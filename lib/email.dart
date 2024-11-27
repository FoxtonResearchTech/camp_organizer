import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  // Function to launch the email app
  void _launchEmailApp() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'example@example.com',  // Replace with the recipient's email address
      query: Uri.encodeFull('subject=Hello&body=I want to contact you'),  // Optional subject and body
    );

    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      print("Could not launch email app.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open Email App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _launchEmailApp, // Call the function to open the email app
          child: const Text('Open Email App'),
        ),
      ),
    );
  }
}

