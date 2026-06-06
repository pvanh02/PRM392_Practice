import 'package:flutter/material.dart';

/// Exercise 5 – Debug & Fix Common UI Errors
/// Shows 4 common Flutter layout and logic mistakes, provides detailed explanations,
/// and showcases the fixed implementations in a tabbed, interactive structure.
class DebugUIErrorsDemo extends StatefulWidget {
  const DebugUIErrorsDemo({super.key});

  @override
  State<DebugUIErrorsDemo> createState() => _DebugUIErrorsDemoState();
}

class _DebugUIErrorsDemoState extends State<DebugUIErrorsDemo> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // State variables for showing Fixes
  int _counter = 0; // State variable for counter fix
  DateTime? _selectedDate; // State variable for DatePicker fix

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Method to showcase DatePicker using a valid BuildContext
  Future<void> _showFixedDatePicker(BuildContext context) async {
    final DateTime now = DateTime.now();
    // FIX: Using the correct, valid build context of the button widget
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 5: Debug & Fix UI Errors'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: '1. Column/ListView'),
            Tab(text: '2. Overflow'),
            Tab(text: '3. State Update'),
            Tab(text: '4. DatePicker Context'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Column / ListView (Expanded Fix)
          _buildListViewFixTab(),
          
          // Tab 2: Overflow (SingleChildScrollView Fix)
          _buildOverflowFixTab(),
          
          // Tab 3: State Update (setState Fix)
          _buildStateUpdateFixTab(),
          
          // Tab 4: DatePicker Context (Valid Context Fix)
          _buildDatePickerContextFixTab(),
        ],
      ),
    );
  }

  // 1. Tab: ListView inside Column (Expanded Fix)
  Widget _buildListViewFixTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExplanationHeader(
            error: 'Unbounded Height Exception',
            cause: 'Placing a ListView (which requests infinite height) directly inside a Column (which has infinite vertical constraints) results in a layout crash.',
            fix: 'Wrap the ListView in an "Expanded" widget. This constrains the ListView to take only the remaining vertical space of the Column.',
          ),
          const SizedBox(height: 16),
          const Text(
            'Live Demonstration (Fixed):',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          
          // FIX: Wrapping the ListView.builder in Expanded to solve bounded constraint errors
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                itemCount: 15,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text('Scrollable List Item #${index + 1}'),
                    subtitle: const Text('Rendered safely inside a Column container'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Tab: Overflow (SingleChildScrollView Fix)
  Widget _buildOverflowFixTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      // FIX: Wrapped Column in SingleChildScrollView to prevent black/yellow strip overflow warning on small screens
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExplanationHeader(
              error: 'Yellow/Black Strip screen overflow',
              cause: 'Content exceeds the physical screen boundaries (e.g. keyboard popping up, or layout elements having large fixed heights).',
              fix: 'Wrap the root layout container inside a "SingleChildScrollView" to allow the entire list/form to scroll vertically.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Live Demonstration (Fixed - Try scrolling):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            // Simulating a tall layout that would overflow without a scroll view
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
              child: const Text('Block 1: Extremely tall container segment (1)'),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)),
              child: const Text('Block 2: Extremely tall container segment (2)'),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
              child: const Text('Block 3: Extremely tall container segment (3)'),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
              child: const Text('Block 4: Extremely tall container segment (4)'),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Tab: State Update (setState Fix)
  Widget _buildStateUpdateFixTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExplanationHeader(
            error: 'UI does not update upon variable changes',
            cause: 'Updating member variables directly in a StatefulWidget does not trigger a re-build, making the UI look static.',
            fix: 'Enclose variable updates within a "setState(() {...})" block. This marks the widget state as dirty and schedules a build redraw.',
          ),
          const SizedBox(height: 20),
          const Text(
            'Live Demonstration (Fixed):',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text('Tap the button below to update the counter:', style: TextStyle(fontSize: 15)),
                  const SizedBox(height: 12),
                  Text(
                    '$_counter',
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // FIX: Wrapped change in setState so UI redraws
                          setState(() {
                            _counter++;
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Increment'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          // FIX: Wrapped change in setState so UI redraws
                          setState(() {
                            _counter = 0;
                          });
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // 4. Tab: DatePicker Context (Valid Context Fix)
  Widget _buildDatePickerContextFixTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExplanationHeader(
            error: 'DatePicker build context errors / crashes',
            cause: 'Using an invalid/unmounted BuildContext (like context from initState or before widget rendering completes) crashes the app.',
            fix: 'Trigger showDatePicker inside user-triggered gestures (like button callbacks) which supply a validated, fully-initialized BuildContext from the widget tree.',
          ),
          const SizedBox(height: 20),
          const Text(
            'Live Demonstration (Fixed):',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Date Selected:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(
                          _selectedDate == null ? 'No Date Chosen' : '${_selectedDate!.toLocal()}'.split(' ')[0],
                          style: TextStyle(fontSize: 16, color: Colors.indigo[800], fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  // Builder ensures we pass the valid, located context of this exact widget tree node
                  Builder(
                    builder: (buttonContext) {
                      return ElevatedButton.icon(
                        onPressed: () => _showFixedDatePicker(buttonContext),
                        icon: const Icon(Icons.date_range),
                        label: const Text('Open Date Picker'),
                      );
                    }
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Helper template for the explanation banner
  Widget _buildExplanationHeader({required String error, required String cause, required String fix}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50.withOpacity(0.5),
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: Colors.red.shade800, size: 20),
              const SizedBox(width: 8),
              Text(
                'Lỗi: $error',
                style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 13, color: Colors.black87),
              children: [
                const TextSpan(text: '• Nguyên nhân: ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: cause),
              ],
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 13, color: Colors.black87),
              children: [
                const TextSpan(text: '• Giải pháp sửa: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                TextSpan(text: fix, style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
