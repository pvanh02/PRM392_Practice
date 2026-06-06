import 'dart:async';

// ============================================================================
// EXERCISE 4: Stream Transformation
// Goal: Use functional stream operators like map() and where().
// ============================================================================

/// Runner for Exercise 4
Future<void> runExercise4() async {
  print('======================================================================');
  print('EXERCISE 4: Stream Transformation');
  print('======================================================================');

  // 1. Create a stream of numbers 1–5
  final Stream<int> rawStream = Stream.fromIterable([1, 2, 3, 4, 5]);

  print('[Stream] Transforming stream: numbers 1-5');

  // 2. Transform values to their squares using map()
  // 3. Filter even numbers with where()
  final Stream<int> processedStream = rawStream
      .map((number) {
        final squared = number * number;
        print('  [map()] Squared: $number -> $squared');
        return squared;
      })
      .where((squaredNumber) {
        final isEven = squaredNumber % 2 == 0;
        print('  [where()] Is $squaredNumber even? $isEven');
        return isEven;
      });

  // 4. Listen and print each emitted value
  print('\n[Stream] Listening to processed stream results:');
  await processedStream.forEach((emittedValue) {
    print('  -> Emitted: $emittedValue');
  });

  print('======================================================================\n');
}
