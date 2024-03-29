import 'package:get/route_manager.dart';
import 'package:thu_gom/controllers/login/login_binding.dart';
import 'package:thu_gom/controllers/main/home/home_binding.dart';
import 'package:thu_gom/controllers/main/main_binding.dart';
import 'package:thu_gom/controllers/onboarding/onboarding_binding.dart';
import 'package:thu_gom/controllers/register/register_binding.dart';
import 'package:thu_gom/controllers/splash/splash_binding.dart';
import 'package:thu_gom/views/auth/login/login_screen.dart';
import 'package:thu_gom/views/auth/register/register_screen.dart';
import 'package:thu_gom/views/landing/landing_sceen.dart';
import 'package:thu_gom/views/auth/onboarding/intro/intro_screen.dart';
import 'package:thu_gom/views/auth/onboarding/profile/profile_screen.dart';
import 'package:thu_gom/views/main/home/home_screen.dart';
import 'package:thu_gom/views/main/infomation/infomation_screen.dart';
import 'package:thu_gom/views/main/main_screen.dart';
import 'package:thu_gom/views/main/map/map_screen.dart';
import 'package:thu_gom/views/splash/splash_screen.dart';

class Routes {
  static const INITIAL = '/splash';

  static final routes = [
    GetPage(
      name: '/splash',
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: '/landingPage',
      page: () => LandingScreen(),
    ),
    GetPage(
      name: '/loginPage',
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    // reigster
    GetPage(
      name: '/registerPage',
      page: () => RegisterScreen(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name : '/introPage',
      page: () => IntroScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name:  '/profilePage',
      page: () => ProfileScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
        name: '/mainPage',
        page: () => MainScreen(),
        binding: MainBinding(),

        children: [
          GetPage(
            name: '/homePage',
            page: () => HomeScreen(),
            binding: HomeBinding(),
          ),
          GetPage(
            name: '/mapPage',
            page: () => MapScreen(),
          ),
          GetPage(
            name: '/infomationPage',
            page: () => InfomationScreen(),
          ),
        ]),
  ];
}
