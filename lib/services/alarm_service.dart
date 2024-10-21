import '../models/alarm_model.dart';

class AlarmService {
  static final List<Alarm> _alarms = [];

  static void addAlarm(Alarm alarm) {
    _alarms.add(alarm);
  }

  static List<Alarm> getAlarms() {
    return _alarms;
  }
}
