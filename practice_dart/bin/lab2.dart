// ==========================================
// Lab 2 – Dart Essentials Practice Lab
// Course: PRM - FPT University
// Entry Driver - Imports and executes each modular exercise.
// ==========================================

import 'package:practice_dart/lab2/exercise_1.dart';
import 'package:practice_dart/lab2/exercise_2.dart';
import 'package:practice_dart/lab2/exercise_3.dart';
import 'package:practice_dart/lab2/exercise_4.dart';
import 'package:practice_dart/lab2/exercise_5.dart';

void main() async {
  print('======================================================================');
  print('           STARTING LAB 2 - DART ESSENTIALS PRACTICE LAB             ');
  print('                  (REFRACTORED MODULAR VERSION)                      ');
  print('======================================================================\n');

  // Exercise 1 – Basic Syntax & Data Types
  runExercise1();

  // Exercise 2 – Collections & Operators
  runExercise2();

  // Exercise 3 – Control Flow & Functions
  runExercise3();

  // Exercise 4 – Intro to OOP
  runExercise4();

  // Exercise 5 – Async, Future, Null Safety & Streams
  await runExercise5();

  print('======================================================================');
  print('           LAB 2 COMPLETED SUCCESSFULLY - ALL EXERCISES PASS         ');
  print('======================================================================');
}
