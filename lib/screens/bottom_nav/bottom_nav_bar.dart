import 'dart:developer';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cargorun_rider/constants/app_colors.dart';
import 'package:cargorun_rider/constants/shared_prefs.dart';
import 'package:cargorun_rider/providers/auth_provider.dart';
import 'package:cargorun_rider/providers/bottom_nav_provider.dart';
import 'package:cargorun_rider/providers/order_provider.dart';
import 'package:cargorun_rider/screens/dashboard/home_screens/home_screen.dart';
import 'package:cargorun_rider/screens/dashboard/profile_screens/view_profile_screen.dart';
import 'package:cargorun_rider/screens/dashboard/shipment_screens/shipment_screen.dart';
import 'package:cargorun_rider/services/notification_service.dart';
import 'package:flutter/material.dart';
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
      Provider.of<AuthProvider>(context, listen: false).getUserProfile();
      Provider.of<OrderProvider>(context, listen: false).getOrdersHistory();
      Provider.of<OrderProvider>(context, listen: false).getPendingOrders();
      Provider.of<OrderProvider>(context, listen: false).getAnalysis();
    });
  }

  //connecting websocket
  void _connectSocket() async {
    log("_connectSocket() started....");

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
        socket!.emit('order');
        socket!.on('join', (data) {
          log("on join=====:$data");
        });
      });

      if (mounted) {
        //fetch all orders
        socket!.on('order', (data) {
          try {
            log("getorder-}");
            var res = data['data'];
            //  Provider.of<OrderProvider>(context, listen: false)
            // .getNewOrder(order: res, isNewOrder: false);

            Provider.of<OrderProvider>(context, listen: false)
                .getOrderData(res);
          } catch (e) {
            log("orders error:$e");
          }
        });
      }

      if (mounted) {
        socket!.on('new-order', (data) async {
          log("getNewOrder-}");
          var res = data['data'];
             Provider.of<OrderProvider>(context, listen: false)
                .getOrderData(res);


          try {
            var response = Provider.of<OrderProvider>(context, listen: false)
                .getNewOrder(order: res);

            if (response) {
              newOrderNotify();
            }
      Provider.of<OrderProvider>(context, listen: false).getAnalysis();

            // log("response new order :${response}");
            Provider.of<OrderProvider>(context, listen: false)
                .getPendingOrders();
            Provider.of<OrderProvider>(context, listen: false)
                .getOrdersHistory();
          } catch (e) {
            log("new-order error:$e");
          }
        });
      }

      if(mounted){
           socket!.on("payment-${sharedPrefs.userId}", (data) async {
        try {

          await NotificationService.showNotification(
              title: "Payment ",
              body: "${data['msg']}",
              payload: {
                "navigate": "true",
              },
              actionButtons: [
                NotificationActionButton(
                  key: 'Preview',
                  label: 'Preview',
                  actionType: ActionType.Default,
                  color: Colors.green,
                )
              ]);
        } catch (e) {
          log("notifications error:$e");
        }
      });
      }
      socket!.onDisconnect((_) => log('disconnect'));

      socket!.onAny(
        (event, data) {
          // log("event:$event, data:$data");
        },
      );
    } catch (e) {
      debugPrint("socket error:${e.toString()}");
    }
  }

  newOrderNotify() async {
    await NotificationService.showNotification(
        title: "New order",
        body: "new order has been created",
        payload: {
          "navigate": "true",
        },
        actionButtons: [
          NotificationActionButton(
            key: 'Preview',
            label: 'Preview',
            actionType: ActionType.Default,
            color: Colors.green,
          )
        ]);
  }
  //

  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BottomNavProvider>();

    return PopScope(
      onPopInvokedWithResult: (a, b) {},
      canPop: false,
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
