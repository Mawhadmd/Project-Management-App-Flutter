import 'package:flutter/material.dart';

class Topbar extends StatelessWidget {
  const Topbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
         
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              "Hello, User",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Transform.translate(
              offset: const Offset(0.0, -5),
              child: Text(
                "Welcome back!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(left: 16),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(30),
            // image: const DecorationImage(
            //   image: AssetImage("assets/profile.jpg"),
            //   fit: BoxFit.cover,
            // ),
          ),
        ),
      ],
    );
  }
}
