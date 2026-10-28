
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecordsScreen extends StatefulWidget {
  final String token;

  RecordsScreen({super.key, required this.token});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  List<dynamic> records = [];
  bool isLoading = true;
  String? errorMessage;

  final String baseUrl = 'http://127.0.0.1:8000';

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final doctorController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    fetchRecords();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    doctorController.dispose();
    super.dispose();
  }

  Future<void> fetchRecords() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/medical-records/'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          records = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Unable to load medical records.';
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Server connection failed. Please try again.';
        isLoading = false;
      });
    }
  }

  IconData getRecordIcon(String title) {
    final value = title.toLowerCase();

    if (value.contains('blood')) {
      return Icons.bloodtype_outlined;
    } else if (value.contains('prescription')) {
      return Icons.medication_outlined;
    } else if (value.contains('health')) {
      return Icons.monitor_heart_outlined;
    }

    return Icons.description_outlined;
  }

  String formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return '${parsedDate.day.toString().padLeft(2, '0')} '
          '${_monthName(parsedDate.month)} ${parsedDate.year}';
    } catch (e) {
      return date;
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    return months[month - 1];
  }

  Future<void> showAddRecordDialog() async {
    titleController.clear();
    descriptionController.clear();
    doctorController.clear();
    selectedDate = DateTime.now();

    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      barrierDismissible: !isSaving,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Add Medical Record'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: 'Record Title',
                          hintText: 'Blood Test Report',
                          prefixIcon: Icon(Icons.description_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length < 2) {
                            return 'Enter a valid title';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 14),
                      TextFormField(
                        controller: descriptionController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Enter report details',
                          prefixIcon: Icon(Icons.notes_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length < 2) {
                            return 'Enter a description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 14),
                      TextFormField(
                        controller: doctorController,
                        decoration: InputDecoration(
                          labelText: 'Doctor Name',
                          hintText: 'Dr. Rahul',
                          prefixIcon: Icon(Icons.person_outline_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length < 2) {
                            return 'Enter doctor name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 14),
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );

                          if (date != null) {
                            setDialogState(() {
                              selectedDate = date;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFDDE9E8),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                color: Color(0xFF0D9488),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  formatDate(
                                    selectedDate.toIso8601String().split('T')[0],
                                  ),
                                ),
                              ),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }

                          setDialogState(() {
                            isSaving = true;
                          });

                          final success = await saveMedicalRecord();

                          if (!mounted) return;

                          if (success) {
                            Navigator.pop(dialogContext);

                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(
                                content: Text('Medical record added successfully'),
                                backgroundColor: Color(0xFF0D9488),
                              ),
                            );
                          } else {
                            setDialogState(() {
                              isSaving = false;
                            });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0D9488),
                    foregroundColor: Colors.white,
                  ),
                  child: isSaving
                      ? SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text('Save Record'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool> saveMedicalRecord() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/medical-records/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'title': titleController.text.trim(),
          'description': descriptionController.text.trim(),
          'doctor_name': doctorController.text.trim(),
          'record_date': selectedDate.toIso8601String().split('T')[0],
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchRecords();
        return true;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save record: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to connect to the server.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Records'),
        actions: [
          IconButton(
            onPressed: showAddRecordDialog,
            icon: Icon(Icons.add_circle_outline_rounded),
            tooltip: 'Add Medical Record',
          ),
          IconButton(
            onPressed: fetchRecords,
            icon: Icon(Icons.refresh_rounded),
            tooltip: 'Refresh records',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchRecords,
        color: Color(0xFF0D9488),
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFE6F7F5),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.folder_open_rounded,
                      color: Color(0xFF0D9488),
                      size: 32,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Health Records',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF163A43),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Keep your medical documents in one place.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF526B70),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Records',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '${records.length} records',
                  style: TextStyle(
                    color: Color(0xFF0D9488),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            if (isLoading)
              Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF0D9488),
                  ),
                ),
              )
            else if (errorMessage != null)
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFFFF3F3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.cloud_off_outlined,
                      size: 36,
                      color: Colors.redAccent,
                    ),
                    SizedBox(height: 10),
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: fetchRecords,
                      child: Text('Try Again'),
                    ),
                  ],
                ),
              )
            else if (records.isEmpty)
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Color(0xFFF7FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Color(0xFFDDE9E8)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.folder_open_outlined,
                      size: 42,
                      color: Color(0xFF0D9488),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No medical records yet',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Your medical records will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF526B70)),
                    ),
                  ],
                ),
              )
            else
              ...records.map((record) {
                final title =
                    record['title']?.toString() ?? 'Medical Record';
                final description =
                    record['description']?.toString() ?? '';
                final doctorName =
                    record['doctor_name']?.toString() ?? 'Doctor not specified';
                final date = record['record_date']?.toString() ?? '';

                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xFFE6F7F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            getRecordIcon(title),
                            color: Color(0xFF0D9488),
                            size: 28,
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                description,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                doctorName,
                                style: TextStyle(
                                  color: Color(0xFF163A43),
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                formatDate(date),
                                style: TextStyle(
                                  color: Color(0xFF0D9488),
                                  fontSize: 12,
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
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xFFDDE9E8)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    color: Color(0xFF0D9488),
                    size: 28,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your records are loaded from MediCare.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF526B70),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
