import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/service_card.dart';
import 'booking_screen.dart';

class HomeScreen extends StatelessWidget {
  final String token;

  HomeScreen({
    super.key,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.favorite_rounded,
              color: Color(0xFF0D9488),
            ),
            SizedBox(width: 8),
            Text('MediCare'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_rounded),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, Welcome! 👋',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 8),
            Text(
              'Your health, our priority.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 24),
            _buildHealthCard(context),
            SizedBox(height: 28),
            Text(
              'Our Services',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF163A43),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ServiceCard(
                    icon: Icons.calendar_month_rounded,
                    title: 'Appointments',
                    onTap: () {},
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: ServiceCard(
                    icon: Icons.medical_services_rounded,
                    title: 'Find Doctors',
                    onTap: () {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ServiceCard(
                    icon: Icons.receipt_long_rounded,
                    title: 'Medical Records',
                    onTap: () {},
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: ServiceCard(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'Health Support',
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFE6F7F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.health_and_safety_rounded,
            size: 42,
            color: Color(0xFF0D9488),
          ),
          SizedBox(height: 12),
          Text(
            'Take care of your health',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF163A43),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Book appointments and manage your healthcare in one place.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF52656B),
            ),
          ),
          SizedBox(height: 20),
          CustomButton(
            text: 'Get Started',
            icon: Icons.arrow_forward_rounded,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingScreen(
                    token: token,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
