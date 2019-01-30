import 'package:flutter/material.dart';

import './product_list.dart';
import './product_create_or_edit.dart';
import '../scoped-models/main.dart';
import '../widgets/drawer.dart';

class ProductAdmin extends StatelessWidget {
  final MainModel model;
  ProductAdmin(this.model);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: DrawerWidget(),
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
          children: <Widget>[ProductCreateOrEditPage(), ProductListPage(model)],
        ),
      ),
    );
  }
}
