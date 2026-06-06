void runCollectionsDemo() {
  print('--- DEMO COLLECTIONS ---');
  
  // 1. LIST: Danh sách có thứ tự, cho phép các phần tử trùng lặp
  List<String> subjects = ['Toán', 'Lý', 'Hóa'];
  subjects.add('Sinh');
  subjects.remove('Lý');
  print('List môn học: $subjects');

  // 2. SET: Tập hợp không có thứ tự, KHÔNG cho phép trùng lặp
  Set<String> uniqueTags = {'Flutter', 'Dart', 'Mobile'};
  uniqueTags.add('Dart'); // Bỏ qua vì đã tồn tại
  uniqueTags.add('Web');
  print('Set các thẻ: $uniqueTags');

  // 3. MAP: Lưu trữ dữ liệu theo cặp Key - Value
  Map<String, double> studentGrades = {
    'S01': 8.5,
    'S02': 9.0,
  };
  studentGrades['S03'] = 7.5;
  studentGrades['S01'] = 8.8; // Cập nhật
  
  print('Map điểm sinh viên:');
  studentGrades.forEach((id, grade) {
    print(' - Mã SV: $id, Điểm: $grade');
  });
  print('------------------------\n');
}
