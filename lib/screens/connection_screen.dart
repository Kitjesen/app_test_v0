import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/robot_provider.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _startScan() {
    setState(() {
      _isScanning = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RobotProvider>(
      builder: (context, robotProvider, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: Column(
            children: [
              _buildHeader(robotProvider),
              Expanded(
                child: Column(
                  children: [
                    // Tab Bar
                    Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: const Color(0xFF3498DB),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: const Color(0xFF7F8C8D),
                        dividerColor: Colors.transparent,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                        tabs: [
                          Tab(
                            height: 56,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.wifi, size: 20),
                                SizedBox(width: 8),
                                Text('Wi-Fi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          Tab(
                            height: 56,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.bluetooth, size: 20),
                                SizedBox(width: 8),
                                Text('蓝牙', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tab View
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildWiFiTab(robotProvider),
                          _buildBluetoothTab(robotProvider),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(RobotProvider provider) {
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
                color: provider.isConnected
                    ? const Color(0xFF27AE60).withOpacity(0.1)
                    : const Color(0xFF95A5A6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                provider.isConnected ? Icons.link : Icons.link_off,
                color: provider.isConnected
                    ? const Color(0xFF27AE60)
                    : const Color(0xFF95A5A6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.isConnected ? '已连接' : '连接设备',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  Text(
                    provider.isConnected ? '大算机器人 OW' : '选择连接方式',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF95A5A6),
                    ),
                  ),
                ],
              ),
            ),
            if (provider.isConnected)
              TextButton(
                onPressed: () {
                  provider.setConnected(false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('已断开连接'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  backgroundColor: const Color(0xFFFFE5E5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  '断开',
                  style: TextStyle(color: Color(0xFFE74C3C), fontWeight: FontWeight.w600),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWiFiTab(RobotProvider provider) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildScanSection(),
        const SizedBox(height: 20),
        _buildDeviceList(provider, 'WiFi'),
      ],
    );
  }

  Widget _buildBluetoothTab(RobotProvider provider) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildScanSection(),
        const SizedBox(height: 20),
        _buildDeviceList(provider, '蓝牙'),
      ],
    );
  }

  Widget _buildScanSection() {
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
          Expanded(
            child: Text(
              _isScanning ? '扫描中...' : '点击扫描附近设备',
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF7F8C8D),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _isScanning ? null : _startScan,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3498DB),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: _isScanning
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('扫描', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceList(RobotProvider provider, String type) {
    final devices = _isScanning
        ? []
        : [
            DeviceInfo('大算机器人 OW-001', '上次连接: 2分钟前', 92, true),
            DeviceInfo('大算机器人 OW-002', '上次连接: 1小时前', 78, false),
            DeviceInfo('大算机器人 OW-003', '从未连接', 65, false),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                '可用设备',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
            // 帮助按钮
            IconButton(
              icon: const Icon(Icons.help_outline, color: Color(0xFF3498DB)),
              onPressed: () => _showConnectionHelp(),
            ),
          ],
        ),
        // 设备列表或空状态
        if (_isScanning)
          _buildScanningState()
        else if (devices.isEmpty)
          _buildEmptyState(type)
        else
          ...devices.map((device) => _buildDeviceCard(device, provider, type)),
        
        // 手动连接选项
        const SizedBox(height: 12),
        _buildManualConnectionButton(type),
      ],
    );
  }

  Widget _buildScanningState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          const Text(
            '正在搜索附近的设备...',
            style: TextStyle(fontSize: 15, color: Color(0xFF7F8C8D)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String type) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECF0F1)),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF95A5A6).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              type == 'WiFi' ? Icons.wifi_off : Icons.bluetooth_disabled,
              size: 40,
              color: const Color(0xFF95A5A6),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '未找到可用设备',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            type == 'WiFi'
                ? '请确保机器人已开机并连接到同一WiFi'
                : '请确保机器人蓝牙已开启且在附近',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF95A5A6),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: _startScan,
            icon: const Icon(Icons.refresh),
            label: const Text('重新扫描'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF3498DB),
              side: const BorderSide(color: Color(0xFF3498DB)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManualConnectionButton(String type) {
    if (type != 'WiFi') return const SizedBox();
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECF0F1)),
      ),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF9B59B6).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.edit, color: Color(0xFF9B59B6)),
        ),
        title: const Text(
          '手动输入IP地址',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        subtitle: const Text(
          '适用于自定义网络配置',
          style: TextStyle(fontSize: 13, color: Color(0xFF95A5A6)),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF95A5A6)),
        onTap: () => _showManualConnectionDialog(),
      ),
    );
  }

  void _showConnectionHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF3498DB).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.help_outline, color: Color(0xFF3498DB)),
            ),
            const SizedBox(width: 12),
            const Text('连接帮助', style: TextStyle(fontSize: 18)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpItem('1', '确保机器人已开机', '长按电源键3秒，等待指示灯亮起'),
              const SizedBox(height: 16),
              _buildHelpItem('2', '检查连接方式', 'WiFi需要同一网络，蓝牙需要在10米范围内'),
              const SizedBox(height: 16),
              _buildHelpItem('3', '点击扫描按钮', '等待2-5秒，设备会自动出现在列表中'),
              const SizedBox(height: 16),
              _buildHelpItem('4', '选择设备连接', '点击设备卡片，等待连接成功提示'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('知道了', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String number, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF3498DB),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
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
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF7F8C8D),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showManualConnectionDialog() {
    final ipController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('手动输入IP地址'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ipController,
              decoration: InputDecoration(
                labelText: 'IP地址',
                hintText: '例如: 192.168.1.100',
                prefixIcon: const Icon(Icons.computer),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: Color(0xFFF39C12), size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '请确保您的设备与机器人在同一网络',
                      style: TextStyle(fontSize: 12, color: Color(0xFF856404)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: 实现手动连接逻辑
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('正在连接到指定IP...')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3498DB),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('连接'),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(DeviceInfo device, RobotProvider provider, String type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: device.isRecommended ? Border.all(color: const Color(0xFF3498DB), width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF3498DB).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            type == 'WiFi' ? Icons.wifi : Icons.bluetooth,
            color: const Color(0xFF3498DB),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                device.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
            if (device.isRecommended)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF27AE60),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '推荐',
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Text(
                device.subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF95A5A6),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.signal_cellular_alt,
                size: 14,
                color: device.signal > 80
                    ? const Color(0xFF27AE60)
                    : device.signal > 50
                        ? const Color(0xFFF39C12)
                        : const Color(0xFFE74C3C),
              ),
              const SizedBox(width: 4),
              Text(
                '${device.signal}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: device.signal > 80
                      ? const Color(0xFF27AE60)
                      : device.signal > 50
                          ? const Color(0xFFF39C12)
                          : const Color(0xFFE74C3C),
                ),
              ),
            ],
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: () => _connectToDevice(device, provider),
      ),
    );
  }

  void _connectToDevice(DeviceInfo device, RobotProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text(
              '连接中...',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              device.name,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      // 关闭对话框
      Navigator.pop(context);
      
      // 设置连接状态
      provider.setConnected(true);
      
      // 显示成功提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text('已连接到 ${device.name}')),
            ],
          ),
          backgroundColor: const Color(0xFF27AE60),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      
      // 延迟一下再跳转，让用户看到成功提示
      Future.delayed(const Duration(milliseconds: 500), () {
        // 返回上一页（首页）
        if (Navigator.canPop(context)) {
          Navigator.pop(context, true); // 传递true表示连接成功
        }
      });
    });
  }
}

class DeviceInfo {
  final String name;
  final String subtitle;
  final int signal;
  final bool isRecommended;

  DeviceInfo(this.name, this.subtitle, this.signal, this.isRecommended);
}
