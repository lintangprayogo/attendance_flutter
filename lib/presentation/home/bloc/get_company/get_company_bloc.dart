import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/model/company/company_response_model.dart';

part 'get_company_event.dart';
part 'get_company_state.dart';
part 'get_company_bloc.freezed.dart';
class GetCompanyBloc extends Bloc<GetCompanyEvent, GetCompanyState> {
  GetCompanyBloc() : super(const _Initial()) {
    on<GetCompanyEvent>((event, emit) {
    });
  }
}
