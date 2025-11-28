import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class Joystick extends StatefulWidget {
  final bool enabled;
  final Function(double x, double y) onDirectionChanged;
  final String label;

  const Joystick({
    super.key,
    required this.enabled,
    required this.onDirectionChanged,
    required this.label,
  });

  @override
  State<Joystick> createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  Offset _position = Offset.zero;
  final double _maxDistance = 60;
  DateTime _lastHapticTime = DateTime.now();

  void _updatePosition(Offset localPosition, Size size) {
    if (!widget.enabled) return;

    final center = Offset(size.width / 2, size.height / 2);
    final delta = localPosition - center;
    final distance = delta.distance;

    if (distance < _maxDistance) {
      _position = delta;
    } else {
      _position = delta * (_maxDistance / distance);
    }

    // 触发震动反馈 (限制频率)
    if (DateTime.now().difference(_lastHapticTime).inMilliseconds > 50) {
      HapticFeedback.selectionClick();
      _lastHapticTime = DateTime.now();
    }

    // 归一化坐标 (-1 到 1)
    final x = _position.dx / _maxDistance;
    final y = -_position.dy / _maxDistance; // Y轴反转

    widget.onDirectionChanged(x, y);
    setState(() {});
  }

  void _resetPosition() {
    HapticFeedback.mediumImpact();
    setState(() {
      _position = Offset.zero;
    });
    widget.onDirectionChanged(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    // 深色主题配色
    final baseColor = const Color(0xFF7FFF7F);
    final bgColor = const Color(0xFF1A2A1A);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: widget.enabled ? baseColor : Colors.grey[600],
              ),
            ),
          ),
        GestureDetector(
          onPanStart: (details) {
            if (widget.enabled) {
              HapticFeedback.mediumImpact();
              final box = context.findRenderObject() as RenderBox;
              _updatePosition(details.localPosition, box.size);
            }
          },
          onPanUpdate: (details) {
            if (widget.enabled) {
              final box = context.findRenderObject() as RenderBox;
              _updatePosition(details.localPosition, box.size);
            }
          },
          onPanEnd: (_) => _resetPosition(),
          child: Container(
            width: 150, // 调整尺寸以适应新布局
            height: 150,
            decoration: BoxDecoration(
              color: Colors.transparent, // 背景透明，由外部容器提供
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 中心点指示器
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: widget.enabled
                        ? baseColor.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
                // 方向线
                CustomPaint(
                  size: const Size(150, 150),
                  painter: _DirectionPainter(
                    position: _position,
                    enabled: widget.enabled,
                    color: baseColor,
                  ),
                ),
                // 摇杆
                Transform.translate(
                  offset: _position,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: widget.enabled
                            ? [
                                baseColor.withOpacity(0.9),
                                const Color(0xFF2D4A2B),
                              ]
                            : [
                                Colors.grey[600]!,
                                Colors.grey[800]!,
                              ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.enabled
                            ? Colors.white.withOpacity(0.2)
                            : Colors.transparent,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.gamepad,
                      color: widget.enabled ? const Color(0xFF0A0E14) : Colors.white30,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DirectionPainter extends CustomPainter {
  final Offset position;
  final bool enabled;
  final Color color;

  _DirectionPainter({
    required this.position,
    required this.enabled,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (position == Offset.zero) return;

    final paint = Paint()
      ..color = enabled
          ? color.withOpacity(0.3)
          : Colors.grey.withOpacity(0.2)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawLine(center, center + position, paint);
  }

  @override
  bool shouldRepaint(_DirectionPainter oldDelegate) {
    return position != oldDelegate.position || enabled != oldDelegate.enabled;
  }
}
