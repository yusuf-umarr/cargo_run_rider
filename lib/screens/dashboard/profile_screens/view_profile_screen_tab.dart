import 'package:cargorun_rider/constants/shared_prefs.dart';
import 'package:cargorun_rider/providers/auth_provider.dart';
import 'package:cargorun_rider/screens/authentication/login_screen.dart';
import 'package:cargorun_rider/screens/dashboard/profile_screens/vehicle_info_screen.dart';
import 'package:cargorun_rider/screens/dashboard/profile_screens/profile_info.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';

class ViewProfileTabScreen extends StatefulWidget {
  const ViewProfileTabScreen({super.key});

  @override
  State<ViewProfileTabScreen> createState() => _ViewProfileTabScreenState();
}

class _ViewProfileTabScreenState extends State<ViewProfileTabScreen> {

  void navigate() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xffF3F3F3),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: primaryColor1,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryColor1,
            tabs: [
              Tab(text: 'Profile Info'),
              Tab(text: 'Vehicle Info'),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: FractionallySizedBox(
                        heightFactor: 0.3,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 56,
                              child: AppBar(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                leadingWidth: 62,
                                leading: IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: const Icon(Icons.cancel),
                                ),
                                centerTitle: true,
                                title: Text(
                                  "Take a break from Cargo run?",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                scrolledUnderElevation: 0,
                                bottom: PreferredSize(
                                  preferredSize: Size(
                                    MediaQuery.of(context).size.width,
                                    1,
                                  ),
                                  child: const Divider(color: Colors.grey),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                sharedPrefs.clearAll();
                                navigate();
                              },
                              child: const Text("Log out"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Iconsax.logout, size: 30),
            ),
          ],
          title: const Text(
            'My Account',
            style: TextStyle(color: blackText),
          ),
        ),
        body: const TabBarView(
          children: [
            ProfileInfo(),
            VehicleInfoScreen(),
          ],
        ),
      ),
    );
  }
}
