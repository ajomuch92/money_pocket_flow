import 'package:flutter/material.dart';

class ErrorEmpty extends StatelessWidget {
  final String message;
  final Widget? child;
  final bool fullHeight;
  const ErrorEmpty(
      {super.key, required this.message, this.child, this.fullHeight = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: fullHeight ? MediaQuery.of(context).size.height : null,
      child: Column(
        mainAxisAlignment:
            fullHeight ? MainAxisAlignment.center : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          child ?? Container(),
          Text(
            message,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
