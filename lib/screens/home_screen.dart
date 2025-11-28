import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/robot_provider.dart';
import 'connection_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onNavigateToControl;
  
  const HomeScreen({super.key, this.onNavigateToControl});

  void _onConnectionSuccess(BuildContext context) {
    if (onNavigateToControl != null) {
      onNavigateToControl!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RobotProvider>(
      builder: (context, robotProvider, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF0A0E14),
          body: Column(
            children: [
              _buildHeader(robotProvider, context),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // 欢迎语
                    Text(
                      robotProvider.isConnected
                          ? '一切就绪 ✨'
                          : '欢迎回来 👋',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      robotProvider.isConnected
                          ? '您的机器狗已连接，随时待命'
                          : '连接您的机器狗开始使用',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF95A5A6),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 连接状态卡片
                    _buildConnectionCard(robotProvider, context),
                    const SizedBox(height: 16),

                    // 快捷功能
                    if (robotProvider.isConnected) ...[
                      _buildQuickActions(context, robotProvider),
                      const SizedBox(height: 16),
                      _buildStatusOverview(robotProvider),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(RobotProvider provider, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5DADE2), Color(0xFF3498DB)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'OW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '大算机器人',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  Text(
                    'Control System v3.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF95A5A6),
                    ),
                  ),
                ],
              ),
            ),
            // 通知按钮
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, color: Color(0xFF7F8C8D)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionCard(RobotProvider provider, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ConnectionScreen()),
        );
        // 如果连接成功，通知父组件切换到控制页面
        if (result == true && context.mounted) {
          // 使用回调通知MainScreen切换Tab
          _onConnectionSuccess(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: provider.isConnected
                ? [const Color(0xFF27AE60), const Color(0xFF2ECC71)]
                : [const Color(0xFF95A5A6), const Color(0xFFBDC3C7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (provider.isConnected
                      ? const Color(0xFF27AE60)
                      : const Color(0xFF95A5A6))
                  .withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                provider.isConnected ? Icons.link : Icons.link_off,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.isConnected ? '已连接' : '未连接',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    provider.isConnected
                        ? '大算机器人 OW-001'
                        : '点击这里连接您的机器狗',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white.withOpacity(0.8),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, RobotProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '快捷操作',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.gamepad,
                title: '开始控制',
                color: const Color(0xFF3498DB),
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
                  // 跳转到控制Tab
                  if (onNavigateToControl != null) {
                    onNavigateToControl!();
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.route,
                title: '自动巡逻',
                color: const Color(0xFF9B59B6),
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
                  // 执行巡逻任务
                  provider.follow();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.route, color: Colors.white),
                          SizedBox(width: 12),
                          Text('巡逻模式已启动'),
                        ],
                      ),
                      backgroundColor: Color(0xFF9B59B6),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.person_pin,
                title: '跟随模式',
                color: const Color(0xFFE67E22),
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
                  provider.follow();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.person_pin, color: Colors.white),
                          SizedBox(width: 12),
                          Text('跟随模式已启动'),
                        ],
                      ),
                      backgroundColor: Color(0xFFE67E22),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.home,
                title: '返回基地',
                color: const Color(0xFF27AE60),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.home, color: Colors.white),
                          SizedBox(width: 12),
                          Text('正在返回充电基地...'),
                        ],
                      ),
                      backgroundColor: Color(0xFF27AE60),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOverview(RobotProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '状态总览',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatusItem(
                Icons.battery_charging_full,
                '${provider.robotState.battery}%',
                '电量',
                provider.robotState.battery < 20
                    ? const Color(0xFFE74C3C)
                    : const Color(0xFF27AE60),
              ),
              _buildDivider(),
              _buildStatusItem(
                Icons.thermostat,
                '${provider.robotState.temperature}°C',
                '温度',
                provider.robotState.temperature > 50
                    ? const Color(0xFFE74C3C)
                    : const Color(0xFF3498DB),
              ),
              _buildDivider(),
              _buildStatusItem(
                Icons.signal_cellular_alt,
                '${provider.robotState.signalStrength}%',
                '信号',
                provider.robotState.signalStrength < 30
                    ? const Color(0xFFE74C3C)
                    : const Color(0xFF27AE60),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF95A5A6),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 50,
      color: const Color(0xFFECF0F1),
    );
  }
}
