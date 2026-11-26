import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressStore extends ChangeNotifier {
  ProgressStore._();

  static final ProgressStore instance = ProgressStore._();

  static const _starsKey = 'milo_stars';
  static const _coinsKey = 'milo_coins';
  static const _lessonsKey = 'milo_lessons';
  static const _wordsKey = 'milo_words';
  static const _streakKey = 'milo_streak';

  late SharedPreferences _prefs;

  int _stars = 12;
  int _coins = 30;
  int _lessonsCompleted = 0;
  int _wordsLearned = 0;
  int _streak = 1;

  int get stars => _stars;
  int get coins => _coins;
  int get lessonsCompleted => _lessonsCompleted;
  int get wordsLearned => _wordsLearned;
  int get streak => _streak;

  double get weeklyProgress => (_lessonsCompleted / 12).clamp(0.0, 1.0).toDouble();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _stars = _prefs.getInt(_starsKey) ?? _stars;
    _coins = _prefs.getInt(_coinsKey) ?? _coins;
    _lessonsCompleted = _prefs.getInt(_lessonsKey) ?? _lessonsCompleted;
    _wordsLearned = _prefs.getInt(_wordsKey) ?? _wordsLearned;
    _streak = _prefs.getInt(_streakKey) ?? _streak;
  }

  Future<void> completeLesson({int words = 3}) async {
    _stars += 3;
    _coins += 10;
    _lessonsCompleted += 1;
    _wordsLearned += words;
    _streak = _streak < 1 ? 1 : _streak;
    await _save();
    notifyListeners();
  }

  Future<void> completeGame() async {
    _stars += 1;
    _coins += 5;
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    await _prefs.setInt(_starsKey, _stars);
    await _prefs.setInt(_coinsKey, _coins);
    await _prefs.setInt(_lessonsKey, _lessonsCompleted);
    await _prefs.setInt(_wordsKey, _wordsLearned);
    await _prefs.setInt(_streakKey, _streak);
  }
}
