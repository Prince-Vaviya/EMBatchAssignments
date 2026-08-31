import 'package:flutter/material.dart';

// ============================================================================
// CRAVYY CELEBRATIONS - LUXURY CADBURY VELVET PURPLE & GOLD THEME
// ============================================================================

void main() {
  runApp(const MyApp());
}

// ----------------------------------------------------------------------------
// DATA MODELS
// ----------------------------------------------------------------------------

class FoodItem {
  final String name;
  final String category;
  final String price;
  final int rawPrice;
  final IconData icon;
  final double rating;
  final int reviewCount;
  final String deliveryTime;
  final bool isBestseller;
  final bool isVeg;

  const FoodItem({
    required this.name,
    required this.category,
    required this.price,
    required this.rawPrice,
    required this.icon,
    required this.rating,
    this.reviewCount = 120,
    this.deliveryTime = '20-25 mins',
    this.isBestseller = false,
    this.isVeg = true,
  });
}

class CartItem {
  final FoodItem food;
  int quantity;

  CartItem({required this.food, this.quantity = 1});
}

class OrderItem {
  final String id;
  final String food;
  final String status;
  final String time;
  final int amount;

  const OrderItem({
    required this.id,
    required this.food,
    required this.status,
    required this.time,
    this.amount = 299,
  });
}

class Coupon {
  final String code;
  final String title;
  final String description;
  final double percentageDiscount;
  final int flatDiscount;
  final int minOrderValue;

  const Coupon({
    required this.code,
    required this.title,
    required this.description,
    this.percentageDiscount = 0.0,
    this.flatDiscount = 0,
    this.minOrderValue = 0,
  });
}

// ============================================================================
// THEME CONFIGURATION (RICH VELVET PURPLE, ELECTRIC VIOLET & CELEBRATION GOLD)
// ============================================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Cadbury Palette
  static const Color midnightBg = Color(0xFF150028);     // Midnight Velvet Purple
  static const Color surfaceDark = Color(0xFF240242);    // Dark Violet Surface
  static const Color cardBg = Color(0xFF2F0554);         // Elevated Card Velvet
  static const Color royalPurple = Color(0xFF4A0E78);    // Rich Cadbury Purple
  static const Color vibrantViolet = Color(0xFF9333EA);  // Electric Violet Accent
  static const Color celebrationGold = Color(0xFFFFB800); // Shimmering Gold
  static const Color softGold = Color(0xFFFEF08A);        // Bright Golden Cream
  static const Color lavenderText = Color(0xFFE9D5FF);    // Soft Lavender Text
  static const Color mutedText = Color(0xFFC084FC);       // Muted Violet Text

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cravyy Celebrations',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Inter',
        colorScheme: const ColorScheme.dark(
          primary: celebrationGold,
          secondary: vibrantViolet,
          surface: surfaceDark,
        ),
        scaffoldBackgroundColor: midnightBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: surfaceDark,
          foregroundColor: softGold,
          elevation: 0,
          scrolledUnderElevation: 2,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

// ============================================================================
// MAIN CONTAINER SCREEN (WITH LUXURY BOTTOM NAV & FLOATING CART BAR)
// ============================================================================
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedNavIndex = 0;
  final Set<String> favoriteItemNames = {};

  final List<CartItem> cartItems = [];

  final List<Coupon> availableCoupons = const [
    Coupon(
      code: 'CELEBRATE50',
      title: 'FLAT 50% OFF Festive Feast',
      description: 'Get 50% discount on all celebration orders!',
      percentageDiscount: 0.50,
      minOrderValue: 200,
    ),
    Coupon(
      code: 'SWEETDELIGHT',
      title: 'Flat ₹100 OFF Sweet Delights',
      description: 'Get flat ₹100 instant cash discount on your order.',
      flatDiscount: 100,
      minOrderValue: 250,
    ),
    Coupon(
      code: 'GOLDEN20',
      title: '20% OFF Special Treats',
      description: 'Save 20% on any food order above ₹150.',
      percentageDiscount: 0.20,
      minOrderValue: 150,
    ),
    Coupon(
      code: 'FREESHIP',
      title: 'Free Delivery Special',
      description: 'Flat ₹50 savings on delivery & packaging charges.',
      flatDiscount: 50,
      minOrderValue: 100,
    ),
  ];

  Coupon? appliedCoupon;

  int get totalCartCount => cartItems.fold(0, (sum, item) => sum + item.quantity);

  int get subtotalCartPrice =>
      cartItems.fold(0, (sum, item) => sum + (item.food.rawPrice * item.quantity));

  int get discountAmount {
    if (appliedCoupon == null || subtotalCartPrice == 0) return 0;

    int discount = 0;
    if (appliedCoupon!.percentageDiscount > 0) {
      discount = (subtotalCartPrice * appliedCoupon!.percentageDiscount).round();
    } else if (appliedCoupon!.flatDiscount > 0) {
      discount = appliedCoupon!.flatDiscount;
    }

    if (discount > subtotalCartPrice) {
      discount = subtotalCartPrice;
    }
    return discount;
  }

  int get finalPayablePrice {
    int finalPrice = subtotalCartPrice - discountAmount;
    return finalPrice > 0 ? finalPrice : 0;
  }

  void toggleFavorite(String name) {
    setState(() {
      if (favoriteItemNames.contains(name)) {
        favoriteItemNames.remove(name);
      } else {
        favoriteItemNames.add(name);
      }
    });
  }

  void addToCart(FoodItem item) {
    setState(() {
      int index = cartItems.indexWhere((c) => c.food.name == item.name);
      if (index != -1) {
        cartItems[index].quantity++;
      } else {
        cartItems.add(CartItem(food: item, quantity: 1));
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: MyApp.celebrationGold, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Added ${item.name} ($totalCartCount items in cart)',
                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: MyApp.cardBg,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: MyApp.celebrationGold, width: 1.2),
        ),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: MyApp.celebrationGold,
          onPressed: openCartSheet,
        ),
      ),
    );
  }

  void removeFromCart(FoodItem item) {
    setState(() {
      int index = cartItems.indexWhere((c) => c.food.name == item.name);
      if (index != -1) {
        if (cartItems[index].quantity > 1) {
          cartItems[index].quantity--;
        } else {
          cartItems.removeAt(index);
        }
      }
    });
  }

  void clearCart() {
    setState(() {
      cartItems.clear();
      appliedCoupon = null;
    });
  }

  bool applyCouponCode(String code) {
    final coupon = availableCoupons.firstWhere(
      (c) => c.code.toUpperCase().trim() == code.toUpperCase().trim(),
      orElse: () => const Coupon(code: '', title: '', description: ''),
    );

    if (coupon.code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid coupon code "$code". Please try another!'),
          backgroundColor: Colors.red.shade900,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }

    setState(() {
      appliedCoupon = coupon;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.verified, color: MyApp.celebrationGold, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Coupon "${coupon.code}" applied! You saved ₹$discountAmount!',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: MyApp.cardBg,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: MyApp.celebrationGold, width: 1.2),
        ),
      ),
    );
    return true;
  }

  void removeCoupon() {
    setState(() {
      appliedCoupon = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coupon removed.'),
        backgroundColor: MyApp.cardBg,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void openCartSheet() {
    final TextEditingController couponInputController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: MyApp.surfaceDark,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                border: Border(top: BorderSide(color: MyApp.celebrationGold, width: 1.5)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: MyApp.vibrantViolet.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: MyApp.celebrationGold.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.shopping_bag_outlined,
                                color: MyApp.celebrationGold,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'My Celebration Cart',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: MyApp.softGold,
                                  ),
                                ),
                                Text(
                                  '$totalCartCount items selected',
                                  style: const TextStyle(
                                    color: MyApp.mutedText,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (cartItems.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              clearCart();
                              setModalState(() {});
                            },
                            child: const Text(
                              'Clear All',
                              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: MyApp.vibrantViolet.withValues(alpha: 0.2)),
                  Expanded(
                    child: cartItems.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(22),
                                    decoration: BoxDecoration(
                                      color: MyApp.cardBg,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: MyApp.celebrationGold.withValues(alpha: 0.3)),
                                    ),
                                    child: const Icon(
                                      Icons.fastfood_outlined,
                                      size: 55,
                                      color: MyApp.celebrationGold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Your Cart is Hungry!',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: MyApp.softGold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Explore our Cadbury Celebrations feast and add your favorite treats!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: MyApp.lavenderText, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView(
                            padding: const EdgeInsets.all(16),
                            children: [
                              ...cartItems.map((item) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: MyApp.cardBg,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: MyApp.vibrantViolet.withValues(alpha: 0.25)),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.greenAccent, width: 1.2),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Icon(Icons.circle, color: Colors.greenAccent, size: 8),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.food.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              '₹${item.food.rawPrice} each',
                                              style: const TextStyle(
                                                color: MyApp.mutedText,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: MyApp.surfaceDark,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: MyApp.celebrationGold.withValues(alpha: 0.4)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                removeFromCart(item.food);
                                                setModalState(() {});
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                child: Icon(Icons.remove, size: 16, color: Colors.redAccent),
                                              ),
                                            ),
                                            Text(
                                              '${item.quantity}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: MyApp.celebrationGold,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                addToCart(item.food);
                                                setModalState(() {});
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                child: Icon(Icons.add, size: 16, color: Colors.greenAccent),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Text(
                                        '₹${item.food.rawPrice * item.quantity}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.5,
                                          color: MyApp.celebrationGold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: MyApp.cardBg,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: appliedCoupon != null
                                        ? Colors.greenAccent
                                        : MyApp.vibrantViolet.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.local_offer_outlined,
                                          color: appliedCoupon != null ? Colors.greenAccent : MyApp.celebrationGold,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          appliedCoupon != null ? 'Promo Code Applied 🎉' : 'Offers & Promo Codes',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: appliedCoupon != null ? Colors.greenAccent : MyApp.softGold,
                                            fontSize: 13.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    if (appliedCoupon != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade900.withValues(alpha: 0.3),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.greenAccent),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${appliedCoupon!.code} (Saved ₹$discountAmount)',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.greenAccent,
                                                fontSize: 13,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.close, color: Colors.redAccent, size: 18),
                                              onPressed: () {
                                                removeCoupon();
                                                setModalState(() {});
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    else ...[
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: MyApp.surfaceDark,
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color: MyApp.vibrantViolet.withValues(alpha: 0.4)),
                                              ),
                                              child: TextField(
                                                controller: couponInputController,
                                                textCapitalization: TextCapitalization.characters,
                                                style: const TextStyle(color: Colors.white),
                                                decoration: const InputDecoration(
                                                  hintText: 'Enter code (e.g. CELEBRATE50)',
                                                  hintStyle: TextStyle(fontSize: 12, color: Colors.white38),
                                                  border: InputBorder.none,
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: MyApp.celebrationGold,
                                              foregroundColor: MyApp.midnightBg,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () {
                                              if (couponInputController.text.isNotEmpty) {
                                                applyCouponCode(couponInputController.text);
                                                setModalState(() {});
                                              }
                                            },
                                            child: const Text('APPLY', style: TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: availableCoupons.map((c) {
                                          return ActionChip(
                                            backgroundColor: MyApp.surfaceDark,
                                            side: BorderSide(color: MyApp.celebrationGold.withValues(alpha: 0.4)),
                                            avatar: const Icon(Icons.local_offer, size: 12, color: MyApp.celebrationGold),
                                            label: Text(
                                              c.code,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: MyApp.softGold,
                                              ),
                                            ),
                                            onPressed: () {
                                              applyCouponCode(c.code);
                                              setModalState(() {});
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                  if (cartItems.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: MyApp.surfaceDark,
                        border: Border(top: BorderSide(color: MyApp.vibrantViolet.withValues(alpha: 0.2))),
                      ),
                      child: SafeArea(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Item Total', style: TextStyle(fontSize: 13.5, color: MyApp.lavenderText)),
                                Text('₹$subtotalCartPrice', style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Colors.white)),
                              ],
                            ),
                            if (appliedCoupon != null) ...[
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Coupon Discount (${appliedCoupon!.code})', style: const TextStyle(fontSize: 13.5, color: Colors.greenAccent)),
                                  Text('-₹$discountAmount', style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                                ],
                              ),
                            ],
                            const SizedBox(height: 4),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Delivery Partner Fee', style: TextStyle(fontSize: 13.5, color: MyApp.lavenderText)),
                                Text('FREE', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                              ],
                            ),
                            Divider(height: 18, color: MyApp.vibrantViolet.withValues(alpha: 0.2)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('To Pay', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: MyApp.softGold)),
                                Row(
                                  children: [
                                    if (appliedCoupon != null)
                                      Padding(
                                        padding: const EdgeInsets.only(right: 6),
                                        child: Text(
                                          '₹$subtotalCartPrice',
                                          style: const TextStyle(fontSize: 14, color: Colors.grey, decoration: TextDecoration.lineThrough),
                                        ),
                                      ),
                                    Text('₹$finalPayablePrice', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: MyApp.celebrationGold)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyApp.celebrationGold,
                                  foregroundColor: MyApp.midnightBg,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: MyApp.cardBg,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(color: MyApp.celebrationGold),
                                      ),
                                      title: const Row(
                                        children: [
                                          Icon(Icons.check_circle, color: Colors.greenAccent, size: 26),
                                          SizedBox(width: 8),
                                          Text('Order Placed!', style: TextStyle(color: MyApp.softGold)),
                                        ],
                                      ),
                                      content: Text(
                                        'Your celebration feast of ₹$finalPayablePrice has been placed successfully!\n\nThank you for choosing Cravyy Celebrations.',
                                        style: const TextStyle(color: MyApp.lavenderText),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: MyApp.celebrationGold,
                                            foregroundColor: MyApp.midnightBg,
                                          ),
                                          onPressed: () {
                                            clearCart();
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Awesome!', style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Text(
                                  'Place Order • ₹$finalPayablePrice',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 700;
    bool isTablet = screenWidth >= 700 && screenWidth < 1050;
    bool isDesktop = screenWidth >= 1050;

    final List<Widget> pages = [
      DashboardContent(
        isMobile: isMobile,
        isTablet: isTablet,
        isDesktop: isDesktop,
        cartCount: totalCartCount,
        favoriteNames: favoriteItemNames,
        onToggleFavorite: toggleFavorite,
        onAddToCart: addToCart,
        onOpenCart: openCartSheet,
      ),
      const OrdersScreen(),
      OffersScreen(
        onApplyCoupon: (code) {
          applyCouponCode(code);
          openCartSheet();
        },
      ),
      const CustomersScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: const BoxDecoration(
                color: MyApp.royalPurple,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, color: MyApp.celebrationGold, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Cravyy Celebrations',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: MyApp.softGold,
                    letterSpacing: -0.2,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 12, color: MyApp.mutedText),
                    SizedBox(width: 2),
                    Text(
                      'Celebrations Food Hub, 25 mins',
                      style: TextStyle(fontSize: 11.5, color: MyApp.mutedText),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: MyApp.softGold),
            onPressed: () {
              setState(() {
                selectedNavIndex = 0;
              });
            },
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: MyApp.softGold),
                onPressed: openCartSheet,
              ),
              if (totalCartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: MyApp.celebrationGold,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$totalCartCount',
                      style: const TextStyle(
                        color: MyApp.midnightBg,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Row(
            children: [
              if (!isMobile)
                SizedBox(
                  width: isDesktop ? 240 : 200,
                  child: SideMenu(
                    selectedIndex: selectedNavIndex,
                    onSelect: (index) {
                      setState(() {
                        selectedNavIndex = index;
                      });
                    },
                  ),
                ),
              Expanded(
                child: IndexedStack(index: selectedNavIndex, children: pages),
              ),
            ],
          ),
          if (totalCartCount > 0 && selectedNavIndex == 0)
            Positioned(
              bottom: isMobile ? 12 : 20,
              left: isMobile ? 16 : 280,
              right: 16,
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(16),
                color: MyApp.surfaceDark,
                child: InkWell(
                  onTap: openCartSheet,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: MyApp.celebrationGold, width: 1.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$totalCartCount ITEMS IN CART',
                              style: const TextStyle(
                                color: MyApp.celebrationGold,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              '₹$finalPayablePrice plus taxes',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: const [
                            Text(
                              'View Cart',
                              style: TextStyle(
                                color: MyApp.celebrationGold,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_ios, size: 14, color: MyApp.celebrationGold),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: isMobile
          ? Container(
              decoration: BoxDecoration(
                color: MyApp.surfaceDark,
                border: Border(
                  top: BorderSide(color: MyApp.vibrantViolet.withValues(alpha: 0.25), width: 1),
                ),
              ),
              child: NavigationBar(
                selectedIndex: selectedNavIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    selectedNavIndex = index;
                  });
                },
                backgroundColor: MyApp.surfaceDark,
                elevation: 0,
                indicatorColor: MyApp.celebrationGold.withValues(alpha: 0.2),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.explore_outlined, color: MyApp.mutedText),
                    selectedIcon: Icon(Icons.explore, color: MyApp.celebrationGold),
                    label: 'Explore',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.receipt_long_outlined, color: MyApp.mutedText),
                    selectedIcon: Icon(Icons.receipt_long, color: MyApp.celebrationGold),
                    label: 'Orders',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.local_offer_outlined, color: MyApp.mutedText),
                    selectedIcon: Icon(Icons.local_offer, color: MyApp.celebrationGold),
                    label: 'Offers',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.favorite_outline, color: MyApp.mutedText),
                    selectedIcon: Icon(Icons.favorite, color: MyApp.celebrationGold),
                    label: 'Loyalty',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_outline, color: MyApp.mutedText),
                    selectedIcon: Icon(Icons.person, color: MyApp.celebrationGold),
                    label: 'Profile',
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

// ============================================================================
// SIDEBAR (TABLET / DESKTOP)
// ============================================================================
class SideMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelect;

  const SideMenu({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyApp.surfaceDark,
        border: Border(
          right: BorderSide(color: MyApp.vibrantViolet.withValues(alpha: 0.25), width: 1),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [MyApp.royalPurple, MyApp.vibrantViolet],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: MyApp.celebrationGold.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.restaurant_menu,
              size: 30,
              color: MyApp.celebrationGold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Cravyy Hub',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MyApp.softGold,
            ),
          ),
          const SizedBox(height: 20),
          Divider(height: 1, color: MyApp.vibrantViolet.withValues(alpha: 0.2)),
          const SizedBox(height: 10),
          MenuItem(icon: Icons.explore_outlined, title: 'Explore', isSelected: selectedIndex == 0, onTap: () => onSelect(0)),
          MenuItem(icon: Icons.receipt_long_outlined, title: 'Orders', isSelected: selectedIndex == 1, onTap: () => onSelect(1)),
          MenuItem(icon: Icons.local_offer_outlined, title: 'Offers', isSelected: selectedIndex == 2, onTap: () => onSelect(2)),
          MenuItem(icon: Icons.favorite_outline, title: 'Customers', isSelected: selectedIndex == 3, onTap: () => onSelect(3)),
          MenuItem(icon: Icons.settings_outlined, title: 'Settings', isSelected: selectedIndex == 4, onTap: () => onSelect(4)),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const MenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? MyApp.celebrationGold : MyApp.mutedText,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? MyApp.softGold : MyApp.lavenderText,
        ),
      ),
      tileColor: isSelected ? MyApp.celebrationGold.withValues(alpha: 0.12) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      onTap: onTap,
    );
  }
}

// ============================================================================
// PAGE 0: LUXURY CADBURY DASHBOARD EXPLORE CONTENT
// ============================================================================
class DashboardContent extends StatefulWidget {
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  final int cartCount;
  final Set<String> favoriteNames;
  final Function(String) onToggleFavorite;
  final Function(FoodItem) onAddToCart;
  final VoidCallback onOpenCart;

  const DashboardContent({
    super.key,
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
    required this.cartCount,
    required this.favoriteNames,
    required this.onToggleFavorite,
    required this.onAddToCart,
    required this.onOpenCart,
  });

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  String searchQuery = '';
  String selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> categories = const [
    'All',
    'Pizza',
    'Burgers',
    'Pasta',
    'Biryani',
    'Starters',
    'Chinese',
    'Desserts',
  ];

  final List<FoodItem> allFoods = const [
    FoodItem(
      name: 'Pizza Margherita',
      category: 'Pizza',
      price: '₹199',
      rawPrice: 199,
      icon: Icons.local_pizza,
      rating: 4.8,
      reviewCount: 340,
      deliveryTime: '20-25 mins',
      isBestseller: true,
      isVeg: true,
    ),
    FoodItem(
      name: 'Veggie Burger Deluxe',
      category: 'Burgers',
      price: '₹149',
      rawPrice: 149,
      icon: Icons.lunch_dining,
      rating: 4.5,
      reviewCount: 180,
      deliveryTime: '15-20 mins',
      isBestseller: false,
      isVeg: true,
    ),
    FoodItem(
      name: 'Creamy White Pasta',
      category: 'Pasta',
      price: '₹229',
      rawPrice: 229,
      icon: Icons.ramen_dining,
      rating: 4.7,
      reviewCount: 220,
      deliveryTime: '25-30 mins',
      isBestseller: true,
      isVeg: true,
    ),
    FoodItem(
      name: 'Grilled Club Sandwich',
      category: 'Starters',
      price: '₹129',
      rawPrice: 129,
      icon: Icons.breakfast_dining,
      rating: 4.4,
      reviewCount: 95,
      deliveryTime: '15-20 mins',
      isBestseller: false,
      isVeg: true,
    ),
    FoodItem(
      name: 'Hyderabadi Dum Biryani',
      category: 'Biryani',
      price: '₹299',
      rawPrice: 299,
      icon: Icons.rice_bowl,
      rating: 4.9,
      reviewCount: 510,
      deliveryTime: '30-35 mins',
      isBestseller: true,
      isVeg: true,
    ),
    FoodItem(
      name: 'Hakka Noodles Wok',
      category: 'Chinese',
      price: '₹179',
      rawPrice: 179,
      icon: Icons.ramen_dining,
      rating: 4.6,
      reviewCount: 140,
      deliveryTime: '20-25 mins',
      isBestseller: false,
      isVeg: true,
    ),
    FoodItem(
      name: 'Tandoori Paneer Tikka',
      category: 'Starters',
      price: '₹259',
      rawPrice: 259,
      icon: Icons.outdoor_grill,
      rating: 4.9,
      reviewCount: 420,
      deliveryTime: '20-25 mins',
      isBestseller: true,
      isVeg: true,
    ),
    FoodItem(
      name: 'Choco Lava Cake',
      category: 'Desserts',
      price: '₹139',
      rawPrice: 139,
      icon: Icons.cake,
      rating: 4.9,
      reviewCount: 680,
      deliveryTime: '15-20 mins',
      isBestseller: true,
      isVeg: true,
    ),
    FoodItem(
      name: 'Extra Cheese Tandoori Pizza',
      category: 'Pizza',
      price: '₹399',
      rawPrice: 399,
      icon: Icons.local_pizza,
      rating: 4.9,
      reviewCount: 290,
      deliveryTime: '25-30 mins',
      isBestseller: true,
      isVeg: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredFoods = allFoods.where((food) {
      final matchesSearch = food.name.toLowerCase().contains(
        searchQuery.toLowerCase().trim(),
      );
      final matchesCategory =
          selectedCategory == 'All' || food.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        widget.isMobile ? 16 : 24,
        14,
        widget.isMobile ? 16 : 24,
        widget.cartCount > 0 ? 90 : 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. VELVET SEARCH BAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: MyApp.cardBg,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: MyApp.vibrantViolet.withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: MyApp.celebrationGold, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (val) {
                      setState(() {
                        searchQuery = val;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search pizza, biryani, choco cake...',
                      hintStyle: TextStyle(fontSize: 13.5, color: MyApp.mutedText),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                if (searchQuery.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 18, color: MyApp.mutedText),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        searchQuery = '';
                      });
                    },
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: MyApp.royalPurple,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.tune, size: 16, color: MyApp.celebrationGold),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // 2. FESTIVE CADBURY PROMO BANNER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [MyApp.royalPurple, Color(0xFF7E22CE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: MyApp.celebrationGold.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: MyApp.celebrationGold,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'FESTIVE FEAST OFFER',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: MyApp.midnightBg,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'FLAT 50% OFF Up to ₹250',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MyApp.softGold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Use code CELEBRATE50 at checkout',
                        style: TextStyle(color: MyApp.lavenderText, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.card_giftcard,
                  size: 48,
                  color: MyApp.celebrationGold,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 3. CATEGORY PILLS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((cat) {
                final isSelected = selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: MyApp.celebrationGold,
                    labelStyle: TextStyle(
                      color: isSelected ? MyApp.midnightBg : MyApp.lavenderText,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 13,
                    ),
                    checkmarkColor: MyApp.midnightBg,
                    backgroundColor: MyApp.cardBg,
                    side: BorderSide(
                      color: isSelected
                          ? MyApp.celebrationGold
                          : MyApp.vibrantViolet.withValues(alpha: 0.3),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onSelected: (val) {
                      setState(() {
                        selectedCategory = cat;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 22),

          // 4. METRIC STATS
          const Text(
            'Live Kitchen Highlights',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: MyApp.softGold,
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: const [
              Expanded(
                child: QuickStatPill(
                  icon: Icons.trending_up,
                  title: '120+ Orders',
                  subtitle: 'Served Today',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: QuickStatPill(
                  icon: Icons.timer,
                  title: '18 Pending',
                  subtitle: 'Kitchen Live',
                  isGold: true,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: QuickStatPill(
                  icon: Icons.star,
                  title: '4.8 ★ Rating',
                  subtitle: '500+ Reviews',
                ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          // 5. FOOD GRID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedCategory == 'All'
                    ? 'Popular Celebration Menu'
                    : '$selectedCategory Specialities',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: MyApp.softGold,
                ),
              ),
              Text(
                '${filteredFoods.length} items',
                style: const TextStyle(color: MyApp.mutedText, fontSize: 12.5),
              ),
            ],
          ),

          const SizedBox(height: 14),

          if (filteredFoods.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: MyApp.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: MyApp.vibrantViolet.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.search_off_rounded,
                    size: 55,
                    color: MyApp.mutedText,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No Food Found',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: MyApp.softGold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'No food matching "$searchQuery" in $selectedCategory. Try another search!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: MyApp.lavenderText, fontSize: 13),
                  ),
                ],
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredFoods.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.isMobile
                    ? 2
                    : widget.isTablet
                    ? 3
                    : 4,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: widget.isMobile ? 0.73 : 0.78,
              ),
              itemBuilder: (context, index) {
                final food = filteredFoods[index];
                final isFav = widget.favoriteNames.contains(food.name);

                return VelvetFoodCard(
                  food: food,
                  isFavorite: isFav,
                  onToggleFavorite: () => widget.onToggleFavorite(food.name),
                  onAddToCart: () => widget.onAddToCart(food),
                );
              },
            ),
        ],
      ),
    );
  }
}

// ============================================================================
// STAT PILL
// ============================================================================
class QuickStatPill extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isGold;

  const QuickStatPill({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isGold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: MyApp.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isGold
              ? MyApp.celebrationGold
              : MyApp.vibrantViolet.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: isGold ? MyApp.celebrationGold : MyApp.vibrantViolet,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: isGold ? MyApp.softGold : Colors.white,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: MyApp.mutedText),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// LUXURY VELVET PURPLE & GOLD FOOD CARD
// ============================================================================
class VelvetFoodCard extends StatelessWidget {
  final FoodItem food;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onAddToCart;

  const VelvetFoodCard({
    super.key,
    required this.food,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MyApp.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MyApp.vibrantViolet.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Row: Rating Badge (Top Left) & Heart Button (Top Right)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: MyApp.midnightBg,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: MyApp.celebrationGold.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${food.rating}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: MyApp.celebrationGold,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.star, size: 10, color: MyApp.celebrationGold),
                  ],
                ),
              ),
              InkWell(
                onTap: onToggleFavorite,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: isFavorite ? Colors.redAccent : MyApp.mutedText,
                  ),
                ),
              ),
            ],
          ),

          // Centered Icon inside glowing velvet gradient
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      MyApp.royalPurple.withValues(alpha: 0.9),
                      MyApp.surfaceDark,
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: MyApp.celebrationGold.withValues(alpha: 0.3)),
                ),
                child: Icon(food.icon, size: 40, color: MyApp.celebrationGold),
              ),
            ),
          ),

          const SizedBox(height: 6),

          // Food Name & Veg Indicator
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.greenAccent, width: 1.2),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Icon(Icons.circle, color: Colors.greenAccent, size: 6),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  food.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 2),

          Text(
            food.deliveryTime,
            style: const TextStyle(color: MyApp.mutedText, fontSize: 11.5),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                food.price,
                style: const TextStyle(
                  color: MyApp.softGold,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              InkWell(
                onTap: onAddToCart,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: MyApp.celebrationGold,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '+ ADD',
                    style: TextStyle(
                      color: MyApp.midnightBg,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PAGE 1: ORDERS MANAGEMENT SCREEN
// ============================================================================
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String selectedFilter = 'All';

  final List<OrderItem> allOrders = const [
    OrderItem(
      id: '#1001',
      food: 'Pizza Margherita + Coke',
      status: 'Delivered',
      time: '10:30 AM',
      amount: 239,
    ),
    OrderItem(
      id: '#1002',
      food: 'Veggie Burger + Fries',
      status: 'Preparing',
      time: '11:15 AM',
      amount: 199,
    ),
    OrderItem(
      id: '#1003',
      food: 'White Sauce Pasta + Garlic Bread',
      status: 'Delivered',
      time: '12:00 PM',
      amount: 279,
    ),
    OrderItem(
      id: '#1004',
      food: 'Hyderabadi Biryani + Raita',
      status: 'Cancelled',
      time: '12:45 PM',
      amount: 349,
    ),
    OrderItem(
      id: '#1005',
      food: 'Choco Lava Cake + Cold Coffee',
      status: 'On The Way',
      time: '01:10 PM',
      amount: 219,
    ),
    OrderItem(
      id: '#1006',
      food: 'Tandoori Paneer Tikka Platter',
      status: 'Pending',
      time: '01:25 PM',
      amount: 289,
    ),
    OrderItem(
      id: '#1007',
      food: 'Grilled Club Sandwich + Lemonade',
      status: 'Preparing',
      time: '01:40 PM',
      amount: 169,
    ),
    OrderItem(
      id: '#1008',
      food: 'Extra Cheese Tandoori Pizza',
      status: 'Delivered',
      time: '02:00 PM',
      amount: 419,
    ),
  ];

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.greenAccent;
      case 'preparing':
        return Colors.orangeAccent;
      case 'cancelled':
        return Colors.redAccent;
      case 'on the way':
        return MyApp.vibrantViolet;
      case 'pending':
        return MyApp.celebrationGold;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = selectedFilter == 'All'
        ? allOrders
        : allOrders
              .where(
                (o) => o.status.toLowerCase() == selectedFilter.toLowerCase(),
              )
              .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  [
                    'All',
                    'Delivered',
                    'Preparing',
                    'On The Way',
                    'Pending',
                    'Cancelled',
                  ].map((status) {
                    final isSelected = selectedFilter == status;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(status),
                        selected: isSelected,
                        selectedColor: MyApp.celebrationGold,
                        labelStyle: TextStyle(
                          color: isSelected ? MyApp.midnightBg : MyApp.lavenderText,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                        checkmarkColor: MyApp.midnightBg,
                        backgroundColor: MyApp.cardBg,
                        side: BorderSide(
                          color: isSelected
                              ? MyApp.celebrationGold
                              : MyApp.vibrantViolet.withValues(alpha: 0.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onSelected: (val) {
                          setState(() {
                            selectedFilter = status;
                          });
                        },
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Showing ${filteredOrders.length} orders',
            style: const TextStyle(color: MyApp.mutedText, fontSize: 13),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredOrders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final order = filteredOrders[index];
              final statusColor = getStatusColor(order.status);

              return Card(
                elevation: 0,
                color: MyApp.cardBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: MyApp.vibrantViolet.withValues(alpha: 0.3)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: MyApp.royalPurple,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: MyApp.celebrationGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order ${order.id}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '₹${order.amount}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MyApp.celebrationGold,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    '${order.food}\nOrdered at ${order.time}',
                    style: const TextStyle(color: MyApp.lavenderText),
                  ),
                  isThreeLine: true,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: statusColor,
                      ),
                    ),
                    child: Text(
                      order.status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsScreen(order: order),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PAGE 2: OFFERS & PROMOTIONS SCREEN
// ============================================================================
class OffersScreen extends StatelessWidget {
  final Function(String) onApplyCoupon;

  const OffersScreen({super.key, required this.onApplyCoupon});

  final List<Map<String, String>> offers = const [
    {
      'title': 'FLAT 50% OFF Festive Feast',
      'code': 'CELEBRATE50',
      'discount': '50% OFF',
      'desc': 'Get 50% instant discount on your celebration cart!',
    },
    {
      'title': 'Flat ₹100 OFF Sweet Delights',
      'code': 'SWEETDELIGHT',
      'discount': '₹100 OFF',
      'desc': 'Flat ₹100 discount on desserts, cakes, and full meal combos.',
    },
    {
      'title': '20% OFF Special Treats',
      'code': 'GOLDEN20',
      'discount': '20% OFF',
      'desc': 'Save 20% on any food order above ₹150.',
    },
    {
      'title': 'Free Delivery Special',
      'code': 'FREESHIP',
      'discount': '₹50 OFF',
      'desc': 'Save ₹50 on delivery & handling charges.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [MyApp.royalPurple, Color(0xFF7E22CE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: MyApp.celebrationGold.withValues(alpha: 0.5)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_offer,
                      color: MyApp.celebrationGold,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Festive Offers & Coupons',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: MyApp.softGold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  'Tap "Apply To Cart" on any coupon to apply instant savings directly to your cart bill!',
                  style: TextStyle(color: MyApp.lavenderText, fontSize: 12.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: offers.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final offer = offers[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MyApp.cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: MyApp.vibrantViolet.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            offer['title']!,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: MyApp.celebrationGold.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: MyApp.celebrationGold),
                          ),
                          child: Text(
                            offer['discount']!,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: MyApp.celebrationGold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      offer['desc']!,
                      style: const TextStyle(
                        color: MyApp.lavenderText,
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: MyApp.surfaceDark,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: MyApp.vibrantViolet.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            'CODE: ${offer['code']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MyApp.celebrationGold,
                              letterSpacing: 1,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyApp.celebrationGold,
                            foregroundColor: MyApp.midnightBg,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            onApplyCoupon(offer['code']!);
                          },
                          icon: const Icon(
                            Icons.check,
                            size: 14,
                            color: MyApp.midnightBg,
                          ),
                          label: const Text(
                            'Apply To Cart',
                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PAGE 3: CUSTOMERS SCREEN
// ============================================================================
class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  final List<Map<String, dynamic>> customers = const [
    {
      'name': 'Nirav Sharma',
      'email': 'nirav.sharma@example.com',
      'orders': 24,
      'spent': '₹6,400',
      'tier': 'Gold VIP',
    },
    {
      'name': 'P Patel',
      'email': 'p.patel@example.com',
      'orders': 18,
      'spent': '₹4,850',
      'tier': 'Gold VIP',
    },
    {
      'name': 'Someone Mehta',
      'email': 'someone.m@example.com',
      'orders': 12,
      'spent': '₹3,100',
      'tier': 'Silver',
    },
    {
      'name': 'OK Gupta',
      'email': 'ok.g@example.com',
      'orders': 9,
      'spent': '₹2,200',
      'tier': 'Silver',
    },
    {
      'name': 'Nothing Singh',
      'email': 'nothing.s@example.com',
      'orders': 5,
      'spent': '₹1,350',
      'tier': 'Bronze',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Loyal Customers Directory',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: MyApp.softGold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Top foodies and celebration loyalty tiers',
            style: TextStyle(color: MyApp.mutedText, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: customers.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final customer = customers[index];
              final isGold = customer['tier'] == 'Gold VIP';

              return Card(
                elevation: 0,
                color: MyApp.cardBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: MyApp.vibrantViolet.withValues(alpha: 0.3)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: isGold
                        ? MyApp.celebrationGold.withValues(alpha: 0.2)
                        : MyApp.royalPurple,
                    child: Text(
                      customer['name'][0],
                      style: TextStyle(
                        color: isGold
                            ? MyApp.celebrationGold
                            : MyApp.softGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        customer['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (isGold)
                        const Icon(
                          Icons.star,
                          color: MyApp.celebrationGold,
                          size: 16,
                        ),
                    ],
                  ),
                  subtitle: Text(
                    '${customer['email']}\n${customer['orders']} orders completed',
                    style: const TextStyle(color: MyApp.lavenderText),
                  ),
                  isThreeLine: true,
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        customer['spent'],
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: MyApp.celebrationGold,
                        ),
                      ),
                      Text(
                        customer['tier'],
                        style: TextStyle(
                          fontSize: 11,
                          color: isGold
                              ? MyApp.softGold
                              : MyApp.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PAGE 4: SETTINGS SCREEN
// ============================================================================
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pushNotifications = true;
  bool soundAlerts = true;
  bool autoAcceptOrders = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'App & Store Settings',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: MyApp.softGold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            color: MyApp.cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: MyApp.vibrantViolet.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text(
                    'Push Notifications',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Receive order alerts and status updates',
                    style: TextStyle(color: MyApp.mutedText),
                  ),
                  value: pushNotifications,
                  activeTrackColor: MyApp.royalPurple,
                  activeThumbColor: MyApp.celebrationGold,
                  onChanged: (val) {
                    setState(() {
                      pushNotifications = val;
                    });
                  },
                ),
                Divider(height: 1, color: MyApp.vibrantViolet.withValues(alpha: 0.2)),
                SwitchListTile(
                  title: const Text(
                    'Order Sound Alerts',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Play sound on new incoming orders',
                    style: TextStyle(color: MyApp.mutedText),
                  ),
                  value: soundAlerts,
                  activeTrackColor: MyApp.royalPurple,
                  activeThumbColor: MyApp.celebrationGold,
                  onChanged: (val) {
                    setState(() {
                      soundAlerts = val;
                    });
                  },
                ),
                Divider(height: 1, color: MyApp.vibrantViolet.withValues(alpha: 0.2)),
                SwitchListTile(
                  title: const Text(
                    'Auto-Accept Orders',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Automatically move new orders to Preparing',
                    style: TextStyle(color: MyApp.mutedText),
                  ),
                  value: autoAcceptOrders,
                  activeTrackColor: MyApp.royalPurple,
                  activeThumbColor: MyApp.celebrationGold,
                  onChanged: (val) {
                    setState(() {
                      autoAcceptOrders = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 0,
            color: MyApp.cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: MyApp.vibrantViolet.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.store, color: MyApp.celebrationGold),
                  title: Text('Store Name', style: TextStyle(color: Colors.white)),
                  trailing: Text(
                    'Cravyy Celebrations Hub',
                    style: TextStyle(fontWeight: FontWeight.bold, color: MyApp.softGold),
                  ),
                ),
                Divider(height: 1, color: MyApp.vibrantViolet.withValues(alpha: 0.2)),
                const ListTile(
                  leading: Icon(Icons.currency_rupee, color: MyApp.celebrationGold),
                  title: Text('Default Currency', style: TextStyle(color: Colors.white)),
                  trailing: Text(
                    'INR (₹)',
                    style: TextStyle(fontWeight: FontWeight.bold, color: MyApp.softGold),
                  ),
                ),
                Divider(height: 1, color: MyApp.vibrantViolet.withValues(alpha: 0.2)),
                const ListTile(
                  leading: Icon(Icons.info_outline, color: MyApp.celebrationGold),
                  title: Text('App Version', style: TextStyle(color: Colors.white)),
                  trailing: Text(
                    'v3.0.0 Luxury Edition',
                    style: TextStyle(color: MyApp.mutedText),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyApp.celebrationGold,
                foregroundColor: MyApp.midnightBg,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings saved successfully!'),
                    backgroundColor: MyApp.cardBg,
                  ),
                );
              },
              icon: const Icon(Icons.save, color: MyApp.midnightBg),
              label: const Text(
                'Save Preferences',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// ORDER DETAILS SCREEN
// ============================================================================
class OrderDetailsScreen extends StatelessWidget {
  final OrderItem order;

  const OrderDetailsScreen({super.key, required this.order});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.greenAccent;
      case 'preparing':
        return Colors.orangeAccent;
      case 'cancelled':
        return Colors.redAccent;
      case 'on the way':
        return MyApp.vibrantViolet;
      case 'pending':
        return MyApp.celebrationGold;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(order.status);

    return Scaffold(
      appBar: AppBar(title: Text('Order Details - ${order.id}')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 0,
              color: MyApp.cardBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(color: MyApp.celebrationGold),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [MyApp.royalPurple, MyApp.vibrantViolet],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.receipt_long,
                        size: 42,
                        color: MyApp.celebrationGold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: MyApp.softGold,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Divider(color: MyApp.vibrantViolet.withValues(alpha: 0.3)),
                    const SizedBox(height: 10),

                    _buildDetailRow('Order ID', order.id, isBold: true),
                    const SizedBox(height: 12),
                    _buildDetailRow('Food Item', order.food),
                    const SizedBox(height: 12),
                    _buildDetailRow('Order Time', order.time),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      'Amount Paid',
                      '₹${order.amount}',
                      isBold: true,
                    ),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Status',
                          style: TextStyle(color: MyApp.lavenderText, fontSize: 14),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: statusColor),
                          ),
                          child: Text(
                            order.status,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),
                    Divider(color: MyApp.vibrantViolet.withValues(alpha: 0.3)),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyApp.celebrationGold,
                          foregroundColor: MyApp.midnightBg,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: MyApp.midnightBg,
                          size: 18,
                        ),
                        label: const Text(
                          'Go Back',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: MyApp.lavenderText, fontSize: 14),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold ? MyApp.celebrationGold : Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
