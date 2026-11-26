import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class MiloBottomNav extends StatelessWidget {
  const MiloBottomNav({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    (Icons.route_rounded, 'Hành trình'),
    (Icons.bolt_rounded, 'Ôn tập'),
    (Icons.face_rounded, 'Hồ sơ'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: AppColors.ink.withOpacity(.07), blurRadius: 22, offset: const Offset(0, -5)),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 7),
          child: Row(
            children: List.generate(_items.length, (index) {
              final selected = currentIndex == index;
              final item = _items[index];
              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.paleBlue : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedScale(
                          scale: selected ? 1.12 : 1,
                          duration: const Duration(milliseconds: 180),
                          child: Icon(item.$1, color: selected ? AppColors.blue : AppColors.muted, size: 23),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.$2,
                          style: TextStyle(
                            color: selected ? AppColors.blue : AppColors.muted,
                            fontSize: 11,
                            fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
