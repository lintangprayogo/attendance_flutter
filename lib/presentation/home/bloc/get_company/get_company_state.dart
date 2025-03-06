part of 'get_company_bloc.dart';

@freezed
class GetCompanyState with _$GetCompanyState {
  const factory GetCompanyState.initial() = _Initial;
  const factory GetCompanyState.loaded() = _Loaded;
  const factory GetCompanyState.loading() = _Loading;
  const factory GetCompanyState.sucess(CompanyResponseModel company) = _Success;
  const factory GetCompanyState.error(String error) = _Error;
}
