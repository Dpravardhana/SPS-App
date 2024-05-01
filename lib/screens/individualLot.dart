import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

import 'navigation/navigation.dart';

class IndividualLot extends StatefulWidget {
  final Map<String,dynamic> data;

  const IndividualLot({Key? key, required this.data}) : super(key: key);

  @override
  State<IndividualLot> createState() => _IndividualLotState();
}

class _IndividualLotState extends State<IndividualLot> {
  // Map<String, dynamic> data ={
  //   "_id": "662d39eb745f280a0c4eeb96",
  //   "lotName": "Lot 6",
  //   "description": "South Western Railways adjusts the Vande Bharat train schedule between Bengaluru and Coimbatore. Departure from Coimbatore is now at 7.25 am, and arrival in Bengaluru is at 1.50 pm. ",
  //   "short": "Bengaluru - Coimbatore Vande Bharat Express Timings Revised \n hh",
  //   "coordinates": "6 6",
  //   "rating": "3.3",
  //   "votes": "10",
  //   "createdAt": "2024-04-27T17:46:19.318Z",
  //   "updatedAt": "2024-04-30T15:53:42.728Z",
  //   "__v": 0,
  //   "lotId": "662d39eb745f280a0c4eeb94",
  //   "lotImageURL": "https://i.imgur.com/iQy8GLM.jpg"
  // };



  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            IntrinsicHeight(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height*0.9,
                  minWidth: MediaQuery.of(context).size.width,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.maxFinite,
                        height: 400,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.data["lot"]["lotImageURL"]),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Positioned(
                        top: 360,
                        left: 20,
                        right: 20,
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(25, 18, 20, 0),
                            width: MediaQuery.of(context).size.width,
                            height: 80,
                            // constraints: BoxConstraints(
                            //     maxWidth: double.maxFinite,
                            //     minHeight: 100,
                            // ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                )),
                            child: Text(
                              widget.data["lot"]["lotName"],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),

                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Positioned(
                        top: 460,
                        left: 20,
                        right: 20,
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: InkWell(
                            onTap:(){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NavigationPage(coordinates:widget.data["lot"]["coordinates"]),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(25, 18, 20, 0),
                              width: MediaQuery.of(context).size.width,
                              height: 70,
                              // constraints: BoxConstraints(
                              //     maxWidth: double.maxFinite,
                              //     minHeight: 100,
                              // ),
                              decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  border: Border.all(color: Colors.black, width: 2)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom:8),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.pin_drop_outlined,
                                      color: Colors.black,
                                    ),
                                    const Spacer(),
                                    Text(
                                      "Start Navigation",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.quicksand(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const Spacer(),
                                     const Icon(Icons.arrow_forward_ios_rounded,color: Colors.black,)
                                  ],
                                ),
                              ),

                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      right: 20,
                      top: 550,
                      child: Material(
                        elevation: 2,
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 15, 0),
                          width: MediaQuery.of(context).size.width,

                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(25)),
                            color: Colors.grey[400],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade500,
                                offset: const Offset(5, 5),
                                blurRadius: 15,
                                spreadRadius: 1,
                              ),
                              const BoxShadow(
                                color: Colors.white,
                                offset: Offset(-1, -1),
                                blurRadius: 15,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MarkdownBody(
                                  data: widget.data["lot"]['description'],
                                  styleSheet: MarkdownStyleSheet(
                                    h2: GoogleFonts.poppins(color: Colors.black),
                                    h1: GoogleFonts.poppins(color: Colors.black),
                                    p: GoogleFonts.quicksand(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),
                                    a: GoogleFonts.poppins(color: Colors.black),
                                    h3: GoogleFonts.poppins(color: Colors.black),
                                    h4: GoogleFonts.poppins(color: Colors.black),
                                    h5: GoogleFonts.poppins(color: Colors.black),
                                    h6: GoogleFonts.poppins(color: Colors.black),
                                    em: GoogleFonts.poppins(color: Colors.black),
                                    strong: GoogleFonts.poppins(color: Colors.black),
                                    del: GoogleFonts.poppins(color: Colors.black),
                                    blockquote:
                                    GoogleFonts.poppins(color: Colors.black),
                                    img: GoogleFonts.poppins(color: Colors.black),
                                    checkbox: GoogleFonts.poppins(color: Colors.black),
                                    listBullet:
                                    GoogleFonts.poppins(color: Colors.black),
                                    tableBody: GoogleFonts.poppins(color: Colors.black),
                                    tableHead: GoogleFonts.poppins(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),



                  ],
                ),
              ),
            ),

          ],
        ),
      ),


    );
  }
}