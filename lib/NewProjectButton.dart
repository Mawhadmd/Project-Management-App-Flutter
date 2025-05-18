import 'package:finalmobileproject/AddProjectForm.dart';
import 'package:flutter/material.dart';

class Newprojectbutton extends StatefulWidget {
  const Newprojectbutton({super.key});

  @override
  State<Newprojectbutton> createState() => _NewprojectbuttonState();
}

class _NewprojectbuttonState extends State<Newprojectbutton> {
  @override
  Widget build(BuildContext context) {
    return  ElevatedButton.icon(
                onPressed: () {Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Addprojectform(),
                  ),
                );},
                icon: const Icon(Icons.edit, size: 18),
                label: const Text("New Project", style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              );
  }
}