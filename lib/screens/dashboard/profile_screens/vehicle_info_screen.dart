// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cargorun_rider/screens/authentication/guarantor_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_textfields.dart';
import '../../../widgets/page_widgets/appbar_widget.dart';

class VehicleInfoScreen extends StatefulWidget {
  const VehicleInfoScreen({super.key});

  @override
  State<VehicleInfoScreen> createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _vehicleType = TextEditingController();
  final TextEditingController _vehicleBrand = TextEditingController();
  final TextEditingController _plateNumber = TextEditingController();
  final TextEditingController _driverLicence = TextEditingController();

  @override
  void initState() {
    setData();
    super.initState();
  }

  void setData() {
    final profileVM = context.read<AuthProvider>();
    if (profileVM.user != null) {
      _vehicleType.text = profileVM.user!.vehicle!.vehicleType!;
      _vehicleBrand.text = profileVM.user!.vehicle!.brand!;
      _plateNumber.text = profileVM.user!.vehicle!.plateNumber!;
      _driverLicence.text = profileVM.user!.vehicle!.image!;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final authProvider = context.read<AuthProvider>();
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Upload A Picture Of Your Driver’s Licence",
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                    color: greyText,
                  ),
                ),
                const SizedBox(height: 20),
                Consumer<AuthProvider>(builder: (context, watch, _) {
                  return GestureDetector(
                    onTap: () => watch.pickImg(),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: (watch.vehicleImg != null)
                          ? Stack(
                              children: [
                                Image.file(
                                  File(watch.vehicleImg!),
                                  fit: BoxFit.cover,
                                  width: size.width,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: IconButton(
                                      onPressed: () {
                                        watch.clearImage();
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: redColor,
                                      )),
                                )
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_driverLicence.text != "") ...[
                                  Image.network(
                                    _driverLicence.text,
                                    fit: BoxFit.cover,
                                    height: 200,
                                    width: double.infinity,
                                  )
                                ] else ...[
                                  const FaIcon(
                                    FontAwesomeIcons.idCard,
                                    size: 45,
                                    color: primaryColor1,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Select Image',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500,
                                      color: greyText,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                AppTextField(
                  labelText: 'Vehicle Type',
                  isPassword: false,
                  hintText: 'e.g Car',
                  controller: _vehicleType,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  labelText: 'Vehicle Brand',
                  isPassword: false,
                  hintText: 'e.g Toyota',
                  controller: _vehicleBrand,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  labelText: 'Plate Number',
                  isPassword: false,
                  controller: _plateNumber,
                ),
                const SizedBox(height: 40),
                Consumer<AuthProvider>(builder: (context, watch, _) {
                  return (watch.authState == AuthState.authenticating)
                      ? const LoadingButton(
                          backgroundColor: primaryColor1,
                          textColor: Colors.white,
                        )
                      : AppButton(
                          text: 'Update',
                          hasIcon: false,
                          textColor: Colors.white,
                          backgroundColor: primaryColor1,
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              await watch
                                  .verifyVehicle(
                                    context,
                                    vehicleType: _vehicleType.text,
                                    brand: _vehicleBrand.text,
                                    vehicleNumber: _plateNumber.text,
                                  )
                                  .then(
                                    (value) => {
                                      if (watch.authState ==
                                          AuthState.authenticated)
                                        {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              backgroundColor: primaryColor2,
                                              content: Text("Successful"),
                                            ),
                                          ),
                                        }
                                    },
                                  );
                            }
                          },
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
