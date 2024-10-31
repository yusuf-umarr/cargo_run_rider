import 'dart:async';
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
  String greeting = '';
  
  Timer? _timer;
  int count = 0;
  DateTime now = DateTime.now();

  void getLocation() async {
    log("==1==========================conter:${count++}");
    getPosition();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      log("====2========================conter:${count++}");
      getPosition();
    });
  }

  void getPosition() async {
    Position position = await determinePosition();
    if (mounted) {
      context.read<OrderProvider>().setLocationCoordinate(
            position.latitude,
            position.longitude,
          );
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
          Expanded(
            child: Consumer<OrderProvider>(
              builder: (context, watch, _) {
                watch.orderData.sort((a, b) => DateTime.parse(b!.createdAt!)
                    .compareTo(DateTime.parse(a!.createdAt!)));
                return Visibility(
                  visible: (watch.orderData.isEmpty) ? false : true,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: watch.orderData.length,
                    itemBuilder: (context, index) {
                      return RequestCard(
                        order: watch.orderData[index]!,
                        orderHistory: watch.orderHistory,
                      );
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
