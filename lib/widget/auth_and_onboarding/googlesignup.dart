import 'package:fixmate/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Reusable Google Sign-In button that launches the device's native
/// Google Account Chooser dialog using google_sign_in 7.x+
class GoogleSignInButton extends StatefulWidget {
  /// Callback returning the selected Google account
  final Function(GoogleSignInAccount account)? onSuccess;

  /// Callback if sign-in fails
  final Function(Object error)? onError;

  /// Callback if user cancels/closes the picker
  final VoidCallback? onCanceled;

  /// Button label text (default: 'Continue with Google')
  final String text;

  /// Button height (default: 52)
  final double height;

  const GoogleSignInButton({
    super.key,
    this.onSuccess,
    this.onError,
    this.onCanceled,
    this.text = 'Continue with Google',
    this.height = 52,
  });

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initGoogleSignIn();
  }

  /// Initialize Google Sign-In instance
  Future<void> _initGoogleSignIn() async {
    try {
      await GoogleSignIn.instance.initialize();
    } catch (_) {
      // Initialization will be retried when the button is clicked
    }
  }

  // 1. Paste both IDs from google-services.json:
  String kAndroidClientId =
      '1092420138522-6c7estv3fvkbg7lbilnm7j6eiao6eqeo.apps.googleusercontent.com';
  String kWebServerClientId =
      '1092420138522-av8gl6bvfot0emaenocjnulmhbsvojcd.apps.googleusercontent.com';

  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      // 2. Initialize with serverClientId only (Android reads clientId automatically)
      await GoogleSignIn.instance.initialize(
        serverClientId: kWebServerClientId,
      );

      // 3. Clear session
      await GoogleSignIn.instance.signOut();

      // 4. Authenticate
      final GoogleSignInAccount? account = await GoogleSignIn.instance
          .authenticate();

      if (account != null) {
        print('Logged in: ${account.displayName} (${account.email})');
        widget.onSuccess?.call(account);
      } else {
        widget.onCanceled?.call();
      }
    } catch (e) {
      widget.onError?.call(e);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.height,
      child: OutlinedButton(
        onPressed: _isLoading ? null : _handleGoogleSignIn,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.surface,
          side: const BorderSide(color: AppColors.border, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google Logo from assets/icons/google.png
                  Image.asset(
                    'assets/icons/google.png',
                    width: 22,
                    height: 22,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.g_mobiledata_rounded,
                        color: AppColors.primary,
                        size: 26,
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.text,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
