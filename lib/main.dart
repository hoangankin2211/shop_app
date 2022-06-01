import 'package:flutter/material.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import './screens/product_overview_screen.dart';
import './providers/product_provider.dart';
import 'package:provider/provider.dart';
import './providers/cart_provider.dart';
import './screens/cart_screen.dart';

void main() {
  runApp(const MyApp());
}

final lightTheme = ThemeData(
  primaryColor: Colors.greenAccent,
  primarySwatch: Colors.blueGrey,
  backgroundColor: Colors.white,
);

final darkTheme = ThemeData(
  primaryColor: Colors.white,
  backgroundColor: Colors.grey,
);  

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
      ],
      child: MaterialApp(
        theme: lightTheme,
        title: 'My Shop',
        home: const MyHomePage(),
        routes: {
          ProductDetailScreen.routeName: (context) =>
              const ProductDetailScreen(),
          CartScreen.routeName: (context) => const CartScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ProductOverviewScreen(),
    );
  }
}
