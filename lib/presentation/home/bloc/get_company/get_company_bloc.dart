import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasource/attendance_remote_datasource.dart';
import '../../../../data/model/company/company_response_model.dart';

part 'get_company_event.dart';
part 'get_company_state.dart';
part 'get_company_bloc.freezed.dart';

class GetCompanyBloc extends Bloc<GetCompanyEvent, GetCompanyState> {
  GetCompanyBloc(AttendanceRemoteDatasource dataSource)
      : super(const _Initial()) {
    on<_GetCompany>((event, emit) async {
      emit(const _Loading());
      final result = await dataSource.getCompanyProfile();
      result.fold((l) {
        emit(_Error(l));
      }, (r) {
        emit(_Success(r));
      });
    });
  }
}
