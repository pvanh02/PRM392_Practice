// ==========================================
// Lab 3 – Advanced Dart Practice Exercises
// Course: PRM - FPT University
// Entry Driver - Imports and executes each modular exercise.
// ==========================================

import 'package:practice_dart/lab3/exercise_1.dart';
import 'package:practice_dart/lab3/exercise_2.dart';
import 'package:practice_dart/lab3/exercise_3.dart';
import 'package:practice_dart/lab3/exercise_4.dart';
import 'package:practice_dart/lab3/exercise_5.dart';

void main() async {
  print('======================================================================');
  print('           STARTING LAB 3 - ADVANCED DART PRACTICE EXERCISES         ');
  print('                  (REFACETORED MODULAR VERSION)                      ');
  print('======================================================================\n');

  // Exercise 1: Futures & Streams (Product Repository)
  await runExercise1();

  // Exercise 2: JSON Deserialization (User Repository)
  await runExercise2();

  // Exercise 3: Async & Microtasks Event Loop Debugging
  await runExercise3();

  // Exercise 4: Functional Stream Transformations (map & where)
  await runExercise4();

  // Exercise 5: Factory Constructors & Singleton Caching
  runExercise5();

  print('======================================================================');
  print('           LAB 3 COMPLETED SUCCESSFULLY - ALL EXERCISES PASS         ');
  print('======================================================================');
}
