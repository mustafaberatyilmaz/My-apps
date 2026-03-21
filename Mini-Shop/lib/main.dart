// lib/main.dart
// Uygulama giriş noktası ve Named Route tanımları (Gün 3: Route kavramı)

import 'package:flutter/material.dart';
import 'screens/product_discovery_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/shopping_cart_screen.dart';

void main() {
  runApp(const MiniKatalogApp());
}

class MiniKatalogApp extends StatelessWidget {
  const MiniKatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Shop',
      debugShowCheckedModeBanner: false,
      // Basit Material tema (yalnızca material.dart)
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A84FF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          surfaceTintColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      // Named Routes tanımları (Gün 3: Named Routes)
      initialRoute: '/',
      routes: {
        '/': (context) => const ProductDiscoveryScreen(),
        '/product-details': (context) => const ProductDetailsScreen(),
        '/cart': (context) => const ShoppingCartScreen(),
      },
    );
  }
}
