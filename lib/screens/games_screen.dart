import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../data/lesson_data.dart';
import '../state/progress_store.dart';
import '../theme/app_colors.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_title.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  final FlutterTts _tts = FlutterTts();
  int _round = 0;
  int _score = 0;
  int? _selected;
  bool _finished = false;

  final List<VocabularyWord> _questions = const [
    VocabularyWord(word: 'Cat', meaning: 'Con mèo', emoji: '🐱', example: 'It is a cat.'),
    VocabularyWord(word: 'Dog', meaning: 'Con chó', emoji: '🐶', example: 'It is a dog.'),
    VocabularyWord(word: 'Bird', meaning: 'Con chim', emoji: '🐦', example: 'It is a bird.'),
  ];

  VocabularyWord get _current => _questions[_round];

  List<VocabularyWord> get _options {
    if (_round == 0) return [_questions[1], _questions[0], _questions[2]];
    if (_round == 1) return [_questions[1], _questions[2], _questions[0]];
    return [_questions[0], _questions[2], _questions[1]];
  }

  Future<void> _listen() async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(.4);
      await _tts.speak(_current.word);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thiết bị chưa có giọng đọc tiếng Anh.')),
        );
      }
    }
  }

  void _choose(int index) {
    if (_selected != null || _finished) return;
    setState(() {
      _selected = index;
      if (_options[index].word == _current.word) _score += 1;
    });
  }

  Future<void> _next() async {
    if (_round == _questions.length - 1) {
      setState(() => _finished = true);
      await ProgressStore.instance.completeGame();
      return;
    }
    setState(() {
      _round += 1;
      _selected = null;
    });
  }

  void _restart() {
    setState(() {
      _round = 0;
      _score = 0;
      _selected = null;
      _finished = false;
    });
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Giờ chơi đến rồi! 🎮',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: AppColors.ink)),
            const SizedBox(height: 5),
            const Text('Chơi vui, nhớ từ mới thật lâu!',
                style: TextStyle(fontSize: 12, color: AppColors.muted)),
            const SizedBox(height: 18),
            const _GameBanner(),
            const SizedBox(height: 18),
            if (_finished)
              _GameResult(score: _score, onRestart: _restart)
            else
              _QuestionCard(
                round: _round,
                score: _score,
                word: _current,
                options: _options,
                selected: _selected,
                onChoose: _choose,
                onListen: _listen,
                onNext: _selected == null ? null : _next,
              ),
            const SizedBox(height: 22),
            const SectionTitle(title: 'Sắp ra mắt'),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(child: _ComingSoonCard(emoji: '🧩', title: 'Ghép chữ', subtitle: 'Xếp chữ thành từ')),
                SizedBox(width: 12),
                Expanded(child: _ComingSoonCard(emoji: '🃏', title: 'Thẻ từ vựng', subtitle: 'Lật thẻ ghi nhớ')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GameBanner extends StatelessWidget {
  const _GameBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.lavender, Color(0xFF8D7AF5)]),
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('THỬ THÁCH\nĐÔI TAI TINH!',
                    style: TextStyle(color: Colors.white, fontSize: 21, height: 1.1, fontWeight: FontWeight.w900)),
                SizedBox(height: 7),
                Text('Nghe từ tiếng Anh và chọn hình đúng nhé.',
                    style: TextStyle(color: Colors.white, fontSize: 11, height: 1.4)),
              ],
            ),
          ),
          Text('🦊🎧', style: TextStyle(fontSize: 52)),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.round,
    required this.score,
    required this.word,
    required this.options,
    required this.selected,
    required this.onChoose,
    required this.onListen,
    required this.onNext,
  });

  final int round;
  final int score;
  final VocabularyWord word;
  final List<VocabularyWord> options;
  final int? selected;
  final ValueChanged<int> onChoose;
  final VoidCallback onListen;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          Row(
            children: [
              Text('Câu ${round + 1}/3', style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.ink)),
              const Spacer(),
              Text('⭐ $score', style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.orange)),
            ],
          ),
          const SizedBox(height: 13),
          const Text('Nghe và chọn hình đúng',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.ink)),
          const SizedBox(height: 14),
          InkWell(
            onTap: onListen,
            borderRadius: BorderRadius.circular(22),
            child: Container(
              width: 78,
              height: 78,
              decoration: const BoxDecoration(color: AppColors.paleBlue, shape: BoxShape.circle),
              child: const Icon(Icons.volume_up_rounded, color: AppColors.blue, size: 38),
            ),
          ),
          const SizedBox(height: 6),
          const Text('Chạm để nghe lại', style: TextStyle(color: AppColors.muted, fontSize: 10)),
          const SizedBox(height: 18),
          Row(
            children: List.generate(options.length, (index) {
              final isSelected = selected == index;
              final isCorrect = options[index].word == word.word;
              Color background = AppColors.canvas;
              Color border = Colors.transparent;
              if (selected != null && isCorrect) {
                background = AppColors.paleMint;
                border = AppColors.mint;
              } else if (isSelected && !isCorrect) {
                background = AppColors.palePink;
                border = AppColors.coral;
              }
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index == 2 ? 0 : 8),
                  child: InkWell(
                    onTap: () => onChoose(index),
                    borderRadius: BorderRadius.circular(19),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      height: 112,
                      decoration: BoxDecoration(
                        color: background,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: border, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(options[index].emoji, style: const TextStyle(fontSize: 38)),
                          const SizedBox(height: 6),
                          Text(options[index].meaning,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.ink)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          if (selected != null) ...[
            const SizedBox(height: 13),
            Text(
              options[selected!].word == word.word
                  ? 'Chính xác! Bé giỏi quá! 🎉'
                  : 'Gần đúng rồi, đáp án là ${word.meaning} nhé!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: options[selected!].word == word.word ? const Color(0xFF22A879) : AppColors.coral,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: round == 2 ? 'Xem kết quả' : 'Câu tiếp theo',
              onPressed: onNext,
              icon: Icons.arrow_forward_rounded,
              compact: true,
            ),
          ],
        ],
      ),
    );
  }
}

class _GameResult extends StatelessWidget {
  const _GameResult({required this.score, required this.onRestart});

  final int score;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          const Text('🏆', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 8),
          const Text('Hoàn thành thử thách!',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: AppColors.ink)),
          const SizedBox(height: 7),
          Text('Bé trả lời đúng $score/3 câu. Cố gắng thêm nhé!',
              textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 18),
          PrimaryButton(label: 'Chơi lại', onPressed: onRestart, icon: Icons.refresh_rounded),
        ],
      ),
    );
  }
}

class _ComingSoonCard extends StatelessWidget {
  const _ComingSoonCard({required this.emoji, required this.title, required this.subtitle});

  final String emoji;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.palePurple, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.ink)),
          const SizedBox(height: 3),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.muted)),
        ],
      ),
    );
  }
}
