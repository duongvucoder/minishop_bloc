import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_shop/list_product/product_model.dart';

class ListProductCubit extends Cubit<ProductState> {
  ListProductCubit() : super(ProductInitState());

  List<ProducModel> listProduct = [];
  List<ProducModel> listProductSelected = [];

  void addItemToCart(ProducModel model) {
    if (!listProductSelected.contains(model)) {
      listProductSelected.add(model);
      emit(ProductGetSuccessState());
    }
  }

  void updateDataSelectedNew(List<ProducModel> newSelected) {
    listProductSelected = newSelected;
    emit(ProductGetSuccessState());
  }

  void converListStringToListModel() async {
    // for(int i = 0; i<itemNames.length; i++){
    //   String item = itemNames[i];
    // }
    emit(ProductGettingState());
    await Future.delayed(Duration(seconds: 2));
    for (String item in itemNames) {
      ProducModel model = ProducModel();
      model.name = item;
      model.price = 42;
      Random random = Random();
      model.color = Color.fromARGB(
        random.nextInt(255),
        random.nextInt(255),
        random.nextInt(255),
        1,
      );
      listProduct.add(model);
    }
    emit(ProductGetSuccessState());
  }

  List<String> itemNames = [
    'Gà KFC',
    'Trà sữa',
    'Vịt quay bắc kinh',
    'Sữa chua hạ long',
    'Gà ủ muối',
    'Bia Tiger',
    'Spaghetti',
    'Pizza',
    'Bánh mì hội an',
    'Phở thìn',
    'Chân gà',
    'Coffee',
    'Trà',
    'Xôi',
    'Cơm',
  ];
}

class ProductState {}

class ProductInitState extends ProductState {}

class ProductGettingState extends ProductInitState {}

class ProductGetSuccessState extends ProductInitState {}
