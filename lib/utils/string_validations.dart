extension Validations on String {
  bool hasCapital() {
    final RegExp regex = RegExp(r'^(?=.*?[A-Z])');
    return regex.hasMatch(this);
  }

  bool hasMinus() {
    final RegExp regex = RegExp(r'^(?=.*?[a-z])');
    return regex.hasMatch(this);
  }

  bool hasNumber() {
    final RegExp regex = RegExp(r'^(?=.*?[0-9])');
    return regex.hasMatch(this);
  }

  bool hasSpecial() {
    final RegExp regex = RegExp(r'^(?=.*?[!@#\$&*~.])');
    return regex.hasMatch(this);
  }

  bool hasLength() {
    return length >= 6;
  }

  bool isEmail() {
    final RegExp regex = RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
    return regex.hasMatch(this);
  }
}
