import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/robot_provider.dart';

class StatusPanel extends StatelessWidget {
  const StatusPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RobotProvider>(
      builder: (context, robotProvider, _) {
        final robotState = robotProvider.robotState;
        
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 状态指示
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '机器狗状态',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(robotState.status)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _getStatusColor(robotState.status)
                              .withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        robotState.statusText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(robotState.status),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // 三个指标
                Row(
                  children: [
                    Expanded(
                      child: _buildMetric(
                        icon: Icons.battery_charging_full,
                        label: '电量',
                        value: '${robotState.battery}%',
                        progress: robotState.battery / 100,
                        color: _getBatteryColor(robotState.battery),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetric(
                        icon: Icons.thermostat,
                        label: '温度',
                        value: '${robotState.temperature}°C',
                        progress: (robotState.temperature / 80).clamp(0.0, 1.0),
                        color: _getTemperatureColor(robotState.temperature),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetric(
                        icon: Icons.signal_cellular_alt,
                        label: '信号',
                        value: '${robotState.signalStrength}%',
                        progress: robotState.signalStrength / 100,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required String label,
    required String value,
    required double progress,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(status) {
    switch (status.toString()) {
      case 'RobotStatus.walking':
        return Colors.green;
      case 'RobotStatus.sitting':
        return Colors.orange;
      case 'RobotStatus.lying':
        return Colors.purple;
      case 'RobotStatus.following':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getBatteryColor(int battery) {
    if (battery > 50) return Colors.green;
    if (battery > 20) return Colors.orange;
    return Colors.red;
  }

  Color _getTemperatureColor(int temperature) {
    if (temperature > 60) return Colors.red;
    if (temperature > 50) return Colors.orange;
    return Colors.blue;
  }
}
