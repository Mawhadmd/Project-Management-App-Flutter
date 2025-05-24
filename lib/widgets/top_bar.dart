import 'package:finalmobileproject/services/ProjectService.dart';
import 'package:finalmobileproject/screens/profile/UserSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Topbar extends StatelessWidget {
  const Topbar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 2, top: 2),
      decoration: BoxDecoration(
        // color: Theme.of(context).colorScheme.surface,
        // borderRadius: BorderRadius.all(Radius.circular(8)),

        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withValues(alpha: 0.3),
        //     spreadRadius: 1,
        //     blurRadius: 4,
        //     offset: const Offset(0, 5),
        //   ),
        // ],
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              FutureBuilder<String?>(
                future: ProjectService().getUserName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading...");
                  }
                  final username = snapshot.data ?? "User";
                  return Text(
                    "Hello, $username",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  );
                },
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
            clipBehavior: Clip.hardEdge,
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary.withAlpha(30),
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child:
                ProjectService().getUserImage() == null
                    ? IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Usersettings(),
                          ),
                        );
                      },
                      icon: SvgPicture.asset(
                        "assets/DefaultUser.svg",
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                    : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Usersettings(),
                          ),
                        );
                      },
                      child: Image.network(
                        ProjectService().getUserImage()!,
                        fit: BoxFit.cover,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
