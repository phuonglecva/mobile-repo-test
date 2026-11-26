import 'package:flutter/material.dart';

import '../data/lesson_data.dart';
import '../state/progress_store.dart';
import '../theme/app_colors.dart';
import '../widgets/milo_avatar.dart';
import 'lesson_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: ProgressStore.instance,
        builder: (context, _) {
          final store = ProgressStore.instance;
          final nextTopic = store.nextTopic;
          final suggestedTopic = nextTopic ?? store.reviewTopic;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const MiloAvatar(size: 54),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Chào ${store.childName}! 👋',
                              style: const TextStyle(color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.w900)),
                          Text('Nhà thám hiểm lớp ${store.grade}',
                              style: const TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    _StreakChip(streak: store.streak),
                  ],
                ),
                const SizedBox(height: 20),
                _ContinueCard(
                  topic: suggestedTopic,
                  allDone: nextTopic == null,
                  onTap: suggestedTopic == null
                      ? null
                      : () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => LessonScreen(topic: suggestedTopic),
                          )),
                ),
                const SizedBox(height: 14),
                _DailyGoalCard(
                  completed: store.dailyLessons,
                  xp: store.xp,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(
                      child: Text('Đường phiêu lưu',
                          style: TextStyle(color: AppColors.ink, fontSize: 20, fontWeight: FontWeight.w900)),
                    ),
                    Text('${store.completedTopicCount}/${lessonTopics.length} chặng',
                        style: const TextStyle(color: AppColors.blue, fontSize: 11, fontWeight: FontWeight.w900)),
                  ],
                ),
                const SizedBox(height: 5),
                const Text('Mỗi bước nhỏ đưa bé đến gần hơn với tiếng Anh!',
                    style: TextStyle(color: AppColors.muted, fontSize: 12)),
                const SizedBox(height: 16),
                _AdventurePath(
                  completedIds: store.completedTopicIds,
                  nextTopicId: nextTopic?.id,
                  onTopicTap: (topic) => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => LessonScreen(topic: topic),
                  )),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.palePurple,
                    borderRadius: BorderRadius.circular(21),
                  ),
                  child: const Row(
                    children: [
                      Text('💡', style: TextStyle(fontSize: 27)),
                      SizedBox(width: 11),
                      Expanded(
                        child: Text(
                          'Mẹo của Milo: Đọc từ mới thành tiếng sẽ giúp bé nhớ lâu hơn đó!',
                          style: TextStyle(color: AppColors.ink, fontSize: 12, height: 1.4, fontWeight: FontWeight.w700),
                        ),
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

class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(color: AppColors.paleYellow, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 5),
          Text('$streak', style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({required this.topic, required this.allDone, required this.onTap});

  final LessonTopic? topic;
  final bool allDone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(17, 18, 14, 17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF55C7F7), Color(0xFF3485F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(color: AppColors.blue.withOpacity(.2), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(.2), borderRadius: BorderRadius.circular(30)),
                  child: const Text('✨ CUỘC PHIÊU LƯU ĐANG CHỜ',
                      style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: .5)),
                ),
                const SizedBox(height: 12),
                Text(
                  allDone ? 'Bé đã chinh phục\nmọi thế giới!' : 'Sẵn sàng khám phá\nthế giới ${topic?.title ?? ''}?',
                  style: const TextStyle(color: Colors.white, fontSize: 21, height: 1.12, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 7),
                Text(
                  allDone ? 'Milo tự hào về bé lắm!' : 'Một bài học ngắn đang đợi bé đó.',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 13),
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: AppColors.ink,
                    minimumSize: const Size(148, 43),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(allDone ? 'Ôn tập nào' : 'Học tiếp'),
                      const SizedBox(width: 7),
                      const Icon(Icons.arrow_forward_rounded, size: 17),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          const MiloAvatar(size: 98, showSparkles: true),
        ],
      ),
    );
  }
}

class _DailyGoalCard extends StatelessWidget {
  const _DailyGoalCard({required this.completed, required this.xp});

  final int completed;
  final int xp;

  @override
  Widget build(BuildContext context) {
    final done = completed > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: AppColors.paleYellow, borderRadius: BorderRadius.circular(14)),
            alignment: Alignment.center,
            child: Text(done ? '🏅' : '🎯', style: const TextStyle(fontSize: 23)),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(done ? 'Nhiệm vụ hôm nay hoàn thành!' : 'Mục tiêu nhỏ hôm nay',
                    style: const TextStyle(color: AppColors.ink, fontSize: 12, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(done ? 'Bé đã có thêm XP. Tuyệt lắm!' : 'Chỉ cần hoàn thành 1 bài học ngắn.',
                    style: const TextStyle(color: AppColors.muted, fontSize: 10, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: done ? 1 : 0,
                    minHeight: 6,
                    backgroundColor: AppColors.paleYellow,
                    color: AppColors.orange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              const Text('⚡', style: TextStyle(fontSize: 15)),
              Text('$xp XP', style: const TextStyle(color: AppColors.orange, fontSize: 10, fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdventurePath extends StatelessWidget {
  const _AdventurePath({
    required this.completedIds,
    required this.nextTopicId,
    required this.onTopicTap,
  });

  final Set<String> completedIds;
  final String? nextTopicId;
  final ValueChanged<LessonTopic> onTopicTap;

  static const _xPattern = [0.50, 0.72, 0.50, 0.28, 0.50, 0.72];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final centers = List.generate(
          lessonTopics.length,
          (index) => Offset(
            width * _xPattern[index % _xPattern.length],
            54 + index * 116,
          ),
        );
        final height = 112.0 + (lessonTopics.length - 1) * 116.0;
        final labelWidth = width * .34;

        return SizedBox(
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _AdventureNodePainter(
                    centers: centers,
                    topics: lessonTopics,
                    completedIds: completedIds,
                  ),
                ),
              ),
              for (var index = 0; index < lessonTopics.length; index++)
                Builder(
                  builder: (context) {
                    final topic = lessonTopics[index];
                    final completed = completedIds.contains(topic.id);
                    final unlocked = completed ||
                        index == 0 ||
                        completedIds.contains(lessonTopics[index - 1].id);
                    final current = topic.id == nextTopicId;
                    final center = centers[index];
                    final nodeSize = current ? 78.0 : 66.0;
                    final labelOnRight = center.dx < width * .5 ||
                        (center.dx == width * .5 && index.isOdd);
                    final labelLeft = labelOnRight
                        ? center.dx + nodeSize / 2 + 6
                        : center.dx - nodeSize / 2 - 6 - labelWidth;

                    return Stack(
                      children: [
                        Positioned(
                          left: center.dx - nodeSize / 2,
                          top: center.dy - nodeSize / 2,
                          child: _AdventureNode(
                            topic: topic,
                            completed: completed,
                            unlocked: unlocked,
                            current: current,
                            onTap: unlocked ? () => onTopicTap(topic) : null,
                          ),
                        ),
                        Positioned(
                          left: labelLeft.clamp(0.0, width - labelWidth).toDouble(),
                          top: center.dy - 31,
                          width: labelWidth,
                          child: _AdventureNodeLabel(
                            topic: topic,
                            completed: completed,
                            unlocked: unlocked,
                            current: current,
                            alignRight: labelOnRight,
                          ),
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _AdventureNodePainter extends CustomPainter {
  const _AdventureNodePainter({
    required this.centers,
    required this.topics,
    required this.completedIds,
  });

  final List<Offset> centers;
  final List<LessonTopic> topics;
  final Set<String> completedIds;

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = const Color(0xFFDCE8F1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final completedPaint = Paint()
      ..color = AppColors.mint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()..color = Colors.white;

    for (var index = 0; index < centers.length - 1; index++) {
      final start = centers[index];
      final end = centers[index + 1];
      final middleY = (start.dy + end.dy) / 2;
      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..cubicTo(start.dx, middleY, end.dx, middleY, end.dx, end.dy);

      canvas.drawPath(path, basePaint);
      if (completedIds.contains(topics[index].id)) {
        canvas.drawPath(path, completedPaint);
      }

      for (final metric in path.computeMetrics()) {
        for (var distance = 18.0; distance < metric.length; distance += 28) {
          final tangent = metric.getTangentForOffset(distance);
          if (tangent != null) canvas.drawCircle(tangent.position, 2.2, dotPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _AdventureNodePainter oldDelegate) => true;
}

class _AdventureNode extends StatelessWidget {
  const _AdventureNode({
    required this.topic,
    required this.completed,
    required this.unlocked,
    required this.current,
    required this.onTap,
  });

  final LessonTopic topic;
  final bool completed;
  final bool unlocked;
  final bool current;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final size = current ? 78.0 : 66.0;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutBack,
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: completed
                ? AppColors.mint
                : unlocked
                    ? topic.color
                    : const Color(0xFFE6EAF0),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: current ? 5 : 4),
            boxShadow: [
              BoxShadow(
                color: (current ? topic.color : AppColors.ink)
                    .withOpacity(current ? .25 : .08),
                blurRadius: current ? 18 : 9,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: completed
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 31)
              : unlocked
                  ? Text(topic.emoji, style: TextStyle(fontSize: current ? 31 : 26))
                  : const Icon(Icons.lock_rounded, color: Color(0xFF9BA6B5), size: 24),
        ),
      ),
    );
  }
}

class _AdventureNodeLabel extends StatelessWidget {
  const _AdventureNodeLabel({
    required this.topic,
    required this.completed,
    required this.unlocked,
    required this.current,
    required this.alignRight,
  });

  final LessonTopic topic;
  final bool completed;
  final bool unlocked;
  final bool current;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          topic.title,
          textAlign: alignRight ? TextAlign.left : TextAlign.right,
          style: TextStyle(
            color: unlocked ? AppColors.ink : AppColors.muted,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          completed
              ? 'ĐÃ HOÀN THÀNH'
              : current
                  ? 'BÀI TIẾP THEO'
                  : unlocked
                      ? topic.subtitle
                      : 'Mở khóa sau',
          textAlign: alignRight ? TextAlign.left : TextAlign.right,
          style: TextStyle(
            color: completed
                ? const Color(0xFF22A879)
                : current
                    ? topic.color
                    : AppColors.muted,
            fontSize: 8,
            letterSpacing: .4,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (current) ...[
          const SizedBox(height: 7),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: topic.softColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'CHƠI NGAY  ›',
              style: TextStyle(color: topic.color, fontSize: 8, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ],
    );
  }
}

