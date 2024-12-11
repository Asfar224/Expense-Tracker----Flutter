import 'package:flutter/material.dart';
import 'package:expense_management_app/Components/Homepage/HeaderSection.dart';
import 'package:expense_management_app/Components/Homepage/MiddleSection.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HeaderSection(
        middleSection: MiddleSection(),
      ),
    );
  }
}
