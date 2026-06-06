import 'package:flutter/material.dart';

/// Exercise 2 – Input Widgets: Slider, Switch, RadioListTile, DatePicker
/// A StatefulWidget that allows users to adjust inputs and displays real-time updates.
class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  // State variables
  double _volumeLevel = 50.0; // Slider value (0.0 to 100.0)
  bool _notificationsEnabled = true; // Switch status
  String _alertPriority = 'Medium'; // RadioListTile group value (Low, Medium, High)
  DateTime? _selectedDate; // Selected Date from DatePicker

  // Controller function for DatePicker
  Future<void> _pickDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    // showDatePicker returns Future<DateTime?>
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 5), // Range: 5 years in past
      lastDate: DateTime(now.year + 5),  // Range: 5 years in future
    );

    // Update state only if user selected a date (did not cancel)
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 2: Input Controls'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Configure Device Alerts',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Adjust your settings below and view real-time changes.',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),

              // 1. SWITCH: Toggle notifications (Bật/Tắt thông báo)
              Card(
                elevation: 2,
                child: SwitchListTile(
                  title: const Text('Enable Notifications'),
                  subtitle: const Text('Receive push alerts on your phone'),
                  value: _notificationsEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                  secondary: const Icon(Icons.notifications),
                  activeColor: Colors.indigoAccent,
                ),
              ),
              const SizedBox(height: 16),

              // 2. SLIDER: Set volume level (Thanh trượt chọn âm lượng)
              // Only active if notifications are enabled
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Alert Volume', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          Text(
                            '${_volumeLevel.round()}%',
                            style: TextStyle(
                              color: _notificationsEnabled ? Colors.indigo : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _volumeLevel,
                        min: 0.0,
                        max: 100.0,
                        divisions: 10, // Divides slider into 10 steps
                        label: '${_volumeLevel.round()}%',
                        onChanged: _notificationsEnabled
                            ? (double value) {
                                setState(() {
                                  _volumeLevel = value;
                                });
                              }
                            : null, // Disables slider when notifications are off
                        activeColor: Colors.indigoAccent,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 3. RADIOLISTTILE: Pick notification priority (Radio button chọn độ ưu tiên)
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'Notification Priority',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      RadioListTile<String>(
                        title: const Text('Low Priority'),
                        subtitle: const Text('Only show in app feed'),
                        value: 'Low',
                        groupValue: _alertPriority,
                        onChanged: _notificationsEnabled
                            ? (value) {
                                setState(() {
                                  _alertPriority = value!;
                                });
                              }
                            : null,
                      ),
                      RadioListTile<String>(
                        title: const Text('Medium Priority'),
                        subtitle: const Text('Show badge and banner notifications'),
                        value: 'Medium',
                        groupValue: _alertPriority,
                        onChanged: _notificationsEnabled
                            ? (value) {
                                setState(() {
                                  _alertPriority = value!;
                                });
                              }
                            : null,
                      ),
                      RadioListTile<String>(
                        title: const Text('High Priority'),
                        subtitle: const Text('Force popups and sound alarms'),
                        value: 'High',
                        groupValue: _alertPriority,
                        onChanged: _notificationsEnabled
                            ? (value) {
                                setState(() {
                                  _alertPriority = value!;
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 4. DATE PICKER BUTTON: Select next maintenance date
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Scheduled Maintenance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(
                            _selectedDate == null
                                ? 'No date selected'
                                : "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}",
                            style: TextStyle(color: Colors.indigo[800], fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _pickDate(context),
                        icon: const Icon(Icons.calendar_month),
                        label: const Text('Choose'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 5. LIVE OUTPUT PANEL: Displaying updated states
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigo.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.dashboard, color: Colors.indigo),
                        SizedBox(width: 8),
                        Text(
                          'Live Summary Output',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.indigo, height: 20, thickness: 0.5),
                    Text('• Notifications: ${_notificationsEnabled ? "ENABLED" : "DISABLED"}'),
                    const SizedBox(height: 6),
                    Text('• Volume Level: ${_notificationsEnabled ? "${_volumeLevel.round()}%" : "N/A (Muted)"}'),
                    const SizedBox(height: 6),
                    Text('• Alert Priority: ${_notificationsEnabled ? _alertPriority.toUpperCase() : "N/A"}'),
                    const SizedBox(height: 6),
                    Text('• Date Selected: ${_selectedDate == null ? "None" : "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}"}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
