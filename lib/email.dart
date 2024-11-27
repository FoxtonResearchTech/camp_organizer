import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendEmail() async {
  const String url = 'http://localhost:3000/send-email'; // URL of your backend server

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'to_email': 'nn0004481@gmail.com',
      'subject': 'Subject of the email',
      'message': 'Body of the email',
    }),
  );

  if (response.statusCode == 200) {
    print('Email sent successfully!');
  } else {
    print('Failed to send email: ${response.body}');
  }
}
