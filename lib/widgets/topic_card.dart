import 'package:flutter/material.dart';

import '../data/lesson_data.dart';

class TopicCard extends StatelessWidget {
  const TopicCard({super.key, required this.topic, required this.onTap, this.compact = false});

  final LessonTopic topic;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: topic.softColor,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: topic.unlocked ? onTap : null,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: EdgeInsets.all(compact ? 13 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: compact ? 42 : 48,
                    height: compact ? 42 : 48,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(.85), borderRadius: BorderRadius.circular(16)),
                    alignment: Alignment.center,
                    child: Text(topic.emoji, style: TextStyle(fontSize: compact ? 23 : 27)),
                  ),
                  const Spacer(),
                  if (!topic.unlocked)
                    const Icon(Icons.lock_rounded, color: Color(0xFF9AA6B8))
                  else
                    Icon(Icons.arrow_forward_rounded, color: topic.color),
                ],
              ),
              SizedBox(height: compact ? 9 : 13),
              Text(topic.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: topic.color, fontSize: compact ? 14 : 16, fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text(topic.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF7E8CA4), fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
