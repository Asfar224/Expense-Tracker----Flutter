import 'package:flutter/material.dart';

class ErrorDisplayer extends StatefulWidget {
  final String? errorMessage;

  const ErrorDisplayer({Key? key, this.errorMessage}) : super(key: key);

  @override
  State<ErrorDisplayer> createState() => _ErrorDispayerState();
}

class _ErrorDispayerState extends State<ErrorDisplayer> {
  bool _isVisible = false;
  String? _currentErrorMessage;

  @override
  void didUpdateWidget(covariant ErrorDisplayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if the errorMessage has changed
    if (widget.errorMessage != null &&
        widget.errorMessage != oldWidget.errorMessage) {
      showError(widget.errorMessage!);
    }
  }

  void showError(String errorMessage) {
    setState(() {
      _currentErrorMessage = errorMessage;
      _isVisible = true;
    });

    // Hide the error after 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Display the error message if _isVisible is true
    return _isVisible
        ? Container(
            width: double.infinity,
            color: Colors.red,
            padding: EdgeInsets.all(10.0),
            child: Text(
              _currentErrorMessage ?? '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
