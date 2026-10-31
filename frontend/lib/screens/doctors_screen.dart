
import 'package:flutter/material.dart';
import '../model/doctor_model.dart';
import 'doctor_details_screen.dart';

class DoctorsScreen extends StatefulWidget {
  DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> doctors = [
    {
      'name': 'Dr. Rahul Sharma',
      'speciality': 'Cardiologist',
      'experience': '8 years experience',
      'fee': '₹500',
      'icon': Icons.favorite,
      'qualification': 'MBBS, MD Cardiology',
      'availableDays': 'Monday to Saturday',
      'availableTime': '10:00 AM - 2:00 PM',
    },
    {
      'name': 'Dr. Priya Patil',
      'speciality': 'Dermatologist',
      'experience': '6 years experience',
      'fee': '₹400',
      'icon': Icons.face,
      'qualification': 'MBBS, MD Dermatology',
      'availableDays': 'Monday to Friday',
      'availableTime': '11:00 AM - 3:00 PM',
    },
    {
      'name': 'Dr. Amit Deshmukh',
      'speciality': 'Orthopedic',
      'experience': '10 years experience',
      'fee': '₹600',
      'icon': Icons.accessibility_new,
      'qualification': 'MBBS, MS Orthopedic',
      'availableDays': 'Monday to Saturday',
      'availableTime': '9:00 AM - 1:00 PM',
    },
    {
      'name': 'Dr. Sneha Joshi',
      'speciality': 'Pediatrician',
      'experience': '5 years experience',
      'fee': '₹350',
      'icon': Icons.child_care,
      'qualification': 'MBBS, MD Pediatrics',
      'availableDays': 'Monday to Friday',
      'availableTime': '10:00 AM - 4:00 PM',
    },
  ];

  List<Map<String, dynamic>> get filteredDoctors {
    String search = searchController.text.toLowerCase().trim();

    return doctors.where((doctor) {
      return doctor['name'].toLowerCase().contains(search) ||
          doctor['speciality'].toLowerCase().contains(search);
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
            controller: searchController,
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: 'Search doctors or speciality',
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  setState(() {});
                },
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 20),

          if (filteredDoctors.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Text(
                  'No doctors found',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

          ...filteredDoctors.map((doctor) {
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
                              onPressed: () {
                                Doctor selectedDoctor = Doctor(
                                  name: doctor['name'],
                                  specialization: doctor['speciality'],
                                  qualification: doctor['qualification'],
                                  experience: doctor['experience'],
                                  availableDays: doctor['availableDays'],
                                  availableTime: doctor['availableTime'],
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DoctorDetailsScreen(
                                      doctor: selectedDoctor,
                                    ),
                                  ),
                                );
                              },
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
