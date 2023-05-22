import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/store/store.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(StoreState()) {
    on<StoreProductsRequested>(_handleStorProductsRequested);
    on<StoreProductsAddedToCart>(_handleAddToCart);
    on<StoreProductsRemovedFromCart>(_handleRemoveFromCart);
  }

  final StoreRepostory api = StoreRepostory();

  Future<void> _handleStorProductsRequested(
      StoreProductsRequested event, Emitter<StoreState> emit) async {
    try {
      emit(state.copyWith(productStatus: StoreRequest.requestInProgress));

      final response = await api.getProducts();
      emit(state.copyWith(
          productStatus: StoreRequest.requestSucess, products: response));
    } catch (e) {
      emit(state.copyWith(productStatus: StoreRequest.requestFailure));
    }
  }

  Future<void> _handleAddToCart(
    StoreProductsAddedToCart event,
    Emitter<StoreState> emit
  )async{
    emit(state.copyWith(cartIds: {...state.cartIds, event.cartId}));

  }
  Future<void> _handleRemoveFromCart(
    StoreProductsRemovedFromCart event,
    Emitter<StoreState> emit
  )async{
    emit(state.copyWith(cartIds: {...state.cartIds}..remove(event.cartId)));
  }
}
