import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'task_model.dart';
import 'add_task_sheet.dart';
import 'task_detail.dart';
// import '../services/notif_service.dart'; // Tidak perlu di-import di sini jika tidak dipakai langsung

// Enum untuk Pilihan Sortir
enum SortOption { myOrder, date, starred }

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  // --- WARNA DARK MODE ---
  final Color kBackground = const Color(0xFF1F1F1F);
  final Color kSurface = const Color(0xFF303030);
  final Color kBlueGoogle = const Color(0xFF8AB4F8);
  final Color kTextWhite = const Color(0xFFE3E3E3);
  final Color kTextGrey = const Color(0xFFAAAAAA);

  List<TaskGroup> taskGroups = [];
  final TextEditingController _newListController = TextEditingController();

  SortOption _currentSort = SortOption.myOrder;
  int _initialIndex = 1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    // Gunakan key 'v6' agar data benar-benar bersih dan fresh
    final String? dataString = prefs.getString('my_task_data_v6');
    setState(() {
      if (dataString != null) {
        List<dynamic> jsonList = jsonDecode(dataString);
        taskGroups = jsonList.map((json) => TaskGroup.fromJson(json)).toList();
      } else {
        taskGroups = [
          TaskGroup(title: "My Tasks", tasks: [
            Task(
              id: DateTime.now().millisecondsSinceEpoch,
              title: "Welcome to Taskify!",
              isCompleted: false,
              isStarred: true
            ),
          ]),
        ];
      }
      isLoading = false;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    String dataString = jsonEncode(taskGroups.map((g) => g.toJson()).toList());
    await prefs.setString('my_task_data_v6', dataString);
  }

  void _addNewTask(Task newTask, int activeListIndex) {
    setState(() {
      taskGroups[activeListIndex].tasks.insert(0, newTask);
    });
    _saveData();
  }

  void _createNewList() {
    if (_newListController.text.isNotEmpty) {
      setState(() {
        taskGroups.add(TaskGroup(title: _newListController.text, tasks: []));
        _newListController.clear();
        _initialIndex = taskGroups.length;
      });
      _saveData();
    }
  }

  void _toggleTaskStatus(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
    _saveData();
  }

  void _toggleSubTaskStatus(SubTask subtask) {
    setState(() {
      subtask.isCompleted = !subtask.isCompleted;
    });
    _saveData();
  }

  void _toggleStarStatus(Task task) {
    setState(() {
      task.isStarred = !task.isStarred;
    });
    _saveData();
  }

  // --- MENU SORTIR & OPSI ---
  void _renameList(BuildContext context, int groupIndex) {
    TextEditingController renameController = TextEditingController(text: taskGroups[groupIndex].title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kSurface,
        title: Text("Rename list", style: TextStyle(color: kTextWhite)),
        content: TextField(
          controller: renameController,
          style: TextStyle(color: kTextWhite),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: kBlueGoogle)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kBlueGoogle)),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              if (renameController.text.isNotEmpty) {
                setState(() {
                  taskGroups[groupIndex].title = renameController.text;
                  _initialIndex = groupIndex + 1;
                });
                _saveData();
                Navigator.pop(context);
              }
            },
            child: const Text("Rename"),
          ),
        ],
      ),
    );
  }

  void _deleteList(BuildContext context, int groupIndex) {
    if (groupIndex == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Default list can't be deleted")));
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kSurface,
        title: Text("Delete list?", style: TextStyle(color: kTextWhite)),
        content: Text("All tasks in this list will be permanently deleted.", style: TextStyle(color: kTextGrey)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() {
                taskGroups.removeAt(groupIndex);
                _initialIndex = 1;
              });
              _saveData();
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _deleteCompletedTasks(BuildContext context, int groupIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kSurface,
        title: Text("Delete completed tasks?", style: TextStyle(color: kTextWhite)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() {
                taskGroups[groupIndex].tasks.removeWhere((t) => t.isCompleted);
                for (var task in taskGroups[groupIndex].tasks) {
                  task.subtasks.removeWhere((s) => s.isCompleted);
                }
              });
              _saveData();
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _showSortMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setMenuState) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text("Sort by", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextGrey)),
                  ),
                  _buildSortItem(SortOption.myOrder, "My order", Icons.drag_handle, setMenuState),
                  _buildSortItem(SortOption.date, "Date", Icons.calendar_today, setMenuState),
                  _buildSortItem(SortOption.starred, "Starred recently", Icons.star_border, setMenuState),
                  const SizedBox(height: 10),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildSortItem(SortOption option, String text, IconData icon, StateSetter setMenuState) {
    bool isSelected = _currentSort == option;
    return ListTile(
      leading: Icon(icon, color: isSelected ? kBlueGoogle : kTextWhite),
      title: Text(text, style: TextStyle(color: isSelected ? kBlueGoogle : kTextWhite)),
      trailing: isSelected ? Icon(Icons.check, color: kBlueGoogle) : null,
      onTap: () {
        setState(() { _currentSort = option; });
        setMenuState(() {});
        Navigator.pop(context);
      },
    );
  }

  void _showMoreMenu(BuildContext context, int listIndex) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMenuItem(Icons.edit_outlined, "Rename list", () => _renameList(context, listIndex)),
            _buildMenuItem(Icons.delete_outline, "Delete list", () => _deleteList(context, listIndex)),
            const Divider(color: Colors.grey, height: 20),
            _buildMenuItem(Icons.delete_sweep_outlined, "Delete all completed tasks", () => _deleteCompletedTasks(context, listIndex)),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: kTextWhite),
      title: Text(text, style: TextStyle(color: kTextWhite)),
      onTap: () { Navigator.pop(context); onTap(); },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Scaffold(backgroundColor: kBackground, body: const Center(child: CircularProgressIndicator()));

    int totalTabs = 1 + taskGroups.length + 1;
    if (_initialIndex >= totalTabs) _initialIndex = 1;

    return DefaultTabController(
      key: ValueKey(totalTabs),
      length: totalTabs,
      initialIndex: _initialIndex,
      child: Builder(builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: kBackground,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: kBackground,
            elevation: 0,
            title: Text("Taskify", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kTextWhite)),
            centerTitle: true,
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: CircleAvatar(backgroundColor: Colors.purple, radius: 16, child: Text("J", style: TextStyle(color: Colors.white))),
              )
            ],
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: kBlueGoogle,
              indicatorWeight: 3,
              labelColor: kBlueGoogle,
              unselectedLabelColor: kTextGrey,
              labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              dividerColor: Colors.transparent,
              tabAlignment: TabAlignment.start,
              tabs: [
                const Tab(icon: Icon(Icons.star)),
                ...taskGroups.map((group) => Tab(text: group.title)),
                const Tab(text: "+ New list"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildStarredPage(),
              ...List.generate(taskGroups.length, (index) => _buildTaskListPage(taskGroups[index], index)),
              _buildCreateListPage(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              int tabIndex = DefaultTabController.of(context).index;
              int listIndex = tabIndex - 1;
              if (listIndex >= 0 && listIndex < taskGroups.length) {
                showModalBottomSheet(
                  context: context, isScrollControlled: true, backgroundColor: kSurface,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (context) => AddTaskSheet(onSave: (newTask) => _addNewTask(newTask, listIndex)),
                );
              }
            },
            backgroundColor: kBlueGoogle,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.add, size: 32, color: Color(0xFF1F1F1F)),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      }),
    );
  }

  Widget _buildCreateListPage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.playlist_add, size: 80, color: Colors.white70),
            const SizedBox(height: 20),
            TextField(
              controller: _newListController,
              style: TextStyle(color: kTextWhite, fontSize: 18),
              cursorColor: kBlueGoogle,
              decoration: InputDecoration(
                hintText: "Enter list title",
                hintStyle: TextStyle(color: kTextGrey),
                filled: true, fillColor: kSurface,
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.transparent)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: kBlueGoogle, width: 2)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createNewList,
              style: ElevatedButton.styleFrom(backgroundColor: kBlueGoogle, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
              child: const Text("Create List", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTaskListPage(TaskGroup group, int groupIndex) {
    List<Task> activeTasks = group.tasks.where((t) => !t.isCompleted).toList();
    List<Task> completedTasks = group.tasks.where((t) => t.isCompleted).toList();
    List<SubTask> completedSubtasks = [];
    for (var task in activeTasks) {
      completedSubtasks.addAll(task.subtasks.where((s) => s.isCompleted));
    }

    if (_currentSort == SortOption.starred) {
      activeTasks.sort((a, b) => (b.isStarred ? 1 : 0).compareTo(a.isStarred ? 1 : 0));
    } else if (_currentSort == SortOption.date) {
      activeTasks.sort((a, b) {
        if (a.deadline == null && b.deadline == null) return 0;
        if (a.deadline == null) return 1; 
        if (b.deadline == null) return -1;
        return a.deadline!.compareTo(b.deadline!);
      });
    }

    int totalCompletedCount = completedTasks.length + completedSubtasks.length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(group.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kTextWhite)),
            Row(
              children: [
                IconButton(icon: const Icon(Icons.swap_vert, color: Colors.white70), onPressed: () => _showSortMenu(context)),
                IconButton(icon: const Icon(Icons.more_vert, color: Colors.white70), onPressed: () => _showMoreMenu(context, groupIndex)),
              ],
            )
          ],
        ),
        const SizedBox(height: 10),

        if (activeTasks.isNotEmpty)
          Container(
            decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: activeTasks.map((t) => _buildTaskItem(t)).toList(),
            ),
          ),

        if (activeTasks.isEmpty && totalCompletedCount > 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.check_circle_outline, size: 120, color: kBlueGoogle.withOpacity(0.5)),
                  const SizedBox(height: 20),
                  Text("All tasks completed", style: TextStyle(fontSize: 20, color: kTextWhite, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 5),
                  Text("Nice work!", style: TextStyle(fontSize: 14, color: kTextGrey)),
                ],
              ),
            ),
          ),

        if (totalCompletedCount > 0) ...[
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(16)),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                iconColor: kTextWhite,
                collapsedIconColor: kTextWhite,
                title: Text("Completed ($totalCompletedCount)", style: TextStyle(fontWeight: FontWeight.bold, color: kTextWhite)),
                children: [
                  ...completedTasks.map((t) => _buildTaskItem(t)).toList(),
                  ...completedSubtasks.map((s) => ListTile(
                    leading: Icon(Icons.check, color: kBlueGoogle),
                    title: Text(s.title, style: TextStyle(decoration: TextDecoration.lineThrough, color: kTextGrey)),
                    onTap: () {
                      setState(() { s.isCompleted = false; });
                      _saveData();
                    },
                  )).toList(),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildStarredPage() {
    final List<Task> allStarred = [];
    for (var group in taskGroups) {
      allStarred.addAll(group.tasks.where((t) => t.isStarred));
    }
    
    if (_currentSort == SortOption.date) {
       allStarred.sort((a, b) {
        if (a.deadline == null && b.deadline == null) return 0;
        if (a.deadline == null) return 1; 
        if (b.deadline == null) return -1;
        return a.deadline!.compareTo(b.deadline!);
      });
    }

    if (allStarred.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star_border, size: 100, color: kBlueGoogle.withOpacity(0.5)),
          const SizedBox(height: 20),
          Text("No starred tasks", style: TextStyle(fontSize: 20, color: kTextWhite)),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Starred", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kTextWhite)),
            IconButton(
              icon: const Icon(Icons.swap_vert, color: Colors.white70), 
              onPressed: () => _showSortMenu(context)
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: kSurface, 
            borderRadius: BorderRadius.circular(16)
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: allStarred.map((t) => _buildTaskItem(t)).toList(),
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildTaskItem(Task task) {
    List<SubTask> activeSubtasks = task.subtasks.where((s) => !s.isCompleted).toList();

    void navigateToDetail() {
      TaskGroup currentGroup = taskGroups.firstWhere((g) => g.tasks.contains(task));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPage(
            task: task,
            currentListName: currentGroup.title,
            allListNames: taskGroups.map((g) => g.title).toList(),
            onMoveTask: (targetListName) {
              setState(() {
                currentGroup.tasks.remove(task);
                TaskGroup targetGroup = taskGroups.firstWhere((g) => g.title == targetListName);
                targetGroup.tasks.insert(0, task);
              });
              _saveData();
            },
            onDeleteTask: () {
              setState(() { currentGroup.tasks.remove(task); });
              _saveData();
            },
          ),
        ),
      ).then((_) { setState(() {}); _saveData(); });
    }

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
          leading: IconButton(
            icon: Icon(task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked, color: task.isCompleted ? kBlueGoogle : kTextGrey),
            onPressed: () => _toggleTaskStatus(task),
          ),
          title: Text(
            task.title, 
            style: TextStyle(
              fontSize: 16, 
              decoration: task.isCompleted ? TextDecoration.lineThrough : null, 
              color: task.isCompleted ? kTextGrey : kTextWhite
            )
          ),
          subtitle: (task.details.isNotEmpty || task.date != null) 
            ? Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (task.details.isNotEmpty) 
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Text(task.details, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: kTextGrey, fontSize: 13)),
                      ),
                    
                    if (task.date != null) 
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: kBlueGoogle.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          task.date!, 
                          style: TextStyle(color: kBlueGoogle, fontSize: 12, fontWeight: FontWeight.w500)
                        ),
                      ),
                  ],
                ),
              )
            : null,
          trailing: IconButton(
            icon: Icon(task.isStarred ? Icons.star : Icons.star_border, color: task.isStarred ? kBlueGoogle : kTextGrey),
            onPressed: () => _toggleStarStatus(task),
          ),
          onTap: navigateToDetail,
        ),

        if (activeSubtasks.isNotEmpty && !task.isCompleted)
          ...activeSubtasks.map((subtask) => Padding(
            padding: const EdgeInsets.only(left: 40.0), 
            child: ListTile(
              dense: true, 
              visualDensity: VisualDensity.compact,
              leading: IconButton(
                icon: const Icon(Icons.radio_button_unchecked, color: Colors.grey, size: 20),
                onPressed: () => _toggleSubTaskStatus(subtask), 
              ),
              title: Text(subtask.title, style: TextStyle(color: kTextWhite, fontSize: 15)),
              onTap: navigateToDetail, 
            ),
          )),
      ],
    );
  }
}