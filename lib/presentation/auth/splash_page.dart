import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../data/datasource/auth_local_datasource.dart';
import '../home/pages/main_page.dart';
import 'login_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: FutureBuilder(
          future: Future.delayed(
            const Duration(seconds: 2),
            () => AuthLocalDatasource().isAuth(),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == true) {
                return const MainPage();
              } else {
                return const LoginPage();
              }
            }
            return Column(
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Assets.images.logoWhite.image(),
                ),
                const Spacer(),
                Assets.images.logoCodeWithBahri.image(height: 70),
                const SpaceHeight(20.0),
              ],
            );
          }),
    );
  }
}
