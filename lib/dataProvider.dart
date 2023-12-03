import 'package:flutter/material.dart';
import 'database/db_helper.dart'; // Asegúrate de importar DBHelper
import 'models/categories.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/foundation.dart';

class DataProvider extends ChangeNotifier {
  List<Categories> _categories = [];

  List<Categories> get categories => _categories;

  void updateCategories(List<Categories> newCategories) {
    _categories = newCategories;
    notifyListeners();
  }
}