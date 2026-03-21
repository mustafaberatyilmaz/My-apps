// lib/screens/product_discovery_screen.dart
// Ana sayfa – Ürün listesi ekranı (Gün 5: GridView, arama, navigasyon)

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';

class ProductDiscoveryScreen extends StatefulWidget {
  const ProductDiscoveryScreen({super.key});

  @override
  State<ProductDiscoveryScreen> createState() => _ProductDiscoveryScreenState();
}

class _ProductDiscoveryScreenState extends State<ProductDiscoveryScreen> {
  // Ürün listesi ve arama için state değişkenleri
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  // Sepet listesi (basit state simülasyonu – Gün 5)
  final List<Product> _cartItems = [];
  // Arama kutusu kontrolcüsü (Gün 4: TextEditingController)
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    // Arama dinleyicisi
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // JSON dosyasından ürün yükleme (Gün 4: rootBundle, fromJson)
  Future<void> _loadProducts() async {
    final String jsonString =
        await rootBundle.loadString('assets/products.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    final products =
        jsonList.map((j) => Product.fromJson(j as Map<String, dynamic>)).toList();
    setState(() {
      _allProducts = products;
      _filteredProducts = products;
      _isLoading = false;
    });
  }

  // Arama/filtreleme mantığı (Gün 4: basit filtreleme)
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts
          .where((p) =>
              p.name.toLowerCase().contains(query) ||
              p.subtitle.toLowerCase().contains(query))
          .toList();
    });
  }

  // Sepete ürün ekleme (Gün 5: basit state güncelleme)
  void _addToCart(Product product) {
    setState(() {
      _cartItems.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} sepete eklendi!'),
        backgroundColor: const Color(0xFF0A84FF),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppBar alanı
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Discover',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Find your perfect device.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8E8E93),
                        ),
                      ),
                    ],
                  ),
                  // Sepet ikonu butonu
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined,
                            color: Colors.black, size: 28),
                        onPressed: () {
                          // Named Route ile sepet sayfasına git (Gün 3)
                          Navigator.pushNamed(
                            context,
                            '/cart',
                            arguments: _cartItems,
                          ).then((_) {
                            // Sepetten dönünce sayıyı güncelle
                            setState(() {});
                          });
                        },
                      ),
                      if (_cartItems.isNotEmpty)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0A84FF),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${_cartItems.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Arama çubuğu (Gün 4: TextEditingController + filtreleme)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search products',
                  hintStyle: const TextStyle(color: Color(0xFF8E8E93)),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF8E8E93)),
                  filled: true,
                  fillColor: const Color(0xFFF2F2F7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            // Banner görseli (Gün 4: Image.asset kullanımı)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/banner.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF003399),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'GIFT STORE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Ürün listesi – GridView.builder (Gün 5: GridView)
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredProducts.isEmpty
                      ? const Center(
                          child: Text(
                            'Ürün bulunamadı.',
                            style: TextStyle(color: Color(0xFF8E8E93)),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                          ),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = _filteredProducts[index];
                            return _ProductCard(
                              product: product,
                              onTap: () {
                                // Named Route + Route Arguments ile detay sayfası (Gün 3)
                                Navigator.pushNamed(
                                  context,
                                  '/product-details',
                                  arguments: {
                                    'product': product,
                                    'cartItems': _cartItems,
                                    'onAddToCart': _addToCart,
                                  },
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

// Ürün kartı widget'ı (ayrı widget sınıfı – iyi pratik)
class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ürün görseli (Gün 4: Image.asset)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    product.imageAsset,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.headphones,
                        size: 64,
                        color: Color(0xFF8E8E93),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Ürün adı
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // Alt başlık
          Text(
            product.subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF8E8E93),
            ),
          ),
          const SizedBox(height: 2),
          // Fiyat
          Text(
            '\$${product.price.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0A84FF),
            ),
          ),
        ],
      ),
    );
  }
}
