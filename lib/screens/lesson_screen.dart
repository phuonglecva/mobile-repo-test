import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../data/lesson_data.dart';
import '../state/progress_store.dart';
import '../theme/app_colors.dart';
import '../widgets/primary_button.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key, required this.topic});

  final LessonTopic topic;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final FlutterTts _tts = FlutterTts();
  int _index = 0;
  bool _speaking = false;

  VocabularyWord get _word => widget.topic.words[_index];

  Future<void> _speak(String text) async {
    setState(() => _speaking = true);
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(.42);
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

  Future<void> _next() async {
    if (_index < widget.topic.words.length - 1) {
      setState(() => _index += 1);
      return;
    }

    await ProgressStore.instance.completeLesson(words: widget.topic.words.length);
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 62)),
            const SizedBox(height: 8),
            const Text('Tuyệt vời!', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: AppColors.ink)),
            const SizedBox(height: 6),
            Text('Bé đã hoàn thành chủ đề ${widget.topic.title}!',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.muted, height: 1.4)),
            const SizedBox(height: 16),
            const Text('+3 ⭐     +10 🪙',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.orange)),
            const SizedBox(height: 18),
            PrimaryButton(
              label: 'Về nhà thôi',
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
              },
              icon: Icons.home_rounded,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final words = widget.topic.words;
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close_rounded)),
        title: Text(widget.topic.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text('${_index + 1}/${words.length}',
                  style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (_index + 1) / words.length,
                  minHeight: 8,
                  backgroundColor: Colors.white,
                  color: widget.topic.color,
                ),
              ),
              const SizedBox(height: 22),
              const Text('CÙNG HỌC TỪ MỚI NÀO!',
                  style: TextStyle(color: AppColors.muted, fontSize: 11, letterSpacing: 1, fontWeight: FontWeight.w900)),
              const SizedBox(height: 14),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  child: Container(
                    key: ValueKey(_word.word),
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(color: widget.topic.color.withOpacity(.12), blurRadius: 20, offset: const Offset(0, 9)),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 168,
                          height: 168,
                          decoration: BoxDecoration(color: widget.topic.softColor, borderRadius: BorderRadius.circular(42)),
                          alignment: Alignment.center,
                          child: Text(_word.emoji, style: const TextStyle(fontSize: 100)),
                        ),
                        const SizedBox(height: 24),
                        Text(_word.word,
                            style: const TextStyle(color: AppColors.ink, fontSize: 34, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 5),
                        Text(_word.meaning,
                            style: const TextStyle(color: AppColors.muted, fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: () => _speak(_word.word),
                          icon: Icon(_speaking ? Icons.graphic_eq_rounded : Icons.volume_up_rounded),
                          label: Text(_speaking ? 'Đang đọc...' : 'Nghe phát âm'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.blue,
                            side: const BorderSide(color: AppColors.sky, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(color: AppColors.paleYellow, borderRadius: BorderRadius.circular(17)),
                          child: Column(
                            children: [
                              const Text('CÂU VÍ DỤ',
                                  style: TextStyle(color: AppColors.orange, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: .8)),
                              const SizedBox(height: 5),
                              Text(_word.example,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w800, fontSize: 14)),
                              TextButton(
                                onPressed: () => _speak(_word.example),
                                child: const Text('Nghe cả câu', style: TextStyle(fontWeight: FontWeight.w800)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              PrimaryButton(
                label: _index == words.length - 1 ? 'Hoàn thành bài học' : 'Từ tiếp theo',
                onPressed: _next,
                icon: Icons.arrow_forward_rounded,
                color: widget.topic.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
