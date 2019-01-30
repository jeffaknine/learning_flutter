import 'package:flutter/material.dart';

import '../widgets/drawer.dart';

class MainContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainContainerState();
  }
}

class _MainContainerState extends State<MainContainer> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer: DrawerWidget(),
      // body: ,
    );
  }
}
