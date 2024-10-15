import 'dart:math';

import 'package:flutter/material.dart';
import 'package:which/models/color_set.dart';
import 'package:which/utils/wave_clipper.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _parent;
  late final Animation<double> _rotateAnimation;
  late final Animation<double> _sizeAnimation;
  late Animation<Color?> _leftColorAnimation;
  late Animation<Color?> _rightColorAnimation;
  late ColorSet _preColorSet = ColorSet.set();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
    _parent = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _rotateAnimation = Tween<double>(
      begin: 4 * pi,
      end: 0,
    ).animate(_parent);
    _sizeAnimation = TweenSequence<double>(
      [
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 50, end: 46),
          weight: 46,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 46, end: 46),
          weight: 8,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 46, end: 50),
          weight: 46,
        ),
      ],
    ).animate(_parent);
    _setColorAnimation();
    _controller.addListener(() {
      if (_controller.isCompleted) {
        _controller.reset();
        _setColorAnimation();
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setColorAnimation() {
    final ColorSet colorSet = ColorSet.set();
    _leftColorAnimation = ColorTween(
      begin: _preColorSet.leftColor,
      end: colorSet.leftColor,
    ).animate(_parent);
    _rightColorAnimation = ColorTween(
      begin: _preColorSet.rightColor,
      end: colorSet.rightColor,
    ).animate(_parent);
    _preColorSet = colorSet;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Container(
            width: _sizeAnimation.value,
            height: _sizeAnimation.value,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            clipBehavior: Clip.antiAlias,
            child: Transform.rotate(
              angle: _rotateAnimation.value,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Container(
                          color: _leftColorAnimation.value,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: _rightColorAnimation.value,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: ClipPath(
                      clipper: const WaveClipper(correct: true),
                      child: Container(
                        width: _sizeAnimation.value * 0.8,
                        height: _sizeAnimation.value * 0.5,
                        color: _rightColorAnimation.value,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ClipPath(
                      clipper: const WaveClipper(correct: false),
                      child: Container(
                        width: _sizeAnimation.value * 0.8,
                        height: _sizeAnimation.value * 0.5,
                        color: _leftColorAnimation.value,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
