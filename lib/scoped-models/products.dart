import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../models/product.dart';

const String dbUrl = 'https://flutter-products-74aed.firebaseio.com/';

mixin ProductsModel on Model {
  List<Product> _products = [];
  String _selectedProductId;
  bool _showFavorites = false;
  bool _isLoading = false;

  bool get loadingProducts {
    return _isLoading;
  }

  List<Product> get products {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  String get selectedProductId {
    return _selectedProductId;
  }

  Product get selectedProduct {
    if (_selectedProductId == null) {
      return null;
    }
    return _products
        .firstWhere((Product product) => product.id == _selectedProductId);
  }

  int get selectedProductIndex {
    return _products
        .indexWhere((Product product) => product.id == _selectedProductId);
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Future<Null> fetchProducts(String token) {
    _isLoading = true;
    return http
        .get(dbUrl + 'products.json?auth=$token')
        .then((http.Response response) {
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> products = json.decode(response.body);
      if (products == null) {
        _isLoading = false;
        notifyListeners();
        return;
      } else if (products['error']['message'] == 'INVALID_ID_TOKEN') {}
      products.forEach((String productId, dynamic productData) {
        final Product product = Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          image: productData['image'],
          userEmail: productData['userEmail'],
          userId: productData['userId'],
        );
        fetchedProductList.add(product);
      });
      _products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
      _selectedProductId = null;
    });
  }

  Future<bool> addProduct(
      title, description, price, image, userEmail, userId, token) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'price': price,
      'image': image,
      'userEmail': userEmail,
      'userId': userId
    };

    final http.Response response = await http
        .post(dbUrl + 'products.json?auth=$token', body: json.encode(data));
    try {
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseBody = json.decode(response.body);
      _products.add(Product(
          id: responseBody['name'],
          title: title,
          description: description,
          price: price,
          image: image,
          userEmail: userEmail,
          userId: userId));
      _selectedProductId = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(
      title, description, price, image, userEmail, userId, token) {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'price': price,
      'image': image,
      'userEmail': userEmail,
      'userId': userId
    };
    return http
        .put(dbUrl + 'products/${selectedProduct.id}.json?auth=$token',
            body: json.encode(data))
        .then((http.Response reponse) {
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          price: price,
          image: image,
          userEmail: userEmail,
          userId: userId);

      _products[selectedProductIndex] = updatedProduct;
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteProduct(token) {
    _isLoading = true;
    notifyListeners();
    return http
        .delete(dbUrl + '/products/${selectedProduct.id}.json?auth=$token')
        .then((http.Response reponse) {
      print(reponse);
      _products.removeAt(selectedProductIndex);
      _selectedProductId = null;
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void selectProduct(String productId) {
    _selectedProductId = productId;
    notifyListeners();
  }

  void toggleProductFavoriteStatus() {
    final bool isFavorite = !_products[selectedProductIndex].isFavorite;
    final Product updatedProduct = new Product(
        id: selectedProduct.id,
        description: selectedProduct.description,
        title: selectedProduct.title,
        image: selectedProduct.image,
        price: selectedProduct.price,
        isFavorite: isFavorite,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}
