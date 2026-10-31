import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  final String token;

  ProfileScreen({super.key, required this.token});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? user;
  bool isLoading = true;
  bool isUpdating = false;

  final TextEditingController nameController = TextEditingController();

  final Color primaryColor = Color(0xFF0D9488);
  final Color backgroundColor = Color(0xFFF5F8FA);

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> getProfile() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/auth/me'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          user = data;
          nameController.text = data['full_name'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateProfile() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter your name')));
      return;
    }

    setState(() {
      isUpdating = true;
    });

    try {
      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({'full_name': nameController.text.trim()}),
      );

      if (response.statusCode == 200) {
        setState(() {
          user = jsonDecode(response.body);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: primaryColor,
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Unable to update profile')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong')));
    } finally {
      if (mounted) {
        setState(() {
          isUpdating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'My Profile',
          style: TextStyle(
            color: Color(0xFF183B45),
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : user == null
          ? Center(child: Text('Unable to load profile'))
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 95,
                          height: 95,
                          decoration: BoxDecoration(
                            color: Color(0xFFE6F7F5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            size: 55,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(height: 14),
                        Text(
                          user!['full_name'] ?? 'User',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF183B45),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          user!['email'] ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFE6F7F5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Active Account',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 25),

                  Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF183B45),
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    'Manage your personal details',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),

                  SizedBox(height: 18),

                  Text(
                    'Full Name',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),

                  SizedBox(height: 9),

                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: primaryColor,
                      ),
                      hintText: 'Enter your full name',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryColor, width: 1.5),
                      ),
                    ),
                  ),

                  SizedBox(height: 18),

                  Text(
                    'Email Address',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),

                  SizedBox(height: 9),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFEFF3F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.email_outlined, color: Colors.grey.shade600),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            user!['email'] ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.lock_outline,
                          size: 18,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isUpdating ? null : updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isUpdating
                          ? CircularProgressIndicator(color: Colors.white)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save_outlined),
                                SizedBox(width: 9),
                                Text(
                                  'Update Profile',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
