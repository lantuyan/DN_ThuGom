import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:thu_gom/shared/constants/color_constants.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 240.sp,
        padding: EdgeInsets.symmetric(horizontal: 18.sp),
        color: Colors.transparent,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 18.sp),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  Get.offAllNamed('/registerPage');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: ColorsConstants.kActiveColor,
                  padding: EdgeInsets.symmetric(vertical: 18.sp),
                  backgroundColor: ColorsConstants.kActiveColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  'Đăng ký',
                  style: TextStyle(
                    color: ColorsConstants.kSecondColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  Get.offAllNamed('/loginPage');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: ColorsConstants.kBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(
                      color: ColorsConstants.kActiveColor,
                    ),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  foregroundColor: ColorsConstants.kActiveColor,
                ),
                child: Text(
                  'Đăng nhập',
                  style: TextStyle(
                    color: ColorsConstants.kMainColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(18.sp, 28.sp, 18.sp, 0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 28.sp),
                  child: Image.asset(
                    'assets/images/logo_new.png',
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                  ),
                ),
                const Text(
                  'Thu Gom',
                  style: TextStyle(
                    color: ColorsConstants.kActiveColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'poppins',
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: const Text(
                    'Dự án thu gom, dọn dẹp rác thải tại Đà Nẵng',
                    style: TextStyle(color: ColorsConstants.kActiveColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
