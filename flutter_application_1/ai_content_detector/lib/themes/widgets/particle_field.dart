import 'dart:math';
import 'package:flutter/material.dart';
import '../app_themes.dart';

class ParticleField extends StatefulWidget {
  final Widget child;
  const ParticleField({super.key, required this.child});

  @override
  State<ParticleField> createState() => _ParticleFieldState();
}

class _Particle {
  double x, y, radius, opacity, speed;
  Color color;
  _Particle(Random r)
      : x = r.nextDouble(),
        y = r.nextDouble(),
        radius = r.nextDouble() * 2 + 0.5,
        opacity = r.nextDouble() * 0.5 + 0.1,
        speed = r.nextDouble() * 0.0003 + 0.0001,
        color = [
          AppTheme.neonCyan,
          AppTheme.neonViolet,
          AppTheme.neonPink,
          AppTheme.neonGreen,
        ][r.nextInt(4)];
}

class _ParticleFieldState extends State<ParticleField>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final List<_Particle> _particles = [];
  final _rand = Random();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 60; i++) {
      _particles.add(_Particle(_rand));
    }
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 60))
      ..repeat();
    _ctrl.addListener(() => setState(() {
          for (final p in _particles) {
            p.y -= p.speed;
            if (p.y < 0) {
              p.y = 1;
              p.x = _rand.nextDouble();
            }
          }
        }));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CustomPaint(
        painter: _ParticlePainter(_particles),
        child: const SizedBox.expand(),
      ),
      widget.child,
    ]);
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = p.color.withAlpha((p.color.alpha * p.opacity).round())
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(
          Offset(p.x * size.width, p.y * size.height), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}
