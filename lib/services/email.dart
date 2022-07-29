import 'package:http/http.dart' as http;
import 'dart:convert';

class Email {

 static Future sendEmail({
    required String name,
    required String email,
    required String toEmail,
    required String subject,
    required String message,


  }) async {
    final serviceId = 'service_44zp75f';
    final templateId = 'template_7rkr3hn';
    final userId = 'etVnbdhH-8d7B2-TC';
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'from_name': name, //my name
          'user_email': email, //my email
          'user_subject': subject, //email's subject
          'message': message, //message of email
          'to_email': toEmail, //recepient email
        },
      }),

    );
    print(response.body);
  }
}