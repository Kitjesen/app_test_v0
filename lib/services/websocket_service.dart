import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

enum ConnectionStatus {
  disconnected,
  connecting,
  connected,
  error,
}

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  WebSocketChannel? _channel;
  ConnectionStatus _status = ConnectionStatus.disconnected;
  String? _currentUrl;
  Timer? _reconnectTimer;
  
  // Stream controllers
  final _statusController = StreamController<ConnectionStatus>.broadcast();
  final _messageController = StreamController<dynamic>.broadcast();
  
  Stream<ConnectionStatus> get statusStream => _statusController.stream;
  Stream<dynamic> get messageStream => _messageController.stream;
  ConnectionStatus get currentStatus => _status;

  Future<void> connect(String url) async {
    if (_status == ConnectionStatus.connected && _currentUrl == url) return;
    
    _currentUrl = url;
    _updateStatus(ConnectionStatus.connecting);
    
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      
      // 等待连接建立
      await _channel!.ready;
      
      _updateStatus(ConnectionStatus.connected);
      _cancelReconnectTimer();
      
      _channel!.stream.listen(
        (message) {
          _messageController.add(message);
        },
        onError: (error) {
          print('WebSocket Error: $error');
          _handleDisconnect();
        },
        onDone: () {
          print('WebSocket Closed');
          _handleDisconnect();
        },
      );
    } catch (e) {
      print('WebSocket Connection Failed: $e');
      _updateStatus(ConnectionStatus.error);
      _scheduleReconnect();
    }
  }

  void disconnect() {
    _cancelReconnectTimer();
    _channel?.sink.close(status.goingAway);
    _channel = null;
    _updateStatus(ConnectionStatus.disconnected);
  }

  void send(dynamic data) {
    if (_status == ConnectionStatus.connected && _channel != null) {
      try {
        final message = data is String ? data : jsonEncode(data);
        _channel!.sink.add(message);
      } catch (e) {
        print('Send Error: $e');
      }
    } else {
      print('Cannot send: Not connected');
    }
  }

  void _updateStatus(ConnectionStatus status) {
    _status = status;
    _statusController.add(status);
  }

  void _handleDisconnect() {
    if (_status != ConnectionStatus.disconnected) {
      _updateStatus(ConnectionStatus.error);
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _cancelReconnectTimer();
    if (_currentUrl != null) {
      print('Scheduling reconnect in 3 seconds...');
      _reconnectTimer = Timer(const Duration(seconds: 3), () {
        print('Attempting to reconnect...');
        connect(_currentUrl!);
      });
    }
  }

  void _cancelReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  void dispose() {
    disconnect();
    _statusController.close();
    _messageController.close();
  }
}
