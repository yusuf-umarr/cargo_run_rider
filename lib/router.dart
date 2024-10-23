// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'screens/bottom_nav/bottom_nav.dart';
// import 'constants/shared_prefs.dart';
// import 'screens/authentication/guarantor_screen.dart';
// import 'screens/authentication/input_verification_screen.dart';
// import 'screens/authentication/login_screen.dart';
// import 'screens/authentication/phone_verify_screen.dart';
// import 'screens/authentication/register_screen.dart';
// import 'screens/authentication/vehicle_verification_screen.dart';
// import 'screens/dashboard/home_screens/home_screen.dart';
// import 'screens/dashboard/home_screens/map_screen.dart';
// import 'screens/dashboard/profile_screens/edit_profile_screen.dart';
// import 'screens/dashboard/profile_screens/get_help_screen.dart';
// import 'screens/dashboard/profile_screens/view_profile_screen.dart';
// import 'screens/dashboard/shipment_screens/shipment_details.dart';
// import 'screens/dashboard/shipment_screens/shipment_screen.dart';
// import 'screens/onboard/onboard_screen.dart';

// final router = GoRouter(
//   routes: <RouteBase>[
//     GoRoute(
//       path: (sharedPrefs.isLoggedIn == true) ? '/onboard' : '/',
//       builder: (context, state) => const OnboardScreen(),
//     ),
//     GoRoute(
//       path: '/login',
//       builder: (context, state) => const LoginScreen(),
//     ),
//     GoRoute(
//       path: '/register',
//       builder: (context, state) => const RegisterScreen(),
//     ),
//     GoRoute(
//       path: '/vehicle-verification',
//       builder: (context, state) => const VehicleVerificationScreen(),
//     ),
//     GoRoute(
//       path: '/guarantor',
//       builder: (context, state) => const GuarantorScreen(),
//     ),
//     GoRoute(
//       path: '/input-phone',
//       builder: (context, state) => const InputPhoneScreen(),
//     ),
//     GoRoute(
//       path: '/verify-phone',
//       builder: (context, state) => const PhoneVerifyScreen(),
//     ),
//     GoRoute(
//       path: '/maps',
//       builder: (BuildContext context, GoRouterState state) {
//         return const MapScreen(recipientLat: 1, recipientLong: 2,);
//       },
//     ),
//     ShellRoute(
//       builder: (BuildContext context, GoRouterState state, Widget child) {
//         return const SizedBox();
//         // return ScaffoldWithNavBar(child: child);
//       },
//       routes: <RouteBase>[
//         GoRoute(
//           path: (sharedPrefs.isLoggedIn == true) ? '/' : '/home',
//           builder: (BuildContext context, GoRouterState state) {
//             return const HomeScreen(); //ShipmentScreen();//ViewProfileScreen();
//           },
//           routes: const <RouteBase>[],
//         ),
//         GoRoute(
//           path: '/shipments',
//           builder: (BuildContext context, GoRouterState state) {
//             return const ShipmentScreen();
//           },
//           routes: <RouteBase>[
//             GoRoute(
//               path: ':id',
//               builder: (BuildContext context, GoRouterState state) {
//                 return ShipmentDetailsScreen( order: null,);
//               },
//             ),
//           ],
//         ),
//         GoRoute(
//           path: '/profile',
//           builder: (BuildContext context, GoRouterState state) {
//             return const ViewProfileScreen();
//           },
//           routes: <RouteBase>[
//             GoRoute(
//               path: 'edit-profile',
//               builder: (BuildContext context, GoRouterState state) {
//                 return const EditProfileScreen();
//               },
//             ),
//             GoRoute(
//               path: 'get-help',
//               builder: (context, state) {
//                 return const GetHelpScreen();
//               },
//             ),
//           ],
//         ),
//       ],
//     ),
//   ],
// );
