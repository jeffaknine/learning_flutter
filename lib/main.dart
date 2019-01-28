import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/auth.dart';
import './pages/product_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './scoped-models/main.dart';
import './models/product.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
        model: model,
        child: MaterialApp(
          theme: ThemeData.dark(),
          // theme: ThemeData(
          //     primarySwatch: Colors.deepOrange, accentColor: Colors.purpleAccent),
          home: AuthPage(),
          routes: {
            '/products': (BuildContext context) => ProductsPage(model),
            '/admin': (BuildContext context) => ProductAdmin(model),
          },
          onGenerateRoute: (RouteSettings settings) {
            final List<String> pathElements = settings.name.split('/');
            if (pathElements[0] != '') {
              return null;
            }
            if (pathElements[1] == 'product') {
              final String productId = (pathElements[2]);
              final Product product = model.products
                  .firstWhere((Product product) => product.id == productId);
              model.selectProduct(productId);
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
