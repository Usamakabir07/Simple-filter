import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../infrastructure/catalog_facade_service.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required this.catalogFacadeService});
  final CatalogFacadeService catalogFacadeService;

  XFile _selectedFile = XFile("");
  XFile get selectedFile => _selectedFile;

  Future<void> requestPermissions(BuildContext context) async {
    final statuses = await [
      Permission.camera,
      Permission.photos,
    ].request();

    if (statuses[Permission.camera]!.isGranted &&
        statuses[Permission.photos]!.isGranted) {
      _showImageSourceDialog(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Permissions are required to pick an image')),
      );
    }
  }

  Future<void> _showImageSourceDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Image Source'),
        actions: [
          TextButton(
            onPressed: () => pickImage(ImageSource.camera),
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () => pickImage(ImageSource.gallery),
            child: const Text('Gallery'),
          ),
        ],
      ),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    // PermissionStatus? status;
    // if (Platform.isAndroid) {
    //   status = await Permission.photos.request();
    //   if (!status.isGranted) {
    //     showToast(
    //       message: "Please grant the permission",
    //       context: NavigationService.navigatorKey.currentContext!,
    //       type: CoolAlertType.info,
    //     );
    //     return;
    //   } else {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      _selectedFile = pickedFile;
      notifyListeners();
    }
  }
}
