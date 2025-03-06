import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/core.dart';
import 'data/datasource/attendance_remote_datasource.dart';
import 'data/datasource/auth_remote_datasource.dart';
import 'presentation/auth/bloc/login/login_bloc.dart';
import 'presentation/auth/bloc/logout/logout_bloc.dart';
import 'presentation/auth/splash_page.dart';
import 'presentation/home/bloc/checkin_attendace/checkin_attendance_bloc.dart';
import 'presentation/home/bloc/checkout_attendace/checkout_attendance_bloc.dart';
import 'presentation/home/bloc/get_company/get_company_bloc.dart';
import 'presentation/home/bloc/update_user_register_face/update_user_register_face_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
//const SplashPage()
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
            create: (context) =>
                UpdateUserRegisterFaceBloc(AuthRemoteDatasource())),
        BlocProvider(
            create: (context) =>
                CheckinAttendanceBloc(AttendanceRemoteDatasource())),
        BlocProvider(
            create: (context) =>
                CheckoutAttendanceBloc(AttendanceRemoteDatasource())),
        BlocProvider(
            create: (context) =>
                GetCompanyBloc(AttendanceRemoteDatasource())),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Intensive Club batch 16',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            dividerTheme:
                DividerThemeData(color: AppColors.light.withAlpha(0x50)),
            dialogTheme: const DialogTheme(elevation: 0),
            textTheme: GoogleFonts.kumbhSansTextTheme(
              Theme.of(context).textTheme,
            ),
            appBarTheme: AppBarTheme(
              centerTitle: true,
              color: AppColors.white,
              elevation: 0,
              titleTextStyle: GoogleFonts.kumbhSans(
                color: AppColors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          home: const SplashPage()),
    );
  }
}
