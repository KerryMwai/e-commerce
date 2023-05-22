import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/store/store.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hasEmptyCart=context.select<StoreBloc, bool>((b) =>b.state.cartIds.isEmpty );
    final cartProducts = context.select<StoreBloc, List<Product>>((b) => b
        .state.products
        .where((product) => b.state.cartIds.contains(product.id))
        .toList());
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your cart"),
          centerTitle: true,
        ),
        body:hasEmptyCart?Center(
          child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("The cart is Empty"),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Add product"))
                ],
              ),
        ): GridView.builder(
          itemCount: cartProducts.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
               final product = cartProducts[index];
              return Card(
                key: ValueKey(product.id),
                child: Column(
                  children: [
                    Flexible(child: Image.network(product.image)),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: Text(
                      product.title,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                    )),
                    const SizedBox(
                      height: 20,
                    ),
                    OutlinedButton(
                        style:const  ButtonStyle(
                            padding:  MaterialStatePropertyAll(
                                EdgeInsets.all(10)),
                            backgroundColor:  MaterialStatePropertyAll<Color>(
                                    Colors.black26)
                               ),
                        onPressed: () {
                         context.read<StoreBloc>().add(StoreProductsRemovedFromCart(product.id));
                         
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:  const [
                                      Icon(
                                        Icons.remove_shopping_cart,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Remove from Cart",
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 16,
                                            color: Colors.black),
                                      )
                                    ],
                            ),
                          ),
                        ))
                  ],
                ),
              );
            }));
  }
}
