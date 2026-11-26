import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class MiloAvatar extends StatelessWidget {
  const MiloAvatar({super.key, this.size = 72, this.showSparkles = true});

  final double size;
  final bool showSparkles;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 12,
      height: size + 12,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFD98A), AppColors.orange],
              ),
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: AppColors.orange.withOpacity(.22),
                  blurRadius: 14,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text('🦊', style: TextStyle(fontSize: size * .58)),
          ),
          if (showSparkles)
            const Positioned(right: -1, top: -2, child: Text('✨', style: TextStyle(fontSize: 19))),
        ],
      ),
    );
  }
}
