import 'package:flutter/material.dart';

import '../data/lesson_data.dart';
import '../state/progress_store.dart';
import '../theme/app_colors.dart';
import '../widgets/milo_character.dart';
import '../widgets/primary_button.dart';
import 'lesson_screen.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: ProgressStore.instance,
        builder: (context, _) {
          final store = ProgressStore.instance;
          final suggested = store.reviewTopic ?? store.nextTopic;
          final learned = lessonTopics.where((topic) => store.isTopicCompleted(topic.id)).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Góc luyện tập 🎯',
                    style: TextStyle(color: AppColors.ink, fontSize: 25, fontWeight: FontWeight.w900)),
                const SizedBox(height: 5),
                const Text('Ôn lại một chút để nhớ thật lâu nhé!',
                    style: TextStyle(color: AppColors.muted, fontSize: 12)),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(19),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFFFD96A), Color(0xFFFFB56D)]),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('THỬ THÁCH NHỎ', style: TextStyle(color: AppColors.ink, fontSize: 9, letterSpacing: 1, fontWeight: FontWeight.w900)),
                            SizedBox(height: 8),
                            Text('3 phút ôn từ\ncùng Milo!',
                                style: TextStyle(color: AppColors.ink, fontSize: 23, height: 1.12, fontWeight: FontWeight.w900)),
                            SizedBox(height: 7),
                            Text('Nghe, nhìn và chọn thật nhanh.',
                                style: TextStyle(color: AppColors.ink, fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const MiloCharacter(size: 102, expression: MiloExpression.excited),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    label: suggested == null ? 'Ôn tập lại nào' : 'Bắt đầu luyện tập',
                    onPressed: suggested == null
                        ? null
                        : () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => LessonScreen(topic: suggested),
                            )),
                    icon: Icons.play_arrow_rounded,
                    color: AppColors.orange,
                  ),
                ),
                const SizedBox(height: 26),
                Row(
                  children: [
                    const Expanded(child: Text('Chủ đề bé đã mở khóa',
                        style: TextStyle(color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.w900))),
                    Text('${learned.length} chủ đề',
                        style: const TextStyle(color: AppColors.blue, fontSize: 10, fontWeight: FontWeight.w900)),
                  ],
                ),
                const SizedBox(height: 11),
                if (learned.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
                    child: const Column(
                      children: [
                        Text('🌱', style: TextStyle(fontSize: 38)),
                        SizedBox(height: 8),
                        Text('Khu vườn từ vựng đang chờ bé!',
                            style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900)),
                        SizedBox(height: 5),
                        Text('Hoàn thành bài đầu tiên để mở khóa góc ôn tập nhé.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.muted, fontSize: 11, height: 1.4)),
                      ],
                    ),
                  )
                else
                  ...learned.map((topic) => Padding(
                        padding: const EdgeInsets.only(bottom: 9),
                        child: _ReviewRow(
                          topic: topic,
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => LessonScreen(topic: topic),
                          )),
                        ),
                      )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.topic, required this.onTap});

  final LessonTopic topic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: topic.softColor, borderRadius: BorderRadius.circular(15)),
                alignment: Alignment.center,
                child: Text(topic.emoji, style: const TextStyle(fontSize: 26)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(topic.title, style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 3),
                    Text('${topic.words.length} từ vựng • Đã hoàn thành',
                        style: const TextStyle(color: AppColors.muted, fontSize: 10)),
                  ],
                ),
              ),
              const Icon(Icons.replay_rounded, color: AppColors.blue),
            ],
          ),
        ),
      ),
    );
  }
}
