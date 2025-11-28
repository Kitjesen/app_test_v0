import 'package:flutter/material.dart';
import '../services/local_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _controlSensitivity = 0.7;
  bool _reverseYAxis = false;
  bool _touchFeedback = true;
  String _videoQuality = '1080p (1920×1080)';
  String _frameRate = '60 FPS';
  bool _autoRecord = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final sensitivity = await LocalStorage.getControlSensitivity();
    final videoQuality = await LocalStorage.getVideoQuality();
    
    setState(() {
      _controlSensitivity = sensitivity;
      _videoQuality = videoQuality == 'HD' ? '1080p (1920×1080)' : '720p (1280×720)';
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    await LocalStorage.saveControlSensitivity(_controlSensitivity);
    await LocalStorage.saveVideoQuality(
      _videoQuality.contains('1080p') ? 'HD' : 'SD'
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('设置已保存'),
            ],
          ),
          backgroundColor: Color(0xFF27AE60),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Header
          _buildHeader(),
          // Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // 控制设置
                _buildSectionTitle(Icons.tune, '控制设置', const Color(0xFFE67E22)),
                const SizedBox(height: 12),
                _buildSettingCard(
                  children: [
                    _buildSliderSetting(
                      title: '控制灵敏度',
                      value: _controlSensitivity,
                      valueLabel: '${(_controlSensitivity * 100).toInt()}%',
                      onChanged: (v) {
                        setState(() => _controlSensitivity = v);
                        _saveSettings();
                      },
                    ),
                    const Divider(height: 32),
                    _buildSwitchSetting(
                      title: '反转Y轴',
                      subtitle: '反转垂直操杆方向',
                      value: _reverseYAxis,
                      onChanged: (v) => setState(() => _reverseYAxis = v),
                    ),
                    const Divider(height: 24),
                    _buildSwitchSetting(
                      title: '触觉反馈',
                      subtitle: '操作时振动',
                      value: _touchFeedback,
                      onChanged: (v) => setState(() => _touchFeedback = v),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // 视频设置
                _buildSectionTitle(Icons.videocam, '视频设置', const Color(0xFF9B59B6)),
                const SizedBox(height: 12),
                _buildSettingCard(
                  children: [
                    _buildDropdownSetting(
                      title: '视频质量',
                      value: _videoQuality,
                      items: ['720p (1280×720)', '1080p (1920×1080)', '4K (3840×2160)'],
                      onChanged: (v) => setState(() => _videoQuality = v!),
                    ),
                    const Divider(height: 24),
                    _buildDropdownSetting(
                      title: '帧率',
                      value: _frameRate,
                      items: ['30 FPS', '60 FPS', '120 FPS'],
                      onChanged: (v) => setState(() => _frameRate = v!),
                    ),
                    const Divider(height: 24),
                    _buildSwitchSetting(
                      title: '自动录制',
                      subtitle: '任务期间录制',
                      value: _autoRecord,
                      onChanged: (v) => setState(() => _autoRecord = v),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // 安全设置
                _buildSectionTitle(Icons.security, '安全设置', const Color(0xFF3498DB)),
                const SizedBox(height: 12),
                _buildSettingCard(
                  children: [
                    _buildSwitchSetting(
                      title: '低电量自动返回',
                      subtitle: '15%时返回',
                      value: true,
                      onChanged: (v) {},
                    ),
                    const Divider(height: 24),
                    _buildSwitchSetting(
                      title: '避障',
                      subtitle: '自动检测障碍物',
                      value: true,
                      onChanged: (v) {},
                    ),
                    const Divider(height: 24),
                    _buildSwitchSetting(
                      title: '紧急停止',
                      subtitle: '信号丢失时停止',
                      value: true,
                      onChanged: (v) {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // 关于
                _buildSectionTitle(Icons.info_outline, '关于', const Color(0xFF95A5A6)),
                const SizedBox(height: 12),
                _buildSettingCard(
                  children: [
                    _buildInfoRow('应用版本', '3.0.0'),
                    const Divider(height: 24),
                    _buildInfoRow('机器人型号', '大算机器人 OW'),
                    const Divider(height: 24),
                    _buildInfoRow('序列号', 'OW-2025-001'),
                  ],
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
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
          '设置',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildSliderSetting({
    required String title,
    required double value,
    required String valueLabel,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
            Text(
              valueLabel,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE67E22),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: const Color(0xFFE67E22),
            inactiveTrackColor: const Color(0xFFECF0F1),
            thumbColor: const Color(0xFFE67E22),
            overlayColor: const Color(0xFFE67E22).withOpacity(0.2),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            onChanged: onChanged,
            min: 0,
            max: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchSetting({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF95A5A6),
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF27AE60),
        ),
      ],
    );
  }

  Widget _buildDropdownSetting({
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF7F8C8D),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }
}
