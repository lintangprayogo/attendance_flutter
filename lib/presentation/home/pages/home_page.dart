import 'package:detect_fake_location/detect_fake_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';

import '../../../core/core.dart';
import '../../../core/helper/radius_calculate.dart';
import '../../../data/datasource/auth_local_datasource.dart';
import '../bloc/get_company/get_company_bloc.dart';
import '../bloc/is_checkedin/is_checkedin_bloc.dart';
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
    context.read<IsCheckedinBloc>().add(const IsCheckedinEvent.isCheckedIn());
    getCurrentPosition();
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

  double? latitude;
  double? longitude;

  Future<void> getCurrentPosition() async {
    try {
      Location location = Location();

      bool serviceEnabled;
      PermissionStatus permissionGranted;
      LocationData locationData;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      locationData = await location.getLocation();
      latitude = locationData.latitude;
      longitude = locationData.longitude;

      setState(() {});
    } on PlatformException catch (e) {
      if (e.code == 'IO_ERROR') {
        debugPrint(
            'A network error occurred trying to lookup the supplied coordinates: ${e.message}');
      } else {
        debugPrint('Failed to lookup coordinates: ${e.message}');
      }
    } catch (e) {
      debugPrint('An unknown error occurred: $e');
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
                  BlocBuilder<GetCompanyBloc, GetCompanyState>(
                    builder: (context, state) {
                      final double latitudePoint = state.maybeWhen(
                          orElse: () => 0.0,
                          success: (company) => double.parse(company.latitude));

                      final double longitudePoint = state.maybeWhen(
                          orElse: () => 0.0,
                          success: (company) =>
                              double.parse(company.longitude));

                      final double radiusKm = state.maybeWhen(
                          orElse: () => 0.0,
                          success: (company) => double.parse(company.radiusKm));

                      final distanceKm = RadiusCalculate.calculateDistance(
                          lat1: latitudePoint,
                          lon1: longitudePoint,
                          lat2: latitude ?? 0,
                          lon2: longitude ?? 0);

                      return BlocBuilder<IsCheckedinBloc, IsCheckedinState>(
                        builder: (context, state) {
                          final isCheckedin = state.maybeWhen(
                            orElse: () => false,
                            success: (data) => data.isCheckedin,
                          );

                          return state.maybeWhen(orElse: () {
                            return MenuButton(
                              label: 'Datang',
                              iconPath: Assets.icons.menu.datang.path,
                              onPressed: () async {
                                bool isFakeLocation = await DetectFakeLocation()
                                    .detectFakeLocation();

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

                                  if (!isCheckedin) {
                                    this
                                        .context
                                        .push(const AttendanceCheckInPage());
                                  }
                                  if (longitude == null || latitude == null) {
                                    ScaffoldMessenger.of(this.context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Belum mendapatkan Lokasi'),
                                      backgroundColor: Colors.red,
                                    ));
                                  } else if (distanceKm > radiusKm) {
                                    ScaffoldMessenger.of(this.context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Anda Diluar jangkauan'),
                                      backgroundColor: Colors.red,
                                    ));
                                  } else {
                                    ScaffoldMessenger.of(this.context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Andah Sudah Checkin'),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                }
                              },
                            );
                          });
                        },
                      );
                    },
                  ),
                  BlocBuilder<GetCompanyBloc, GetCompanyState>(
                    builder: (context, state) {
                      final double latitudePoint = state.maybeWhen(
                          orElse: () => 0.0,
                          success: (company) => double.parse(company.latitude));

                      final double longitudePoint = state.maybeWhen(
                          orElse: () => 0.0,
                          success: (company) =>
                              double.parse(company.longitude));

                      final double radiusKm = state.maybeWhen(
                          orElse: () => 0.0,
                          success: (company) => double.parse(company.radiusKm));

                      final distanceKm = RadiusCalculate.calculateDistance(
                          lat1: latitudePoint,
                          lon1: longitudePoint,
                          lat2: latitude ?? 0,
                          lon2: longitude ?? 0);

                      return BlocBuilder<IsCheckedinBloc, IsCheckedinState>(
                        builder: (context, state) {
                          final isCheckedin = state.maybeWhen(
                            orElse: () => false,
                            success: (data) => data.isCheckedin,
                          );
                          final isCheckedout = state.maybeWhen(
                            orElse: () => false,
                            success: (data) => data.isCheckedout,
                          );
                          return state.maybeWhen(
                              orElse: () => MenuButton(
                                    label: 'Pulang',
                                    iconPath: Assets.icons.menu.pulang.path,
                                    onPressed: () async {
                                      bool isFakeLocation =
                                          await DetectFakeLocation()
                                              .detectFakeLocation();

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
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Ok'))
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        if (!mounted) return;

                                        if (!isCheckedin) {
                                          ScaffoldMessenger.of(this.context)
                                              .showSnackBar(const SnackBar(
                                            content:
                                                Text('Andah Belum Checkin'),
                                            backgroundColor: Colors.red,
                                          ));
                                        } else if (isCheckedout) {
                                          ScaffoldMessenger.of(this.context)
                                              .showSnackBar(const SnackBar(
                                            content:
                                                Text('Andah Telah Checkout'),
                                            backgroundColor: Colors.red,
                                          ));
                                        }
                                        if (longitude == null ||
                                            latitude == null) {
                                          ScaffoldMessenger.of(this.context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                                'Belum mendapatkan Lokasi'),
                                            backgroundColor: Colors.red,
                                          ));
                                        } else if (distanceKm > radiusKm) {
                                          ScaffoldMessenger.of(this.context)
                                              .showSnackBar(const SnackBar(
                                            content:
                                                Text('Anda Diluar jangkauan'),
                                            backgroundColor: Colors.red,
                                          ));
                                        } else {
                                          this.context.push(
                                              const AttendanceCheckOutPage());
                                        }
                                      }
                                    },
                                  ));
                        },
                      );
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
                  ? BlocBuilder<GetCompanyBloc, GetCompanyState>(
                      builder: (context, state) {
                        final double latitudePoint = state.maybeWhen(
                            orElse: () => 0.0,
                            success: (company) =>
                                double.parse(company.latitude));

                        final double longitudePoint = state.maybeWhen(
                            orElse: () => 0.0,
                            success: (company) =>
                                double.parse(company.longitude));

                        final double radiusKm = state.maybeWhen(
                            orElse: () => 0.0,
                            success: (company) =>
                                double.parse(company.radiusKm));

                        final distanceKm = RadiusCalculate.calculateDistance(
                            lat1: latitudePoint,
                            lon1: longitudePoint,
                            lat2: latitude ?? 0,
                            lon2: longitude ?? 0);

                        return BlocBuilder<IsCheckedinBloc, IsCheckedinState>(
                          builder: (context, state) {
                            final isCheckedin = state.maybeWhen(
                              orElse: () => false,
                              success: (data) => data.isCheckedin,
                            );
                            final isCheckedout = state.maybeWhen(
                              orElse: () => false,
                              success: (data) => data.isCheckedout,
                            );
                            return Button.filled(
                              onPressed: () {
                                if (!isCheckedin) {
                                  this
                                      .context
                                      .push(const AttendanceCheckInPage());
                                } else if (isCheckedout) {
                                  ScaffoldMessenger.of(this.context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Andah Telah Checkout'),
                                    backgroundColor: Colors.red,
                                  ));
                                }
                                if (longitude == null || latitude == null) {
                                  ScaffoldMessenger.of(this.context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Belum mendapatkan Lokasi'),
                                    backgroundColor: Colors.red,
                                  ));
                                } else if (distanceKm > radiusKm) {
                                  ScaffoldMessenger.of(this.context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Anda Diluar jangkauan'),
                                    backgroundColor: Colors.red,
                                  ));
                                } else {
                                  this
                                      .context
                                      .push(const AttendanceCheckOutPage());
                                }
                              },
                              label: 'Attendance Using Face ID',
                              icon: Assets.icons.attendance.svg(),
                              color: AppColors.primary,
                            );
                          },
                        );
                      },
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
