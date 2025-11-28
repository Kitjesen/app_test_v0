import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _keyLastDevice = 'last_device';
  static const String _keyControlSensitivity = 'control_sensitivity';
  static const String _keyVideoQuality = 'video_quality';
  static const String _keyAutoReconnect = 'auto_reconnect';
  static const String _keyLowPowerMode = 'low_power_mode';
  static const String _keyCollisionAvoidance = 'collision_avoidance';
  static const String _keyMaxSpeed = 'max_speed';
  static const String _keyFirstLaunch = 'first_launch';

  // 保存上次连接的设备
  static Future<void> saveLastDevice(String deviceName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastDevice, deviceName);
  }

  // 获取上次连接的设备
  static Future<String?> getLastDevice() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastDevice);
  }

  // 保存控制灵敏度
  static Future<void> saveControlSensitivity(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyControlSensitivity, value);
  }

  // 获取控制灵敏度
  static Future<double> getControlSensitivity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyControlSensitivity) ?? 0.5;
  }

  // 保存视频质量
  static Future<void> saveVideoQuality(String quality) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyVideoQuality, quality);
  }

  // 获取视频质量
  static Future<String> getVideoQuality() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyVideoQuality) ?? 'HD';
  }

  // 保存自动重连
  static Future<void> saveAutoReconnect(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAutoReconnect, enabled);
  }

  // 获取自动重连
  static Future<bool> getAutoReconnect() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAutoReconnect) ?? true;
  }

  // 保存低功耗模式
  static Future<void> saveLowPowerMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLowPowerMode, enabled);
  }

  // 获取低功耗模式
  static Future<bool> getLowPowerMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLowPowerMode) ?? false;
  }

  // 保存避障功能
  static Future<void> saveCollisionAvoidance(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyCollisionAvoidance, enabled);
  }

  // 获取避障功能
  static Future<bool> getCollisionAvoidance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyCollisionAvoidance) ?? true;
  }

  // 保存最大速度
  static Future<void> saveMaxSpeed(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyMaxSpeed, value);
  }

  // 获取最大速度
  static Future<double> getMaxSpeed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyMaxSpeed) ?? 1.0;
  }

  // 保存首次启动标记
  static Future<void> setFirstLaunchCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFirstLaunch, false);
  }

  // 检查是否首次启动
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyFirstLaunch) ?? true;
  }

  // 保存所有设置
  static Future<void> saveAllSettings({
    required double controlSensitivity,
    required String videoQuality,
    required bool autoReconnect,
    required bool lowPowerMode,
    required bool collisionAvoidance,
    required double maxSpeed,
  }) async {
    await Future.wait([
      saveControlSensitivity(controlSensitivity),
      saveVideoQuality(videoQuality),
      saveAutoReconnect(autoReconnect),
      saveLowPowerMode(lowPowerMode),
      saveCollisionAvoidance(collisionAvoidance),
      saveMaxSpeed(maxSpeed),
    ]);
  }

  // 重置所有设置为默认值
  static Future<void> resetToDefaults() async {
    await saveAllSettings(
      controlSensitivity: 0.5,
      videoQuality: 'HD',
      autoReconnect: true,
      lowPowerMode: false,
      collisionAvoidance: true,
      maxSpeed: 1.0,
    );
  }

  // 清除所有数据
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
