// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:provider/provider.dart';

// import '../../providers/order_provider.dart';
// import '../../constants/app_colors.dart';

// class ScaffoldWithNavBar extends StatefulWidget {
//   /// Constructs an [ScaffoldWithNavBar].
//   const ScaffoldWithNavBar({
//     required this.child,
//     super.key,
//   });

//   /// The widget to display in the body of the Scaffold.
//   /// In this sample, it is a Navigator.
//   final Widget child;

//   @override
//   State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();

//   static int _calculateSelectedIndex(BuildContext context) {
//     final String location = GoRouterState.of(context).uri.toString();
//     if (location.startsWith('/')) {
//       return 0;
//     }
//     if (location.startsWith('/shipments')) {
//       return 1;
//     }
//     if (location.startsWith('/profile')) {
//       return 2;
//     }
//     return 0;
//   }
// }

// class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<OrderProvider>(context, listen: false).socketListener();
  //     Provider.of<OrderProvider>(context, listen: false).getOrders();
  //   });
  // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F3F3),
//       body: widget.child,
//       bottomNavigationBar: BottomNavigationBar(
//         elevation: 10,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Iconsax.home_2),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Iconsax.clipboard_text),
//             label: 'Shipments',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Iconsax.user),
//             label: 'Profile',
//           ),
//         ],
//         currentIndex: ScaffoldWithNavBar._calculateSelectedIndex(context),
//         onTap: (int idx) => _onItemTapped(idx, context),
//         selectedItemColor: primaryColor1,
//       ),
//     );
//   }

//   void _onItemTapped(int index, BuildContext context) {
//     switch (index) {
//       case 0:
//         GoRouter.of(context).go('/');
//       case 1:
//         GoRouter.of(context).go('/shipments');
//       case 2:
//         GoRouter.of(context).go('/profile');
//     }
//   }
// }
