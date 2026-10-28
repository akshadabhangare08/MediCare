import 'package:flutter/material.dart';
import '../services/appointment_service.dart';

class AppointmentsScreen extends StatefulWidget {
  final String token;

  AppointmentsScreen({super.key, required this.token});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final AppointmentService _service = AppointmentService();
  List<dynamic> appointments = [];
  bool isLoading = true;
  String? errorMessage;
  int? cancellingId;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      final result = await _service.getAppointments(token: widget.token);

      if (!mounted) return;

      if (result['statusCode'] == 200) {
        setState(() {
          appointments = result['data']['appointments'];
          isLoading = false;
          errorMessage = null;
        });
      } else {
        setState(() {
          errorMessage = 'Unable to load appointments.';
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Something went wrong. Please try again.';
        isLoading = false;
      });
    }
  }

  Future<void> cancelAppointment(int appointmentId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Appointment?'),
        content: Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      cancellingId = appointmentId;
    });

    try {
      final result = await _service.cancelAppointment(
        token: widget.token,
        appointmentId: appointmentId,
      );

      if (!mounted) return;

      if (result['statusCode'] == 200) {
        setState(() {
          appointments.removeWhere((item) => item['id'] == appointmentId);
          cancellingId = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Appointment cancelled successfully')),
        );
      } else {
        setState(() {
          cancellingId = null;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Unable to cancel appointment')));
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cancellingId = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        actions: [
          IconButton(
            onPressed: isLoading
                ? null
                : () {
                    setState(() {
                      isLoading = true;
                      errorMessage = null;
                    });
                    fetchAppointments();
                  },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(errorMessage!),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                        errorMessage = null;
                      });
                      fetchAppointments();
                    },
                    child: Text('Try Again'),
                  ),
                ],
              ),
            )
          : appointments.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    size: 60,
                    color: Color(0xFF0D9488),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No Appointments Yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text('Your booked appointments will appear here.'),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                final id = appointment['id'] as int;

                return Card(
                  margin: EdgeInsets.only(bottom: 14),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: Color(0xFF0D9488),
                              size: 30,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                appointment['doctor_name'] ?? '',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14),
                        Text('Date: ${appointment['appointment_date']}'),
                        SizedBox(height: 6),
                        Text('Time: ${appointment['appointment_time']}'),
                        SizedBox(height: 6),
                        Text('Reason: ${appointment['reason']}'),

                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: OutlinedButton.icon(
                            onPressed: cancellingId == id
                                ? null
                                : () => cancelAppointment(id),
                            icon: cancellingId == id
                                ? SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Icon(Icons.event_busy_rounded, size: 19),
                            label: Text(
                              cancellingId == id
                                  ? 'Cancelling...'
                                  : 'Cancel Appointment',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Color(0xFF0D9488),
                              side: BorderSide(color: Color(0xFFB2E5DF)),
                              backgroundColor: Color(0xFFE6F7F5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
