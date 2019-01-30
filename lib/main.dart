import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/auth.dart';
import './pages/product_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './scoped-models/main.dart';
import './models/product.dart';

main() {
  final MainModel _model = MainModel();
  runApp(MyApp(_model));
}

class MyApp extends StatelessWidget {
  final MainModel _model;
  MyApp(this._model) {
    _model.autoAuthenticate();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
        model: _model,
        child: MaterialApp(
          theme: ThemeData.dark(),
          // theme: ThemeData(
          //     primarySwatch: Colors.deepOrange, accentColor: Colors.purpleAccent),
          // home: AuthPage(),
          routes: {
            '/': (BuildContext context) => _model.authenticatedUser != null
                ? ProductsPage(_model)
                : AuthPage(),
            '/admin': (BuildContext context) => ProductAdmin(_model),
          },
          onGenerateRoute: (RouteSettings settings) {
            final List<String> pathElements = settings.name.split('/');
            if (pathElements[0] != '') {
              return null;
            }
            if (pathElements[1] == 'product') {
              final String productId = (pathElements[2]);
              final Product product = _model.products
                  .firstWhere((Product product) => product.id == productId);
              _model.selectProduct(productId);
              return MaterialPageRoute<bool>(
                  builder: (context) => ProductPage(
                        product: product,
                        address: 'Union Square, San Francisco',
                      ));
            }
            return null;
          },
        ));
  }
}
