// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:iconsax/iconsax.dart';

// import '../../../constants/app_colors.dart';
// import '../../../constants/location.dart';
// import '../../../widgets/page_widgets/delivery_card.dart';

// class MapScreen extends StatefulWidget {
//   final double recipientLat;
//   final double recipientLong;
//   const MapScreen({
//     super.key,
//     required this.recipientLat,
//     required this.recipientLong,
//   });

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late LatLng _initialPosition;
//   late GoogleMapController mapController;

//   CameraPosition? cposition;

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   void getLocation() async {
//     Position position = await determinePosition();
//     debugPrint('position: $position');
//     _initialPosition = LatLng(position.latitude, position.longitude);
//     final CameraPosition kGooglePlex = CameraPosition(
//       target: _initialPosition,
//       zoom: 14.4746,
//     );
//     setState(() {
//       cposition = kGooglePlex;
//     });
//   }

//   @override
//   void initState() {
//     getLocation();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           const GoogleMap(
//             mapType: MapType.normal,
//             initialCameraPosition: CameraPosition(
//               target: LatLng(6.5244, 3.3792),
//               zoom: 20,
//             ),
//           ),
//           const Positioned(
//             bottom: 50,
//             child: DeliveryCard(),
//           ),
//           Positioned(
//             top: 50,
//             left: 20,
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.of(context).pop();
//               },
//               child: Container(
//                 height: 50,
//                 width: 50,
//                 decoration: BoxDecoration(
//                   color: primaryColor1,
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 child: const Icon(Iconsax.arrow_left, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
