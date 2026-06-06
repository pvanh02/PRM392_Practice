import 'dart:io';
import 'package:practice_dart/lab1/collections_demo.dart';
import 'package:practice_dart/lab1/models/student.dart';
import 'package:practice_dart/lab1/models/teacher.dart';

void main() {
  // Demo Collections
  runCollectionsDemo();

  // Khởi tạo dữ liệu
  List<Student> students = [
    Student('S01', 'Nguyễn Văn A', 8.5),
    Student('S02', 'Trần Thị B', 9.2)
  ];
  
  List<Teacher> teachers = [
    Teacher('T01', 'Lê Văn C', 'Toán học')
  ];
  
  bool isRunning = true;

  while (isRunning) {
    print('\n--- QUẢN LÝ TRƯỜNG HỌC ---');
    print('1. Xem danh sách sinh viên');
    print('2. Xem danh sách giáo viên');
    print('3. Thêm sinh viên mới');
    print('0. Thoát');
    stdout.write('Chọn chức năng: ');
    
    String? choice = stdin.readLineSync();
    
    switch (choice) {
      case '1':
        print('\n--- Danh sách Sinh viên ---');
        for (var student in students) {
          student.displayInfo();
        }
        break;
        
      case '2':
        print('\n--- Danh sách Giáo viên ---');
        for (var teacher in teachers) {
          teacher.displayInfo();
        }
        break;

      case '3':
        print('\n--- Thêm Sinh Viên ---');
        stdout.write('Nhập ID: ');
        String id = stdin.readLineSync() ?? '';
        stdout.write('Nhập Tên: ');
        String name = stdin.readLineSync() ?? '';
        stdout.write('Nhập Điểm TB: ');
        double gpa = double.tryParse(stdin.readLineSync() ?? '0') ?? 0.0;
        
        students.add(Student(id, name, gpa));
        print('=> Đã thêm sinh viên thành công!');
        break;

      case '0':
        isRunning = false;
        print('Đã thoát chương trình.');
        break;
        
      default:
        print('Lựa chọn không hợp lệ, vui lòng thử lại!');
    }
  }
}
