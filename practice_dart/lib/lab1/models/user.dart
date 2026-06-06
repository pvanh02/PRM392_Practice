abstract class User {
  String _id;
  String _name;

  User(this._id, this._name);

  String get id => _id;
  String get name => _name;

  set name(String newName) {
    if (newName.isNotEmpty) {
      _name = newName;
    }
  }

  void displayInfo() {
    print('ID: $_id | Tên: $_name');
  }
}
