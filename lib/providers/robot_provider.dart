import 'package:flutter/foundation.dart';
import '../models/robot_state.dart';

class RobotProvider extends ChangeNotifier {
  bool _isConnected = false;
  RobotState _robotState = RobotState(
    battery: 85,
    temperature: 42,
    signalStrength: 87,
    status: RobotStatus.idle,
  );

  bool get isConnected => _isConnected;
  RobotState get robotState => _robotState;

  void setConnected(bool connected) {
    _isConnected = connected;
    notifyListeners();
  }

  void updateRobotState(RobotState newState) {
    _robotState = newState;
    notifyListeners();
  }

  void updateBattery(int battery) {
    _robotState = _robotState.copyWith(battery: battery);
    notifyListeners();
  }

  void updateTemperature(int temperature) {
    _robotState = _robotState.copyWith(temperature: temperature);
    notifyListeners();
  }

  void updateSignalStrength(int signalStrength) {
    _robotState = _robotState.copyWith(signalStrength: signalStrength);
    notifyListeners();
  }

  void updateStatus(RobotStatus status) {
    _robotState = _robotState.copyWith(status: status);
    notifyListeners();
  }

  // 控制命令
  void moveForward() {
    updateStatus(RobotStatus.walking);
    // TODO: 发送前进命令
  }

  void moveBackward() {
    updateStatus(RobotStatus.walking);
    // TODO: 发送后退命令
  }

  void turnLeft() {
    updateStatus(RobotStatus.walking);
    // TODO: 发送左转命令
  }

  void turnRight() {
    updateStatus(RobotStatus.walking);
    // TODO: 发送右转命令
  }

  void sit() {
    updateStatus(RobotStatus.sitting);
    // TODO: 发送坐下命令
  }

  void layDown() {
    updateStatus(RobotStatus.lying);
    // TODO: 发送躺下命令
  }

  void follow() {
    updateStatus(RobotStatus.following);
    // TODO: 发送跟随命令
  }

  void stopMovement() {
    updateStatus(RobotStatus.idle);
    // TODO: 发送停止命令
  }
}
