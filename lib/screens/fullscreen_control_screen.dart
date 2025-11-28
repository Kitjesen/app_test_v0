import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/robot_provider.dart';
import '../widgets/joystick.dart';
import '../widgets/grid_painter.dart';
import '../models/robot_state.dart';

class FullscreenControlScreen extends StatefulWidget {
  const FullscreenControlScreen({super.key});

  @override
  State<FullscreenControlScreen> createState() => _FullscreenControlScreenState();
}

class _FullscreenControlScreenState extends State<FullscreenControlScreen> {
  @override
  void initState() {
    super.initState();
    // 进入时设置为横屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // 隐藏状态栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // 退出时恢复竖屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // 显示状态栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RobotProvider>(
      builder: (context, robotProvider, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF1A1A2E),
          body: Stack(
            children: [
              // 背景装饰
              _buildBackgroundDecoration(),
              
              // 主要内容
              SafeArea(
                child: Column(
                  children: [
                    // 顶部状态栏
                    _buildTopBar(robotProvider, context),
                    
                    // 中间控制区域
                    Expanded(
                      child: Row(
                        children: [
                          // 左侧摇杆区域
                          Expanded(
                            child: _buildLeftJoystickArea(robotProvider),
                          ),
                          
                          // 中间信息区域
                          _buildCenterInfoArea(robotProvider),
                          
                          // 右侧摇杆区域
                          Expanded(
                            child: _buildRightJoystickArea(robotProvider),
                          ),
                        ],
                      ),
                    ),
                    
                    // 底部快捷操作
                    _buildBottomActions(robotProvider),
                  ],
                ),
              ),
              
              // 紧急停止按钮
              Positioned(
                top: 20,
                right: 20,
                child: _buildEmergencyStop(robotProvider),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackgroundDecoration() {
    return Stack(
      children: [
        // 渐变背景
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0A0E27),
                const Color(0xFF1C1F3E),
                const Color(0xFF2D3561),
              ],
            ),
          ),
        ),
        // 装饰性网格
        Opacity(
          opacity: 0.03,
          child: CustomPaint(
            painter: GridPainter(),
            size: Size.infinite,
          ),
        ),
        // 发光圆形装饰
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF5DADE2).withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -150,
          right: -150,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF9B59B6).withOpacity(0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(RobotProvider provider, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // 返回按钮
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),
          const SizedBox(width: 16),
          
          // 标题
          const Text(
            '实时操控',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const Spacer(),
          
          // 状态指示器
          _buildStatusIndicator(
            Icons.battery_charging_full,
            '${provider.robotState.battery}%',
            provider.robotState.battery < 20,
          ),
          const SizedBox(width: 16),
          _buildStatusIndicator(
            Icons.thermostat,
            '${provider.robotState.temperature}°C',
            provider.robotState.temperature > 60,
          ),
          const SizedBox(width: 16),
          _buildStatusIndicator(
            Icons.signal_cellular_alt,
            '${provider.robotState.signalStrength}%',
            provider.robotState.signalStrength < 30,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(IconData icon, String text, bool isWarning) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isWarning
            ? const Color(0xFFE74C3C).withOpacity(0.2)
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isWarning ? const Color(0xFFE74C3C) : Colors.white24,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isWarning ? const Color(0xFFE74C3C) : Colors.white70,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: isWarning ? const Color(0xFFE74C3C) : Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftJoystickArea(RobotProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 摇杆外围发光效果
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5DADE2).withOpacity(0.3),
                  blurRadius: 40,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 外圈装饰
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.08),
                        Colors.white.withOpacity(0.02),
                      ],
                    ),
                    border: Border.all(
                      color: const Color(0xFF5DADE2).withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                ),
                // 中圈
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
                // 摇杆组件
                SizedBox(
                  width: 180,
                  height: 180,
                  child: Joystick(
                    enabled: provider.isConnected,
                    onDirectionChanged: (x, y) {
                      if (y > 0.3) provider.moveForward();
                      else if (y < -0.3) provider.moveBackward();
                      else if (x > 0.3) provider.turnRight();
                      else if (x < -0.3) provider.turnLeft();
                      else provider.stopMovement();
                    },
                    label: '',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 简化的图标指示
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF5DADE2).withOpacity(0.3),
                  const Color(0xFF3498DB).withOpacity(0.2),
                ],
              ),
              border: Border.all(
                color: const Color(0xFF5DADE2).withOpacity(0.5),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.open_with,
              color: Color(0xFF5DADE2),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterInfoArea(RobotProvider provider) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 视频预览区域 - 更大更精致
          Container(
            width: 240,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.8),
                ],
              ),
              border: Border.all(
                color: const Color(0xFF5DADE2).withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                // 背景装饰
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF5DADE2).withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.videocam_off_outlined,
                      color: Colors.white.withOpacity(0.3),
                      size: 40,
                    ),
                  ),
                ),
                // 简化的状态指示
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE74C3C),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE74C3C).withOpacity(0.6),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // 简化速度显示
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF27AE60).withOpacity(0.2),
                  const Color(0xFF2ECC71).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF27AE60).withOpacity(0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF27AE60).withOpacity(0.2),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.speed,
                  color: const Color(0xFF27AE60),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  provider.robotState.status == RobotStatus.walking ? '0.8' : '0.0',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'm/s',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightJoystickArea(RobotProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 摇杆外围发光效果
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9B59B6).withOpacity(0.3),
                  blurRadius: 40,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 外圈装饰
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.08),
                        Colors.white.withOpacity(0.02),
                      ],
                    ),
                    border: Border.all(
                      color: const Color(0xFF9B59B6).withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                ),
                // 中圈
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
                // 摇杆组件
                SizedBox(
                  width: 180,
                  height: 180,
                  child: Joystick(
                    enabled: provider.isConnected,
                    onDirectionChanged: (x, y) {
                      // 右摇杆控制姿态
                      if (y > 0.3) {
                        // 抬头
                      } else if (y < -0.3) {
                        // 低头
                      }
                    },
                    label: '',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 简化的图标指示
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF9B59B6).withOpacity(0.3),
                  const Color(0xFF8E44AD).withOpacity(0.2),
                ],
              ),
              border: Border.all(
                color: const Color(0xFF9B59B6).withOpacity(0.5),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.rotate_right,
              color: Color(0xFF9B59B6),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(RobotProvider provider) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            Icons.chair_alt,
            '坐下',
            const Color(0xFF3498DB),
            provider.robotState.status == RobotStatus.sitting,
            () => provider.sit(),
          ),
          _buildActionButton(
            Icons.hotel,
            '躺下',
            const Color(0xFF9B59B6),
            provider.robotState.status == RobotStatus.lying,
            () => provider.layDown(),
          ),
          _buildActionButton(
            Icons.directions_walk,
            '站立',
            const Color(0xFF27AE60),
            provider.robotState.status == RobotStatus.idle,
            () => provider.stopMovement(),
          ),
          _buildActionButton(
            Icons.person_pin,
            '跟随',
            const Color(0xFFE67E22),
            provider.robotState.status == RobotStatus.following,
            () => provider.follow(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color color,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.4),
                    color.withOpacity(0.2),
                  ],
                )
              : null,
          color: isActive ? null : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isActive ? color.withOpacity(0.8) : Colors.white.withOpacity(0.2),
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: isActive ? color : Colors.white.withOpacity(0.7),
          size: 36,
        ),
      ),
    );
  }

  Widget _buildEmergencyStop(RobotProvider provider) {
    return GestureDetector(
      onTap: () {
        provider.stopMovement();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('紧急停止'),
            backgroundColor: Color(0xFFE74C3C),
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Color(0xFFE74C3C),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xFFE74C3C),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.stop,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
