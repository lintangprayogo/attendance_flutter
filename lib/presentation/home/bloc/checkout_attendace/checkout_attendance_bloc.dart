import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasource/attendance_remote_datasource.dart';
import '../../../../data/model/request/check_out_request.dart';
import '../../../../data/model/response/attendance_response_model.dart';

part 'checkout_attendance_event.dart';
part 'checkout_attendance_state.dart';
part 'checkout_attendance_bloc.freezed.dart';

class CheckoutAttendanceBloc
    extends Bloc<CheckoutAttendanceEvent, CheckoutAttendanceState> {
 
  CheckoutAttendanceBloc(AttendanceRemoteDatasource dataSource) : super(const _Initial()) {
    on<_Checkout>((event, emit) async {
      final result = await dataSource.checkout(event.request);
      result.fold((l) {
        emit(_Error(l));
      }, (r) {
        emit(_Success(r));
      });
    });   
  }
}
