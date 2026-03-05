import 'package:flutter/material.dart';
import 'dart:math';

class Spinner_2 extends StatefulWidget {
  const Spinner_2({super.key,
    required this.size,
    required this.color
  });

  final double size;
  final Color color;

  @override
  State<Spinner_2> createState() => Spinner_2State();
}

class Spinner_2State extends State<Spinner_2>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(Offset offset, int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double progress = (_controller.value + index * .25) % 1;
        final double opacity = sin(progress * pi);

        return Transform.translate(
          offset: offset,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: widget.size * .88,
              height: widget.size * .88,
              decoration:    BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildDot( Offset(- widget.size, -widget.size), 0), // top-left
          _buildDot( Offset(widget.size, -widget.size), 1),  // top-right
          _buildDot( Offset(- widget.size, widget.size), 2),  // bottom-left
          _buildDot( Offset(widget.size, widget.size), 3),   // bottom-right
        ],
      ),
    );
  }
}

class Spinner_1 extends StatefulWidget {
  const Spinner_1({super.key});

  @override
  State<Spinner_1> createState() => Spinner_1State();
}

class Spinner_1State extends State<Spinner_1>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCircle(double angle, int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double progress = (_controller.value + index * 0.25) % 1.0;
        final double opacity = sin(progress * pi);

        final double radius = 30;
        final double x = radius * cos(angle);
        final double y = radius * sin(angle);

        return Transform.translate(
          offset: Offset(x, y),
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const int numDots = 4;
    final double angleStep = 2 * pi / numDots;

    return SizedBox(
      width: 80,
      height: 80,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: List.generate(
            numDots,
                (i) => _buildCircle(i * angleStep, i),
          ),
        ),
      ),
    );
  }
}

class Spinner_0 extends StatefulWidget {
  const Spinner_0({super.key});

  @override
  State<Spinner_0> createState() => _Spinner_0State();
}

class _Spinner_0State extends State<Spinner_0>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(); // Infinite loop
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Icon(
        Icons.sync, // or use any widget/image here
        size: 40,
        color: Colors.blue,
      ),
    );
  }
}
