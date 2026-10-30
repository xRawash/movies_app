class Validations {
  static String?validateName(String? name){
    if(name == null || name.trim().isEmpty){
      return "Name is required";
    }
    if(name.length < 7){
      return "Sorry, name should be at least 6 chars";
    }
    if (!name.contains(" ")){
      return "Enter Your First & Last Names";
    }
    return null;
  }
  static String? validateEmail(String? email){
    RegExp emailExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (email == null || email.trim().isEmpty) {
      return "Email is required";
    } else if (!emailExp.hasMatch(email)) {
      return "Email Bad Format";
    }
    return null;
  }
  static String? validatePassword(String? password){
    RegExp passwordExp =  RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
    );
    if (password == null || password.trim().isEmpty) {
      return "Sorry, required password";
    } else if (password.length < 8) {
      return "Sorry, Password should be at least 8 chars";
    } else if (!passwordExp.hasMatch(password)) {
      return "Weak Password";
    }
    return null;
  }

  static String normalizePhone(String input) {
    const arabic = '٠١٢٣٤٥٦٧٨٩';
    const persian = '۰۱۲۳۴۵۶۷۸۹';
    final buffer = StringBuffer();
    for (final ch in input.trim().split('')) {
      final a = arabic.indexOf(ch);
      final p = persian.indexOf(ch);
      buffer.write(a != -1 ? a : (p != -1 ? p : ch));
    }
    return buffer.toString().replaceAll(RegExp(r'[\s\-().]'), '');
  }

  static String? validatePhone(String? input) {
    if (input == null || input.trim().isEmpty) {
      return 'Phone number is required';
    }
    final phone = normalizePhone(input);

    if (!RegExp(r'^\+?\d+$').hasMatch(phone)) {
      return 'Phone number can only contain digits';
    }

    final digits = phone.startsWith('+') ? phone.substring(1) : phone;

    if (digits.length < 8 || digits.length > 15) {
      return 'Enter a valid phone number';
    }

    if (phone.startsWith('+') && digits.startsWith('0')) {
      return 'Enter a valid phone number';
    }

    return null;
  }

  static String? validatePasswordConfirmation (String? password, String? confirmPassword){
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }
}