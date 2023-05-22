import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'store/store.dart';
void main() {
  runApp(BlocProvider(
    create: (context) => StoreBloc(),
    child: const StoreApp(),
  ));
}