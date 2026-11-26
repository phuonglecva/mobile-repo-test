import 'package:flutter/material.dart';

import '../state/progress_store.dart';
import '../theme/app_colors.dart';
import '../widgets/milo_character.dart';
import '../widgets/section_title.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _avatars = ['🦊', '🐼', '🐰', '🐱'];

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
                const Text('Ngôi nhà của bé 🏡',
                    style: TextStyle(color: AppColors.ink, fontSize: 25, fontWeight: FontWeight.w900)),
                const SizedBox(height: 5),
                const Text('Nhìn lại những điều tuyệt vời bé đã học.',
                    style: TextStyle(color: AppColors.muted, fontSize: 12)),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(19),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.paleBlue, Color(0xFFDDF5FF)]),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 74,
                        height: 74,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                        alignment: Alignment.center,
                        child: Text(_avatars[store.avatarIndex], style: const TextStyle(fontSize: 44)),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(store.childName,
                                style: const TextStyle(color: AppColors.ink, fontSize: 20, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 4),
                            Text('Nhà thám hiểm lớp ${store.grade}',
                                style: const TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 7),
                            Text('${store.xp} XP tích lũy',
                                style: const TextStyle(color: AppColors.blue, fontSize: 11, fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Chỉnh sửa hồ sơ',
                        onPressed: () => _showEditDialog(context, store),
                        icon: const Icon(Icons.edit_rounded, color: AppColors.blue),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _MetricCard(emoji: '📚', value: '${store.lessonsCompleted}', label: 'Bài hoàn thành', color: AppColors.paleBlue)),
                    const SizedBox(width: 9),
                    Expanded(child: _MetricCard(emoji: '💬', value: '${store.wordsLearned}', label: 'Từ đã học', color: AppColors.paleMint)),
                    const SizedBox(width: 9),
                    Expanded(child: _MetricCard(emoji: '🔥', value: '${store.streak}', label: 'Ngày liên tiếp', color: AppColors.paleYellow)),
                  ],
                ),
                const SizedBox(height: 23),
                const SectionTitle(title: 'Tiến bộ tuần này'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(child: Text('Mục tiêu 7 bài học',
                              style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900))),
                          Text('${store.weeklyLessons}/7',
                              style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.w900)),
                        ],
                      ),
                      const SizedBox(height: 11),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: LinearProgressIndicator(
                          value: store.weeklyProgress,
                          minHeight: 11,
                          color: AppColors.blue,
                          backgroundColor: AppColors.paleBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        store.weeklyLessons == 0
                            ? 'Mỗi bài học nhỏ đều là một bước tiến!'
                            : 'Tuyệt lắm! Bé đã học ${store.weeklyLessons} bài trong tuần này.',
                        style: const TextStyle(color: AppColors.muted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 23),
                const SectionTitle(title: 'Huy hiệu của bé'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _BadgeTile(emoji: '🌟', title: 'Khởi đầu', unlocked: store.lessonsCompleted >= 1)),
                    const SizedBox(width: 9),
                    Expanded(child: _BadgeTile(emoji: '🔥', title: 'Chăm chỉ', unlocked: store.streak >= 3)),
                    const SizedBox(width: 9),
                    Expanded(child: _BadgeTile(emoji: '🗺️', title: 'Thám hiểm', unlocked: store.completedTopicCount >= 6)),
                  ],
                ),
                const SizedBox(height: 19),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.palePurple, borderRadius: BorderRadius.circular(21)),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MiloCharacter(size: 48, expression: MiloExpression.thinking),
                      SizedBox(width: 11),
                      Expanded(
                        child: Text(
                          'Gợi ý cho ba mẹ: Cùng bé ôn lại 5 phút mỗi ngày. Khen ngợi sự cố gắng để bé luôn tự tin nhé!',
                          style: TextStyle(color: AppColors.ink, fontSize: 11, height: 1.5, fontWeight: FontWeight.w700),
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

  Future<void> _showEditDialog(BuildContext context, ProgressStore store) async {
    final controller = TextEditingController(text: store.childName);
    var grade = store.grade;
    var avatar = store.avatarIndex;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: const Text('Sửa hồ sơ bé', style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Tên của bé',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 15),
              const Align(alignment: Alignment.centerLeft, child: Text('Lớp', style: TextStyle(fontWeight: FontWeight.w800))),
              const SizedBox(height: 8),
              Wrap(
                spacing: 7,
                children: List.generate(5, (index) {
                  final value = index + 1;
                  return ChoiceChip(
                    label: Text('$value'),
                    selected: grade == value,
                    onSelected: (_) => setDialogState(() => grade = value),
                  );
                }),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: List.generate(_avatars.length, (index) => InkWell(
                  onTap: () => setDialogState(() => avatar = index),
                  child: CircleAvatar(
                    radius: 23,
                    backgroundColor: avatar == index ? AppColors.paleYellow : AppColors.canvas,
                    child: Text(_avatars[index], style: const TextStyle(fontSize: 24)),
                  ),
                )),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Để sau')),
            ElevatedButton(
              onPressed: () async {
                await store.updateProfile(name: controller.text, grade: grade, avatarIndex: avatar);
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
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
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(19)),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 23)),
          const SizedBox(height: 7),
          Text(value, style: const TextStyle(color: AppColors.ink, fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(label, textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, fontSize: 9, fontWeight: FontWeight.w700)),
        ],
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
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
      decoration: BoxDecoration(
        color: unlocked ? AppColors.paleYellow : const Color(0xFFF0F1F4),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Column(
        children: [
          Text(unlocked ? emoji : '🔒', style: const TextStyle(fontSize: 29)),
          const SizedBox(height: 6),
          Text(title, style: TextStyle(color: unlocked ? AppColors.ink : AppColors.muted, fontSize: 9, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
