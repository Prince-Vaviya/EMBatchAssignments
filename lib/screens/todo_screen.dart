import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import '../theme/pastel_theme.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  // Master list of tasks sorted by Eisenhower matrix quadrants
  final List<TodoItem> _todos = [
    // Q1: Do First (Urgent & Important)
    TodoItem(
      id: '1',
      title: 'Submit Flutter Matrix Assignment',
      description: 'Review rubric, test responsiveness & push to git',
      isUrgent: true,
      isImportant: true,
      isCompleted: false,
      category: TodoCategory.study,
    ),
    TodoItem(
      id: '2',
      title: 'Fix critical database sync bug',
      description: 'Resolve state inconsistency in user auth token',
      isUrgent: true,
      isImportant: true,
      isCompleted: true,
      category: TodoCategory.work,
    ),

    // Q2: Schedule / Decide (Not Urgent & Important)
    TodoItem(
      id: '3',
      title: 'Plan weekly workout & nutrition split',
      description: 'Prepare meal prep list and schedule chest/back days',
      isUrgent: false,
      isImportant: true,
      isCompleted: false,
      category: TodoCategory.health,
    ),
    TodoItem(
      id: '4',
      title: 'Read 20 pages of Clean Code architecture',
      description: 'Focus on separation of concerns & dependency injection',
      isUrgent: false,
      isImportant: true,
      isCompleted: false,
      category: TodoCategory.personal,
    ),

    // Q3: Delegate (Urgent & Not Important)
    TodoItem(
      id: '5',
      title: 'Respond to routine team Slack pings',
      description: 'Forward client invoice queries to billing coordinator',
      isUrgent: true,
      isImportant: false,
      isCompleted: false,
      category: TodoCategory.work,
    ),
    TodoItem(
      id: '6',
      title: 'Order replacement HDMI cable online',
      description: 'Quick check for same-day delivery',
      isUrgent: true,
      isImportant: false,
      isCompleted: true,
      category: TodoCategory.shopping,
    ),

    // Q4: Eliminate / Minimize (Not Urgent & Not Important)
    TodoItem(
      id: '7',
      title: 'Clean up old download folders',
      description: 'Delete temporary screenshots & cache files',
      isUrgent: false,
      isImportant: false,
      isCompleted: false,
      category: TodoCategory.personal,
    ),
  ];

  // View modes: 'Matrix' (2x2 grid) or 'Focused' (Quadrant tabs)
  int _selectedViewTab = 0; // 0 = 2x2 Matrix, 1 = Tabbed Focus
  EisenhowerQuadrant _selectedFocusQuadrant = EisenhowerQuadrant.q1DoFirst;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Add Task using setState
  void _addTodo({
    required String title,
    String? description,
    required bool isUrgent,
    required bool isImportant,
    required TodoCategory category,
  }) {
    if (title.trim().isEmpty) return;
    setState(() {
      _todos.insert(
        0,
        TodoItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title.trim(),
          description: description?.trim().isEmpty == true ? null : description?.trim(),
          isUrgent: isUrgent,
          isImportant: isImportant,
          category: category,
          isCompleted: false,
        ),
      );
    });
  }

  // Toggle Completion using setState
  void _toggleTodo(String id) {
    setState(() {
      final index = _todos.indexWhere((item) => item.id == id);
      if (index != -1) {
        _todos[index].isCompleted = !_todos[index].isCompleted;
      }
    });
  }

  // Move Task to a different quadrant using setState
  void _moveTodoQuadrant(String id, EisenhowerQuadrant targetQuadrant) {
    setState(() {
      final index = _todos.indexWhere((item) => item.id == id);
      if (index != -1) {
        switch (targetQuadrant) {
          case EisenhowerQuadrant.q1DoFirst:
            _todos[index].isUrgent = true;
            _todos[index].isImportant = true;
            break;
          case EisenhowerQuadrant.q2Schedule:
            _todos[index].isUrgent = false;
            _todos[index].isImportant = true;
            break;
          case EisenhowerQuadrant.q3Delegate:
            _todos[index].isUrgent = true;
            _todos[index].isImportant = false;
            break;
          case EisenhowerQuadrant.q4Eliminate:
            _todos[index].isUrgent = false;
            _todos[index].isImportant = false;
            break;
        }
      }
    });
  }

  // Delete Task using setState with Undo snackbar
  void _deleteTodo(String id) {
    final deletedIndex = _todos.indexWhere((item) => item.id == id);
    if (deletedIndex == -1) return;
    final deletedItem = _todos[deletedIndex];

    setState(() {
      _todos.removeAt(deletedIndex);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: PastelTheme.textPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(
          'Deleted "${deletedItem.title}"',
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: PastelTheme.pastelMint,
          onPressed: () {
            setState(() {
              _todos.insert(deletedIndex, deletedItem);
            });
          },
        ),
      ),
    );
  }

  // Helper to get tasks for a given quadrant
  List<TodoItem> _getTasksForQuadrant(EisenhowerQuadrant quadrant) {
    return _todos.where((item) {
      final matchesQuadrant = item.quadrant == quadrant;
      final matchesSearch = _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (item.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      return matchesQuadrant && matchesSearch;
    }).toList();
  }

  // Open Modal to Add a Task with custom Urgency/Importance
  void _openAddTaskModal({EisenhowerQuadrant? defaultQuadrant}) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    TodoCategory selectedCategory = TodoCategory.work;
    bool isUrgent = defaultQuadrant == null
        ? true
        : (defaultQuadrant == EisenhowerQuadrant.q1DoFirst ||
            defaultQuadrant == EisenhowerQuadrant.q3Delegate);
    bool isImportant = defaultQuadrant == null
        ? true
        : (defaultQuadrant == EisenhowerQuadrant.q1DoFirst ||
            defaultQuadrant == EisenhowerQuadrant.q2Schedule);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            final activeQuadrant = EisenhowerQuadrant.fromFlags(
              isUrgent: isUrgent,
              isImportant: isImportant,
            );

            return Container(
              padding: EdgeInsets.only(
                top: 22,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: PastelTheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4.5,
                        decoration: BoxDecoration(
                          color: PastelTheme.border,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Text(
                          'Add Task to Matrix 🎯',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: PastelTheme.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Task Title
                    TextField(
                      controller: titleController,
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: PastelTheme.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Task title...',
                        hintStyle: const TextStyle(
                          color: PastelTheme.textTertiary,
                          fontWeight: FontWeight.w500,
                        ),
                        filled: true,
                        fillColor: PastelTheme.surfaceElevated,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Task Description
                    TextField(
                      controller: descController,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 13, color: PastelTheme.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Notes or details (optional)...',
                        hintStyle: const TextStyle(
                          color: PastelTheme.textTertiary,
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: PastelTheme.surfaceElevated,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Eisenhower Matrix Quadrant Selector (Urgency & Importance)
                    const Text(
                      'Eisenhower Matrix Assignment',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: PastelTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 4-Quadrant Preview Selector
                    Row(
                      children: [
                        _buildQuadrantChoiceTile(
                          quadrant: EisenhowerQuadrant.q1DoFirst,
                          isSelected: activeQuadrant == EisenhowerQuadrant.q1DoFirst,
                          onTap: () => setModalState(() {
                            isUrgent = true;
                            isImportant = true;
                          }),
                        ),
                        const SizedBox(width: 8),
                        _buildQuadrantChoiceTile(
                          quadrant: EisenhowerQuadrant.q2Schedule,
                          isSelected: activeQuadrant == EisenhowerQuadrant.q2Schedule,
                          onTap: () => setModalState(() {
                            isUrgent = false;
                            isImportant = true;
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildQuadrantChoiceTile(
                          quadrant: EisenhowerQuadrant.q3Delegate,
                          isSelected: activeQuadrant == EisenhowerQuadrant.q3Delegate,
                          onTap: () => setModalState(() {
                            isUrgent = true;
                            isImportant = false;
                          }),
                        ),
                        const SizedBox(width: 8),
                        _buildQuadrantChoiceTile(
                          quadrant: EisenhowerQuadrant.q4Eliminate,
                          isSelected: activeQuadrant == EisenhowerQuadrant.q4Eliminate,
                          onTap: () => setModalState(() {
                            isUrgent = false;
                            isImportant = false;
                          }),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Category Chips
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: PastelTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: TodoCategory.values.map((cat) {
                        final isSelected = selectedCategory == cat;
                        return InkWell(
                          onTap: () => setModalState(() => selectedCategory = cat),
                          borderRadius: BorderRadius.circular(10),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? cat.pastelBg : PastelTheme.surfaceElevated,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? cat.textDark : PastelTheme.border,
                                width: isSelected ? 1.4 : 1.0,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(cat.icon, size: 14, color: isSelected ? cat.textDark : PastelTheme.textSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  cat.label,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                    color: isSelected ? cat.textDark : PastelTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 22),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          if (titleController.text.trim().isEmpty) return;
                          _addTodo(
                            title: titleController.text,
                            description: descController.text,
                            isUrgent: isUrgent,
                            isImportant: isImportant,
                            category: selectedCategory,
                          );
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: activeQuadrant.accentDark,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_outline_rounded, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              'Assign to ${activeQuadrant.code} (${activeQuadrant.title})',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Quadrant choice tile in modal
  Widget _buildQuadrantChoiceTile({
    required EisenhowerQuadrant quadrant,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? quadrant.pastelBg : PastelTheme.surfaceElevated,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? quadrant.accentDark : PastelTheme.border,
              width: isSelected ? 1.8 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: quadrant.accentDark.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(quadrant.icon, size: 14, color: quadrant.accentDark),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${quadrant.code}: ${quadrant.title}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: isSelected ? quadrant.textDark : PastelTheme.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      quadrant.subtitle,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? quadrant.accentDark : PastelTheme.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalTasks = _todos.length;
    final completedTasks = _todos.where((t) => t.isCompleted).length;
    final mediaQuery = MediaQuery.of(context);
    final isWide = mediaQuery.size.width > 700;

    return Scaffold(
      backgroundColor: PastelTheme.background,
      appBar: AppBar(
        title: const Row(
          children: [
            Text('🎯 Priority Matrix'),
          ],
        ),
        actions: [
          // View Mode Switcher: 2x2 Matrix vs Focused Tabs
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: PastelTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: PastelTheme.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildViewToggleButton(
                  icon: Icons.grid_view_rounded,
                  label: '2x2 Matrix',
                  isSelected: _selectedViewTab == 0,
                  onTap: () => setState(() => _selectedViewTab = 0),
                ),
                _buildViewToggleButton(
                  icon: Icons.view_agenda_rounded,
                  label: 'Quadrant Tabs',
                  isSelected: _selectedViewTab == 1,
                  onTap: () => setState(() => _selectedViewTab = 1),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddTaskModal(),
        icon: const Icon(Icons.add_task_rounded, size: 20),
        label: const Text(
          'Add to Matrix',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
        ),
      ),
      body: Column(
        children: [
          // 1. Matrix Overview Pill & Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              children: [
                // Real-time Progress Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: PastelTheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: PastelTheme.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.task_alt_rounded, size: 16, color: PastelTheme.pastelMintDark),
                      const SizedBox(width: 6),
                      Text(
                        '$completedTasks/$totalTasks Done',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: PastelTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Search Bar with Flexible
                Expanded(
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: PastelTheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: PastelTheme.border),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        const Icon(Icons.search_rounded, size: 18, color: PastelTheme.textTertiary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v) => setState(() => _searchQuery = v),
                            style: const TextStyle(fontSize: 12.5, color: PastelTheme.textPrimary),
                            decoration: const InputDecoration(
                              hintText: 'Filter matrix tasks...',
                              hintStyle: TextStyle(color: PastelTheme.textTertiary, fontSize: 12.5),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 15, color: PastelTheme.textSecondary),
                            onPressed: () => setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            }),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Matrix Body (2x2 Grid or Tabbed Focus)
          Expanded(
            child: _selectedViewTab == 0
                ? _build2x2MatrixGrid(isWide)
                : _buildTabbedFocusView(),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggleButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? PastelTheme.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? PastelTheme.pastelLilacDark : PastelTheme.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? PastelTheme.pastelLilacDark : PastelTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2x2 Eisenhower Matrix Grid View with Urgency (Top) and Importance (Left) Axis Labels
  Widget _build2x2MatrixGrid(bool isWide) {
    const double leftAxisWidth = 24.0;
    const double axisSpacing = 6.0;
    const double cardSpacing = 8.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 10),
      child: Column(
        children: [
          // Urgency Axis Labels Header (Offset by left axis width)
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Row(
              children: [
                // Left axis corner spacer
                const SizedBox(width: leftAxisWidth + axisSpacing),

                // Top Axis: Urgent
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 3.5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: PastelTheme.pastelRose.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.bolt_rounded,
                          size: 13,
                          color: PastelRoseThemeHelper.dark,
                        ),
                        SizedBox(width: 2),
                        Text(
                          'URGENT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: PastelRoseThemeHelper.dark,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: cardSpacing),

                // Top Axis: Not Urgent
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 3.5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: PastelTheme.pastelSky.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.hourglass_bottom_rounded,
                          size: 12,
                          color: Color(0xFF0369A1),
                        ),
                        SizedBox(width: 2),
                        Text(
                          'NOT URGENT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0369A1),
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Top Row: [★ IMPORTANT Axis Label] + Q1 (Do First) + Q2 (Schedule)
          Expanded(
            child: Row(
              children: [
                // Left Axis Label: Important
                Container(
                  width: leftAxisWidth,
                  decoration: BoxDecoration(
                    color: PastelTheme.pastelLilac.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: PastelTheme.pastelLilacDark.withValues(alpha: 0.25),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const RotatedBox(
                    quarterTurns: 3,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 11,
                          color: PastelTheme.pastelLilacDark,
                        ),
                        SizedBox(width: 3),
                        Text(
                          'IMPORTANT',
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                            color: PastelTheme.pastelLilacDark,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: axisSpacing),

                // Q1: Do First
                Expanded(
                  child: _buildQuadrantCard(EisenhowerQuadrant.q1DoFirst),
                ),
                const SizedBox(width: cardSpacing),

                // Q2: Schedule
                Expanded(
                  child: _buildQuadrantCard(EisenhowerQuadrant.q2Schedule),
                ),
              ],
            ),
          ),

          const SizedBox(height: cardSpacing),

          // Bottom Row: [⚪ NOT IMPORTANT Axis Label] + Q3 (Delegate) + Q4 (Eliminate)
          Expanded(
            child: Row(
              children: [
                // Left Axis Label: Not Important
                Container(
                  width: leftAxisWidth,
                  decoration: BoxDecoration(
                    color: PastelTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: PastelTheme.border),
                  ),
                  alignment: Alignment.center,
                  child: const RotatedBox(
                    quarterTurns: 3,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.radio_button_unchecked_rounded,
                          size: 9,
                          color: PastelTheme.textSecondary,
                        ),
                        SizedBox(width: 3),
                        Text(
                          'NOT IMPORTANT',
                          style: TextStyle(
                            fontSize: 8.0,
                            fontWeight: FontWeight.w800,
                            color: PastelTheme.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: axisSpacing),

                // Q3: Delegate
                Expanded(
                  child: _buildQuadrantCard(EisenhowerQuadrant.q3Delegate),
                ),
                const SizedBox(width: cardSpacing),

                // Q4: Eliminate
                Expanded(
                  child: _buildQuadrantCard(EisenhowerQuadrant.q4Eliminate),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Quadrant Card widget containing task list and fast add action
  Widget _buildQuadrantCard(EisenhowerQuadrant quadrant) {
    final tasks = _getTasksForQuadrant(quadrant);
    final completedCount = tasks.where((t) => t.isCompleted).length;

    return Container(
      decoration: BoxDecoration(
        color: quadrant.pastelCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: quadrant.accentDark.withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quadrant Card Header with Overflow-safe constraints
          Container(
            padding: const EdgeInsets.fromLTRB(8, 7, 6, 6),
            decoration: BoxDecoration(
              color: quadrant.pastelBg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              children: [
                Icon(quadrant.icon, size: 14, color: quadrant.accentDark),
                const SizedBox(width: 4),
                // Title and Subtitle with Expanded to prevent horizontal overflow
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${quadrant.code} • ${quadrant.title}',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900,
                          color: quadrant.textDark,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        quadrant.subtitle,
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w600,
                          color: quadrant.accentDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                // Task Count Chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$completedCount/${tasks.length}',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: quadrant.textDark,
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                // Quick Add button for this quadrant
                InkWell(
                  onTap: () => _openAddTaskModal(defaultQuadrant: quadrant),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.all(3.5),
                    decoration: BoxDecoration(
                      color: quadrant.accentDark,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.add_rounded, size: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Quadrant Task List with ListView.builder
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.done_all_rounded,
                            size: 20,
                            color: quadrant.accentDark.withValues(alpha: 0.35),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'No tasks',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: quadrant.textDark.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                    physics: const BouncingScrollPhysics(),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final item = tasks[index];
                      return _buildMatrixTaskItem(item, quadrant);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Individual Task item inside a quadrant optimized for narrow mobile widths
  Widget _buildMatrixTaskItem(TodoItem item, EisenhowerQuadrant quadrant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.fromLTRB(6, 5, 4, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: item.isCompleted
              ? PastelTheme.border
              : quadrant.pastelBg,
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Checkbox toggle with setState
          InkWell(
            onTap: () => _toggleTodo(item.id),
            borderRadius: BorderRadius.circular(5),
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: item.isCompleted ? quadrant.accentDark : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: item.isCompleted ? quadrant.accentDark : PastelTheme.border,
                  width: 1.4,
                ),
              ),
              child: item.isCompleted
                  ? const Icon(Icons.check_rounded, size: 12, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 6),

          // Task details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: item.isCompleted ? PastelTheme.textTertiary : PastelTheme.textPrimary,
                    decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                    decorationColor: PastelTheme.textTertiary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.description != null && !item.isCompleted)
                  Text(
                    item.description!,
                    style: const TextStyle(fontSize: 9, color: PastelTheme.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),

          // Action Menu & Delete
          PopupMenuButton<EisenhowerQuadrant>(
            icon: const Icon(Icons.more_vert_rounded, size: 14, color: PastelTheme.textTertiary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Change Priority',
            onSelected: (target) => _moveTodoQuadrant(item.id, target),
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                enabled: false,
                child: Text('Move to Quadrant:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              ...EisenhowerQuadrant.values.map(
                (q) => PopupMenuItem(
                  value: q,
                  child: Row(
                    children: [
                      Icon(q.icon, size: 14, color: q.accentDark),
                      const SizedBox(width: 6),
                      Text('${q.code} • ${q.title}', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () => _deleteTodo(item.id),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: Icon(Icons.close_rounded, size: 13, color: PastelTheme.textTertiary),
            ),
          ),
        ],
      ),
    );
  }

  // Focused Tab View Mode for deep inspection of a single quadrant
  Widget _buildTabbedFocusView() {
    final tasks = _getTasksForQuadrant(_selectedFocusQuadrant);

    return Column(
      children: [
        // 4 Quadrant Selector Tabs
        Container(
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: EisenhowerQuadrant.values.map((q) {
              final isSelected = _selectedFocusQuadrant == q;
              final count = _getTasksForQuadrant(q).length;

              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedFocusQuadrant = q),
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? q.pastelBg : PastelTheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? q.accentDark : PastelTheme.border,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${q.code} ${q.title}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                            color: isSelected ? q.textDark : PastelTheme.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '$count tasks',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? q.accentDark : PastelTheme.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 12),

        // Quadrant Mission Explanation Banner
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _selectedFocusQuadrant.pastelCardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _selectedFocusQuadrant.accentDark.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(_selectedFocusQuadrant.icon, size: 22, color: _selectedFocusQuadrant.accentDark),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_selectedFocusQuadrant.title}: ${_selectedFocusQuadrant.subtitle}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: _selectedFocusQuadrant.textDark,
                        ),
                      ),
                      Text(
                        _selectedFocusQuadrant.actionDesc,
                        style: TextStyle(
                          fontSize: 11,
                          color: _selectedFocusQuadrant.textDark.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Focused List View
        Expanded(
          child: tasks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.checklist_rounded, size: 40, color: _selectedFocusQuadrant.accentDark.withValues(alpha: 0.4)),
                      const SizedBox(height: 8),
                      Text(
                        'No tasks in ${_selectedFocusQuadrant.title}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: _selectedFocusQuadrant.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => _openAddTaskModal(defaultQuadrant: _selectedFocusQuadrant),
                        icon: const Icon(Icons.add_rounded, size: 16),
                        label: Text('Add to ${_selectedFocusQuadrant.code}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedFocusQuadrant.accentDark,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 80),
                  physics: const BouncingScrollPhysics(),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final item = tasks[index];
                    return _buildFocusedTaskCard(item, _selectedFocusQuadrant);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFocusedTaskCard(TodoItem item, EisenhowerQuadrant quadrant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PastelTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isCompleted ? PastelTheme.border : quadrant.pastelBg,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox toggle
          InkWell(
            onTap: () => _toggleTodo(item.id),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: item.isCompleted ? quadrant.accentDark : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: item.isCompleted ? quadrant.accentDark : PastelTheme.border,
                  width: 2,
                ),
              ),
              child: item.isCompleted
                  ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: item.isCompleted ? PastelTheme.textTertiary : PastelTheme.textPrimary,
                    decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (item.description != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    item.description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: item.isCompleted ? PastelTheme.textTertiary : PastelTheme.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: item.category.pastelBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.category.label,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: item.category.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: quadrant.pastelBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        quadrant.badgeText,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: quadrant.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Move Quadrant and Delete
          PopupMenuButton<EisenhowerQuadrant>(
            icon: const Icon(Icons.swap_horiz_rounded, size: 20, color: PastelTheme.textTertiary),
            tooltip: 'Move Quadrant',
            onSelected: (target) => _moveTodoQuadrant(item.id, target),
            itemBuilder: (ctx) => EisenhowerQuadrant.values.map((q) {
              return PopupMenuItem(
                value: q,
                child: Row(
                  children: [
                    Icon(q.icon, size: 16, color: q.accentDark),
                    const SizedBox(width: 8),
                    Text('${q.code} • ${q.title} (${q.subtitle})'),
                  ],
                ),
              );
            }).toList(),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, size: 20, color: PastelTheme.textTertiary),
            onPressed: () => _deleteTodo(item.id),
          ),
        ],
      ),
    );
  }
}

class PastelRoseThemeHelper {
  static const Color dark = Color(0xFFBE123C);
}
