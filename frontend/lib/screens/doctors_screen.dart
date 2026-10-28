import 'package:flutter/material.dart';

class DoctorsScreen extends StatelessWidget {
  DoctorsScreen({super.key});

  final List<Map<String, dynamic>> doctors = [
    {
      'name': 'Dr. Rahul Sharma',
      'speciality': 'Cardiologist',
      'experience': '8 years experience',
      'fee': '₹500',
      'icon': Icons.favorite,
    },
    {
      'name': 'Dr. Priya Patil',
      'speciality': 'Dermatologist',
      'experience': '6 years experience',
      'fee': '₹400',
      'icon': Icons.face,
    },
    {
      'name': 'Dr. Amit Deshmukh',
      'speciality': 'Orthopedic',
      'experience': '10 years experience',
      'fee': '₹600',
      'icon': Icons.accessibility_new,
    },
    {
      'name': 'Dr. Sneha Joshi',
      'speciality': 'Pediatrician',
      'experience': '5 years experience',
      'fee': '₹350',
      'icon': Icons.child_care,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Doctors'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Find the right doctor for you',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search doctors or speciality',
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 20),
          ...doctors.map((doctor) {
            return Card(
              margin: EdgeInsets.only(bottom: 14),
              elevation: 1,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        color: Color(0xFFE6F7F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        doctor['icon'],
                        color: Color(0xFF0D9488),
                        size: 32,
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(doctor['speciality']),
                          SizedBox(height: 5),
                          Text(
                            doctor['experience'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Fee: ${doctor['fee']}',
                            style: TextStyle(
                              color: Color(0xFF0D9488),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text('View Details'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}