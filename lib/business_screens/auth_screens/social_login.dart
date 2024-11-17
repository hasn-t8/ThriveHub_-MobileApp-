import 'package:flutter/material.dart';
import '../../core/constants/text_styles.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback onGoogleLogin;
  final VoidCallback onFacebookLogin;

  const SocialLoginButtons({
    Key? key,
    required this.onGoogleLogin,
    required this.onFacebookLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Google Login Button
        OutlinedButton.icon(
          onPressed: onGoogleLogin,
          icon: const Icon(Icons.g_translate),
          label: const Text(
            'Continue with Google',
            style: TextStyle(color: kTextColor),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: kDividerColor, width: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(double.infinity, kButtonHeight),
          ),
        ),
        const SizedBox(height: 10),
        // Facebook Login Button
        OutlinedButton.icon(
          onPressed: onFacebookLogin,
          icon: const Icon(Icons.facebook),
          label: const Text(
            'Continue with Facebook',
            style: TextStyle(color: kTextColor),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: kDividerColor, width: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(double.infinity, kButtonHeight),
          ),
        ),
      ],
    );
  }
}
