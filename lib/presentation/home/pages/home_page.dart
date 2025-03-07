import 'package:detect_fake_location/detect_fake_location.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../core/core.dart';
import '../../../data/datasource/auth_local_datasource.dart';
import '../widgets/menu_button.dart';
import 'attendance_check_in_page.dart';
import 'attendance_check_out_page.dart';
import 'register_face_attendance_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? faceEmbedding;
  var log = Logger();

  @override
  void initState() {
    _initializeFaceEmbedding();
    super.initState();
  }

  void _initializeFaceEmbedding() async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      setState(() {
        faceEmbedding = authData?.user.faceEmbedding;
      });
    } catch (e) {
      // Tangani error di sini jika ada masalah dalam mendapatkan authData
      log.d('Error fetching auth data: $e');
      setState(() {
        faceEmbedding = null; // Atur faceEmbedding ke null jika ada kesalahan
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Assets.images.bgHome.provider(),
              alignment: Alignment.topCenter,
            ),
          ),
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              FutureBuilder(
                  future: AuthLocalDatasource().getAuthData(),
                  builder: (context, snapshot) {
                    return Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.network(
                            snapshot.data?.user.imageUrl ??
                                'https://i.pinimg.com/originals/1b/14/53/1b14536a5f7e70664550df4ccaa5b231.jpg',
                            width: 48.0,
                            height: 48.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SpaceWidth(12.0),
                        Expanded(
                          child: Text(
                            'Hello, ${snapshot.data?.user.name ?? 'Pengguna'}',
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: AppColors.white,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Assets.icons.notificationRounded.svg(),
                        ),
                      ],
                    );
                  }),
              const SpaceHeight(24.0),
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  children: [
                    Text(
                      DateTime.now().toFormattedTime(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      DateTime.now().toFormattedDate(),
                      style: const TextStyle(
                        color: AppColors.grey,
                        fontSize: 12.0,
                      ),
                    ),
                    const SpaceHeight(18.0),
                    const Divider(),
                    const SpaceHeight(30.0),
                    Text(
                      DateTime.now().toFormattedDate(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey,
                      ),
                    ),
                    const SpaceHeight(6.0),
                    Text(
                      '${DateTime(2024, 3, 14, 8, 0).toFormattedTime()} - ${DateTime(2024, 3, 14, 16, 0).toFormattedTime()}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SpaceHeight(80.0),
              GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 30.0,
                  mainAxisSpacing: 30.0,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  MenuButton(
                    label: 'Datang',
                    iconPath: Assets.icons.menu.datang.path,
                    onPressed: () async {
                      bool isFakeLocation =
                         await DetectFakeLocation().detectFakeLocation();
                      if (isFakeLocation) {
                        if (!mounted) return;
                        showDialog(
                          context: this.context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                'Fake Location Decteed',
                              ),
                              content: const Text(
                                  'Please disable fake location to proceed.'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Ok'))
                              ],
                            );
                          },
                        );
                      } else {
                        if (!mounted) return;
                        this.context.push(const AttendanceCheckInPage());
                      }
                    },
                  ),
                  MenuButton(
                    label: 'Pulang',
                    iconPath: Assets.icons.menu.pulang.path,
                    onPressed: () async {
                      bool isFakeLocation =
                          await DetectFakeLocation().detectFakeLocation();
                      if (isFakeLocation) {
                        if (!mounted) return;
                        showDialog(
                          context: this.context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                'Fake Location Decteed',
                              ),
                              content: const Text(
                                  'Please disable fake location to proceed.'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Ok'))
                              ],
                            );
                          },
                        );
                      } else {
                         if (!mounted) return;
                        this.context.push(const AttendanceCheckOutPage());
                      }
                    },
                  ),
                  MenuButton(
                    label: 'Jadwal',
                    iconPath: Assets.icons.menu.jadwal.path,
                    onPressed: () {},
                  ),
                  MenuButton(
                    label: 'Izin',
                    iconPath: Assets.icons.menu.izin.path,
                    onPressed: () {},
                  ),
                  MenuButton(
                    label: 'Lembur',
                    iconPath: Assets.icons.menu.lembur.path,
                    onPressed: () {},
                  ),
                  MenuButton(
                    label: 'Catatan',
                    iconPath: Assets.icons.menu.catatan.path,
                    onPressed: () {},
                  ),
                ],
              ),
              const SpaceHeight(24.0),
              faceEmbedding != null
                  ? Button.filled(
                      onPressed: () {},
                      label: 'Attendance Using Face ID',
                      icon: Assets.icons.attendance.svg(),
                      color: AppColors.primary,
                    )
                  : Button.filled(
                      onPressed: () {
                        showBottomSheet(
                          backgroundColor: AppColors.white,
                          context: context,
                          builder: (context) => Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  width: 60.0,
                                  height: 8.0,
                                  child: Divider(color: AppColors.lightSheet),
                                ),
                                const CloseButton(),
                                const Center(
                                  child: Text(
                                    'Oops !',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24.0,
                                    ),
                                  ),
                                ),
                                const SpaceHeight(4.0),
                                const Center(
                                  child: Text(
                                    'Aplikasi ingin mengakses Kamera',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                                const SpaceHeight(36.0),
                                Button.filled(
                                  onPressed: () => context.pop(),
                                  label: 'Tolak',
                                  color: AppColors.secondary,
                                ),
                                const SpaceHeight(16.0),
                                Button.filled(
                                  onPressed: () {
                                    context.pop();
                                    context.push(
                                        const RegisterFaceAttendencePage());
                                  },
                                  label: 'Izinkan',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      label: 'Attendance Using Face ID',
                      icon: Assets.icons.attendance.svg(),
                      color: AppColors.red,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
