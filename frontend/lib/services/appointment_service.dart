
import 'dart:convert';
import 'package:http/http.dart' as http;

class AppointmentService {
  final String baseUrl = 'http://127.0.0.1:8000';

  Future<Map<String, dynamic>> bookAppointment({
    required String token,
    required String doctorName,
    required String appointmentDate,
    required String appointmentTime,
    required String reason,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/appointments/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'doctor_name': doctorName,
        'appointment_date': appointmentDate,
        'appointment_time': appointmentTime,
        'reason': reason,
      }),
    );

    return {
      'statusCode': response.statusCode,
      'data': jsonDecode(response.body),
    };
  }

  Future<Map<String, dynamic>> getAppointments({
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/appointments/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return {
      'statusCode': response.statusCode,
      'data': jsonDecode(response.body),
    };
  }

    Future<Map<String, dynamic>> cancelAppointment({
    required String token,
    required int appointmentId,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/appointments/$appointmentId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return {
      'statusCode': response.statusCode,
      'data': jsonDecode(response.body),
    };
  }
}




