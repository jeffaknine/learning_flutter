import 'package:flutter/material.dart';

import './product_list.dart';
import './product_create_or_edit.dart';

class ProductAdmin extends StatelessWidget {
  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          automaticallyImplyLeading: false,
          title: Text("Choose"),
        ),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text("Products"),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/products');
          },
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title: Text("ProductAdmin"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: 'Create Product',
              ),
              Tab(
                icon: Icon(Icons.list),
                text: 'My Products',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[ProductCreateOrEditPage(), ProductListPage()],
        ),
      ),
    );
  }
}
