import 'user.dart';

class Teacher extends User {
  String subject;

  Teacher(String id, String name, this.subject) : super(id, name);

  @override
  void displayInfo() {
    print('Giáo viên - ID: $id | Tên: $name | Dạy môn: $subject');
  }
}
