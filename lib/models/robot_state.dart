enum RobotStatus {
  idle,
  walking,
  sitting,
  lying,
  following,
}

class RobotState {
  final int battery;
  final int temperature;
  final int signalStrength;
  final RobotStatus status;

  RobotState({
    required this.battery,
    required this.temperature,
    required this.signalStrength,
    required this.status,
  });

  RobotState copyWith({
    int? battery,
    int? temperature,
    int? signalStrength,
    RobotStatus? status,
  }) {
    return RobotState(
      battery: battery ?? this.battery,
      temperature: temperature ?? this.temperature,
      signalStrength: signalStrength ?? this.signalStrength,
      status: status ?? this.status,
    );
  }

  String get statusText {
    switch (status) {
      case RobotStatus.idle:
        return '待机';
      case RobotStatus.walking:
        return '行走中';
      case RobotStatus.sitting:
        return '坐下';
      case RobotStatus.lying:
        return '躺下';
      case RobotStatus.following:
        return '跟随中';
    }
  }
}
