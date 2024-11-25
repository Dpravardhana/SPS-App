import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        child: GNav(
          rippleColor: Colors.grey[300]!,
          // Effect color
          hoverColor: Colors.grey[100]!,
          // Hover color
          gap: 8,
          // Gap between icons
          activeColor: Colors.black,
          // Active color
          iconSize: 24,
          // Icon size
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          // Button padding
          duration: const Duration(milliseconds: 400),
          // Animation duration
          tabBackgroundColor: Colors.grey[100]!,
          // Selected tab background color
          color: Colors.black,
          // Unselected icon color
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.car_repair_rounded,
              text: 'Lots',
            ),
            GButton(
              icon: Icons.qr_code,
              text: 'Scan',
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
            ),
          ],
          selectedIndex: currentIndex,
          onTabChange: onTap,
        ),
      ),
    );
  }
}
