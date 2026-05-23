import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class GlowCard extends StatelessWidget {
  final Widget child;
  final Color? glowColor;
  final EdgeInsets? padding;
  final double borderRadius;

  const GlowCard({
    super.key,
    required this.child,
    this.glowColor,
    this.padding,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final color = glowColor ?? AppTheme.neonCyan;
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: padding ?? const EdgeInsets.all(20),
      child: child,
    );
  }
}

class NeonButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final List<Color>? gradientColors;
  final IconData? icon;
  final bool outlined;

  const NeonButton({
    super.key,
    required this.label,
    this.onTap,
    this.gradientColors,
    this.icon,
    this.outlined = false,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1, end: 0.96).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.gradientColors ??
        [AppTheme.neonViolet, AppTheme.neonCyan];

    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: widget.outlined
            ? Container(
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: colors.first.withValues(alpha: 0.7), width: 1.5),
                ),
                alignment: Alignment.center,
                child: _label(colors.first),
              )
            : Container(
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: colors.last.withValues(alpha: 0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 6)),
                  ],
                ),
                alignment: Alignment.center,
                child: _label(Colors.white),
              ),
      ),
    );
  }

  Widget _label(Color color) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, color: color, size: 18),
            const SizedBox(width: 8),
          ],
          Text(widget.label,
              style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8)),
        ],
      );
}

class NeonSwitch extends StatelessWidget {
  final bool value;
  final Color color;
  final ValueChanged<bool> onChanged;

  const NeonSwitch({
    super.key,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: value ? color.withValues(alpha: 0.25) : AppTheme.bgCard,
          border: Border.all(
            color: value ? color : AppTheme.border,
            width: 1.5,
          ),
          boxShadow: value
              ? [
                  BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 1),
                ]
              : [],
        ),
        child: Stack(children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            left: value ? 20 : 2,
            top: 2,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: value ? color : AppTheme.textMuted,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
