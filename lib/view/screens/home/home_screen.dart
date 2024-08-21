import 'dart:io';
import 'package:filter/viewModels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/images.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double kWidth = MediaQuery.of(context).size.width;
    double kHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: kHeight,
        width: kWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child:
              Consumer<HomeViewModel>(builder: (context, homeViewModel, child) {
            return homeViewModel.selectedFile.path.isNotEmpty
                ? Image.file(
                    File(homeViewModel.selectedFile.path),
                    fit: BoxFit.cover,
                  )
                : const Center(
                    child: Text(
                      "Hello",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
          }),
        ),
      ),
      bottomNavigationBar:
          Consumer<HomeViewModel>(builder: (context, homeViewModel, child) {
        return Container(
          width: kWidth,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 50,
                width: 50,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.filters),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<HomeViewModel>().requestPermissions(context);
                },
                child: Container(
                  height: 80,
                  width: 80,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImages.appLogo),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 50,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.aiFilters),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
