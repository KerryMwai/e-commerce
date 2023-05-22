import 'package:ecommerce/store/store.dart';
enum StoreRequest{
  unknown,
  requestInProgress,
  requestSucess,
  requestFailure
}

class  StoreState {
  final List<Product> products;
  final StoreRequest productStatus;
  final Set<int> cartIds;
  const StoreState({this.products=const [], this.productStatus=StoreRequest.unknown, this.cartIds= const{}});

  StoreState copyWith({
    List<Product>? products,
    StoreRequest? productStatus,
    Set<int>? cartIds
  })=>StoreState(
    products: products ?? this.products,
    productStatus: productStatus?? this.productStatus,
    cartIds: cartIds ?? this.cartIds
  );
}
