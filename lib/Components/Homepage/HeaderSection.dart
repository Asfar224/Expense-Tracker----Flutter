import 'package:flutter/material.dart';
import 'package:expense_management_app/Components/Homepage/StatCard.dart';

class HeaderSection extends StatelessWidget {
  final Widget middleSection;

  const HeaderSection({Key? key, required this.middleSection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 78, 21, 144),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Content
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 35),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(width: 10),
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
                SizedBox(width: 50),
                Text(
                  "Monthly Cash Flow",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 60),
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
          ),
          // Middle Section
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: middleSection,
            ),
          ),
        ],
      ),
    );
  }
}
