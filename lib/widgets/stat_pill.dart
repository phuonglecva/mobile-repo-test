import 'package:flutter/material.dart';

class StatPill extends StatelessWidget {
  const StatPill({super.key, required this.emoji, required this.value, required this.background});

  final String emoji;
  final String value;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(18)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(value, style: const TextStyle(color: Color(0xFF253858), fontWeight: FontWeight.w900, fontSize: 13)),
        ],
      ),
    );
  }
}
