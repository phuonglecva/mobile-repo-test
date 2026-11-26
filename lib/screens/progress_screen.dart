import 'package:flutter/material.dart';

import '../state/progress_store.dart';
import '../theme/app_colors.dart';
import '../widgets/section_title.dart';
import '../widgets/stat_pill.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

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
                const Text('Bé học thật giỏi! 📈',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: AppColors.ink)),
                const SizedBox(height: 5),
                const Text('Một chút tiến bộ mỗi ngày tạo nên điều kỳ diệu.',
                    style: TextStyle(fontSize: 12, color: AppColors.muted)),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(child: _MetricCard(emoji: '📚', value: '${store.lessonsCompleted}', label: 'Bài đã học', color: AppColors.paleBlue)),
                    const SizedBox(width: 10),
                    Expanded(child: _MetricCard(emoji: '💬', value: '${store.wordsLearned}', label: 'Từ đã học', color: AppColors.paleMint)),
                    const SizedBox(width: 10),
                    Expanded(child: _MetricCard(emoji: '🔥', value: '${store.streak}', label: 'Ngày học', color: AppColors.paleYellow)),
                  ],
                ),
                const SizedBox(height: 22),
                const SectionTitle(title: 'Tiến độ tuần này'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(child: Text('Mục tiêu 12 bài học', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.ink))),
                          Text('${(store.weeklyProgress * 100).round()}%',
                              style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.blue)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: store.weeklyProgress,
                          minHeight: 12,
                          color: AppColors.blue,
                          backgroundColor: AppColors.paleBlue,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const _WeeklyBars(),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const SectionTitle(title: 'Lời nhắn cho phụ huynh'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(color: AppColors.palePurple, borderRadius: BorderRadius.circular(22)),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('💜', style: TextStyle(fontSize: 28)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Hãy cùng bé ôn lại 5 phút mỗi ngày. Khen ngợi nỗ lực của con sẽ giúp bé tự tin và yêu thích tiếng Anh hơn.',
                          style: TextStyle(color: AppColors.ink, fontSize: 12, height: 1.5, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Center(child: StatPill(emoji: '⭐', value: '${store.stars} ngôi sao tích lũy', background: AppColors.paleYellow)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.emoji, required this.value, required this.label, required this.color});

  final String emoji;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(19)),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 23)),
          const SizedBox(height: 7),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.ink)),
          const SizedBox(height: 2),
          Text(label, textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 9, color: AppColors.muted, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _WeeklyBars extends StatelessWidget {
  const _WeeklyBars();

  @override
  Widget build(BuildContext context) {
    const values = [0.28, 0.56, 0.4, 0.78, 0.48, 0.92, 0.32];
    const labels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return SizedBox(
      height: 112,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (index) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: values[index],
                      child: Container(
                        width: 17,
                        decoration: BoxDecoration(
                          color: index == 5 ? AppColors.orange : AppColors.sky,
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Text(labels[index], style: const TextStyle(fontSize: 9, color: AppColors.muted, fontWeight: FontWeight.w800)),
              ],
            ),
          );
        }),
      ),
    );
  }
}
