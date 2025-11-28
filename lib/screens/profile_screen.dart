import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/robot_provider.dart';
import 'settings_screen.dart';
import 'health_screen.dart';
import 'gallery_screen.dart';
import 'model_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RobotProvider>(
      builder: (context, robotProvider, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF0A0E14),
          body: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // 用户信息卡片
                    _buildUserCard(),
                    const SizedBox(height: 20),

                    // 设备信息
                    _buildSectionTitle('我的设备'),
                    const SizedBox(height: 12),
                    _buildDeviceCard(robotProvider),
                    const SizedBox(height: 20),

                    // 功能列表
                    _buildSectionTitle('更多功能'),
                    const SizedBox(height: 12),
                    _buildFunctionList(context),
                    const SizedBox(height: 20),

                    // 设置入口
                    _buildSectionTitle('设置'),
                    const SizedBox(height: 12),
                    _buildSettingsList(context),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
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
      child: const SafeArea(
        bottom: false,
        child: Text(
          '我的',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3498DB), Color(0xFF5DADE2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3498DB).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '用户',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '点击登录获取更多功能',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white70),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2C3E50),
      ),
    );
  }

  Widget _buildDeviceCard(RobotProvider provider) {
    return Container(
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
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: provider.isConnected
                  ? const Color(0xFF27AE60).withOpacity(0.1)
                  : const Color(0xFF95A5A6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.pets,
              color: provider.isConnected
                  ? const Color(0xFF27AE60)
                  : const Color(0xFF95A5A6),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '大算机器人 OW-001',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: provider.isConnected
                            ? const Color(0xFF27AE60)
                            : const Color(0xFF95A5A6),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      provider.isConnected ? '在线' : '离线',
                      style: TextStyle(
                        fontSize: 13,
                        color: provider.isConnected
                            ? const Color(0xFF27AE60)
                            : const Color(0xFF95A5A6),
                      ),
                    ),
                    if (provider.isConnected) ...[
                      const Text(' · ', style: TextStyle(color: Color(0xFF95A5A6))),
                      Text(
                        '电量 ${provider.robotState.battery}%',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF95A5A6),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFFBDC3C7)),
        ],
      ),
    );
  }

  Widget _buildFunctionList(BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          _buildListItem(
            icon: Icons.favorite,
            title: '健康监控',
            subtitle: '查看机器狗健康状态',
            color: const Color(0xFFE74C3C),
            onTap: () => _navigateTo(context, const HealthScreen()),
          ),
          _buildDivider(),
          _buildListItem(
            icon: Icons.photo_library,
            title: '媒体图库',
            subtitle: '查看照片和视频',
            color: const Color(0xFF9B59B6),
            onTap: () => _navigateTo(context, const GalleryScreen()),
          ),
          _buildDivider(),
          _buildListItem(
            icon: Icons.view_in_ar,
            title: '3D模型',
            subtitle: '查看机器狗3D模型',
            color: const Color(0xFF3498DB),
            onTap: () => _navigateTo(context, const ModelScreen()),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          _buildListItem(
            icon: Icons.settings,
            title: '设置',
            subtitle: '控制、视频、安全设置',
            color: const Color(0xFF7F8C8D),
            onTap: () => _navigateTo(context, const SettingsScreen()),
          ),
          _buildDivider(),
          _buildListItem(
            icon: Icons.help_outline,
            title: '帮助中心',
            subtitle: '常见问题和使用指南',
            color: const Color(0xFF3498DB),
            onTap: () {},
          ),
          _buildDivider(),
          _buildListItem(
            icon: Icons.info_outline,
            title: '关于',
            subtitle: '版本 3.0.0',
            color: const Color(0xFF95A5A6),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2C3E50),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF95A5A6),
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFFBDC3C7)),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 76);
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}
