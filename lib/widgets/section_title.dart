import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: const TextStyle(color: AppColors.ink, fontSize: 19, fontWeight: FontWeight.w900)),
        ),
        if (action != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(foregroundColor: AppColors.blue, visualDensity: VisualDensity.compact),
            child: Text(action!, style: const TextStyle(fontWeight: FontWeight.w800)),
          ),
      ],
    );
  }
}
