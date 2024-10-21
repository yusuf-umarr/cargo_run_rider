import 'dart:convert';
import 'dart:developer';

import 'package:cargorun_rider/constants/app_colors.dart';
import 'package:cargorun_rider/constants/location.dart';
import 'package:cargorun_rider/constants/shared_prefs.dart';
import 'package:cargorun_rider/models/order.dart';
import 'package:cargorun_rider/models/order_model.dart';
import 'package:cargorun_rider/providers/bottom_nav_provider.dart';
import 'package:cargorun_rider/providers/order_provider.dart';
import 'package:cargorun_rider/screens/dashboard/home_screens/home_screen.dart';
import 'package:cargorun_rider/screens/dashboard/profile_screens/view_profile_screen.dart';
import 'package:cargorun_rider/screens/dashboard/shipment_screens/shipment_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:upgrader/upgrader.dart';

class BottomNavBar extends StatefulWidget {
  static const String routeName = '/bottomNav';
  const BottomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  io.Socket? socket;

  List<Widget> pages = [
    const HomeScreen(),
    const ShipmentScreen(),
    const ViewProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _connectSocket();
      // Provider.of<OrderProvider>(context, listen: false).socketListener();
      Provider.of<OrderProvider>(context, listen: false).getOrders();
    });
  }

  //connecting websocket
  void _connectSocket() async {
    log("_connectSocket() started....");
    // final _sessionProvider = context.read<SessionProvider>();
    // String? currentUserId = await storage.read(key: 'id') ?? "";

    try {
      socket = io.io(
          "https://cargo-run-test-31c2cf9f78e4.herokuapp.com",
          <String, dynamic>{
            "transports": ["websocket"],
            "autoConnect": false,
            'forceNew': true,
            // 'Connection', 'upgrade'
          });

      socket!.connect();
      socket!.onConnect((data) {
        socket!.emit(
          'join',
          {
            "socketId": socket!.id!,
            "userId": sharedPrefs.userId,
            "type": "Rider"
          },
        );
        context.read<OrderProvider>().setSocketIo(socket);
        socket!.emit(
          'order'
        );
        socket!.on('join', (data) {
          log("on join=====:${data}");
        });
      });

      //fetch all orders
      socket!.on('order', (data) {
        try {
          log("message${data.runtimeType}");
            //  var jsonResponse = jsonDecode(data);
         var res = data['data'];
          context.read<OrderProvider>().getOrderData(res);
         
        } catch (e) {
          // log("orders error:${e}");
        }
      });

   

      socket!.onAny(
        (event, data) {
          // print(
          //   "event:$event, data:$data",
          // );
          // log(
          //   "event:$event, data:$data"
          // );
        },
      );
    } catch (e) {
      debugPrint("socket error:${e.toString()}");
    }
  }

  void getLocation() async {
    Position position = await determinePosition();
    debugPrint('latitude: ${position.latitude}');
    debugPrint('longitude: ${position.longitude}');
    // debugPrint('position: $position');
  }

  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BottomNavProvider>();

    return PopScope(
      onPopInvokedWithResult: (a, b) {},
      canPop: false,
      // onWillPop: () async {
      // DateTime now = DateTime.now();

      // if (provider.currentIndex != 0) {
      //   provider.setNavbarIndex(0);
      //   return false;
      // } else {
      //   return false;
      // }
      // },
      child: UpgradeAlert(
        dialogStyle: UpgradeDialogStyle.cupertino,
        child: Scaffold(
          body: pages[provider.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: provider.currentIndex,
            selectedItemColor: primaryColor1,
            unselectedItemColor: Colors.black54,
            backgroundColor: Colors.white,
            showUnselectedLabels: true,
            selectedFontSize: 10.0,
            unselectedFontSize: 10.0,
            elevation: 5,
            onTap: (index) {
              provider.setNavbarIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.home_2,
                  size: 26,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.clipboard_text,
                  size: 26,
                ),
                label: 'Shipments',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.user,
                  size: 26,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
