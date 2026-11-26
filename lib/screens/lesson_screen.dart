import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../data/lesson_data.dart';
import '../state/progress_store.dart';
import '../theme/app_colors.dart';
import '../widgets/milo_character.dart';
import '../widgets/primary_button.dart';

enum _LessonPhase { learn, quiz, complete }

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key, required this.topic});

  final LessonTopic topic;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final FlutterTts _tts = FlutterTts();
  _LessonPhase _phase = _LessonPhase.learn;
  int _index = 0;
  int? _selectedIndex;
  bool _speaking = false;
  bool _savedReward = false;
  bool _earnedRewards = true;

  List<VocabularyWord> get _words => widget.topic.words;
  VocabularyWord get _currentWord => _words[_index];

  double get _progress {
    if (_phase == _LessonPhase.complete) return 1;
    if (_phase == _LessonPhase.learn) return .5 * ((_index + 1) / _words.length);
    final quizProgress = (_index + (_selectedIndex != null && _isCorrect ? 1 : 0)) / _words.length;
    return .5 + (.5 * quizProgress);
  }

  bool get _isCorrect => _selectedIndex != null && _choices[_selectedIndex!].word == _currentWord.word;

  List<VocabularyWord> get _choices {
    final length = _words.length;
    final next = ( _index + 1) % length;
    final previous = (_index + length - 1) % length;
    final base = [_words[_index], _words[next], _words[previous]];
    final shift = _index % base.length;
    return [...base.skip(shift), ...base.take(shift)];
  }

  Future<void> _speak(String text) async {
    setState(() => _speaking = true);
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(.4);
      await _tts.setPitch(1.08);
      await _tts.speak(text);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thiết bị chưa có giọng đọc tiếng Anh. Bé thử lại nhé!')),
        );
      }
    } finally {
      if (mounted) setState(() => _speaking = false);
    }
  }

  void _nextLearn() {
    if (_index < _words.length - 1) {
      setState(() => _index += 1);
    } else {
      setState(() {
        _phase = _LessonPhase.quiz;
        _index = 0;
      });
    }
  }

  void _choose(int index) {
    if (_selectedIndex != null) return;
    setState(() => _selectedIndex = index);
    if (_choices[index].word == _currentWord.word) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.selectionClick();
    }
  }

  Future<void> _nextQuiz() async {
    if (_selectedIndex == null) return;
    if (!_isCorrect) {
      setState(() => _selectedIndex = null);
      return;
    }

    if (_index < _words.length - 1) {
      setState(() {
        _index += 1;
        _selectedIndex = null;
      });
    } else {
      await _finishLesson();
    }
  }

  Future<void> _finishLesson() async {
    if (!_savedReward) {
      _savedReward = true;
      final store = ProgressStore.instance;
      _earnedRewards = !store.isTopicCompleted(widget.topic.id);
      await store.completeTopic(
        topicId: widget.topic.id,
        words: _words.length,
      );
    }
    if (!mounted) return;
    HapticFeedback.mediumImpact();
    setState(() => _phase = _LessonPhase.complete);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phaseLabel = switch (_phase) {
      _LessonPhase.learn => 'LÀM QUEN TỪ MỚI',
      _LessonPhase.quiz => 'THỬ TÀI GHI NHỚ',
      _LessonPhase.complete => 'NHIỆM VỤ HOÀN THÀNH',
    };

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Thoát bài học',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded),
        ),
        title: Text(widget.topic.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Center(
              child: Text(
                _phase == _LessonPhase.complete ? '✓' : '${_index + 1}/${_words.length}',
                style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.w900, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: _progress),
                  duration: const Duration(milliseconds: 420),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) => LinearProgressIndicator(
                    value: value,
                    minHeight: 9,
                    backgroundColor: Colors.white,
                    color: _phase == _LessonPhase.complete ? AppColors.mint : widget.topic.color,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                phaseLabel,
                style: const TextStyle(color: AppColors.muted, fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.easeOutBack,
                  child: switch (_phase) {
                    _LessonPhase.learn => _LearnStep(
                        key: const ValueKey('learn'),
                        topic: widget.topic,
                        word: _currentWord,
                        speaking: _speaking,
                        onSpeak: () => _speak(_currentWord.word),
                        onSpeakExample: () => _speak(_currentWord.example),
                      ),
                    _LessonPhase.quiz => _QuizStep(
                        key: const ValueKey('quiz'),
                        topic: widget.topic,
                        word: _currentWord,
                        choices: _choices,
                        selectedIndex: _selectedIndex,
                        onChoose: _choose,
                        onListen: () => _speak(_currentWord.word),
                      ),
                    _LessonPhase.complete => _CompleteStep(
                        key: const ValueKey('complete'),
                        topic: widget.topic,
                        rewarded: _earnedRewards,
                        onContinue: () => Navigator.of(context).pop(),
                      ),
                  },
                ),
              ),
              const SizedBox(height: 14),
              if (_phase == _LessonPhase.learn)
                PrimaryButton(
                  label: _index == _words.length - 1 ? 'Bắt đầu thử thách' : 'Từ tiếp theo',
                  onPressed: _nextLearn,
                  icon: Icons.arrow_forward_rounded,
                  color: widget.topic.color,
                )
              else if (_phase == _LessonPhase.quiz && _selectedIndex != null)
                PrimaryButton(
                  label: _isCorrect ? (_index == _words.length - 1 ? 'Nhận phần thưởng' : 'Câu tiếp theo') : 'Thử lại nhé',
                  onPressed: _nextQuiz,
                  icon: _isCorrect ? Icons.arrow_forward_rounded : Icons.refresh_rounded,
                  color: _isCorrect ? AppColors.mint : AppColors.orange,
                )
              else if (_phase == _LessonPhase.quiz)
                const Text('Bé chọn một đáp án nhé!',
                    style: TextStyle(color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.w700))
              else
                const SizedBox(height: 54),
            ],
          ),
        ),
      ),
    );
  }
}

class _LearnStep extends StatelessWidget {
  const _LearnStep({
    super.key,
    required this.topic,
    required this.word,
    required this.speaking,
    required this.onSpeak,
    required this.onSpeakExample,
  });

  final LessonTopic topic;
  final VocabularyWord word;
  final bool speaking;
  final VoidCallback onSpeak;
  final VoidCallback onSpeakExample;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Nhìn hình và học từ mới nhé!', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 20),
          Container(
            width: 174,
            height: 174,
            decoration: BoxDecoration(
              color: topic.softColor,
              borderRadius: BorderRadius.circular(44),
            ),
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              child: Text(word.emoji, key: ValueKey(word.word), style: const TextStyle(fontSize: 98)),
            ),
          ),
          const SizedBox(height: 20),
          Text(word.word, style: const TextStyle(color: AppColors.ink, fontSize: 34, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(word.meaning, style: const TextStyle(color: AppColors.muted, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 15),
          OutlinedButton.icon(
            onPressed: onSpeak,
            icon: Icon(speaking ? Icons.graphic_eq_rounded : Icons.volume_up_rounded),
            label: Text(speaking ? 'Đang đọc...' : 'Nghe phát âm'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.blue,
              side: const BorderSide(color: AppColors.sky, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
          ),
          const SizedBox(height: 17),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(color: AppColors.paleYellow, borderRadius: BorderRadius.circular(17)),
            child: Column(
              children: [
                const Text('CÂU VÍ DỤ', style: TextStyle(color: AppColors.orange, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: .8)),
                const SizedBox(height: 5),
                Text(word.example, textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w800, fontSize: 14)),
                TextButton.icon(
                  onPressed: onSpeakExample,
                  icon: const Icon(Icons.volume_up_rounded, size: 15),
                  label: const Text('Nghe cả câu'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizStep extends StatelessWidget {
  const _QuizStep({
    super.key,
    required this.topic,
    required this.word,
    required this.choices,
    required this.selectedIndex,
    required this.onChoose,
    required this.onListen,
  });

  final LessonTopic topic;
  final VocabularyWord word;
  final List<VocabularyWord> choices;
  final int? selectedIndex;
  final ValueChanged<int> onChoose;
  final VoidCallback onListen;

  @override
  Widget build(BuildContext context) {
    final correct = selectedIndex != null && choices[selectedIndex!].word == word.word;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Nghe từ tiếng Anh và chọn hình đúng',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.ink, fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 15),
          InkWell(
            onTap: onListen,
            borderRadius: BorderRadius.circular(40),
            child: Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(color: AppColors.paleBlue, shape: BoxShape.circle),
              child: const Icon(Icons.volume_up_rounded, color: AppColors.blue, size: 38),
            ),
          ),
          const SizedBox(height: 6),
          const Text('Chạm để nghe lại', style: TextStyle(color: AppColors.muted, fontSize: 10)),
          const SizedBox(height: 20),
          Row(
            children: List.generate(choices.length, (index) {
              final selected = selectedIndex == index;
              final isAnswer = choices[index].word == word.word;
              final showCorrect = selectedIndex != null && isAnswer;
              final wrongChoice = selected && !isAnswer;
              final background = showCorrect
                  ? AppColors.paleMint
                  : wrongChoice
                      ? AppColors.palePink
                      : AppColors.canvas;
              final border = showCorrect
                  ? AppColors.mint
                  : wrongChoice
                      ? AppColors.coral
                      : Colors.transparent;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index == choices.length - 1 ? 0 : 8),
                  child: InkWell(
                    onTap: selectedIndex == null ? () => onChoose(index) : null,
                    borderRadius: BorderRadius.circular(19),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      height: 118,
                      decoration: BoxDecoration(
                        color: background,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: border, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(choices[index].emoji, style: const TextStyle(fontSize: 39)),
                          const SizedBox(height: 7),
                          Text(choices[index].meaning,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppColors.ink, fontSize: 10, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          if (selectedIndex != null) ...[
            const SizedBox(height: 17),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(correct ? 'Chính xác!' : 'Gần đúng rồi!',
                    style: TextStyle(
                      color: correct ? const Color(0xFF22A879) : AppColors.orange,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    )),
                const SizedBox(width: 7),
                Text(correct ? '🎉' : '💛', style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 4),
            Text(correct ? 'Milo tự hào về bé!' : 'Mình thử lại một lần nữa nhé.',
                style: const TextStyle(color: AppColors.muted, fontSize: 11)),
          ],
        ],
      ),
    );
  }
}

class _CompleteStep extends StatelessWidget {
  const _CompleteStep({super.key, required this.topic, required this.rewarded, required this.onContinue});

  final LessonTopic topic;
  final bool rewarded;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFFF4CE), Color(0xFFFFE5C9)]),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const MiloCharacter(size: 132, expression: MiloExpression.cheering),
          const SizedBox(height: 15),
          Text(rewarded ? 'BÉ GIỎI QUÁ!' : 'ÔN TẬP XUẤT SẮC',
              style: const TextStyle(color: AppColors.orange, fontSize: 12, letterSpacing: 1.3, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          const Text('Chặng đường tuyệt vời!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.ink, fontSize: 25, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(
            rewarded
                ? 'Bé đã hoàn thành ${topic.title}. Milo rất tự hào về bé!'
                : 'Bé đã ôn lại ${topic.title}. Mỗi lần luyện tập là một bước tiến!',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 20),
          if (rewarded)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _RewardPill(emoji: '⭐', label: '+3 sao'),
                const SizedBox(width: 10),
                _RewardPill(emoji: '⚡', label: '+25 XP'),
                const SizedBox(width: 10),
                _RewardPill(emoji: '🪙', label: '+10 xu'),
              ],
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: const Text('🌱 Bé đang ghi nhớ ngày càng tốt hơn!',
                  style: TextStyle(color: AppColors.ink, fontSize: 11, fontWeight: FontWeight.w800)),
            ),
          const SizedBox(height: 23),
          PrimaryButton(label: 'Tiếp tục hành trình', onPressed: onContinue, icon: Icons.arrow_forward_rounded),
        ],
      ),
    );
  }
}

class _RewardPill extends StatelessWidget {
  const _RewardPill({required this.emoji, required this.label});

  final String emoji;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(color: Colors.white.withOpacity(.9), borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 19)),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(color: AppColors.ink, fontSize: 9, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
