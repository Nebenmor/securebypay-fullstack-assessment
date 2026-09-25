import 'package:flutter/material.dart';

class AuthSidePanel extends StatelessWidget {
  final String heading;
  final String body;
  const AuthSidePanel({super.key, required this.heading, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/auth_panel_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.all(48),
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            heading,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, height: 35 / 24, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: const TextStyle(fontSize: 18, height: 30 / 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}