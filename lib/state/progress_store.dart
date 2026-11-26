import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/lesson_data.dart';

class ProgressStore extends ChangeNotifier {
  ProgressStore._();

  static final ProgressStore instance = ProgressStore._();

  static const _onboardedKey = 'milo_onboarded';
  static const _nameKey = 'milo_child_name';
  static const _gradeKey = 'milo_grade';
  static const _avatarKey = 'milo_avatar';
  static const _starsKey = 'milo_stars';
  static const _coinsKey = 'milo_coins';
  static const _xpKey = 'milo_xp';
  static const _lessonsKey = 'milo_lessons';
  static const _wordsKey = 'milo_words';
  static const _streakKey = 'milo_streak';
  static const _completedKey = 'milo_completed_topics';
  static const _lastStudyKey = 'milo_last_study';
  static const _dailyLessonsKey = 'milo_daily_lessons';
  static const _weekStorageKey = 'milo_week_key';
  static const _weeklyLessonsKey = 'milo_weekly_lessons';

  late SharedPreferences _prefs;

  bool _isOnboarded = false;
  String _childName = 'Minh Anh';
  int _grade = 2;
  int _avatarIndex = 0;
  int _stars = 0;
  int _coins = 0;
  int _xp = 0;
  int _lessonsCompleted = 0;
  int _wordsLearned = 0;
  int _streak = 0;
  int _dailyLessons = 0;
  int _weeklyLessons = 0;
  String _lastStudyDate = '';
  String _weekKey = '';
  final Set<String> _completedTopics = {};

  bool get isOnboarded => _isOnboarded;
  String get childName => _childName;
  int get grade => _grade;
  int get avatarIndex => _avatarIndex;
  int get stars => _stars;
  int get coins => _coins;
  int get xp => _xp;
  int get lessonsCompleted => _lessonsCompleted;
  int get wordsLearned => _wordsLearned;
  int get streak => _streak;
  int get dailyLessons => _dailyLessons;
  int get weeklyLessons => _weeklyLessons;
  int get completedTopicCount => _completedTopics.length;
  Set<String> get completedTopicIds => Set.unmodifiable(_completedTopics);

  double get weeklyProgress => (_weeklyLessons / 7).clamp(0.0, 1.0).toDouble();
  double get dailyProgress => (_dailyLessons / 1).clamp(0.0, 1.0).toDouble();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isOnboarded = _prefs.getBool(_onboardedKey) ?? false;
    _childName = _prefs.getString(_nameKey) ?? 'Minh Anh';
    _grade = _prefs.getInt(_gradeKey) ?? 2;
    _avatarIndex = _prefs.getInt(_avatarKey) ?? 0;
    _stars = _prefs.getInt(_starsKey) ?? 0;
    _coins = _prefs.getInt(_coinsKey) ?? 0;
    _xp = _prefs.getInt(_xpKey) ?? 0;
    _lessonsCompleted = _prefs.getInt(_lessonsKey) ?? 0;
    _wordsLearned = _prefs.getInt(_wordsKey) ?? 0;
    _streak = _prefs.getInt(_streakKey) ?? 0;
    _lastStudyDate = _prefs.getString(_lastStudyKey) ?? '';
    _dailyLessons = _prefs.getInt(_dailyLessonsKey) ?? 0;
    _weekKey = _prefs.getString(_weekStorageKey) ?? '';
    _weeklyLessons = _prefs.getInt(_weeklyLessonsKey) ?? 0;
    _completedTopics
      ..clear()
      ..addAll(_prefs.getStringList(_completedKey) ?? []);

    final now = DateTime.now();
    final today = _dateKey(now);
    if (_lastStudyDate != today) _dailyLessons = 0;
    final yesterday = _dateKey(now.subtract(const Duration(days: 1)));
    if (_lastStudyDate != today && _lastStudyDate != yesterday) _streak = 0;
    final currentWeek = _weekKeyFor(now);
    if (_weekKey != currentWeek) {
      _weekKey = currentWeek;
      _weeklyLessons = 0;
    }
  }

  Future<void> finishOnboarding({
    required String name,
    required int grade,
    required int avatarIndex,
  }) async {
    _childName = name.trim().isEmpty ? 'Minh Anh' : name.trim();
    _grade = grade.clamp(1, 5).toInt();
    _avatarIndex = avatarIndex.clamp(0, 3).toInt();
    _isOnboarded = true;
    await _save();
    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required int grade,
    required int avatarIndex,
  }) async {
    _childName = name.trim().isEmpty ? _childName : name.trim();
    _grade = grade.clamp(1, 5).toInt();
    _avatarIndex = avatarIndex.clamp(0, 3).toInt();
    await _save();
    notifyListeners();
  }

  bool isTopicCompleted(String topicId) => _completedTopics.contains(topicId);

  bool isTopicUnlocked(String topicId) {
    final index = lessonTopics.indexWhere((topic) => topic.id == topicId);
    if (index < 0) return false;
    if (index == 0) return true;
    return _completedTopics.contains(lessonTopics[index - 1].id);
  }

  LessonTopic? get nextTopic {
    for (final topic in lessonTopics) {
      if (!_completedTopics.contains(topic.id) && isTopicUnlocked(topic.id)) return topic;
    }
    return null;
  }

  LessonTopic? get reviewTopic {
    for (final topic in lessonTopics.reversed) {
      if (_completedTopics.contains(topic.id)) return topic;
    }
    return nextTopic;
  }

  Future<void> completeTopic({required String topicId, required int words}) async {
    final isFirstCompletion = _completedTopics.add(topicId);
    if (isFirstCompletion) {
      _stars += 3;
      _coins += 10;
      _xp += 25;
      _lessonsCompleted += 1;
      _wordsLearned += words;
    }

    // A replay is still meaningful practice: count it toward the daily habit
    // and weekly goal, while keeping one-time world rewards idempotent.
    _recordStudyDay();
    await _save();
    notifyListeners();
  }

  Future<void> completeLesson({int words = 3}) async {
    _stars += 3;
    _coins += 10;
    _xp += 25;
    _lessonsCompleted += 1;
    _wordsLearned += words;
    _recordStudyDay();
    await _save();
    notifyListeners();
  }

  Future<void> completeGame() async {
    _stars += 1;
    _coins += 5;
    _xp += 5;
    await _save();
    notifyListeners();
  }

  void _recordStudyDay() {
    final now = DateTime.now();
    final today = _dateKey(now);
    if (_lastStudyDate != today) {
      final yesterday = _dateKey(now.subtract(const Duration(days: 1)));
      _streak = _lastStudyDate == yesterday ? _streak + 1 : 1;
      _lastStudyDate = today;
      _dailyLessons = 0;
    }
    final week = _weekKeyFor(now);
    if (_weekKey != week) {
      _weekKey = week;
      _weeklyLessons = 0;
    }
    _dailyLessons += 1;
    _weeklyLessons += 1;
  }

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String _weekKeyFor(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return _dateKey(monday);
  }

  Future<void> _save() async {
    await _prefs.setBool(_onboardedKey, _isOnboarded);
    await _prefs.setString(_nameKey, _childName);
    await _prefs.setInt(_gradeKey, _grade);
    await _prefs.setInt(_avatarKey, _avatarIndex);
    await _prefs.setInt(_starsKey, _stars);
    await _prefs.setInt(_coinsKey, _coins);
    await _prefs.setInt(_xpKey, _xp);
    await _prefs.setInt(_lessonsKey, _lessonsCompleted);
    await _prefs.setInt(_wordsKey, _wordsLearned);
    await _prefs.setInt(_streakKey, _streak);
    await _prefs.setStringList(_completedKey, _completedTopics.toList());
    await _prefs.setString(_lastStudyKey, _lastStudyDate);
    await _prefs.setInt(_dailyLessonsKey, _dailyLessons);
    await _prefs.setString(_weekStorageKey, _weekKey);
    await _prefs.setInt(_weeklyLessonsKey, _weeklyLessons);
  }
}
