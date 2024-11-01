import 'dart:async';
import 'dart:developer' as dev;

import 'package:cargorun_rider/constants/location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/shared_prefs.dart';
import '../../../providers/order_provider.dart';
import '../../../widgets/page_widgets/dashboard_card.dart';
import '../../../widgets/page_widgets/request_card.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String greeting = '';
  Position? position;
  Timer? _timer;
  int count = 0;
  DateTime now = DateTime.now();

  void getLocation() async {
    getPosition();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      getPosition();
    });
  }

  void getPosition() async {
    position = await determinePosition();
    if (mounted) {
      context.read<OrderProvider>().setLocationCoordinate(
            position!.latitude,
            position!.longitude,
          );

      dev.log("lat:${position!.latitude}");
      dev.log("long:${position!.longitude}");
    }
  }

  @override
  void initState() {
    getLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false).getPendingOrders();

      Provider.of<OrderProvider>(context, listen: false).getOrdersHistory();
    });
    setState(() {
      greeting = switch (now.hour) {
        >= 6 && < 12 => 'Good Morning,',
        >= 12 && < 18 => 'Good Afternoon,',
        _ => 'Good Evening,',
      };
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40),
            width: double.infinity,
            height: size.height * 0.3,
            decoration: const BoxDecoration(
              color: primaryColor1,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35.0,
                      backgroundColor: primaryColor2,
                      child: Center(
                        child: Text(
                          sharedPrefs.fullName[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          greeting,
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          sharedPrefs.fullName,
                          style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Consumer<OrderProvider>(
                      builder: (context, watch, _) {
                        return Switch(
                          value: sharedPrefs.isOnline,
                          onChanged: (val) {
                            if (val == true) {
                              watch.reconnect();
                            } else {
                              watch.disconnect();
                            }
                            setState(() {
                              sharedPrefs.isOnline = val;
                            });
                          },
                          activeColor: Colors.white,
                          inactiveThumbColor: primaryColor2,
                          activeTrackColor: primaryColor2,
                        );
                      },
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  (sharedPrefs.isOnline == false)
                      ? "You're currently Offline"
                      : "You're currently Online",
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Consumer<OrderProvider>(builder: (context, watch, _) {
            return GridView(
              shrinkWrap: true,
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.4,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              children: [
                DashboardCard(
                  num: '${watch.orderHistory.length}',
                  icon: Iconsax.ticket,
                  title: 'Total Orders',
                ),
                // DashboardCard(
                //   num: '${watch.orderHistory.length}',
                //   icon: Iconsax.document,
                //   title: 'Total Service',
                // ),
                const DashboardCard(
                  num: '₦0.00',
                  icon: Iconsax.discount_shape,
                  title: 'Total Earning',
                ),
              ],
            );
          }),
          const SizedBox(height: 20),
          Consumer<OrderProvider>(
            builder: (context, watch, _) {
              return Visibility(
                visible: watch.orderData.isEmpty ? false : true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'You have incoming requests',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor1.withOpacity(0.9),
                    ),
                  ),
                ),
              );
            },
          ),

          OrderListWidget()
          // else ...[Text("position is null")]
          // Expanded(
          //   child: Consumer<OrderProvider>(
          //     builder: (context, watch, _) {
          //       watch.orderData.sort((a, b) => DateTime.parse(b!.createdAt!)
          //           .compareTo(DateTime.parse(a!.createdAt!)));
          //       return Visibility(
          //         visible: (watch.orderData.isEmpty) ? false : true,
          //         child: ListView.builder(
          //           padding: const EdgeInsets.all(0),
          //           itemCount: watch.orderData.length,
          //           itemBuilder: (context, index) {
          //             return RequestCard(
          //               order: watch.orderData[index]!,
          //               orderHistory: watch.orderHistory,
          //             );
          //           },
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

// Method to calculate the distance between two coordinates
double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
  const double earthRadius = 6371; // Radius of Earth in kilometers
  double dLat = _degreesToRadians(lat2 - lat1);
  double dLng = _degreesToRadians(lng2 - lng1);

  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_degreesToRadians(lat1)) *
          cos(_degreesToRadians(lat2)) *
          sin(dLng / 2) *
          sin(dLng / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadius * c; // Distance in kilometers
}

// Helper function to convert degrees to radians
double _degreesToRadians(double degrees) {
  return degrees * pi / 180;
}

// Assuming rider coordinates are available globally or passed as parameters
// final double riderLat = 40.748817; // Replace with actual rider latitude
// final double riderLng = -73.985428; // Replace with actual rider longitude

class OrderListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<OrderProvider>(
        builder: (context, orderProvider, _) {
          // Sort orders based on createdAt
          orderProvider.orderData.sort((a, b) => DateTime.parse(b!.createdAt!)
              .compareTo(DateTime.parse(a!.createdAt!)));

          // Filter orders within 1 km distance
          final nearbyOrders = orderProvider.orderData.where((order) {
            if (order?.addressDetails?.lat != null &&
                order?.addressDetails?.lng != null) {
              double distance = calculateDistance(
                orderProvider.riderCurrentLat,
                orderProvider.riderCurrentLong,
                order!.addressDetails!.lat!,
                order.addressDetails!.lng!,
              );
              return distance < 10; // Check if distance is less than 1 km
            }
            return false;
          }).toList();

          return Visibility(
            visible: nearbyOrders.isNotEmpty,
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: nearbyOrders.length,
              itemBuilder: (context, index) {
                return RequestCard(
                  order: nearbyOrders[index]!,
                  orderHistory: orderProvider.orderHistory,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
