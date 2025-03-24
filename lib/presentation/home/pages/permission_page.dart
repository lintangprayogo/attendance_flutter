import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/components/custom_date_picker.dart';
import '../../../core/core.dart';
import '../bloc/create_permission/create_permission_bloc.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  String? imagePath;
  late final TextEditingController dateController;
  late final TextEditingController reasonController;

  @override
  void initState() {
    dateController = TextEditingController();
    reasonController = TextEditingController();
    super.initState();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imagePath = pickedFile.path;
      } else {
        debugPrint('No file selected.');
      }
    });
  }

  String formatDate(DateTime date) {
    final dateFormatter = DateFormat('yyyy-MM-dd');
    return dateFormatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Izin'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18.0),
        children: [
          CustomDatePicker(
            label: 'Tanggal',
            onDateSelected: (selectedDate) {
              dateController.text = formatDate(selectedDate);
            },
          ),
          CustomTextField(
            controller: reasonController,
            label: 'Keperluan',
            maxLines: 5,
          ),
          const SpaceHeight(26.0),
          Padding(
            padding: EdgeInsets.only(right: context.deviceWidth / 2),
            child: GestureDetector(
                onTap: _pickImage,
                child: imagePath == null
                    ? DottedBorder(
                        borderType: BorderType.RRect,
                        color: Colors.grey,
                        radius: const Radius.circular(18.0),
                        dashPattern: const [8, 4],
                        child: Center(
                          child: SizedBox(
                            height: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Assets.icons.image.svg(),
                                const SpaceHeight(18.0),
                                const Text('Lampiran'),
                              ],
                            ),
                          ),
                        ))
                    : ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(18.0)),
                        child: Image.file(
                          File(imagePath!),
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      )),
          ),
          const SpaceHeight(65.0),
          BlocConsumer<CreatePermissionBloc, CreatePermissionState>(
            listener: (context, state) {
              state.maybeWhen(
                  orElse: () {},
                  error: (message) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(message),
                      backgroundColor: AppColors.red,
                    ));
                  },
                  success: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Submit Izin success'),
                      backgroundColor: AppColors.primary,
                    ));
                  });
            },
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return Button.filled(
                      onPressed: () {
                        final image =
                            imagePath != null ? XFile(imagePath!) : null;
                        context.read<CreatePermissionBloc>().add(
                            CreatePermissionEvent.create(
                                date: dateController.text,
                                reason: reasonController.text,
                                image: image?.path));
                      },
                      label: 'Kirim Permintaan');
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
