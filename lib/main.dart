import 'package:flutter/material.dart';

void main() => runApp(const LittleWinsApp());

class LittleWinsApp extends StatelessWidget {
  const LittleWinsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Little Wins',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F5FB),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7257D8)),
        fontFamily: 'Roboto',
      ),
      home: const TaskHomePage(),
    );
  }
}

class TaskItem {
  TaskItem({
    required this.title,
    required this.note,
    required this.category,
    required this.color,
    this.isDone = false,
  });

  String title;
  String note;
  String category;
  Color color;
  bool isDone;
}

class TaskHomePage extends StatefulWidget {
  const TaskHomePage({super.key});

  @override
  State<TaskHomePage> createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage> {
  final List<TaskItem> _tasks = [
    TaskItem(
      title: 'Sketch ideas for the new project',
      note: 'A few rough concepts are more than enough to get started.',
      category: 'CREATE',
      color: const Color(0xFFE9DFFF),
    ),
    TaskItem(
      title: 'Take a proper lunch break',
      note: 'Step away from the desk and try that little noodle place.',
      category: 'SELF CARE',
      color: const Color(0xFFFFE6C8),
      isDone: true,
    ),
    TaskItem(
      title: 'Send the team a quick update',
      note: 'Share what is finished and what needs a little more time.',
      category: 'WORK',
      color: const Color(0xFFDDF2E7),
    ),
  ];

  static const _categories = ['WORK', 'CREATE', 'SELF CARE', 'PERSONAL'];
  static const _categoryColors = [
    Color(0xFFDDF2E7),
    Color(0xFFE9DFFF),
    Color(0xFFFFE6C8),
    Color(0xFFDCEBFF),
  ];

  int get _doneCount => _tasks.where((task) => task.isDone).length;

  Future<void> _openTaskEditor({int? index}) async {
    final existing = index == null ? null : _tasks[index];
    final result = await showDialog<TaskItem>(
      context: context,
      builder: (_) => _TaskEditorDialog(initialTask: existing),
    );

    if (result == null || !mounted) return;
    setState(() {
      if (index == null) {
        _tasks.insert(0, result);
      } else {
        _tasks[index] = result;
      }
    });
  }

  void _deleteTask(int index) {
    final removed = _tasks[index];
    setState(() => _tasks.removeAt(index));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('“${removed.title}” removed'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () => setState(() => _tasks.insert(index.clamp(0, _tasks.length).toInt(), removed)),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _tasks.isEmpty ? 0.0 : _doneCount / _tasks.length;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9DFFF),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF7257D8)),
                      ),
                      const SizedBox(width: 11),
                      const Text('little wins', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                        child: Row(children: [
                          const Icon(Icons.wb_sunny_rounded, size: 16, color: Color(0xFFEBA83E)),
                          const SizedBox(width: 6),
                          Text('${_tasks.length - _doneCount} left today', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                        ]),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF745ADB), Color(0xFF927BEA)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [BoxShadow(color: const Color(0xFF7257D8).withValues(alpha: 0.2), blurRadius: 25, offset: const Offset(0, 12))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              const Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('A fresh start,', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
                                  SizedBox(height: 3),
                                  Text('one thing at a time.', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.7)),
                                ]),
                              ),
                              Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), shape: BoxShape.circle),
                                child: const Icon(Icons.spa_rounded, color: Colors.white, size: 28),
                              ),
                            ]),
                            const SizedBox(height: 24),
                            Row(children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 8,
                                    backgroundColor: Colors.white.withValues(alpha: 0.24),
                                    valueColor: const AlwaysStoppedAnimation(Color(0xFFFFD991)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text('${_doneCount}/${_tasks.length} done', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800)),
                            ]),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      Row(children: [
                        const Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Your list', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                            SizedBox(height: 3),
                            Text('Small steps count, too.', style: TextStyle(color: Color(0xFF898797), fontSize: 13)),
                          ]),
                        ),
                        FilledButton.icon(
                          onPressed: () => _openTaskEditor(),
                          icon: const Icon(Icons.add_rounded, size: 19),
                          label: const Text('New task'),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF25233A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 14),
                      if (_tasks.isEmpty)
                        _EmptyState(onAdd: () => _openTaskEditor())
                      else
                        ListView.builder(
                          itemCount: _tasks.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final task = _tasks[index];
                            return _TaskCard(
                              task: task,
                              onToggle: () => setState(() => task.isDone = !task.isDone),
                              onEdit: () => _openTaskEditor(index: index),
                              onDelete: () => _deleteTask(index),
                            );
                          },
                        ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          _tasks.isEmpty ? 'A clear list is a lovely place to start.' : 'You’re doing better than you think ✨',
                          style: const TextStyle(color: Color(0xFFAAA8B5), fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskEditorDialog extends StatefulWidget {
  const _TaskEditorDialog({this.initialTask});

  final TaskItem? initialTask;

  @override
  State<_TaskEditorDialog> createState() => _TaskEditorDialogState();
}

class _TaskEditorDialogState extends State<_TaskEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _note;
  late String _category;
  late Color _color;

  bool get _isEditing => widget.initialTask != null;

  @override
  void initState() {
    super.initState();
    final task = widget.initialTask;
    _title = task?.title ?? '';
    _note = task?.note ?? '';
    _category = task?.category ?? _TaskHomePageState._categories[0];
    _color = task?.color ?? _TaskHomePageState._categoryColors[0];
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      TaskItem(
        title: _title.trim(),
        note: _note.trim(),
        category: _category,
        color: _color,
        isDone: widget.initialTask?.isDone ?? false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = _TaskHomePageState._categories;
    final categoryColors = _TaskHomePageState._categoryColors;

    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Text(
        _isEditing ? 'Edit your win' : 'Add a little win',
        style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF25233A)),
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 380,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _title,
                  onChanged: (value) => _title = value,
                  autofocus: true,
                  maxLength: 70,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: _inputDecoration('What would you like to do?', Icons.edit_outlined),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Give your task a name first.'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: _note,
                  onChanged: (value) => _note = value,
                  maxLines: 3,
                  maxLength: 150,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: _inputDecoration('A note (optional)', Icons.notes_rounded),
                ),
                const SizedBox(height: 12),
                const Text('A little category', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(categories.length, (i) {
                    final selected = _category == categories[i];
                    return ChoiceChip(
                      label: Text(categories[i]),
                      selected: selected,
                      onSelected: (_) => setState(() {
                        _category = categories[i];
                        _color = categoryColors[i];
                      }),
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: selected ? const Color(0xFF4D3C9C) : const Color(0xFF666477),
                      ),
                      selectedColor: categoryColors[i],
                      backgroundColor: const Color(0xFFF4F2F8),
                      side: BorderSide.none,
                      showCheckmark: false,
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 22),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _save,
          icon: Icon(_isEditing ? Icons.check_rounded : Icons.add_rounded),
          label: Text(_isEditing ? 'Save changes' : 'Add task'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF7257D8),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          ),
        ),
      ],
    );
  }
}

InputDecoration _inputDecoration(String hint, IconData icon) => InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 19),
      filled: true,
      fillColor: const Color(0xFFF7F5FB),
      counterText: '',
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFF927BEA), width: 1.5),
      ),
    );

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task, required this.onToggle, required this.onEdit, required this.onDelete});

  final TaskItem task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.fromLTRB(15, 14, 8, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEFEAF5)),
        boxShadow: [BoxShadow(color: const Color(0xFF343047).withValues(alpha: 0.035), blurRadius: 16, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Icon(
                task.isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                color: task.isDone ? const Color(0xFF70B88A) : const Color(0xFFC9C6D2),
                size: 25,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: task.isDone ? const Color(0xFFAAA8B5) : const Color(0xFF302E42),
                    decoration: task.isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (task.note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(task.note, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF92909E), fontSize: 12, height: 1.35)),
                ],
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: task.color, borderRadius: BorderRadius.circular(7)),
                  child: Text(task.category, style: const TextStyle(fontSize: 9, letterSpacing: 0.5, fontWeight: FontWeight.w900, color: Color(0xFF555064))),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit task',
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, size: 19),
            color: const Color(0xFF898797),
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            tooltip: 'Delete task',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded, size: 19),
            color: const Color(0xFFD65F68),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 34),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: Column(children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(color: Color(0xFFF2EEFF), shape: BoxShape.circle),
            child: const Icon(Icons.wb_sunny_outlined, color: Color(0xFF7257D8), size: 28),
          ),
          const SizedBox(height: 14),
          const Text('Room for something new', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          const Text('Add one small thing you’d like to get done.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF92909E), fontSize: 13)),
          const SizedBox(height: 15),
          TextButton.icon(onPressed: onAdd, icon: const Icon(Icons.add_rounded), label: const Text('Add your first task')),
        ]),
      );
}
