import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../core/theme/app_colors.dart';

class CircularLoading extends StatelessWidget {
  final double size;
  final Color? color;

  const CircularLoading({
    super.key,
    this.size = 50,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.threeArchedCircle(
        color: color ?? AppColors.primary,
        size: size,
      ),
    );
  }
}

class CircularLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const CircularLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black26,
            child: const CircularLoading(),
          ),
      ],
    );
  }
}
