class AttendanceRecordModel {
  DateTime date;
  String timeIn;
  String timeOut;
  String latLonIn;
  String latLonOut;

  AttendanceRecordModel({
    required this.date,
    required this.timeIn,
    required this.timeOut,
    required this.latLonIn,
    required this.latLonOut,
  });

  factory AttendanceRecordModel.fromMap(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      date: DateTime.parse(json['date']),
      timeIn: json['time_in'],
      timeOut: json['time_out'],
      latLonIn: json['latlon_in'],
      latLonOut: json['latlon_out'],
    );
  }
}
