import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';
import './product_create_or_edit.dart';

class ProductListPage extends StatefulWidget {
  final MainModel model;

  ProductListPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _ProductListPageState();
  }
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  initState() {
    widget.model.fetchProducts(widget.model.authenticatedUser.token);
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(model.products[index].id);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return ProductCreateOrEditPage();
        }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
              background: Container(color: Colors.red),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  model.selectProduct(model.products[index].id);
                  model.deleteProduct(model.authenticatedUser.token);
                }
              },
              key: Key(model.products[index].title),
              child: Column(
                children: <Widget>[
                  ListTile(
                      leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(model.products[index].image)),
                      title: Text(model.products[index].title),
                      subtitle:
                          Text('\$${model.products[index].price.toString()}'),
                      trailing: _buildEditButton(context, index, model)),
                  Divider(),
                ],
              ));
        },
        itemCount: model.products.length,
      );
    });
  }
}
