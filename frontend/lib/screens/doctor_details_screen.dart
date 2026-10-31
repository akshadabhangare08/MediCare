
import 'package:flutter/material.dart';
import '../model/doctor_model.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final Doctor doctor;

  DoctorDetailsScreen({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7FAFC),
      appBar: AppBar(
        title: Text('Doctor Details'),
        backgroundColor: Color(0xFF0D9488),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xFFE6F7F5),
                child: Icon(
                  Icons.person,
                  size: 65,
                  color: Color(0xFF0D9488),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                doctor.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF163A43),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                doctor.specialization,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF0D9488),
                ),
              ),
            ),
            SizedBox(height: 25),
            detailCard('Qualification', doctor.qualification, Icons.school),
            detailCard('Experience', doctor.experience, Icons.work),
            detailCard('Available Days', doctor.availableDays, Icons.calendar_month),
            detailCard('Available Time', doctor.availableTime, Icons.access_time),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/booking');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Book Appointment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailCard(String title, String value, IconData icon) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF0D9488)),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
