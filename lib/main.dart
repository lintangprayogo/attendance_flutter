import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/core.dart';
import 'presentation/auth/login/login_bloc.dart';
import 'presentation/auth/logout/logout_bloc.dart';
import 'ui/auth/splash_page.dart';

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
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Intensive Club batch 16',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            dividerTheme:
                DividerThemeData(color: AppColors.light.withOpacity(0.5)),
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
