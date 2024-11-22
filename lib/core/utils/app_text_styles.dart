import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static const TextStyle name = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textSecondry,
  );
  static const TextStyle secondryHeading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textSecondry,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static const TextStyle success = TextStyle(
    fontSize: 16,
    color: AppColors.success,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle successSecondry = TextStyle(
    fontSize: 16,
    color: AppColors.successSecondry,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle error = TextStyle(
    fontSize: 16,
    color: AppColors.error,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );
}
