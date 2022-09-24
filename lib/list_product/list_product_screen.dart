import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_shop/cart/cart_screen.dart';
import 'package:mini_shop/list_product/list_product_cubit.dart';
import 'package:mini_shop/list_product/product_model.dart';

class ListProductScreen extends StatefulWidget {
  const ListProductScreen({Key? key}) : super(key: key);

  @override
  State<ListProductScreen> createState() => _ListProductScreenState();
}

class _ListProductScreenState extends State<ListProductScreen> {
  ListProductCubit _listProductCubit = ListProductCubit();
  @override
  void initState() {
    _listProductCubit.converListStringToListModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Danh mục',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          InkWell(
            onTap: () async {
              final data = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(
                    listProductSelected: _listProductCubit.listProductSelected,
                  ),
                ),
              );
              if (data != null) {
                _listProductCubit.updateDataSelectedNew(data);
                _listProductCubit.listProductSelected = data;
              }
            },
            child: BlocBuilder<ListProductCubit, ProductState>(
              bloc: _listProductCubit,
              builder: (context, state) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(Icons.shopping_cart),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                              '${_listProductCubit.listProductSelected.length}'),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
      body: BlocBuilder<ListProductCubit, ProductState>(
        bloc: _listProductCubit,
        builder: (context, ProductState state) {
          if (state is ProductGettingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ProductGetSuccessState &&
              _listProductCubit.listProduct.isNotEmpty) {
            List<ProducModel> listProducts = _listProductCubit.listProduct;
            return ListView.separated(
              itemBuilder: (context, index) {
                return ItemProductWidget(
                  producModel: listProducts[index],
                  onAddItem: (ProducModel model) {
                    _listProductCubit.addItemToCart(model);
                  },
                  isSelected: _listProductCubit.listProductSelected
                      .contains(listProducts[index]),
                );
              },
              itemCount: _listProductCubit.listProduct.length,
              separatorBuilder: ((context, index) => SizedBox(
                    height: 12,
                  )),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class ItemProductWidget extends StatelessWidget {
  final ProducModel producModel;
  final Function(ProducModel producModel) onAddItem;
  final bool isSelected;
  const ItemProductWidget(
      {Key? key,
      required this.producModel,
      required this.onAddItem,
      required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            color: producModel.color ?? Colors.grey,
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
              child: Text(
            '${producModel.name}',
            style: TextStyle(
              fontSize: 16,
            ),
          )),
          isSelected
              ? Icon(Icons.check)
              : InkWell(
                  child: Text(
                    'Thêm',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                  onTap: () {
                    onAddItem(producModel);
                    //  print('${producModel.name}');
                  },
                ),
        ],
      ),
    );
  }
}

//Truyen nguoc Model vao funcition de dung trong Input trong funcition onAddItem nay luon



