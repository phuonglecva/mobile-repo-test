import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class LessonTopic {
  const LessonTopic({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.softColor,
    required this.words,
    this.unlocked = true,
  });

  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
  final Color softColor;
  final List<VocabularyWord> words;
  final bool unlocked;
}

class VocabularyWord {
  const VocabularyWord({
    required this.word,
    required this.meaning,
    required this.emoji,
    required this.example,
  });

  final String word;
  final String meaning;
  final String emoji;
  final String example;
}

const List<LessonTopic> lessonTopics = [
  LessonTopic(
    id: 'alphabet',
    title: 'Bảng chữ cái',
    subtitle: 'A đến E thật vui',
    emoji: '🔤',
    color: AppColors.blue,
    softColor: AppColors.paleBlue,
    words: [
      VocabularyWord(word: 'Apple', meaning: 'Quả táo', emoji: '🍎', example: 'A is for apple.'),
      VocabularyWord(word: 'Ball', meaning: 'Quả bóng', emoji: '⚽', example: 'This is a ball.'),
      VocabularyWord(word: 'Cat', meaning: 'Con mèo', emoji: '🐱', example: 'C is for cat.'),
      VocabularyWord(word: 'Dog', meaning: 'Con chó', emoji: '🐶', example: 'D is for dog.'),
      VocabularyWord(word: 'Egg', meaning: 'Quả trứng', emoji: '🥚', example: 'I like eggs.'),
    ],
  ),
  LessonTopic(
    id: 'numbers',
    title: 'Số đếm',
    subtitle: 'Đếm từ 1 đến 5',
    emoji: '🔢',
    color: AppColors.orange,
    softColor: AppColors.paleYellow,
    words: [
      VocabularyWord(word: 'One', meaning: 'Số một', emoji: '1️⃣', example: 'I have one ball.'),
      VocabularyWord(word: 'Two', meaning: 'Số hai', emoji: '2️⃣', example: 'I see two birds.'),
      VocabularyWord(word: 'Three', meaning: 'Số ba', emoji: '3️⃣', example: 'Three little cats.'),
      VocabularyWord(word: 'Four', meaning: 'Số bốn', emoji: '4️⃣', example: 'I see four stars.'),
      VocabularyWord(word: 'Five', meaning: 'Số năm', emoji: '5️⃣', example: 'Five little ducks.'),
    ],
  ),
  LessonTopic(
    id: 'colors',
    title: 'Màu sắc',
    subtitle: 'Thế giới sắc màu',
    emoji: '🎨',
    color: AppColors.coral,
    softColor: AppColors.palePink,
    words: [
      VocabularyWord(word: 'Red', meaning: 'Màu đỏ', emoji: '❤️', example: 'The apple is red.'),
      VocabularyWord(word: 'Blue', meaning: 'Màu xanh dương', emoji: '💙', example: 'The sky is blue.'),
      VocabularyWord(word: 'Yellow', meaning: 'Màu vàng', emoji: '💛', example: 'The sun is yellow.'),
      VocabularyWord(word: 'Green', meaning: 'Màu xanh lá', emoji: '💚', example: 'The leaf is green.'),
      VocabularyWord(word: 'Pink', meaning: 'Màu hồng', emoji: '🩷', example: 'The flower is pink.'),
    ],
  ),
  LessonTopic(
    id: 'animals',
    title: 'Động vật',
    subtitle: 'Gặp gỡ những người bạn',
    emoji: '🐾',
    color: AppColors.mint,
    softColor: AppColors.paleMint,
    words: [
      VocabularyWord(word: 'Cat', meaning: 'Con mèo', emoji: '🐱', example: 'It is a cat.'),
      VocabularyWord(word: 'Dog', meaning: 'Con chó', emoji: '🐶', example: 'It is a dog.'),
      VocabularyWord(word: 'Bird', meaning: 'Con chim', emoji: '🐦', example: 'It is a bird.'),
      VocabularyWord(word: 'Rabbit', meaning: 'Con thỏ', emoji: '🐰', example: 'I see a rabbit.'),
      VocabularyWord(word: 'Fish', meaning: 'Con cá', emoji: '🐠', example: 'The fish can swim.'),
    ],
  ),
  LessonTopic(
    id: 'family',
    title: 'Gia đình',
    subtitle: 'Những người thân yêu',
    emoji: '🏡',
    color: AppColors.lavender,
    softColor: AppColors.palePurple,
    words: [
      VocabularyWord(word: 'Mother', meaning: 'Mẹ', emoji: '👩', example: 'This is my mother.'),
      VocabularyWord(word: 'Father', meaning: 'Bố', emoji: '👨', example: 'This is my father.'),
      VocabularyWord(word: 'Baby', meaning: 'Em bé', emoji: '👶', example: 'The baby is happy.'),
      VocabularyWord(word: 'Sister', meaning: 'Chị / em gái', emoji: '👧', example: 'I love my sister.'),
      VocabularyWord(word: 'Brother', meaning: 'Anh / em trai', emoji: '👦', example: 'He is my brother.'),
    ],
  ),
  LessonTopic(
    id: 'food',
    title: 'Đồ ăn',
    subtitle: 'Món ngon mỗi ngày',
    emoji: '🍓',
    color: AppColors.orange,
    softColor: AppColors.paleYellow,
    words: [
      VocabularyWord(word: 'Milk', meaning: 'Sữa', emoji: '🥛', example: 'I like milk.'),
      VocabularyWord(word: 'Bread', meaning: 'Bánh mì', emoji: '🍞', example: 'I eat bread.'),
      VocabularyWord(word: 'Banana', meaning: 'Quả chuối', emoji: '🍌', example: 'A yellow banana.'),
      VocabularyWord(word: 'Apple', meaning: 'Quả táo', emoji: '🍎', example: 'I eat an apple.'),
      VocabularyWord(word: 'Rice', meaning: 'Cơm / gạo', emoji: '🍚', example: 'Rice is yummy.'),
    ],
  ),
];
