String? emailValidator(String email) {
  // Regular expression for validating an email address
  final emailRegExp = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

  if (email.isEmpty) {
    return 'Email address is required.';
  } else if (!emailRegExp.hasMatch(email)) {
    return 'Invalid email address.';
  }
  return null; // Email is valid
}
