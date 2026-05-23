import 'dart:math';
import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

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
        opacity = r.nextDouble() * 0.4 + 0.1,
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
    for (int i = 0; i < 50; i++) {
      _particles.add(_Particle(_rand));
    }
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 60))
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
      Container(
        decoration: const BoxDecoration(
          color: AppTheme.bgDeep,
        ),
      ),
      CustomPaint(
        painter: _GridPainter(),
        child: const SizedBox.expand(),
      ),
      CustomPaint(
        painter: _ParticlePainter(_particles),
        child: const SizedBox.expand(),
      ),
      widget.child,
    ]);
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.neonCyan.withOpacity(0.04)
      ..strokeWidth = 0.5;
    const step = 28.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = p.color.withOpacity(p.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(
          Offset(p.x * size.width, p.y * size.height), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}
