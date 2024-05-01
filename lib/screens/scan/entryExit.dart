import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_system/constants.dart';
import 'package:smart_parking_system/screens/payments/paymentPage.dart';

import '../../utils/loading_component.dart';
import '../../utils/qr_overlay.dart';
import '../../utils/toast_message.dart';
import '../auth/primary_page.dart';

class EntryExit extends StatefulWidget {
  const EntryExit({
    super.key,

  });


  @override
  State<EntryExit> createState() => _EntryExitState();
}

class _EntryExitState extends State<EntryExit> {
  String? lotId;

  MobileScannerController cameraController = MobileScannerController(
    autoStart: true,
    facing: CameraFacing.back,
    formats: [BarcodeFormat.qrCode],
    useNewCameraSelector: true,
  );
  bool _isLoading = false;

  bool qrDone = false;

  final List<bool> _selected = [true, false];

  String price="";

  String slotId="";

  void _cameraPermissionInitState() async {
    if (Platform.isAndroid) {
      if (await Permission.camera.request().isGranted) {
        cameraController.start();
      }

      if (!mounted) return;
    }
  }

  Future<String> markEntry(String studentId) async {
    showToast("entry api called");
    setState(() {
      _isLoading = true;
    });
    //
    try {
      final sp = await SharedPreferences.getInstance();
      if (sp.getString("TOKEN") == null) {
        showToast("Session Expired. Please login again.");
        return "-2";
      }

      final dio = Dio();

      debugPrint(
          "${Constants.getFreeSlot}/$lotId");

      final response = await dio.get(
        "${Constants.getFreeSlot}/$lotId",
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {"Authorization": "Bearer ${sp.getString("TOKEN")}"},
          // validateStatus: (status) {
          //   return status! < 1000;
          // },
        ),
      );

      debugPrint("[ENTRY] ${response.statusCode}");

      if (response.statusCode == 200) {
        slotId = response.data["slotId"];
        showToast("slotId : ${slotId}");
        return "1";
      } else if (response.statusCode == 400) {
        // showToast(
        //   response.data["MESSAGE"],
        // );
        _logOut();
        return "-2";
      } else {
        // showToast("else case");
        // showToast(
        //   "Something went wrong. We're working on it. Please try again later.",
        // );
      }

      return "-1";
    } catch (e) {
      debugPrint(e.toString());
      // showToast(
      //  e.toString(),
      // );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    return "-1";

  }

  Future<String> markExit(String studentId) async {
    showToast("exit api called");
    setState(() {
      _isLoading = true;
    });

    try {
      final sp = await SharedPreferences.getInstance();
      if (sp.getString("TOKEN") == null) {
        showToast("Session Expired. Please login again.");
        return "-2";
      }

      final dio = Dio();

      final response = await dio.get(
        "${Constants.getPrice}",
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {"Authorization": "Bearer ${sp.getString("TOKEN")}"},
          // validateStatus: (status) {
          //   return status! < 1000;
          // },
        ),
      );

      debugPrint("[EXIT] ${response.statusCode}");

      debugPrint(response.data.toString());


      if (response.statusCode == 200) {
        price = response.data["price"];
        showToast("${price} rs");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentPage(price: price),
          ),
        );
        return "1";
      } else if (response.statusCode == 401){
        // showToast(
        //   response.data["MESSAGE"].toString(),
        // );

      } else if (response.statusCode == 401) {
        showToast(
          "Session Expired. Please login again.",
        );
        _logOut();
        return "-2";
      } else {
        // showToast(
        //  "Something went wrong, Please try again later",
        // );
      }

      return "-1";
    } catch (e) {
      debugPrint(e.toString());
      // showToast(
      //   e.toString()
      // );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    return "-1";

  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _cameraPermissionInitState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: _isLoading == true
          ? const LoadingComponent()
          : CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'Make Entry/Exit',
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                color: Colors.white,
                icon: ValueListenableBuilder(
                  valueListenable: cameraController.torchState,
                  builder: (context, state, child) {
                    switch (state) {
                      case TorchState.off:
                        return const Icon(Icons.flash_off,
                            color: Colors.grey);
                      case TorchState.on:
                        return const Icon(Icons.flash_on,
                            color: Colors.yellow);
                    }
                  },
                ),
                iconSize: 24.0,
                onPressed: () => cameraController.toggleTorch(),
              ),
              IconButton(
                color: Colors.white,
                icon: ValueListenableBuilder(
                  valueListenable: cameraController.cameraFacingState,
                  builder: (context, state, child) {
                    switch (state) {
                      case CameraFacing.front:
                        return const Icon(Icons.cameraswitch_rounded);
                      case CameraFacing.back:
                        return const Icon(Icons.cameraswitch_rounded);
                    }
                  },
                ),
                iconSize: 24.0,
                onPressed: () => cameraController.switchCamera(),
              ),
            ],
          ),
          SliverFillRemaining(
            child: Stack(
              alignment: Alignment.bottomCenter,
              fit: StackFit.loose,
              textDirection: TextDirection.ltr,
              children: [
                MobileScanner(
                  controller: cameraController,
                  fit: BoxFit.cover,
                  onDetect: (capture) {
                    debugPrint("[CAPTURED]: ${qrDone.toString()}");

                    if (qrDone == true) {
                      return;
                    }

                    final qrCode = capture.barcodes[0].rawValue;
                    if (qrCode != null) {
                      lotId = qrCode;

                      setState(() {
                        qrDone = true;
                      });


                      // lotID is  of format lotId://lotId
                      // We need to extract the lotId from it

                      if (lotId == null ||
                          lotId!.isEmpty ||
                          lotId!.length < 8 ||
                          !lotId!.startsWith("lotId://")) {
                        showToast("Invalid QR Code");
                        Future.delayed(
                            const Duration(seconds: 2),
                                () => setState(() {
                              qrDone = false;
                            }));
                        return;
                      }

                      lotId = lotId!.substring(8);

                      debugPrint(_selected[0].toString());

                      if (_selected[0] == true) {
                        markEntry(lotId.toString()).then((res) {
                          if (res == "1") {
                            showToast("Entry Marked");
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return LayoutBuilder(builder: (context, constraints) {
                                    return AlertDialog(
                                      contentPadding: const EdgeInsets.only(left: 30,top:20),

                                      title:  Text("Enjoy using our service!",textAlign: TextAlign.center,style: GoogleFonts.quicksand(
                                          color: Colors.black, fontWeight: FontWeight.bold),),
                                      content:Padding(
                                        padding: const EdgeInsets.only(top:8.0,right:8,bottom:16),
                                        child: Chip(
                                          backgroundColor: Colors.blue,
                                          label: Text(
                                            "slotId assigned: $slotId",
                                            style:GoogleFonts.quicksand(
                                              textStyle: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),

                                        ),
                                      ),

                                    );
                                  });
                                });
                          }
                        });
                        setState(() {
                          qrDone = false;
                        });
                      } else {
                        markExit(lotId.toString()).then((res) {
                          if (res == "1") {
                            showToast("Exit Marked");
                          }
                        });
                        setState(() {
                          qrDone = false;
                        });
                      }
                    }

                    return;
                  },
                ),
                QRScannerOverlay(
                  overlayColour: Theme.of(context)
                      .colorScheme
                      .background
                      .withOpacity(0.4),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 16.0,
                    ),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32.0),
                        topRight: Radius.circular(32.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Scan QR Code",
                          style: GoogleFonts.poppins(
                            textStyle:
                            Theme.of(context).textTheme.titleLarge,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground,
                          ),
                        ),

                        const SizedBox(
                          height: 16,
                        ),
                        ToggleButtons(
                          onPressed: (int index) {
                            if (index == 0) {
                              setState(() {
                                _selected[0] = true;
                                _selected[1] = false;
                              });

                              setState(() {
                                qrDone = false;
                              });

                            } else {
                              setState(() {
                                _selected[0] = false;
                                _selected[1] = true;
                              });

                              setState(() {
                                qrDone = false;
                              });
                            }
                          },
                          borderRadius:
                          const BorderRadius.all(Radius.circular(8)),
                          selectedBorderColor:
                          const Color.fromRGBO(11, 38, 59, 1),
                          selectedColor:
                          const Color.fromRGBO(255, 255, 255, 1.0),
                          fillColor:
                          const Color.fromRGBO(11, 38, 59, 1),
                          color:
                          Theme.of(context).colorScheme.onBackground,
                          constraints: const BoxConstraints(
                            minHeight: 40.0,
                            minWidth: 80.0,
                          ),
                          isSelected: _selected,
                          children: const <Widget>[
                            Padding(
                              padding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text('Entry'),
                            ),
                            Padding(
                              padding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text('Exit'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _logOut() {
    SharedPreferences.getInstance().then((sp) {
      sp.setBool("LOGGEDINKEY", false);
      sp.setString("NAME", "");
      // sp.setString("EMAIL", "");
      sp.setString("PHONE", "");
      sp.setString("COLLEGE", "");
      sp.setString("CITY", "");
      sp.setString("TOKEN", "");
    });
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const PrimaryScreen()),
            (route) => false);
  }
}
