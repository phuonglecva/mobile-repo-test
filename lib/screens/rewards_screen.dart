import 'package:flutter/material.dart';

import '../state/progress_store.dart';
import '../theme/app_colors.dart';
import '../widgets/section_title.dart';
import '../widgets/stat_pill.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: ProgressStore.instance,
        builder: (context, _) {
          final store = ProgressStore.instance;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Kho báu của bé 🎁',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: AppColors.ink)),
                const SizedBox(height: 5),
                const Text('Mỗi bài học là một món quà nhỏ!',
                    style: TextStyle(fontSize: 12, color: AppColors.muted)),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.yellow, AppColors.orange]),
                    borderRadius: BorderRadius.circular(27),
                  ),
                  child: Column(
                    children: [
                      const Text('🦊🎁', style: TextStyle(fontSize: 66)),
                      const Text('Bộ sưu tập của Milo',
                          style: TextStyle(color: AppColors.ink, fontSize: 20, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StatPill(emoji: '⭐', value: '${store.stars}', background: Colors.white.withOpacity(.85)),
                          const SizedBox(width: 10),
                          StatPill(emoji: '🪙', value: '${store.coins}', background: Colors.white.withOpacity(.85)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 23),
                const SectionTitle(title: 'Huy hiệu đáng yêu'),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: .88,
                  children: const [
                    _BadgeTile(emoji: '🌟', title: 'Ngôi sao mới', unlocked: true),
                    _BadgeTile(emoji: '🔥', title: 'Chăm chỉ', unlocked: true),
                    _BadgeTile(emoji: '🐾', title: 'Bạn của Milo', unlocked: true),
                    _BadgeTile(emoji: '🎧', title: 'Tai thính', unlocked: false),
                    _BadgeTile(emoji: '📚', title: 'Mê đọc sách', unlocked: false),
                    _BadgeTile(emoji: '🏆', title: 'Siêu sao', unlocked: false),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.paleMint, borderRadius: BorderRadius.circular(22)),
                  child: const Row(
                    children: [
                      Text('✨', style: TextStyle(fontSize: 30)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text('Học thêm một bài để nhận 3 ngôi sao và 10 xu nhé!',
                            style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w800, fontSize: 12, height: 1.4)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.emoji, required this.title, required this.unlocked});

  final String emoji;
  final String title;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: unlocked ? AppColors.paleYellow : const Color(0xFFF0F1F4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(unlocked ? emoji : '🔒', style: TextStyle(fontSize: unlocked ? 36 : 27)),
          const SizedBox(height: 9),
          Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: unlocked ? AppColors.ink : AppColors.muted)),
          if (unlocked)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text('Đã mở khóa', style: TextStyle(fontSize: 8, color: AppColors.orange, fontWeight: FontWeight.w800)),
            ),
        ],
      ),
    );
  }
}
