// lib/screens/shopping_cart_screen.dart
// Alışveriş sepeti ekranı (Gün 5: sepet simülasyonu, setState, ListView)

import 'package:flutter/material.dart';
import '../models/product.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  late List<Product> _cartItems;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Route Arguments ile sepet listesini al (Gün 3: Route Arguments)
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is List<Product>) {
      _cartItems = args;
    } else {
      _cartItems = [];
    }
  }

  // Sepetten ürün kaldırma (Gün 5: basit state güncelleme)
  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  // Toplam tutar hesaplama
  double get _totalPrice {
    return _cartItems.fold(0, (sum, item) => sum + item.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar (Gün 2: temel widget'lar)
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30, color: Colors.black),
          // Geri navigasyon (Gün 3: Navigator.pop)
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sepet',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: _cartItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined,
                      size: 80, color: Color(0xFFD1D1D6)),
                  SizedBox(height: 16),
                  Text(
                    'Sepetiniz boş.',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Sepet ürün listesi (Gün 4: ListView.builder)
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return _CartItemTile(
                        product: item,
                        onRemove: () => _removeItem(index),
                      );
                    },
                  ),
                ),

                // Alt kısım – bilgi notu + checkout
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Color(0xFFE5E5EA), width: 1),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Ürün sayısı ve toplam fiyat
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_cartItems.length} ürün',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8E8E93),
                            ),
                          ),
                          Text(
                            'Toplam: \$${_totalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Bilgi notu (Container + Row — Gün 2)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F7),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE5E5EA)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline,
                                color: Color(0xFF8E8E93), size: 18),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Bu bir eğitim simülasyonudur. Gerçek ödeme işlemi yapılmaz.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF8E8E93),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Checkout butonu (Gün 5)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Sipariş Tamamlandı!'),
                                content: const Text(
                                  'Bu bir simülasyondur. Gerçek bir ödeme işlemi yapılmamıştır.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _cartItems.clear(); // Sepeti boşalt
                                      });
                                      Navigator.pop(context); // dialog kapat
                                      Navigator.pop(context); // sepetten çık
                                    },
                                    child: const Text('Tamam'),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Ödemeye Geç',
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
    );
  }
}

// Sepet ürün satırı widget'ı (Gün 2: ListTile, Card, Row)
class _CartItemTile extends StatelessWidget {
  final Product product;
  final VoidCallback onRemove;

  const _CartItemTile({required this.product, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E5EA)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ürün küçük görseli (Gün 4: Image.asset)
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                product.imageAsset,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.headphones,
                      color: Color(0xFF8E8E93));
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Ürün bilgileri (Expanded + Column — Gün 2)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  product.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8E8E93),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // Silme butonu (Gün 5: setState ile sepetten kaldırma)
          IconButton(
            icon: const Icon(Icons.remove_circle_outline,
                color: Color(0xFF8E8E93), size: 22),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
