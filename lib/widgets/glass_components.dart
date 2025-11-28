import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool isActive;
  final double borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.onTap,
    this.isActive = false,
    this.borderRadius = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: padding ?? const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF007AFF).withOpacity(0.85) // 激活时的iOS蓝
                    : const Color(0xFF2C2C2E).withOpacity(0.65), // 未激活时的深灰色
                border: Border.all(
                  color: Colors.white.withOpacity(isActive ? 0.2 : 0.1),
                  width: 0.5,
                ),
                gradient: isActive
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF007AFF),
                          Color(0xFF0055B3),
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.15),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class GlassButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;

  const GlassButton({
    super.key,
    required this.icon,
    this.label,
    this.isActive = false,
    required this.onTap,
    this.activeColor = const Color(0xFF007AFF),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? activeColor : const Color(0xFF3A3A3C).withOpacity(0.8),
          shape: BoxShape.circle,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeColor.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        padding: const EdgeInsets.all(16),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}

class GlassSlider extends StatelessWidget {
  final double value;
  final IconData icon;
  final Color activeColor;
  final String label;

  const GlassSlider({
    super.key,
    required this.value,
    required this.icon,
    this.activeColor = const Color(0xFFFFFFFF),
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: 64,
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E).withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // 进度条背景
          Container(
            height: 140 * value,
            width: double.infinity,
            decoration: BoxDecoration(
              color: activeColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          // 图标
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Icon(
              icon,
              color: value > 0.5 ? Colors.black.withOpacity(0.7) : Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
