import 'package:flutter/material.dart';

import 'milo_character.dart';

class MiloAvatar extends StatelessWidget {
  const MiloAvatar({super.key, this.size = 72, this.showSparkles = true});

  final double size;
  final bool showSparkles;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: const Color(0xFFFF934F).withOpacity(.2), blurRadius: 12, offset: const Offset(0, 5)),
            ],
          ),
          child: MiloCharacter(size: size - 6),
        ),
        if (showSparkles)
          const Positioned(right: -2, top: -4, child: Text('✨', style: TextStyle(fontSize: 18))),
      ],
    );
  }
}
