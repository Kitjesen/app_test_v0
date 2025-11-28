import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/robot_provider.dart';
import 'screens/home_screen.dart';
import 'screens/control_screen.dart';
import 'screens/task_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => RobotProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? _isFirstLaunch;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
    setState(() {
      _isFirstLaunch = !onboardingComplete;
    });
  }

  void _completeOnboarding() {
    setState(() {
      _isFirstLaunch = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstLaunch == null) {
      // 加载中
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3498DB).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.pets,
                    size: 48,
                    color: Color(0xFF3498DB),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '大算机器人 OW',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Control System v3.0',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF95A5A6),
                  ),
                ),
                const SizedBox(height: 32),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      title: '大算机器人 OW',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7FFF7F),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0A0E14),
      ),
      home: _isFirstLaunch!
          ? OnboardingScreen(onComplete: _completeOnboarding)
          : const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // 默认显示首页

  void _navigateToControl() {
    setState(() {
      _currentIndex = 1; // 切换到控制Tab
    });
  }

  // 精简为4个核心页面
  List<Widget> get _screens => [
    HomeScreen(onNavigateToControl: _navigateToControl),  // 首页：状态总览+连接
    const ControlScreen(),   // 控制：核心功能
    const TaskScreen(),      // 任务：预设任务
    const ProfileScreen(),   // 我的：设置+健康+图库+模型
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<RobotProvider>(
      builder: (context, robotProvider, _) {
        return Scaffold(
          body: Stack(
            children: [
              IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
              // 全局紧急停止按钮
              if (robotProvider.isConnected)
                Positioned(
                  right: 20,
                  bottom: 90,
                  child: _buildEmergencyStopButton(robotProvider),
                ),
            ],
          ),
          bottomNavigationBar: Container(
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF0F1419),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.05),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home_outlined, Icons.home),
                  _buildNavItem(1, Icons.calendar_today_outlined, Icons.calendar_today),
                  _buildNavItem(2, Icons.gamepad_outlined, Icons.gamepad),
                  _buildNavItem(3, Icons.show_chart_outlined, Icons.show_chart),
                  _buildNavItem(4, Icons.person_outline, Icons.person),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmergencyStopButton(RobotProvider provider) {
    return GestureDetector(
      onTap: () {
        provider.stopMovement();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('紧急停止已执行'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red,
          ),
        );
      },
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFFFF3B30),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF3B30).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
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

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon) {
    // 将第3个按钮（index=2）映射到控制页面（原_currentIndex=1）
    // 其他按钮映射到对应页面
    int targetIndex;
    if (index == 0) targetIndex = 0;      // Home
    else if (index == 1) targetIndex = 2; // Tasks (calendar)
    else if (index == 2) targetIndex = 1; // Control (gamepad) - 中间位置
    else if (index == 3) targetIndex = 2; // Tasks (chart)
    else targetIndex = 3;                 // Profile
    
    final isSelected = _currentIndex == targetIndex;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = targetIndex;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF2D4A2B)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                size: 28,
                color: isSelected
                    ? const Color(0xFF7FFF7F)
                    : const Color(0xFF8A92A6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConnectionDialog extends StatelessWidget {
  const ConnectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RobotProvider>(
      builder: (context, robotProvider, _) {
        return AlertDialog(
          title: const Text('连接状态'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                robotProvider.isConnected ? '已连接到机器狗' : '未连接',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              if (!robotProvider.isConnected)
                const Text(
                  '请确保机器狗已开机并处于配对模式',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
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
                robotProvider.setConnected(!robotProvider.isConnected);
                Navigator.pop(context);
              },
              child: Text(robotProvider.isConnected ? '断开连接' : '连接'),
            ),
          ],
        );
      },
    );
  }
}
