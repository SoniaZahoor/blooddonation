import 'dart:async';
import 'dart:io';
import 'package:assignmen_1/Screens/Home.dart';
import 'package:assignmen_1/Screens/auth.dart';
import 'package:assignmen_1/shared_pref/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _afterBuild(context));
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Spacer(),
            Center(
              child: Image.asset('assets/images/blood_donation.png'),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  void _afterBuild(BuildContext context) => _checkInternetAndProceed(context);

  void _checkInternetAndProceed(BuildContext context) async {
    bool falgConnected = false;
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(Duration(seconds: 30));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        falgConnected = true;
      }
    } catch (_) {}
    if (falgConnected) {
      _checkSessionAndProceed();
      //  _checkLocationAndProceed(context);
    } else {
      print("no internet");
    }
  }

  void _checkSessionAndProceed() async {
    bool status = await SharedPrefClient().isUserLoggedIn();

    Timer(Duration(seconds: 3), () {
      if (status) {
        Get.offAll(() => const Home());
      } else {
        Get.offAll(() => Auth());
      }
    });
  }
}