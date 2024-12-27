import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';

class AfyaButtonTab extends StatefulWidget {
  const AfyaButtonTab({super.key});

  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<AfyaButtonTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
          length: 6,
          child: Column(
            children: <Widget>[
              ButtonsTabBar(
                backgroundColor: Colors.red,
                unselectedBackgroundColor: Colors.grey[300],
                unselectedLabelStyle: const TextStyle(color: Colors.black),
                labelStyle:
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.directions_car),
                    text: "car",
                  ),
                  Tab(
                    icon: Icon(Icons.directions_transit),
                    text: "transit",
                  ),
                  Tab(
                    icon: Icon(Icons.directions_transit),
                    text: "transit",
                  ),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: <Widget>[
                      
                  ],
                ),
              ),
            ],
          ),
        );
  }
}