import 'user.dart';

class Student extends User {
  double gpa;

  Student(String id, String name, this.gpa) : super(id, name);

  @override
  void displayInfo() {
    print('Sinh viên - ID: $id | Tên: $name | Điểm TB: $gpa');
  }
}
