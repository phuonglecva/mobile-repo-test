import 'package:flutter/material.dart';

import '../data/lesson_data.dart';
import '../state/progress_store.dart';
import '../theme/app_colors.dart';
import '../widgets/milo_avatar.dart';
import '../widgets/section_title.dart';
import '../widgets/stat_pill.dart';
import '../widgets/topic_card.dart';
import 'lesson_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = ProgressStore.instance;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const MiloAvatar(size: 56),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Xin chào, Minh Anh! 👋',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.ink)),
                      SizedBox(height: 3),
                      Text('Hôm nay mình học gì nhỉ?',
                          style: TextStyle(fontSize: 12, color: AppColors.muted, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                AnimatedBuilder(
                  animation: progress,
                  builder: (context, _) => StatPill(
                    emoji: '🔥',
                    value: '${progress.streak}',
                    background: AppColors.paleYellow,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            _WelcomeCard(onContinue: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => LessonScreen(topic: lessonTopics[3]),
              ));
            }),
            const SizedBox(height: 20),
            const _DailyMissionCard(),
            const SizedBox(height: 23),
            SectionTitle(title: 'Khám phá chủ đề', action: 'Xem tất cả', onAction: () {}),
            const SizedBox(height: 12),
            GridView.builder(
              itemCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.25,
              ),
              itemBuilder: (context, index) {
                final topic = lessonTopics[index + 2];
                return TopicCard(
                  topic: topic,
                  compact: true,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => LessonScreen(topic: topic),
                  )),
                );
              },
            ),
            const SizedBox(height: 20),
            const _MiloTipCard(),
          ],
        ),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.sky, AppColors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: AppColors.blue.withOpacity(.22), blurRadius: 18, offset: const Offset(0, 9)),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(right: 0, top: 0, child: Text('☁️', style: TextStyle(fontSize: 34))),
          const Positioned(right: 9, bottom: 22, child: Text('⭐', style: TextStyle(fontSize: 20))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(color: Colors.white.withOpacity(.22), borderRadius: BorderRadius.circular(30)),
                child: const Text('🚀  HÀNH TRÌNH CỦA BÉ',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: .6)),
              ),
              const SizedBox(height: 13),
              const Text('Sẵn sàng\nphiêu lưu chưa?',
                  style: TextStyle(color: Colors.white, fontSize: 27, height: 1.08, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              const Text('Học một chút mỗi ngày,\ngiỏi tiếng Anh lúc nào không hay!',
                  style: TextStyle(color: Colors.white, fontSize: 12, height: 1.4, fontWeight: FontWeight.w600)),
              const SizedBox(height: 17),
              SizedBox(
                width: 170,
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: AppColors.ink,
                    minimumSize: const Size(0, 47),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Học tiếp nào'),
                      SizedBox(width: 7),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Positioned(right: 3, bottom: 6, child: Text('🦊', style: TextStyle(fontSize: 76))),
        ],
      ),
    );
  }
}

class _DailyMissionCard extends StatelessWidget {
  const _DailyMissionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: const Color(0xFFFFE9A6)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: AppColors.paleYellow, borderRadius: BorderRadius.circular(17)),
            alignment: Alignment.center,
            child: const Text('🎯', style: TextStyle(fontSize: 27)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nhiệm vụ hôm nay', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.ink)),
                SizedBox(height: 4),
                Text('Hoàn thành 1 bài học để nhận quà nhé!',
                    style: TextStyle(fontSize: 11, color: AppColors.muted)),
                SizedBox(height: 9),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: LinearProgressIndicator(
                    value: .35,
                    minHeight: 7,
                    backgroundColor: AppColors.paleYellow,
                    color: AppColors.orange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Text('+10\n🪙', textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.w900, fontSize: 12)),
        ],
      ),
    );
  }
}

class _MiloTipCard extends StatelessWidget {
  const _MiloTipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: AppColors.palePurple, borderRadius: BorderRadius.circular(22)),
      child: const Row(
        children: [
          Text('💡', style: TextStyle(fontSize: 30)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Mẹo của Milo: Hãy đọc to từ mới 3 lần để ghi nhớ lâu hơn nhé!',
              style: TextStyle(color: AppColors.ink, fontSize: 12, height: 1.4, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
