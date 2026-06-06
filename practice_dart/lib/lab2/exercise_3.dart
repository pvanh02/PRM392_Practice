// EXERCISE 3 – Control Flow & Functions
void runExercise3() {
  print('========== EXERCISE 3: Control Flow & Functions ==========');
  
  // If/Else block
  int testScore = 85;
  print('Checking Score $testScore: ');
  if (testScore >= 90) {
    print('Grade A');
  } else if (testScore >= 80) {
    print('Grade B');
  } else {
    print('Grade C');
  }

  int dayOfWeek = 3;
  print('Day $dayOfWeek is: ');
  switch (dayOfWeek) {
    case 1: print('Monday'); break;
    case 2: print('Tuesday'); break;
    case 3: print('Wednesday'); break;
    default: print('Other Day');
  }

  print('Looping with [for]:');
  for (int i = 0; i < 2; i++) {
    // using dummy list or inline list to avoid dependency on Exercise 2
    List<int> dummyNumbers = [10, 30, 40, 50]; 
    print(' - dummyNumbers[$i] = ${dummyNumbers[i]}');
  }

  print('Looping with [for-in]:');
  Set<String> dummyTags = {'Dart', 'Flutter', 'Mobile'};
  for (String tag in dummyTags) {
    print(' - tag: $tag');
  }

  print('Looping with [forEach]:');
  Map<String, int> dummyScores = {'Math': 90, 'Science': 85, 'English': 88};
  dummyScores.forEach((key, value) => print(' - $key: $value'));

  int addNormal(int x, int y) {
    return x + y;
  }
  
  int addArrow(int x, int y) => x + y;

  print('Function (Normal): 5 + 3 = ${addNormal(5, 3)}');
  print('Function (Arrow): 5 + 3 = ${addArrow(5, 3)}');
  print('');
}
