import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';
import '../models/product.dart';
import '../models/user.dart';

class ProductCreateOrEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductCreateOrEditPageState();
  }
}

class _ProductCreateOrEditPageState extends State<ProductCreateOrEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image':
        'https://www.google.com/imgres?imgurl=https%3A%2F%2Fwww.capetownetc.com%2Fwp-content%2Fuploads%2F2018%2F06%2FChoc_1.jpeg&imgrefurl=https%3A%2F%2Fwww.capetownetc.com%2Fevents%2Fthe-chocolate-festival%2F&docid=72Fx0nddQ7GrXM&tbnid=Kt8FwqajbzrnhM%3A&vet=10ahUKEwj25Mjn2pDgAhWpsqQKHQUbD9gQMwhvKAUwBQ..i&w=3266&h=2177&bih=938&biw=1920&q=chocolate&ved=0ahUKEwj25Mjn2pDgAhWpsqQKHQUbD9gQMwhvKAUwBQ&iact=mrc&uact=8',
    'address': 'San Francisco'
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitleTextField(Product product) {
    return TextFormField(
      initialValue: product != null ? product.title : '',
      decoration: InputDecoration(labelText: 'Title'),
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return 'Title is required and should be 5+ characters long';
        }
      },
      onSaved: (String value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildDescriptionTextField(Product product) {
    return TextFormField(
      initialValue: product != null ? product.description : '',
      maxLines: 4,
      decoration: InputDecoration(labelText: 'Description'),
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return 'Description is required and should be 5+ characters long';
        }
      },
      onSaved: (String value) {
        _formData['description'] = value;
      },
    );
  }

  Widget _buildPriceTextField(Product product) {
    return TextFormField(
      initialValue: product != null ? product.price.toString() : '',
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Price'),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Price is required and should be a number.';
        }
      },
      onSaved: (String value) {
        _formData['price'] = double.parse(value);
      },
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return model.loadingProducts
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RaisedButton(
              color: Theme.of(context).accentColor,
              child: Text("Save"),
              onPressed: () => _submitForm(
                  model.addProduct,
                  model.updateProduct,
                  model.authenticatedUser,
                  model.selectProduct,
                  model.selectedProductIndex));
    });
  }

  void _submitForm(Function addProduct, Function updateProduct,
      User authenticatedUser, Function setSelectedProduct,
      [int selectedProductIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    if (selectedProductIndex == -1) {
      addProduct(
        _formData['title'],
        _formData['description'],
        _formData['price'],
        _formData['image'],
        authenticatedUser.email,
        authenticatedUser.id,
      ).then((bool success) {
        if (success)
          Navigator.pushReplacementNamed(context, '/products')
              .then((_) => setSelectedProduct(null));
        else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Server error while creating the product'),
          ));
        }
      });
    } else {
      updateProduct(
        _formData['title'],
        _formData['description'],
        _formData['price'],
        _formData['image'],
        authenticatedUser.email,
        authenticatedUser.id,
      ).then((bool success) {
        if (success)
          Navigator.pushReplacementNamed(context, '/products')
              .then((_) => setSelectedProduct(null));
        else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Server error while creating the product'),
          ));
        }
      });
    }
  }

  Widget _builPageContent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
            width: targetWidth,
            margin: EdgeInsets.all(10.0),
            child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
                  children: <Widget>[
                    _buildTitleTextField(product),
                    _buildDescriptionTextField(product),
                    _buildPriceTextField(product),
                    SizedBox(
                      height: 10.0,
                    ),
                    _buildSubmitButton(),
                  ],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      final Widget pageContent =
          _builPageContent(context, model.selectedProduct);

      return model.selectedProductIndex == -1
          ? pageContent
          : Scaffold(
              appBar: AppBar(title: Text("Edit Product")), body: pageContent);
    });
  }
}
