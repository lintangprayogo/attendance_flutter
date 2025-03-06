import '../../../core/extensions/date_time_ext.dart';

class CheckinRequest {
  String latitude;
  String longitude;
  DateTime date;

  CheckinRequest({
    required this.latitude,
    required this.longitude,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'date': date.toFormattedServerDate(),
      'time_in': date.toFormattedServerTime(),
    };
  }
}
