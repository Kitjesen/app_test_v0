import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/robot_provider.dart';
import '../widgets/joystick.dart';
import '../models/robot_state.dart';
import 'fullscreen_control_screen.dart';

class ControlScreen extends StatelessWidget {
  const ControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final joystickHeight = screenHeight < 700 ? 180.0 : 200.0;
    
    return Consumer<RobotProvider>(
      builder: (context, robotProvider, _) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0A0E14),  // 深色背景
            ),
            child: Column(
            children: [
              // 顶部Header
              _buildHeader(robotProvider),
              // 可滚动内容
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // 扫描健康按钮
                    Container(
                      margin: const EdgeInsets.only(bottom: 20, top: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            const Color(0xFF2D4A2B).withOpacity(0.6),
                            const Color(0xFF3D5A3B).withOpacity(0.5),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7FFF7F).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.radar,
                              color: Color(0xFF7FFF7F),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Text(
                              'Scan robot status',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFC8E6C9),
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7FFF7F).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.qr_code_scanner,
                              color: Color(0xFF7FFF7F),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // 横屏控制入口
                    _buildFullscreenControlEntry(context, robotProvider),
                    const SizedBox(height: 16),
                    
                    // 机器狗状态卡片
                    _buildRobotStatusCard(robotProvider),
                    const SizedBox(height: 16),
                    
                    // 摄像头视图卡片
                    _buildCameraCard(),
                    const SizedBox(height: 12),
                    
                    // 操控面板
                    _buildControlPanel(robotProvider, joystickHeight),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(RobotProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0E14),  // 深色背景
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1F2E),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF7FFF7F).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.pets,
                  color: Color(0xFF7FFF7F),
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Evening',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8A92A6),
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Robot OW',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 26,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullscreenControlEntry(BuildContext context, RobotProvider provider) {
    return GestureDetector(
      onTap: () {
        if (!provider.isConnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('请先连接机器狗'),
              backgroundColor: Color(0xFFE74C3C),
            ),
          );
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const FullscreenControlScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1419),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF7FFF7F).withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // 左侧图标
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF2D4A2B),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.fullscreen,
                color: Color(0xFF7FFF7F),
                size: 32,
              ),
            ),
            const SizedBox(width: 18),
            // 中间文字
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fullscreen Control',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Dual joystick precision control',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8A92A6),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            // 右侧箭头
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF7FFF7F).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF7FFF7F),
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRobotStatusCard(RobotProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1419),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'Status Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),
          
          // 状态信息网格 - 2x2布局
          Row(
            children: [
              Expanded(
                child: _buildStatusItem(
                  icon: Icons.battery_charging_full,
                  label: '电量',
                  value: '${provider.robotState.battery}%',
                  color: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatusItem(
                  icon: Icons.thermostat,
                  label: '温度',
                  value: '${provider.robotState.temperature}°C',
                  color: const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatusItem(
                  icon: Icons.wifi,
                  label: '信号',
                  value: '${provider.robotState.signalStrength}%',
                  color: const Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatusItem(
                  icon: Icons.directions_run,
                  label: '状态',
                  value: _getStatusText(provider.robotState.status),
                  color: const Color(0xFF8B5CF6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJoystickController({
    required bool enabled,
    required Function(double, double) onMove,
    required String label,
    required IconData icon,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1A2A1A),
                const Color(0xFF1F3A1F),
              ],
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: enabled ? const Color(0xFF7FFF7F).withOpacity(0.3) : const Color(0xFF2D4A2B),
              width: 2,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: enabled ? const Color(0xFF7FFF7F).withOpacity(0.2) : const Color(0xFF2D4A2B),
              ),
              Joystick(
                enabled: enabled,
                onDirectionChanged: onMove,
                label: '',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: enabled ? const Color(0xFF7FFF7F) : const Color(0xFF8A92A6),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isActive,
    required VoidCallback? onTap,
  }) {
    return _AnimatedActionButton(
      icon: icon,
      label: label,
      color: color,
      isActive: isActive,
      onTap: onTap,
    );
  }
  
  Widget _buildStatusItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A2A1A),
            const Color(0xFF1F3A1F),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Icon(
                icon,
                color: const Color(0xFF8A92A6),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7FFF7F),
                  letterSpacing: -1,
                ),
              ),
              // 环形进度条
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: _getProgressValue(value),
                  strokeWidth: 4,
                  backgroundColor: const Color(0xFF2D4A2B).withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7FFF7F)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  double _getProgressValue(String value) {
    // 从百分比字符串提取数值
    final numStr = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (numStr.isEmpty) return 0.0;
    final num = int.tryParse(numStr) ?? 0;
    return num / 100.0;
  }
  
  Widget _buildCameraCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF0F1419),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          // 深色背景
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1A2A1A),
                  const Color(0xFF1F3A1F),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Icon(
                Icons.videocam_off_outlined,
                color: const Color(0xFF8A92A6).withOpacity(0.3),
                size: 64,
              ),
            ),
          ),
          // 标题
          const Positioned(
            top: 20,
            left: 20,
            child: Text(
              'Live Camera',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // 状态
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF8A92A6).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Disconnected',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8A92A6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildControlPanel(RobotProvider provider, double joystickHeight) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1419),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Virtual Joystick',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),
          Text(
            provider.isConnected ? 'Left: Move · Right: Turn' : 'Please connect robot first',
            style: TextStyle(
              fontSize: 13,
              color: provider.isConnected ? const Color(0xFF8A92A6) : const Color(0xFFEF4444),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: joystickHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildJoystickController(
                      enabled: provider.isConnected,
                      onMove: (x, y) {
                        if (y > 0.3) provider.moveForward();
                        else if (y < -0.3) provider.moveBackward();
                        else provider.stopMovement();
                      },
                      label: '移动',
                      icon: Icons.open_with,
                    ),
                    _buildJoystickController(
                      enabled: provider.isConnected,
                      onMove: (x, y) {
                        if (x > 0.3) provider.turnRight();
                        else if (x < -0.3) provider.turnLeft();
                      },
                      label: '转向',
                      icon: Icons.rotate_right,
                    ),
                  ],
                ),
              ),
              if (!provider.isConnected)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1419).withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.link_off,
                            size: 48,
                            color: const Color(0xFFEF4444).withOpacity(0.6),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Device Disconnected',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Please connect robot first',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8A92A6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _getStatusText(RobotStatus status) {
    switch (status) {
      case RobotStatus.idle:
        return '站立';
      case RobotStatus.walking:
        return '行走';
      case RobotStatus.sitting:
        return '坐下';
      case RobotStatus.lying:
        return '躺下';
      case RobotStatus.following:
        return '跟随';
    }
  }
}

// 带动画和触觉反馈的快捷动作按钮
class _AnimatedActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isActive;
  final VoidCallback? onTap;

  const _AnimatedActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<_AnimatedActionButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      setState(() => _isPressed = true);
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: widget.isActive ? widget.color.withOpacity(0.15) : const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isActive ? widget.color : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: widget.isActive ? widget.color : const Color(0xFF95A5A6),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: widget.isActive ? widget.color : const Color(0xFF95A5A6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
