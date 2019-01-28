import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/auth.dart';
import './pages/product_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './scoped-models/main.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
        model: MainModel(),
        child: MaterialApp(
          theme: ThemeData.dark(),
          // theme: ThemeData(
          //     primarySwatch: Colors.deepOrange, accentColor: Colors.purpleAccent),
          home: AuthPage(),
          routes: {
            '/products': (BuildContext context) => ProductsPage(),
            '/admin': (BuildContext context) => ProductAdmin(),
          },
          onGenerateRoute: (RouteSettings settings) {
            final List<String> pathElements = settings.name.split('/');
            if (pathElements[0] != '') {
              return null;
            }
            if (pathElements[1] == 'product') {
              final int index = int.parse(pathElements[2]);
              return MaterialPageRoute<bool>(
                  builder: (context) => ProductPage(
                        productIndex: index,
                        address: 'Union Square, San Francisco',
                      ));
            }
            return null;
          },
        ));
  }
}
