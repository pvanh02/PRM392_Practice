// EXERCISE 2 – Collections & Operators
void runExercise2() {
  print('========== EXERCISE 2: Collections & Operators ==========');
  
  // 1. List of integers
  List<int> numbers = [10, 20, 30, 40];
  numbers.add(50); // add()
  numbers.remove(20); // remove()
  print('List indexing (first item): ${numbers[0]}');
  print('Modified List: $numbers');

  // 2. Operators
  int a = 15, b = 5;
  print('Arithmetic (+): $a + $b = ${a + b}');
  print('Arithmetic (-): $a - $b = ${a - b}');
  print('Comparison (==): a == b is ${a == b}');
  print('Logical (&&): (a > 10) && (b < 10) is ${(a > 10) && (b < 10)}');
  print('Ternary (? :): a is ${a % 2 == 0 ? "Even" : "Odd"}');

  // 3. Set (Unique values)
  Set<String> uniqueTags = {'Dart', 'Flutter', 'Mobile'};
  uniqueTags.add('Dart'); // Will be ignored because it's duplicate
  print('Set: $uniqueTags');

  // 4. Map (Key-value pairs)
  Map<String, int> scores = {'Math': 90, 'Science': 85};
  scores['English'] = 88; // map access & assignment
  print('Map access (Math score): ${scores['Math']}');
  print('Full Map: $scores');
  print('');
}
