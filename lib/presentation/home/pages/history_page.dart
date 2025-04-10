import 'package:calendar_timeline_sbk/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/components/spaces copy.dart';
import '../../../core/constants/colors.dart';
import '../bloc/get_attendance_by_date/get_attendance_by_date_bloc.dart';
import '../widgets/history_attendace.dart';
import '../widgets/history_location.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    context
        .read<GetAttendanceByDateBloc>()
        .add(GetAttendanceByDateEvent.getAttendanceByDate(currentDate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18.0),
        children: [
          CalendarTimeline(
            initialDate: DateTime.now(),
            firstDate: DateTime(2019, 1, 15),
            lastDate: DateTime.now().add(const Duration(days: 7)),
            onDateSelected: (date) {
              final selectedDate = DateFormat('yyyy-MM-dd').format(date);

              context.read<GetAttendanceByDateBloc>().add(
                    GetAttendanceByDateEvent.getAttendanceByDate(selectedDate),
                  );
            },
            leftMargin: 20,
            monthColor: AppColors.grey,
            dayColor: AppColors.black,
            activeDayColor: Colors.white,
            activeBackgroundDayColor: AppColors.primary,
            showYears: true,
            shrink: true,
          ),
          const SpaceHeight(45.0),
          BlocBuilder<GetAttendanceByDateBloc, GetAttendanceByDateState>(
              builder: (context, state) {
            return state.maybeWhen(
                orElse: () {
                  return const SizedBox.shrink();
                },
                error: (error) {
                  return Center(
                    child: Text(error),
                  );
                },
                loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                empty: () {
                  return const Center(
                    child: Center(child: Text('No Attendance Available')),
                  );
                },
                loaded: (attendance) {
                  final latLotin = attendance.latLonIn ?? '';
                  final latLotOut = attendance.latLonOut ?? '';

                  final latitudeInPart =
                      latLotin.split(',').firstOrNull ?? '0.0';
                  final longitudeInPart =
                      latLotin.split(',').lastOrNull ?? '0.0';

                  final latitudeOutPart =
                      latLotOut.split(',').firstOrNull ?? '0.0';
                  final longitudeOutPart =
                      latLotOut.split(',').lastOrNull ?? '0.0';

                  final latitudeIn = double.tryParse(latitudeInPart) ?? 0.0;
                  final longitudeIn = double.tryParse(longitudeInPart) ?? 0.0;

                  final latitudeOut = double.tryParse(latitudeOutPart) ?? 0.0;
                  final longitudeOut = double.tryParse(longitudeOutPart) ?? 0.0;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      HistoryAttendance(
                          time: attendance.timeIn ?? '',
                          date: attendance.date.toString(),
                          statusAbsen: 'Datang'),
                      const SpaceHeight(20.0),
                      HistoryLocation(
                          latitude: latitudeIn, longitude: longitudeIn),
                      const SpaceHeight(25.0),
                      HistoryAttendance(
                          isAttendanceIn: false,
                          time: attendance.timeOut ?? '',
                          date: attendance.date.toString(),
                          statusAbsen: 'Keluar'),
                      const SpaceHeight(20.0),
                      HistoryLocation(
                          isAttendance: false,
                          latitude: latitudeOut,
                          longitude: longitudeOut)
                    ],
                  );
                });
          })
        ],
      ),
    );
  }
}
