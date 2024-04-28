
import 'package:dio/dio.dart';
import 'package:five_pointed_star/five_pointed_star.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../utils/toast_message.dart';

class NearbyLots extends StatefulWidget {
  const NearbyLots({super.key});

  @override
  State<NearbyLots> createState() => _NearbyLotsState();
}

class _NearbyLotsState extends State<NearbyLots> {
  // late List<Map<String, dynamic>> nearbyLots;
  late List<dynamic> nearbyLots;
  @override
  void initState() {
    super.initState();
    showNearbyLots();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(43, 30, 56, 1),
            Color.fromRGBO(11, 38, 59, 1),
            Color.fromRGBO(15, 21, 39, 1),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: const Color.fromRGBO(43, 30, 56, 1),
          title: Row(
            children: [
              const Icon(
                Icons.location_on, // Location icon
                color: Colors.white,
              ),
              const SizedBox(width: 8), // Adjust spacing between icon and text
              Text(
                "Parking lots near you",
                style: GoogleFonts.quicksand(
                  textStyle: const TextStyle(
                      fontSize: 22, color: Colors.white // Smaller font size
                      ),
                ),
              ),
            ],
          ),
        ),
        body: nearbyLots.isEmpty
            ? const Center(
                child: Text(
                  "No Lots found.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                  bottom: 68,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 2),
                ),
                itemCount: nearbyLots.length,
                itemBuilder: (ctx, i) => LotCard(
                  lot: nearbyLots[i],
                  onTap: () {
                    // todo: individual slot
                  },
                ),
              ),
      ),
    );
  }

  void showNearbyLots() async {
    try {
      final response = await Dio().post(
        Constants.showNearbyLots,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
          validateStatus: (status) =>
              status! < 1000, // This line is extremely important
        ),
        data: {
          "coordinates": "6 6"
          //todo: fetch current location and pass it here
        },
      );

      if (kDebugMode) {
        print("[SHOWNEARBYLOTS]: ${response.data}");
        print("[STATUS]: ${response.statusCode}");
      }

      if (response.statusCode == 200) {
        setState(() {
          nearbyLots = response.data;
        });
      } else if (response.statusCode == 400) {
        showToast(response.data['MESSAGE'] ??
            "Something went wrong. Please try again later");
      }
      showToast("Something went wrong. Please try again later");
    } catch (err) {
      if (kDebugMode) {
        print("[ERROR]: $err");
      }

      showToast("Something went wrong. Please try again later");
    }
  }
}

class LotCard extends StatefulWidget {
  final Map<String, dynamic> lot;
  final VoidCallback onTap;

  const LotCard({super.key, required this.lot, required this.onTap});

  @override
  State<LotCard> createState() => _LotCardState();
}

class _LotCardState extends State<LotCard> {
  @override
  Widget build(BuildContext context) {
    int mycount = 0;
    double gridWidth;
    gridWidth = MediaQuery.of(context).size.height / 4.6 - 25;

    final double imageHeight = gridWidth * 1.5; // 16:9 aspect ratio for images
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.all(5),
        // Reduced margin
        clipBehavior: Clip.antiAlias,
        // Add this line to clip the content to the card's shape
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Consistent border radius
        ),
        child: InkWell(
          onTap: widget.onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(4),
                height: imageHeight,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      // lot["lotImageURL"], //todo:
                      "https://i.imgur.com/iQy8GLM.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return LayoutBuilder(builder: (context, constraints) {
                                double width = constraints.maxWidth;
                                double height = constraints.maxHeight;
                                return AlertDialog(
                                  contentPadding: const EdgeInsets.only(left: 30,top:20),
                                  // width: width,
                                  // height: height,
                                  title:  Text("Rate this lot",textAlign: TextAlign.center,style: GoogleFonts.quicksand(
                                      color: Colors.black, fontWeight: FontWeight.bold),),
                                  content: FivePointedStar(
                                    size: const Size(40,40),
                                    onChange: (count) {
                                      setState(() {
                                        mycount = count;
                                      });
                                    },
                                  ),
                                  actions: [

                                    const SizedBox(height:16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        MaterialButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          color: const Color.fromRGBO(11, 38, 59, 1),
                                          onPressed: () {
                                              rateLot(mycount,widget.lot["lotId"]);
                                              Navigator.pop(context);

                                          },
                                          child: Text(
                                            "Ok",
                                            style: GoogleFonts.quicksand(
                                                color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        MaterialButton(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                              side: const BorderSide(color: Colors.white)),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Cancel",
                                            style: GoogleFonts.quicksand(
                                                color: const Color.fromRGBO(11, 38, 59, 1)),
                                          ),
                                        )
                                      ],
                                    ),

                                  ],
                                );
                              });
                            });
                      },
                      icon: const Icon(
                        Icons.star,
                        color: Colors.yellowAccent,
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0), // Reduced padding
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.lot["lot"]["lotName"],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26, // Smaller font size
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // Date
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: const Color.fromARGB(255, 8, 44, 68),
                                    width: 2),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    widget.lot["rating"],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.star, size: 16),
                                ],
                              ),
                            ),
                          ),
                          // Price
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 8, 44, 68),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    const Icon(Icons.pin_drop,
                                        color: Colors.white,
                                        size: 12), // Smaller icon
                                    const SizedBox(width: 4),
                                    Text(
                                      '${widget.lot["distance"]} Kms',
                                      style: GoogleFonts.quicksand(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors
                                                .white // Smaller font size
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
      ),
    );
  }

  void rateLot(int mycount, lotId) async {
    try {
      final response = await Dio().post(
        Constants.rateLot,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
          validateStatus: (status) =>
          status! < 1000, // This line is extremely important
        ),
        data: {
          "userRating":mycount,
          "lotId":lotId
        },
      );

      if (kDebugMode) {
        print("[RATELOT]: ${response.data}");
        print("[STATUS]: ${response.statusCode}");
      }

      if (response.statusCode == 200) {
       showToast("Thank you for rating this lot");
      } else if (response.statusCode == 400) {
        showToast(response.data['MESSAGE'] ??
            "Something went wrong. Please try again later");
      }
      showToast("Something went wrong. Please try again later");
    } catch (err) {
      if (kDebugMode) {
        print("[ERROR]: $err");
      }

      showToast("Something went wrong. Please try again later");
    }
  }
  }

