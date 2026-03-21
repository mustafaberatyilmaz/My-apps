// lib/screens/product_details_screen.dart
// Ürün detay ekranı (Gün 3: Route Arguments, Gün 5: Ürün detayı, sepete ekle)

import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Route Arguments ile ürün verisini al (Gün 3: Route Arguments)
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Product product = args['product'] as Product;
    final Function(Product) onAddToCart =
        args['onAddToCart'] as Function(Product);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Üst kısım – geri butonu ve ürün görseli
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ürün görseli alanı
                    Stack(
                      children: [
                        Container(
                          height: 280,
                          color: const Color(0xFFF2F2F7),
                          child: ClipRect(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              // Image.asset ile yerel görsel (Gün 4)
                              child: Image.asset(
                                product.imageAsset,
                                fit: BoxFit.contain,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.headphones,
                                      size: 100,
                                      color: Color(0xFF8E8E93),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        // Geri butonu (Gün 3: Navigator.pop)
                        Positioned(
                          top: 16,
                          left: 12,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Ürün bilgileri
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Ürün adı
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Alt başlık
                          Text(
                            product.subtitle,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8E8E93),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Açıklama bölümü
                          const Text(
                            'Açıklama',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4A4A4A),
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Özellikler (Specifications) – Row + Card (Gün 2: Card, Row)
                          const Text(
                            'Özellikler',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _SpecCard(
                                label: product.spec1Label,
                                value: product.spec1Value,
                              ),
                              const SizedBox(width: 10),
                              _SpecCard(
                                label: product.spec2Label,
                                value: product.spec2Value,
                              ),
                              const SizedBox(width: 10),
                              _SpecCard(
                                label: product.spec3Label,
                                value: product.spec3Value,
                              ),
                            ],
                          ),
                          const SizedBox(height: 100), // Alt buton için boşluk
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Alt kısım – fiyat ve sepete ekle butonu
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFE5E5EA), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Fiyat',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8E8E93),
                        ),
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    // ElevatedButton ile sepete ekle (Gün 2: butonlar, Gün 5: state güncelleme)
                    child: ElevatedButton(
                      onPressed: () {
                        onAddToCart(product);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Sepete Ekle',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Özellik kartı widget'ı (Gün 2: Card yapısı)
class _SpecCard extends StatelessWidget {
  final String label;
  final String value;

  const _SpecCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E5EA)),
        ),
        child: Column(
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF8E8E93),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
