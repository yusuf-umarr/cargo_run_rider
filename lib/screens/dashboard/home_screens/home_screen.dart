import 'dart:developer';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double riderLat = 0;
  double riderLong = 0;
  void getLocation() async {
    log("getLocation=====homecalled");
    Position position = await determinePosition();
    debugPrint('position: $position');
    if (mounted) {
      context.read<OrderProvider>().setRiderLocation(
            position.latitude,
            position.latitude,
          );
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false).getPendingOrders();
      // getLocation();
      // startForegroundLocationTracking();

      Provider.of<OrderProvider>(context, listen: false).getOrdersHistory();
    });
    super.initState();
  }

  void startForegroundLocationTracking() async {
    //  Position position = await determinePosition();

    if (mounted) {
      // Position position = await determinePosition();
      // debugPrint('position: $position');
      // if (mounted) {
      //   context.read<OrderProvider>().setRiderLocation(
      //         position.latitude,
      //         position.latitude,
      //       );
      // }

      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((Position position) {
        sendLocationToBackend(position.latitude, position.longitude);
      });
    }
  }

  void sendLocationToBackend(double latitude, double longitude) async {
    context.read<OrderProvider>().setRiderLocation(
          latitude,
          latitude,
        );
    log('Sending Location: Lat:$latitude, Long:$longitude');
    // Implement the HTTP request to your backend here.
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
                        const Text(
                          'Good Morning,',
                          style: TextStyle(
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
          Expanded(
            child: Consumer<OrderProvider>(
              builder: (context, watch, _) {
                watch.orderData.sort((a, b) => DateTime.parse(b!.updatedAt!)
                    .compareTo(DateTime.parse(a!.updatedAt!)));
                return Visibility(
                  visible: (watch.orderData.isEmpty) ? false : true,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: watch.orderData.length,
                    itemBuilder: (context, index) {
                      return RequestCard(order: watch.orderData[index]!);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
