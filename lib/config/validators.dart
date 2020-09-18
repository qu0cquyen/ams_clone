class Validators {
  static isValidUsername(String username) {
    return username.length > 3;
  }

  static isValidPassword(String password) {
    return password.length > 5;
  }

  static isValidPhoneNumber(String phoneNumber) {
    return phoneNumber.length == 14;
  }
}
