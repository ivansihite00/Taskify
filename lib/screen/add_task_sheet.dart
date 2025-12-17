import 'package:flutter/material.dart';
import 'task_model.dart';
import '../services/notif_service.dart'; 

class AddTaskSheet extends StatefulWidget {
  final Function(Task) onSave;

  const AddTaskSheet({super.key, required this.onSave});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final Color kSurface = const Color(0xFF303030);
  final Color kTextWhite = const Color(0xFFE3E3E3);
  final Color kTextGrey = const Color(0xFFAAAAAA);
  final Color kBlueGoogle = const Color(0xFF8AB4F8);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  bool _showDetailsField = false;
  bool _isStarred = false;
  DateTime? _selectedDate; 

  void _handleSave() {
    if (_titleController.text.isNotEmpty) {
      String? dateString;
      if (_selectedDate != null) {
        dateString = _formatDateManual(_selectedDate!);
      }

      // Generate ID Unik (Integer)
      int newId = DateTime.now().millisecondsSinceEpoch & 0x7FFFFFFF;

      Task newTask = Task(
        id: newId, 
        title: _titleController.text,
        details: _detailsController.text,
        date: dateString,       
        deadline: _selectedDate, 
        isStarred: _isStarred,
      );

      // --- LOGIKA ALARM ---
      // Jika user memilih tanggal, kita panggil NotifService
      if (_selectedDate != null) {
        NotifService.scheduleNotification(newId, newTask.title, _selectedDate!);
      }

      widget.onSave(newTask);
      Navigator.pop(context);
    }
  }

  // --- UPDATE: PICK DATE + TIME ---
  Future<void> _pickDate() async {
    // 1. Pilih Tanggal
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(primary: kBlueGoogle, surface: kSurface, onSurface: kTextWhite),
          dialogBackgroundColor: kSurface,
        ),
        child: child!,
      ),
    );

    if (pickedDate != null) {
      // 2. Pilih Jam (Time Picker) - Agar persis Google Task
      if (!mounted) return;
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) => Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(primary: kBlueGoogle, surface: kSurface, onSurface: kTextWhite),
            dialogBackgroundColor: kSurface,
          ),
          child: child!,
        ),
      );

      if (pickedTime != null) {
        // Gabungkan Tanggal + Jam
        DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          _selectedDate = finalDateTime;
        });
      }
    }
  }

  String _formatDateManual(DateTime date) {
    List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final checkDate = DateTime(date.year, date.month, date.day);

    String timePart = "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

    if (checkDate == today) return "Today, $timePart";
    if (checkDate == tomorrow) return "Tomorrow, $timePart";
    return "${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}, $timePart";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20, right: 20, top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            autofocus: true,
            style: TextStyle(color: kTextWhite, fontSize: 18),
            cursorColor: kBlueGoogle,
            decoration: InputDecoration(
              hintText: "New task",
              hintStyle: TextStyle(fontSize: 18, color: kTextGrey),
              border: InputBorder.none,
            ),
          ),
          if (_showDetailsField)
            TextField(
              controller: _detailsController,
              style: TextStyle(color: kTextGrey, fontSize: 14),
              cursorColor: kBlueGoogle,
              decoration: InputDecoration(
                hintText: "Add details",
                hintStyle: TextStyle(fontSize: 14, color: kTextGrey.withOpacity(0.7)),
                border: InputBorder.none, isDense: true, contentPadding: const EdgeInsets.only(bottom: 10),
              ),
            ),
          if (_selectedDate != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Chip(
                backgroundColor: kSurface,
                side: BorderSide(color: kBlueGoogle),
                label: Text(_formatDateManual(_selectedDate!), style: TextStyle(color: kBlueGoogle, fontSize: 12)),
                deleteIcon: Icon(Icons.close, size: 16, color: kBlueGoogle),
                onDeleted: () { setState(() { _selectedDate = null; }); },
              ),
            ),
          const SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                onPressed: () { setState(() { _showDetailsField = !_showDetailsField; }); },
                icon: Icon(Icons.notes, color: _showDetailsField ? kBlueGoogle : kTextWhite),
              ),
              IconButton(
                onPressed: _pickDate,
                icon: Icon(Icons.event_available, color: _selectedDate != null ? kBlueGoogle : kTextWhite),
              ),
              IconButton(
                onPressed: () { setState(() { _isStarred = !_isStarred; }); },
                icon: Icon(_isStarred ? Icons.star : Icons.star_border, color: _isStarred ? kBlueGoogle : kTextWhite),
              ),
              const Spacer(),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _titleController,
                builder: (context, value, child) {
                  bool isEnabled = value.text.isNotEmpty;
                  return TextButton(
                    onPressed: isEnabled ? _handleSave : null,
                    child: Text("Save", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isEnabled ? kBlueGoogle : kTextGrey.withOpacity(0.5))),
                  );
                },
              )
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}