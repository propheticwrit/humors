import 'dart:io';

import 'package:humors/app/models/category.dart';
import 'package:humors/app/models/survey.dart';
import 'package:humors/services/api.dart';
import 'package:rxdart/rxdart.dart';

class CategoryListBloc {

  final _apiConnector = MoodConnector();
  final _categoriesFetcher = PublishSubject<List<Category>>();
  final _baseCategoriesFetcher = PublishSubject<Map<Category, List<Category>>>();

  Stream<Map<Category, List<Category>>> get baseCategories => _baseCategoriesFetcher.stream;
  Stream<List<Category>> get categories => _categoriesFetcher.stream;

  fetchCategories() async {
    try {
      List<Category> categories = await _apiConnector.apiCategories();
      _categoriesFetcher.sink.add(categories);
    } on HttpException {
      _categoriesFetcher.sink.addError('Error parsing categories');
    }
  }

  fetchBaseCategories() async {
    try {
      Map<Category, List<Category>> baseCategories = await _apiConnector.apiBaseCategories();
      _baseCategoriesFetcher.sink.add(baseCategories);
    } on HttpException {
      _baseCategoriesFetcher.sink.addError('Error parsing categories');
    }
  }

  dispose() {
    _categoriesFetcher.close();
    _baseCategoriesFetcher.close();
  }
}