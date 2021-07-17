import 'package:flutter/material.dart';
import 'package:sitecore_flutter/sitecore_headless/sitecore_headless.dart';

class MaterialDrawer extends StatelessWidget {
  final String? currentPage;

  MaterialDrawer({this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
            child: Column(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Color.fromRGBO(75, 25, 88, 1.0)),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://images.unsplash.com/photo-1512529920731-e8abaea917a5?fit=crop&w=840&q=80"),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
                  child: Text("John Doe",
                      style: TextStyle(color: Colors.white, fontSize: 21)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Color.fromRGBO(254, 36, 114, 1.0)),
                            child: Text("Pro",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text("Seller",
                            style: TextStyle(
                                color: Color.fromRGBO(151, 151, 151, 1.0),
                                fontSize: 16)),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text("4.8",
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 152, 0, 1.0),
                                    fontSize: 16)),
                          ),
                          Icon(Icons.star_border,
                              color: Color.fromRGBO(255, 152, 0, 1.0), size: 20)
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(top: 8, left: 8, right: 8),
            children: [
              GestureDetector(
                onTap: () {
                  SitecoreTracking().flushSession();
                },
                child: Container(
                  height: 45,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  margin: EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 24.0),
                        child: Icon(Icons.clean_hands,
                            size: 20, color: Colors.blue),
                      ),
                      Text(
                        "Flush Session",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (currentPage != "Demo")
                    Navigator.pushNamed(context, '/demo');
                },
                child: Container(
                  height: 45,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  margin: EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                      color: currentPage == "Demo"
                          ? Color.fromRGBO(156, 38, 176, 1.0)
                          : Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 24.0),
                        child: Icon(Icons.settings,
                            size: 20,
                            color: currentPage == "Demo"
                                ? Colors.white
                                : Colors.blue),
                      ),
                      Text(
                        "Demo data",
                        style: TextStyle(
                            fontSize: 15,
                            color: currentPage == "Demo"
                                ? Colors.white
                                : Colors.black),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    )));
  }
}
