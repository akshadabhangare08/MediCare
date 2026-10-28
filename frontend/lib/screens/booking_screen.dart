import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../services/appointment_service.dart';

class BookingScreen extends StatefulWidget {
  final String token;

  BookingScreen({
    super.key,
    required this.token,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController _doctorController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final AppointmentService _appointmentService = AppointmentService();

  DateTime? _selectedDate;
  String? _selectedTime;
  bool _isLoading = false;

  final List<String> _times = [
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '02:00 PM',
    '04:00 PM',
  ];

  @override
  void dispose() {
    _doctorController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 90)),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _bookAppointment() async {
    if (_doctorController.text.trim().isEmpty ||
        _selectedDate == null ||
        _selectedTime == null ||
        _reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all details.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _appointmentService.bookAppointment(
        token: widget.token,
        doctorName: _doctorController.text.trim(),
        appointmentDate:
            '${_selectedDate!.year.toString().padLeft(4, '0')}-'
            '${_selectedDate!.month.toString().padLeft(2, '0')}-'
            '${_selectedDate!.day.toString().padLeft(2, '0')}',
        appointmentTime: _selectedTime!,
        reason: _reasonController.text.trim(),
      );

      if (!mounted) return;

      if (result['statusCode'] == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Appointment booked successfully!'),
          ),
        );

        _doctorController.clear();
        _reasonController.clear();

        setState(() {
          _selectedDate = null;
          _selectedTime = null;
        });
      } else {
        final data = result['data'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['detail']?.toString() ?? 'Booking failed.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to connect to server.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Book Your Visit',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 8),
            Text(
              'Enter your details to request an appointment.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 28),
            Text(
              'Doctor Name',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            CustomTextField(
              hintText: 'Enter doctor name',
              prefixIcon: Icons.medical_services_outlined,
              controller: _doctorController,
            ),
            SizedBox(height: 22),
            Text(
              'Appointment Date',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      color: Color(0xFF0D9488),
                    ),
                    SizedBox(width: 12),
                    Text(
                      _selectedDate == null
                          ? 'Select appointment date'
                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 22),
            Text(
              'Available Time',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _times.map((time) {
                return ChoiceChip(
                  label: Text(time),
                  selected: _selectedTime == time,
                  onSelected: (selected) {
                    setState(() {
                      _selectedTime = selected ? time : null;
                    });
                  },
                  selectedColor: Color(0xFFE6F7F5),
                );
              }).toList(),
            ),
            SizedBox(height: 22),
            Text(
              'Reason for Visit',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            CustomTextField(
              hintText: 'Enter reason for appointment',
              prefixIcon: Icons.edit_note_rounded,
              controller: _reasonController,
            ),
            SizedBox(height: 30),
            CustomButton(
              text: _isLoading
                  ? 'Booking...'
                  : 'Book Appointment',
              icon: Icons.check_circle_outline_rounded,
              onPressed: _isLoading ? () {} : _bookAppointment,
            ),
            if (_isLoading)
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
