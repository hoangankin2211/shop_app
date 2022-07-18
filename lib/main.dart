import 'package:flutter/material.dart';

import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/auth_screen.dart';

import 'package:provider/provider.dart';
import './providers/cart_provider.dart';
import './providers/product_provider.dart';
import './providers/order_provider.dart';
import './providers/auth.dart';

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
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductProvider>(
          create: (_) => ProductProvider([], '', ''),
          update: (context, auth, previousProduct) => ProductProvider(
              previousProduct == null ? [] : previousProduct.items,
              auth.token ?? '',
              auth.userID ?? ''),
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          create: (context) => Cart('', {}, ''),
          update: (context, auth, previousCart) =>
              Cart(auth.token ?? '', previousCart!.item, auth.userID ?? ''),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
            create: (context) => Order([], '', ''),
            update: (context, auth, previousOrder) => Order(
                previousOrder!.orders, auth.token ?? '', auth.userID ?? '')),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            title: 'My Shop',
            home: auth.isAuth
                ? const ProductOverviewScreen()
                : const AuthScreen(),
            routes: {
              AuthScreen.routeName: (context) => const AuthScreen(),
              ProductDetailScreen.routeName: (context) =>
                  const ProductDetailScreen(),
              CartScreen.routeName: (context) => const CartScreen(),
              ProductOverviewScreen.routeName: (context) =>
                  const ProductOverviewScreen(),
              OrderScreen.routeName: (context) => const OrderScreen(),
              UserProductsScreen.routeName: (context) =>
                  const UserProductsScreen(),
            },
          );
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
