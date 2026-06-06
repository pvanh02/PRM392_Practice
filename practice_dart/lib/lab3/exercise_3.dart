import 'dart:async';

// ============================================================================
// EXERCISE 3: Async + Microtask Debugging
// Goal: Differentiate microtask and event queues in Dart event loops.
// ============================================================================

/// Runner for Exercise 3
Future<void> runExercise3() async {
  print('======================================================================');
  print('EXERCISE 3: Async + Microtask Debugging');
  print('======================================================================');

  print('[1] Synchronous main execution: Step 1 (Start)');

  // Schedule an event in the standard Event Queue (using a delayed-zero Future)
  Future(() {
    print('[5] Event Queue: Future #1 executed.');
  });

  // Schedule a microtask in the Microtask Queue
  scheduleMicrotask(() {
    print('[3] Microtask Queue: scheduleMicrotask #1 executed.');
  });

  // Another way to schedule a microtask (using Future.microtask)
  Future.microtask(() {
    print('[4] Microtask Queue: Future.microtask #2 executed.');
  });

  // Schedule another event in the Event Queue
  Future(() {
    print('[6] Event Queue: Future #2 executed.');
  });

  print('[2] Synchronous main execution: Step 2 (End)');

  // Let the microtask and event queues drain before printing the explanation.
  // We await a small duration so the output completes sequentially.
  await Future.delayed(const Duration(milliseconds: 100));

  print('\n----------------------------------------------------------------------');
  print('EXPLANATION OF THE EXECUTION ORDER:');
  print('----------------------------------------------------------------------');
  print('1. Synchronous Code runs first, to completion, blocking the thread.');
  print('2. Once synchronous code yields, the Dart event-loop checks the');
  print('   MICROTASK QUEUE. This queue handles very brief async activities');
  print('   that need to execute right after execution returns to the loop.');
  print('   Therefore, microtasks [3] and [4] run before any event callbacks.');
  print('3. After the Microtask Queue is completely empty, the event loop');
  print('   picks events one-by-one from the EVENT QUEUE (e.g. Futures [5] & [6],');
  print('   network responses, I/O, timers).');
  print('======================================================================\n');
}
