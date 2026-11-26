import 'package:flutter/material.dart';

import '../state/progress_store.dart';
import '../theme/app_colors.dart';
import '../widgets/milo_character.dart';
import '../widgets/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Minh Anh');
  int _grade = 2;
  int _avatar = 0;

  static const _avatars = ['🦊', '🐼', '🐰', '🐱'];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    await ProgressStore.instance.finishOnboarding(
      name: _nameController.text,
      grade: _grade,
      avatarIndex: _avatar,
    );
    if (mounted) widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFF1C2), Color(0xFFFFD9B5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(child: MiloCharacter(size: 122, expression: MiloExpression.excited)),
                ),
              ),
              const SizedBox(height: 18),
              const Center(
                child: Text('Chào mừng đến\nMilo World! 🌈',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.ink, fontSize: 30, height: 1.08, fontWeight: FontWeight.w900)),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text('Milo sẽ cùng bé khám phá tiếng Anh\nqua những trò chơi thật vui!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.muted, fontSize: 14, height: 1.45, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 26),
              const Text('Tên của bé là gì?', style: TextStyle(color: AppColors.ink, fontSize: 16, fontWeight: FontWeight.w900)),
              const SizedBox(height: 9),
              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Nhập tên của bé',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.face_rounded, color: AppColors.orange),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Color(0xFFEAEFF5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: AppColors.blue, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Bé đang học lớp mấy?', style: TextStyle(color: AppColors.ink, fontSize: 16, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              Row(
                children: List.generate(5, (index) {
                  final grade = index + 1;
                  final selected = _grade == grade;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: index == 4 ? 0 : 8),
                      child: InkWell(
                        onTap: () => setState(() => _grade = grade),
                        borderRadius: BorderRadius.circular(15),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          height: 48,
                          decoration: BoxDecoration(
                            color: selected ? AppColors.blue : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: selected ? AppColors.blue : const Color(0xFFEAEFF5), width: 1.5),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$grade',
                            style: TextStyle(color: selected ? Colors.white : AppColors.ink, fontSize: 17, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              const Text('Chọn bạn đồng hành', style: TextStyle(color: AppColors.ink, fontSize: 16, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              Row(
                children: List.generate(_avatars.length, (index) {
                  final selected = _avatar == index;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: index == 3 ? 0 : 10),
                      child: InkWell(
                        onTap: () => setState(() => _avatar = index),
                        borderRadius: BorderRadius.circular(18),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          height: 66,
                          decoration: BoxDecoration(
                            color: selected ? AppColors.paleYellow : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: selected ? AppColors.orange : const Color(0xFFEAEFF5), width: selected ? 2 : 1),
                          ),
                          alignment: Alignment.center,
                          child: Text(_avatars[index], style: const TextStyle(fontSize: 32)),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: 'Bắt đầu hành trình',
                  onPressed: _start,
                  icon: Icons.arrow_forward_rounded,
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text('Mỗi ngày một chút, bé sẽ giỏi hơn! 💛',
                    style: TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
