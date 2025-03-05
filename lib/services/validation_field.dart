class Validations {
  static bool isEmail(String em) {
    String p = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(em);
  }

  static bool validateName(String value) {
    if (value.length < 4) {
      return false;
    } else {
      return true;
    }
  }

  static bool validatePassword(String value) {
    final passwordRegex =
        RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return passwordRegex.hasMatch(value);
  }

  static bool validateConfirmPassword(String password, String confirmPassword) {
    if (password != confirmPassword) {
      return false;
    } else {
      return true;
    }
  }

  static bool validateUsername(String value) {
    if (value.length < 5) {
      return false;
    } else {
      return true;
    }
  }

  static bool validateMobile(String value) {
    if (value.length < 10) {
      return false;
    } else {
      return true;
    }
  }
}
