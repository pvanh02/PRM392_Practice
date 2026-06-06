// EXERCISE 5: Async & Streams Functions
Future<void> simulateLoading() async {
  print('Loading data from server...');
  // Simulating network delay
  await Future.delayed(const Duration(seconds: 2));
  print('Data loaded successfully!');
}

Stream<int> countStream(int maxCount) async* {
  for (int i = 1; i <= maxCount; i++) {
    await Future.delayed(const Duration(milliseconds: 500));
    yield i;
  }
}

Future<void> runExercise5() async {
  print('========== EXERCISE 5: Async, Future, Null Safety & Streams ==========');
  
  // Null-Safety Operators
  String? nullableName;
  print('Using ?? : Hello, ${nullableName ?? "Guest"}'); 

  nullableName = "Alice";
  print('Using ?. : Length is ${nullableName.length}'); // Alice is non-null here, but nullableName?.length is safe

  String nonNullName = nullableName;
  print('Using !  : $nonNullName');

  await simulateLoading();

  print('Listening to Stream values:');
  await for (int value in countStream(3)) {
    print(' Stream emitted: $value');
  }
  print('');
}
