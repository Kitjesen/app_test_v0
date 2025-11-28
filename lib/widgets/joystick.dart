import 'package:flutter/material.dart';
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

    // 归一化坐标 (-1 到 1)
    final x = _position.dx / _maxDistance;
    final y = -_position.dy / _maxDistance; // Y轴反转

    widget.onDirectionChanged(x, y);
    setState(() {});
  }

  void _resetPosition() {
    setState(() {
      _position = Offset.zero;
    });
    widget.onDirectionChanged(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: widget.enabled ? Colors.grey[700] : Colors.grey[400],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onPanStart: (details) {
            if (widget.enabled) {
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
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: widget.enabled
                  ? Colors.white
                  : Colors.grey[200],
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.enabled
                    ? Colors.blue.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.2),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
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
                        ? Colors.blue.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
                // 方向线
                CustomPaint(
                  size: const Size(200, 200),
                  painter: _DirectionPainter(
                    position: _position,
                    enabled: widget.enabled,
                  ),
                ),
                // 摇杆
                Transform.translate(
                  offset: _position,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: widget.enabled
                            ? [
                                const Color(0xFF3B82F6),
                                const Color(0xFF2563EB),
                              ]
                            : [
                                Colors.grey[400]!,
                                Colors.grey[500]!,
                              ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (widget.enabled ? Colors.blue : Colors.grey)
                              .withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.control_camera,
                      color: Colors.white,
                      size: 32,
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

  _DirectionPainter({required this.position, required this.enabled});

  @override
  void paint(Canvas canvas, Size size) {
    if (position == Offset.zero) return;

    final paint = Paint()
      ..color = enabled
          ? Colors.blue.withOpacity(0.3)
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
