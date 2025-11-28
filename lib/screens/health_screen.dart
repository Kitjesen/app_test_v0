import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/robot_provider.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RobotProvider>(
      builder: (context, robotProvider, _) {
        final robotState = robotProvider.robotState;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 总体健康状况
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: CircularProgressIndicator(
                              value: _calculateHealthScore(robotState) / 100,
                              strokeWidth: 12,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getHealthColor(_calculateHealthScore(robotState)),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${_calculateHealthScore(robotState).toInt()}',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '健康分数',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _getHealthStatus(_calculateHealthScore(robotState)),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // 详细指标
              _buildMetricCard(
                icon: Icons.battery_charging_full,
                title: '电池健康',
                value: robotState.battery,
                unit: '%',
                color: Colors.green,
                status: robotState.battery > 20 ? '良好' : '需要充电',
              ),
              const SizedBox(height: 12),
              _buildMetricCard(
                icon: Icons.thermostat,
                title: '温度',
                value: robotState.temperature,
                unit: '°C',
                color: robotState.temperature < 60 ? Colors.blue : Colors.orange,
                status: robotState.temperature < 60 ? '正常' : '偏高',
              ),
              const SizedBox(height: 12),
              _buildMetricCard(
                icon: Icons.signal_cellular_alt,
                title: '信号强度',
                value: robotState.signalStrength,
                unit: '%',
                color: Colors.purple,
                status: robotState.signalStrength > 50 ? '优秀' : '一般',
              ),
              const SizedBox(height: 20),
              
              // 运动统计
              const Text(
                '今日运动统计',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildStatRow('步行距离', '2.5', 'km'),
                      const SizedBox(height: 12),
                      _buildStatRow('运动时间', '45', '分钟'),
                      const SizedBox(height: 12),
                      _buildStatRow('消耗电量', '15', '%'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // 维护提醒
              const Text(
                '维护提醒',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildMaintenanceCard(
                icon: Icons.build_outlined,
                title: '下次保养',
                description: '距离下次保养还有 15 天',
                color: Colors.blue,
              ),
              const SizedBox(height: 12),
              _buildMaintenanceCard(
                icon: Icons.cleaning_services_outlined,
                title: '清洁建议',
                description: '建议每周清洁一次机器狗',
                color: Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }

  double _calculateHealthScore(robotState) {
    double score = 0;
    score += robotState.battery * 0.4;
    score += (100 - (robotState.temperature - 30).abs()) * 0.3;
    score += robotState.signalStrength * 0.3;
    return score.clamp(0, 100);
  }

  Color _getHealthColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getHealthStatus(double score) {
    if (score >= 80) return '健康状态良好';
    if (score >= 60) return '状态一般';
    return '需要关注';
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required int value,
    required String unit,
    required Color color,
    required String status,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$value$unit',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, String unit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 15, color: Colors.grey[600]),
        ),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              unit,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMaintenanceCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
