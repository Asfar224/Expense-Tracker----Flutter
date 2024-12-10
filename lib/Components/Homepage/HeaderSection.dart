import 'package:flutter/material.dart';
import 'package:expense_management_app/Components/Homepage/StatCard.dart';

class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 78, 21, 144),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.person,
                color: Colors.white,
                size: 30, // Adjust the size as needed
              ),
              SizedBox(width: 8), // Add some spacing between the icon and text
              Text(
                "Muhammad Asfar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "Monthly Cash Flow",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatCard(
                title: "Income",
                amount: "₹4,00,000",
                color: Colors.green,
              ),
              StatCard(
                title: "Expenses",
                amount: "₹1,59,919",
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
