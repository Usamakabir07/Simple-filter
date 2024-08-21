import 'package:filter/common/colors.dart';
import 'package:filter/utils/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common/images.dart';
import '../infrastructure/catalog_facade_service.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required this.catalogFacadeService});
  final CatalogFacadeService catalogFacadeService;

  XFile _selectedFile = XFile("");
  XFile get selectedFile => _selectedFile;

  int _typeOfFilter = 1;
  int get typeOfFilter => _typeOfFilter;

  int _selectedFilter = 1;
  int get selectedFilter => _selectedFilter;

  String _processedImage = "";
  String get processedImage => _processedImage;

  bool _isApplyingFilter = false;
  bool get isApplyingFilter => _isApplyingFilter;

  bool _seeOldPicture = false;
  bool get seeOldPicture => _seeOldPicture;

  final List<Map<String, String>> _filters = [
    {"filter": Filters.normalImage, "name": "add"},
    {"filter": Filters.normalImage, "name": "Normal"},
    {"filter": Filters.grayScale, "name": "Grey Scale"},
    {"filter": Filters.artistic, "name": "Artistic"},
    {"filter": Filters.lighting, "name": "Lighting"},
    {"filter": Filters.love, "name": "Love"},
    {"filter": Filters.highExposure, "name": "Exposure"},
    {"filter": Filters.orange, "name": "Orange"},
    {"filter": Filters.sepia, "name": "Sepia"},
    {"filter": Filters.vintage, "name": "Vintage"},
  ];
  List<Map<String, String>> get filters => _filters;

  final List<Map<String, String>> _aiFilters = [
    {"filter": Filters.normalImage, "name": "add"},
    {"filter": Filters.normalImage, "name": "Normal"},
    {"filter": AiFilters.catFace, "name": "Cat Face"},
    {"filter": AiFilters.tigerFace, "name": "Tiger Face"},
  ];
  List<Map<String, String>> get aiFilters => _aiFilters;

  void applyingFilter(bool loading) {
    _isApplyingFilter = loading;
    notifyListeners();
  }

  void changePictureView(bool value) {
    _seeOldPicture = value;
    notifyListeners();
  }

  void addProcessedImage(String imagePath) {
    _processedImage = imagePath;
    notifyListeners();
  }

  void changeFilterType(int type) {
    _typeOfFilter = type;
    notifyListeners();
  }

  void selectFilter(int index) {
    _selectedFilter = index;
    notifyListeners();
  }

  void removeImage() {
    _selectedFile = XFile("");
    _processedImage = "";
    _typeOfFilter = 1;
    notifyListeners();
  }

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
        backgroundColor: MyColors.whiteColor,
        title: Text(
          'Choose Image',
          style: TextStyle(color: MyColors.appDark),
        ),
        content: Container(
          height: 100,
          color: MyColors.whiteColor,
          // padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  pickImage(ImageSource.gallery);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.asset(
                        AppImages.gallery,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Gallery',
                      style: TextStyle(color: MyColors.blackColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  pickImage(ImageSource.camera);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.asset(
                        AppImages.camera,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Camera',
                      style: TextStyle(color: MyColors.blackColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
      _processedImage = "";
      _typeOfFilter = 1;
      notifyListeners();
      Navigator.pop(NavigationService.navigatorKey.currentContext!);
    }
  }
}
