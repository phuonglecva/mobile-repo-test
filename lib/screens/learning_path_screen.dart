import 'package:flutter/material.dart';

import '../data/lesson_data.dart';
import '../state/progress_store.dart';
import '../theme/app_colors.dart';
import '../widgets/section_title.dart';
import '../widgets/stat_pill.dart';
import '../widgets/topic_card.dart';
import 'lesson_screen.dart';

class LearningPathScreen extends StatelessWidget {
  const LearningPathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Thế giới của Milo 🌈',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: AppColors.ink)),
            const SizedBox(height: 5),
            const Text('Chọn một hòn đảo và bắt đầu khám phá nhé!',
                style: TextStyle(fontSize: 12, color: AppColors.muted)),
            const SizedBox(height: 17),
            AnimatedBuilder(
              animation: ProgressStore.instance,
              builder: (context, _) {
                final store = ProgressStore.instance;
                return Container(
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.paleBlue, Color(0xFFDDF5FF)]),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      const Text('🗺️', style: TextStyle(fontSize: 35)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Bản đồ phiêu lưu', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.ink)),
                            const SizedBox(height: 7),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: store.weeklyProgress,
                                minHeight: 8,
                                color: AppColors.blue,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text('${store.lessonsCompleted} bài đã hoàn thành',
                                style: const TextStyle(fontSize: 10, color: AppColors.muted, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      StatPill(emoji: '⭐', value: '${store.stars}', background: Colors.white),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 22),
            const SectionTitle(title: 'Chọn chủ đề học'),
            const SizedBox(height: 12),
            GridView.builder(
              itemCount: lessonTopics.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.18,
              ),
              itemBuilder: (context, index) {
                final topic = lessonTopics[index];
                return TopicCard(
                  topic: topic,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => LessonScreen(topic: topic),
                  )),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
