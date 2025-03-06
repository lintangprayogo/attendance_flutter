import '../../../core/extensions/date_time_ext.dart';

class CheckoutRequest {
  String latitude;
  String longitude;
  DateTime date;

  CheckoutRequest({
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
