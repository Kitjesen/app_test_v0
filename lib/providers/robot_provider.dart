import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/robot_state.dart';
import '../services/websocket_service.dart';

class RobotProvider extends ChangeNotifier {
  final WebSocketService _wsService = WebSocketService();
  bool _isConnected = false;
  RobotState _robotState = RobotState(
    battery: 0,
    temperature: 0,
    signalStrength: 0,
    status: RobotStatus.idle,
  );

  RobotProvider() {
    _initService();
  }

  bool get isConnected => _isConnected;
  RobotState get robotState => _robotState;

  void _initService() {
    _wsService.statusStream.listen((status) {
      final connected = status == ConnectionStatus.connected;
      if (_isConnected != connected) {
        _isConnected = connected;
        notifyListeners();
      }
    });

    _wsService.messageStream.listen((message) {
      _parseMessage(message);
    });
  }

  Future<void> connect(String ip, String port) async {
    final url = 'ws://$ip:$port';
    await _wsService.connect(url);
  }

  void disconnect() {
    _wsService.disconnect();
  }

  void setConnected(bool connected) {
    // 仅用于测试或手动强制状态，实际应由 WebSocket 状态决定
    if (connected) {
      // 模拟连接本地测试服务
      connect('127.0.0.1', '8080');
    } else {
      disconnect();
    }
  }

  void _parseMessage(dynamic message) {
    try {
      final data = jsonDecode(message);
      // 假设收到的数据格式: {"battery": 80, "temp": 45, "signal": 90, "status": "idle"}
      // 实际需根据机器人协议调整
      if (data is Map<String, dynamic>) {
        int? battery = data['battery'];
        int? temp = data['temp'];
        int? signal = data['signal'];
        String? statusStr = data['status'];
        
        RobotStatus? newStatus;
        if (statusStr != null) {
          // 简单映射，根据实际协议修改
          if (statusStr == 'walking') newStatus = RobotStatus.walking;
          else if (statusStr == 'sitting') newStatus = RobotStatus.sitting;
          else if (statusStr == 'lying') newStatus = RobotStatus.lying;
          else if (statusStr == 'following') newStatus = RobotStatus.following;
          else newStatus = RobotStatus.idle;
        }

        _robotState = _robotState.copyWith(
          battery: battery,
          temperature: temp,
          signalStrength: signal,
          status: newStatus,
        );
        notifyListeners();
      }
    } catch (e) {
      print('Error parsing message: $e');
    }
  }

  // 发送通用命令
  void sendCommand(String cmd, [Map<String, dynamic>? params]) {
    final Map<String, dynamic> data = {'cmd': cmd};
    if (params != null) {
      data.addAll(params);
    }
    _wsService.send(data);
  }

  // --- 控制命令 ---

  void moveForward() {
    updateStatus(RobotStatus.walking);
    sendCommand('move', {'direction': 'forward'});
  }

  void moveBackward() {
    updateStatus(RobotStatus.walking);
    sendCommand('move', {'direction': 'backward'});
  }

  void turnLeft() {
    updateStatus(RobotStatus.walking);
    sendCommand('move', {'direction': 'turn_left'});
  }

  void turnRight() {
    updateStatus(RobotStatus.walking);
    sendCommand('move', {'direction': 'turn_right'});
  }

  void sit() {
    updateStatus(RobotStatus.sitting);
    sendCommand('action', {'type': 'sit'});
  }

  void layDown() {
    updateStatus(RobotStatus.lying);
    sendCommand('action', {'type': 'lie_down'});
  }

  void follow() {
    updateStatus(RobotStatus.following);
    sendCommand('mode', {'type': 'follow'});
  }

  void stopMovement() {
    updateStatus(RobotStatus.idle);
    sendCommand('move', {'direction': 'stop'});
  }

  // 兼容旧的单个状态更新方法，但主要应依赖 WebSocket 消息
  void updateStatus(RobotStatus status) {
    _robotState = _robotState.copyWith(status: status);
    notifyListeners();
  }
}
