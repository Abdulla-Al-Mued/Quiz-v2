import 'package:flutter/material.dart';

class ModernButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final bool isPrimary;
  final Gradient? gradient;

  const ModernButton({super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.isPrimary,
    this.gradient,
  });

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) => _animationController.reverse(),
        onTapCancel: () => _animationController.reverse(),
        child: Container(
          height: widget.isPrimary ? 60 : 50,
          decoration: BoxDecoration(
            gradient: widget.isPrimary
                ? widget.gradient
                : null,
            color: widget.isPrimary
                ? null
                : Colors.white.withOpacity(0.1),
            borderRadius: widget.isPrimary?BorderRadius.circular(30):BorderRadius.circular(10),
            border: widget.isPrimary
                ? null
                : Border.all(
              color: theme.primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isPrimary
                    ? theme.primaryColor.withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
                blurRadius: widget.isPrimary ? 15 : 8,
                spreadRadius: widget.isPrimary ? 2 : 1,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: widget.isPrimary ? 24 : 20,
                    color: widget.isPrimary
                        ? Colors.white
                        : theme.primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: widget.isPrimary ? 18 : 16,
                      fontWeight: FontWeight.w600,
                      color: widget.isPrimary
                          ? Colors.white
                          : theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildStatsSection(BuildContext context) {
  final theme = Theme.of(context);

  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white.withOpacity(0.1),
      border: Border.all(
        color: Colors.white.withOpacity(0.2),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatItem(
          icon: Icons.quiz,
          value: '0',
          label: 'Quizzes Taken',
          color: theme.primaryColor,
        ),
        Container(
          width: 1,
          height: 40,
          color: Colors.grey.withOpacity(0.3),
        ),
        const _StatItem(
          icon: Icons.trending_up,
          value: '0%',
          label: 'Best Score',
          color: Colors.green,
        ),
        Container(
          width: 1,
          height: 40,
          color: Colors.grey.withOpacity(0.3),
        ),
        const _StatItem(
          icon: Icons.emoji_events,
          value: '0',
          label: 'Achievements',
          color: Colors.orange,
        ),
      ],
    ),
  );
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
