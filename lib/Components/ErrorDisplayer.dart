import 'package:flutter/material.dart';

class ErrorOverlay {
  static void show(BuildContext context, String errorMessage,
      {int durationInSeconds = 4}) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    // Create an entry for the overlay
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 30.0,
        left: 20.0,
        right: 20.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 223, 95, 113),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Text(
              errorMessage,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    // Insert the overlay
    overlay.insert(overlayEntry);

    // Remove the overlay after the specified duration
    Future.delayed(Duration(seconds: durationInSeconds), () {
      overlayEntry.remove();
    });
  }
}
