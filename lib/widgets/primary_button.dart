import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = AppColors.blue,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 44 : 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 22),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(compact ? 15 : 18)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, size: 19),
            ],
          ],
        ),
      ),
    );
  }
}
