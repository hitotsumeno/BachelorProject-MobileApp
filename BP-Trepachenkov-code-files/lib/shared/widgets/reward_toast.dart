import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bp_flutter_app/features/tasks/models/task_reward.dart';

class RewardToast {
  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;

  static void show(BuildContext context, TaskReward reward) {
    // Remove existing toast if any
    _dismiss();

    final overlay = Overlay.of(context);

    _currentEntry = OverlayEntry(
      builder: (_) => _RewardBanner(
        reward: reward,
        onDismissed: _dismiss,
      ),
    );

    overlay.insert(_currentEntry!);

    _dismissTimer = Timer(const Duration(milliseconds: 2600), _dismiss);
  }

  static void _dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class _RewardBanner extends StatefulWidget {
  final TaskReward reward;
  final VoidCallback onDismissed;

  const _RewardBanner({required this.reward, required this.onDismissed});

  @override
  State<_RewardBanner> createState() => _RewardBannerState();
}

class _RewardBannerState extends State<_RewardBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();

    // Start fade-out after hold period
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + kToolbarHeight + 8,
      left: 24,
      right: 24,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.shade900,
                    Colors.grey.shade800,
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFD4A017),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4A017).withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.auto_awesome, color: Color(0xFFD4A017), size: 22),
                  const SizedBox(width: 10),
                  Text(
                    '+${widget.reward.xpAwarded} XP',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.monetization_on, color: Color(0xFFFFD700), size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '+${widget.reward.goldAwarded}',
                    style: const TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.reward.leveledUp) ...[
                    const SizedBox(width: 16),
                    const Icon(Icons.arrow_upward, color: Color(0xFF00E676), size: 20),
                    const Text(
                      'LEVEL UP!',
                      style: TextStyle(
                        color: Color(0xFF00E676),
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
