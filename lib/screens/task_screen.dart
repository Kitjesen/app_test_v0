import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/robot_provider.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  String? _runningTaskId;
  double _taskProgress = 0.0;

  final List<TaskInfo> _presetTasks = [
    TaskInfo(
      id: 'follow',
      icon: Icons.person_pin,
      title: '跟随模式',
      description: '机器狗跟随主人移动',
      color: const Color(0xFFE67E22),
      duration: '持续',
    ),
    TaskInfo(
      id: 'patrol',
      icon: Icons.route,
      title: '自动巡逻',
      description: '按照设定路线自动巡逻',
      color: const Color(0xFF3498DB),
      duration: '10分钟',
    ),
    TaskInfo(
      id: 'guard',
      icon: Icons.security,
      title: '守卫模式',
      description: '原地观察周围环境',
      color: const Color(0xFF9B59B6),
      duration: '持续',
    ),
    TaskInfo(
      id: 'return',
      icon: Icons.home,
      title: '返回充电',
      description: '自动回到充电基地',
      color: const Color(0xFF27AE60),
      duration: '5分钟',
    ),
  ];

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
                    // 标题
                    const Text(
                      '预设任务',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '选择预设任务快速执行',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF95A5A6),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 任务卡片列表
                    ..._presetTasks.map((task) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildTaskCard(task, robotProvider),
                        )),

                    const SizedBox(height: 20),

                    // 任务历史
                    _buildTaskHistory(),
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
          '任务',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(TaskInfo task, RobotProvider provider) {
    final isRunning = _runningTaskId == task.id;
    final isAnyRunning = _runningTaskId != null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isRunning ? Border.all(color: task.color, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: isRunning
                ? task.color.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: isRunning ? 15 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(20),
            leading: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: task.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(task.icon, color: task.color, size: 28),
            ),
            title: Text(
              task.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  task.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF95A5A6),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: task.color),
                    const SizedBox(width: 4),
                    Text(
                      task.duration,
                      style: TextStyle(
                        fontSize: 12,
                        color: task.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Container(
              width: 80,
              child: ElevatedButton(
                onPressed: (!provider.isConnected || (isAnyRunning && !isRunning))
                    ? null
                    : () => isRunning ? _stopTask(task.id) : _startTask(task.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isRunning ? const Color(0xFFE74C3C) : task.color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  isRunning ? '停止' : '开始',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          if (isRunning)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.play_circle_outline, color: task.color, size: 16),
                      const SizedBox(width: 8),
                      const Text(
                        '任务执行中...',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _taskProgress,
                      backgroundColor: task.color.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(task.color),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(_taskProgress * 100).toInt()}% 完成',
                        style: TextStyle(
                          fontSize: 12,
                          color: task.color,
                        ),
                      ),
                      Text(
                        '预计剩余 ${((1 - _taskProgress) * 10).toInt()} 分钟',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF95A5A6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTaskHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '任务历史',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('查看全部'),
            ),
          ],
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
          child: Column(
            children: [
              _buildHistoryItem(
                '跟随模式',
                '今天 14:30',
                '已完成',
                const Color(0xFF27AE60),
              ),
              const Divider(height: 24),
              _buildHistoryItem(
                '自动巡逻',
                '今天 10:15',
                '已完成',
                const Color(0xFF27AE60),
              ),
              const Divider(height: 24),
              _buildHistoryItem(
                '守卫模式',
                '昨天 16:00',
                '中途停止',
                const Color(0xFFF39C12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(String title, String time, String status, Color statusColor) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
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
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF95A5A6),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }

  void _startTask(String taskId) {
    setState(() {
      _runningTaskId = taskId;
      _taskProgress = 0.0;
    });

    // 模拟任务进度
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      if (_runningTaskId == taskId) {
        setState(() {
          _taskProgress += 0.05;
        });
        return _taskProgress < 1.0;
      }
      return false;
    }).then((_) {
      if (_runningTaskId == taskId) {
        _stopTask(taskId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('任务"${_presetTasks.firstWhere((t) => t.id == taskId).title}"已完成'),
            backgroundColor: const Color(0xFF27AE60),
          ),
        );
      }
    });
  }

  void _stopTask(String taskId) {
    setState(() {
      _runningTaskId = null;
      _taskProgress = 0.0;
    });
  }
}

class TaskInfo {
  final String id;
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final String duration;

  TaskInfo({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.duration,
  });
}
