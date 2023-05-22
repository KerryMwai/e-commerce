import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/store/store.dart';

class StoreApp extends StatelessWidget {
  const StoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "E-Commerce",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.purple),
        home: const StoreAppView(title: "E-Commerce"));
  }
}

class StoreAppView extends StatefulWidget {
  const StoreAppView({super.key, required this.title});

  final String title;

  @override
  State<StoreAppView> createState() => _StoreAppViewState();
}

class _StoreAppViewState extends State<StoreAppView> {
  _addToCart(int cartId) {
    context.read<StoreBloc>().add(StoreProductsAddedToCart(cartId));
  }

  _removeFromCart(int cartId) {
    context.read<StoreBloc>().add(StoreProductsRemovedFromCart(cartId));
  }

  void _viewCart() {
    Navigator.push(
        context,
        PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: Offset.zero)
                .animate(animation),
            child: BlocProvider.value(
                value: context.read<StoreBloc>(), child: child),
          ),
          pageBuilder: (_, __, ___) => const CartScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
     final cartProducts = context.select<StoreBloc, List<Product>>((b) => b
        .state.products
        .where((product) => b.state.cartIds.contains(product.id))
        .toList());
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: Center(
          child: BlocBuilder<StoreBloc, StoreState>(builder: (context, state) {
            if (state.productStatus == StoreRequest.requestInProgress) {
              return const CircularProgressIndicator();
            }

            if (state.productStatus == StoreRequest.requestFailure) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Problem Loading Product"),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                      onPressed: () {
                       context.read<StoreBloc>().add(StoreProductsRequested());
                      },
                      child: const Text("Load product again"))
                ],
              );
            }
            if (state.productStatus == StoreRequest.unknown) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shop_outlined,
                    size: 60,
                    color: Colors.black26,
                  ),
                  const Text("No Product to view"),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                      onPressed: () {
                        context.read<StoreBloc>().add(StoreProductsRequested());
                      },
                      child: const Text("Load Products"))
                ],
              );
            }
            return GridView.builder(
              itemCount: state.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                final product = state.products[index];
                final inCart = state.cartIds.contains(product.id);
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
                          style: ButtonStyle(
                              padding: const MaterialStatePropertyAll(
                                  EdgeInsets.all(10)),
                              backgroundColor: inCart
                                  ? const MaterialStatePropertyAll<Color>(
                                      Colors.black26)
                                  : null),
                          onPressed: () {
                            if (!inCart) {
                              setState(() {
                                _addToCart(product.id);
                              });
                            } else {
                              setState(() {
                                _removeFromCart(product.id);
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: !inCart
                                    ? const [
                                        Icon(Icons.add_shopping_cart),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("Add to Cart")
                                      ]
                                    : const [
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
              },
            );
          }),
        ),
        floatingActionButton: Stack(clipBehavior: Clip.none, children: [
         
          FloatingActionButton(
            onPressed: _viewCart,
            child: const Icon(Icons.shopping_cart),
          ),
           Positioned(
            top: -4,
            right: -10,
              child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
            child: Center( child: Text("${cartProducts.length}"),),
          ))
        ]));
    ;
  }
}
