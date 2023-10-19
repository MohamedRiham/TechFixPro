class Validator {

  static String? validateName({required String? name}) {
    if (name == null) {
      return null;
    }

    if (name.isEmpty) {
      return 'Name can\'t be empty';
    }
    return null;
  }

  static String? validateEmail({required String? email}) {
    if (email == null) {
      return null;
    }

    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter a correct email';
    }

    return null;
  }

  static String? validatePassword({required String? password}) {
    if (password == null) {
      return null;
    }

    if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Enter a password with length at least 6';
    }

    return null;
  }

  static String? validatePhoneNumber({required String? phoneNumber}) {
    if (phoneNumber == null) {
      return null;
    }

    // Remove any spaces or special characters from the phone number
    String cleanedPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d]+'), '');

    if (cleanedPhoneNumber.isEmpty) {
      return 'Phone number can\'t be empty';
    } else if (cleanedPhoneNumber.length < 10) {
      return 'Enter a valid phone number with at least 10 digits';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(cleanedPhoneNumber)) {
      return 'Phone number can only contain digits';
    }

    return null;
  }
}

