import 'package:fixmate/theme/colors.dart';
import 'package:flutter/material.dart';

class Submilbutton extends StatelessWidget {
  final double? height;
  final double? buttonTextsize;
  final VoidCallback? handleSubmit;
  final String buttonText;
  const Submilbutton({
    super.key,
    this.height,
    this.handleSubmit,
    required this.buttonText,
    this.buttonTextsize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 52,
      child: ElevatedButton(
        onPressed: handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: AppColors.primary.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: buttonTextsize ?? 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
