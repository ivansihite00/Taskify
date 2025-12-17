import 'package:flutter/material.dart';
import 'task_model.dart';
import '../services/notif_service.dart'; // <--- Import Service

class DetailPage extends StatefulWidget {
  final Task task;
  final String currentListName; 
  final List<String> allListNames; 
  final Function(String targetList) onMoveTask; 
  final VoidCallback onDeleteTask; 

  const DetailPage({
    super.key, 
    required this.task,
    required this.currentListName,
    required this.allListNames,
    required this.onMoveTask,
    required this.onDeleteTask,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final Color kBackground = const Color(0xFF1F1F1F);
  final Color kSurface = const Color(0xFF303030);
  final Color kTextWhite = const Color(0xFFE3E3E3);
  final Color kTextGrey = const Color(0xFFAAAAAA);
  final Color kBlueGoogle = const Color(0xFF8AB4F8);
  final Color kBlueButton = const Color(0xFFA8C7FA);

  late TextEditingController _titleController;
  late TextEditingController _detailsController;
  late String _selectedListName; 
  List<TextEditingController> _subtaskControllers = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _detailsController = TextEditingController(text: widget.task.details);
    _selectedListName = widget.currentListName;
    for (var sub in widget.task.subtasks) {
      _subtaskControllers.add(TextEditingController(text: sub.title));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    for (var controller in _subtaskControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateDetails(String val) {
    widget.task.details = val;
  }

  void _saveAndExit() {
    if (_selectedListName != widget.currentListName) {
      widget.onMoveTask(_selectedListName);
    }
    Navigator.pop(context);
  }

  Future<void> _pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.task.deadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(primary: kBlueGoogle, onPrimary: kBackground, surface: kSurface, onSurface: kTextWhite),
          dialogBackgroundColor: kSurface,
        ),
        child: child!,
      ),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) => Theme(
          data: ThemeData.dark().copyWith(colorScheme: ColorScheme.dark(primary: kBlueGoogle, onPrimary: kBackground, surface: kSurface)),
          child: child!,
        ),
      );

      setState(() {
        DateTime finalDateTime;
        if (pickedTime != null) {
          finalDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
          final localizations = MaterialLocalizations.of(context);
          String formattedTime = localizations.formatTimeOfDay(pickedTime, alwaysUse24HourFormat: false);
          widget.task.date = "${_formatDateManual(pickedDate)}, $formattedTime";
        } else {
          finalDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, 9, 0); // Default jam 9 pagi
          widget.task.date = _formatDateManual(pickedDate);
        }

        widget.task.deadline = finalDateTime;
        
        // --- RESCHEDULE ALARM ---
        NotifService.scheduleNotification(widget.task.id, widget.task.title, finalDateTime);
      });
    }
  }

  String _formatDateManual(DateTime date) {
    List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate == today) return "Today";
    if (checkDate == tomorrow) return "Tomorrow";
    return "${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}";
  }

  void _addSubtask() {
    setState(() {
      widget.task.subtasks.add(SubTask(title: "")); 
      _subtaskControllers.add(TextEditingController()); 
    });
  }

  void _removeSubtask(int index) {
    setState(() {
      widget.task.subtasks.removeAt(index);
      _subtaskControllers[index].dispose();
      _subtaskControllers.removeAt(index);
    });
  }

  void _showMoveMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: kSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text("Move task to", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextWhite)),
              ),
              ...widget.allListNames.map((listName) => ListTile(
                leading: listName == _selectedListName ? Icon(Icons.check, color: kBlueGoogle) : const SizedBox(width: 24),
                title: Text(listName, style: TextStyle(color: kTextWhite)),
                onTap: () {
                  setState(() { _selectedListName = listName; });
                  Navigator.pop(context);
                },
              )),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool hasDate = widget.task.date != null && widget.task.date!.isNotEmpty;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: _saveAndExit),
        title: GestureDetector(
          onTap: _showMoveMenu,
          child: Row(
            children: [
              Text(_selectedListName, style: TextStyle(fontSize: 16, color: kTextWhite, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(widget.task.isStarred ? Icons.star : Icons.star_border, color: widget.task.isStarred ? kBlueGoogle : kTextGrey),
            onPressed: () { setState(() { widget.task.isStarred = !widget.task.isStarred; }); },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: kSurface,
            onSelected: (value) {
              if (value == 'delete') { widget.onDeleteTask(); Navigator.pop(context); }
            },
            itemBuilder: (context) => [ const PopupMenuItem(value: 'delete', child: Text("Delete", style: TextStyle(color: Colors.white))) ],
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: _titleController,
                onChanged: (val) => widget.task.title = val,
                style: TextStyle(fontSize: 24, color: kTextWhite, fontWeight: FontWeight.w400),
                decoration: const InputDecoration(border: InputBorder.none),
                maxLines: null,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _detailsController,
                onChanged: _updateDetails,
                style: TextStyle(fontSize: 16, color: kTextWhite),
                cursorColor: kBlueGoogle,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Padding(padding: const EdgeInsets.only(right: 16, bottom: 2), child: Icon(Icons.notes, color: kTextGrey, size: 24)),
                  prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                  hintText: "Add details", hintStyle: TextStyle(fontSize: 16, color: kTextGrey),
                ),
                maxLines: null,
              ),

              _buildClickableOption(hasDate ? Icons.event : Icons.event_available, hasDate ? widget.task.date! : "Add date/time", _pickDateTime, isActive: hasDate),

              _buildSubtaskSection(),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() { widget.task.isCompleted = !widget.task.isCompleted; });
          _saveAndExit();
        },
        backgroundColor: kBlueButton,
        elevation: 2,
        label: Text(widget.task.isCompleted ? "Mark uncompleted" : "Mark completed", style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSubtaskSection() {
    if (widget.task.subtasks.isEmpty) {
      return InkWell(
        onTap: _addSubtask,
        child: _buildOptionItem(Icons.subdirectory_arrow_right, "Add subtasks"),
      );
    }
    
    return Column(
      children: [
        ...List.generate(widget.task.subtasks.length, (index) {
          return _buildEditableSubtaskItem(index);
        }),
        InkWell(
          onTap: _addSubtask,
          child: Padding(
            padding: const EdgeInsets.only(left: 40, top: 12, bottom: 12), 
            child: Row(
              children: [
                Icon(Icons.add, color: kBlueGoogle, size: 20),
                const SizedBox(width: 12),
                Text("Add subtask", style: TextStyle(color: kBlueGoogle, fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildEditableSubtaskItem(int index) {
    SubTask subtask = widget.task.subtasks[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                subtask.isCompleted = !subtask.isCompleted;
              });
            },
            child: Icon(
              subtask.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: subtask.isCompleted ? kBlueGoogle : kTextGrey,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _subtaskControllers[index],
              onChanged: (val) => subtask.title = val,
              style: TextStyle(
                fontSize: 16, 
                color: kTextWhite,
                decoration: subtask.isCompleted ? TextDecoration.lineThrough : null,
                decorationColor: kTextGrey, 
              ),
              cursorColor: kBlueGoogle,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter title",
                hintStyle: TextStyle(color: kTextGrey),
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: kTextGrey, size: 20),
            onPressed: () => _removeSubtask(index),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: kTextGrey, size: 24),
          const SizedBox(width: 16),
          Text(text, style: TextStyle(color: kTextGrey, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildClickableOption(IconData icon, String text, VoidCallback onTap, {bool isActive = false}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: isActive ? kBlueGoogle : kTextGrey, size: 24),
            const SizedBox(width: 16),
            isActive 
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(border: Border.all(color: kTextGrey), borderRadius: BorderRadius.circular(20)),
                  child: Text(text, style: TextStyle(color: kBlueGoogle, fontSize: 14)),
                )
              : Text(text, style: TextStyle(color: kTextGrey, fontSize: 16)),
            if (isActive) ...[
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () { setState(() { widget.task.date = null; widget.task.deadline = null; }); },
                child: Icon(Icons.close, size: 18, color: kTextGrey),
              )
            ]
          ],
        ),
      ),
    );
  }
}