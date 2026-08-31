import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

// ============================================================================
// CRAVYY CELEBRATIONS - BRIGHT WHITE, SLATE & BRIGHT ORANGE THEME
// ============================================================================

bool checkShouldShowSplash() {
  if (kIsWeb) {
    try {
      final visited = html.window.sessionStorage['has_seen_splash'];
      if (visited == 'true') {
        return false;
      } else {
        html.window.sessionStorage['has_seen_splash'] = 'true';
        return true;
      }
    } catch (_) {
      return true;
    }
  }
  return true;
}

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
  final String? assetPath;
  final String? imageUrl;
  final double rating;
  final int reviewCount;
  final String deliveryTime;
  final bool isBestseller;
  final bool isVeg;
  final bool isOutOfStock;

  const FoodItem({
    required this.name,
    required this.category,
    required this.price,
    required this.rawPrice,
    required this.icon,
    this.assetPath,
    this.imageUrl,
    this.rating = 4.8,
    this.reviewCount = 120,
    this.deliveryTime = '20-25 mins',
    this.isBestseller = false,
    this.isVeg = true,
    this.isOutOfStock = false,
  });
}

class CustomOption {
  final String name;
  final int extraPrice;
  final IconData icon;

  const CustomOption({
    required this.name,
    this.extraPrice = 0,
    this.icon = Icons.check_circle_outline,
  });
}

class ComboItem {
  final String id;
  final String name;
  final String description;
  final int basePrice;
  final IconData icon;
  final String? assetPath;
  final String? imageUrl;
  final double rating;
  final List<CustomOption> mainOptions;
  final List<CustomOption> sideOptions;
  final List<CustomOption> beverageOptions;
  final List<CustomOption> addonOptions;
  final bool isOutOfStock;

  const ComboItem({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.icon,
    this.assetPath,
    this.imageUrl,
    this.rating = 4.8,
    required this.mainOptions,
    required this.sideOptions,
    required this.beverageOptions,
    this.addonOptions = const [],
    this.isOutOfStock = false,
  });
}

class CartItem {
  final String title;
  final int unitPrice;
  int quantity;
  final IconData icon;
  final String? assetPath;
  final String? imageUrl;
  final String? customizations;

  CartItem({
    required this.title,
    required this.unitPrice,
    this.quantity = 1,
    required this.icon,
    this.assetPath,
    this.imageUrl,
    this.customizations,
  });
}

// ----------------------------------------------------------------------------
// FOOD IMAGE & OUT-OF-STOCK OVERLAY WIDGET
// ----------------------------------------------------------------------------
class FoodImageWidget extends StatelessWidget {
  final String? assetPath;
  final String? networkUrl;
  final IconData icon;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool isOutOfStock;

  const FoodImageWidget({
    super.key,
    this.assetPath,
    this.networkUrl,
    required this.icon,
    this.width,
    this.height,
    this.borderRadius = 14,
    this.isOutOfStock = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isOutOfStock
              ? Colors.red.shade300
              : MyApp.orangeBorder.withValues(alpha: 0.6),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - 1),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildImageContent(),
            if (isOutOfStock) _buildSlantingOutOfStockBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    if (assetPath != null && assetPath!.isNotEmpty) {
      return Image.asset(
        assetPath!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          if (networkUrl != null && networkUrl!.isNotEmpty) {
            return _buildNetworkImage();
          }
          return _buildFallbackIcon();
        },
      );
    } else if (networkUrl != null && networkUrl!.isNotEmpty) {
      return _buildNetworkImage();
    } else {
      return _buildFallbackIcon();
    }
  }

  Widget _buildNetworkImage() {
    return Image.network(
      networkUrl!,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: MyApp.orangeLight,
          child: const Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: MyApp.brightOrange,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildFallbackIcon(isError: true);
      },
    );
  }

  Widget _buildFallbackIcon({bool isError = false}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: MyApp.orangeLight,
          child: Center(
            child: Icon(
              icon,
              size: 38,
              color: MyApp.brightOrange.withValues(alpha: isError ? 0.35 : 1.0),
            ),
          ),
        ),
        if (isError || isOutOfStock) _buildSlantingOutOfStockBadge(),
      ],
    );
  }

  Widget _buildSlantingOutOfStockBadge() {
    return Container(
      color: Colors.black.withValues(alpha: 0.45),
      child: Center(
        child: Transform.rotate(
          angle: -0.28, // Slanting diagonal ~ -16 degrees
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.shade700.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white, width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Text(
              'OUT OF STOCK',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 11,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
      ),
    );
  }
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
// THEME CONFIGURATION (BRIGHT WHITE, SLATE & VIBRANT ORANGE)
// ============================================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // White, Slate & Bright Orange Palette
  static const Color slateBg = Color(0xFFF8FAFC); // Slate-50 Crisp Clean Canvas
  static const Color surfaceWhite = Color(0xFFFFFFFF); // Pure White Surface
  static const Color cardWhite = Color(0xFFFFFFFF); // Elevated Card White
  static const Color brightOrange = Color(0xFFFF5E00); // Electric Bright Orange
  static const Color orangeLight = Color(
    0xFFFFF7ED,
  ); // Soft Orange Tint (Orange-50)
  static const Color orangeBorder = Color(0xFFFFEDD5); // Orange-100 Border Tint
  static const Color slateBorder = Color(0xFFE2E8F0); // Slate-200 Subtle Border
  static const Color slate900 = Color(0xFF0F172A); // Deep Slate-900 Headings
  static const Color slate700 = Color(0xFF334155); // Slate-700 Body Text
  static const Color slate600 = Color(0xFF475569); // Slate-600 Subtitles
  static const Color slate400 = Color(
    0xFF94A3B8,
  ); // Slate-400 Muted / Placeholders

  // Design Tokens Mapping
  static const Color midnightBg = slateBg;
  static const Color surfaceDark = surfaceWhite;
  static const Color cardBg = cardWhite;
  static const Color royalPurple = orangeLight;
  static const Color vibrantViolet = brightOrange;
  static const Color celebrationGold = brightOrange;
  static const Color softGold = slate900;
  static const Color lavenderText = slate600;
  static const Color mutedText = slate400;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cravyy Celebrations',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: 'Inter',
        colorScheme: const ColorScheme.light(
          primary: brightOrange,
          secondary: brightOrange,
          surface: surfaceWhite,
        ),
        scaffoldBackgroundColor: slateBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: surfaceWhite,
          foregroundColor: slate900,
          elevation: 0,
          scrolledUnderElevation: 1,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(color: slate900),
          titleTextStyle: TextStyle(
            color: slate900,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: checkShouldShowSplash()
          ? const SplashScreen()
          : const DashboardScreen(),
    );
  }
}

// ============================================================================
// ANIMATED "BON APPÉTIT" BRIGHT ORANGE SPLASH SCREEN
// ============================================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _steamAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _steamAnimation = Tween<double>(begin: 0.0, end: -8.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    // Auto navigate to Dashboard after 2.4 seconds
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) {
        _navigateToDashboard();
      }
    });
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const DashboardScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _navigateToDashboard,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFF5E00), // Vibrant Bright Orange
                Color(0xFFEA580C), // Rich Warm Orange
                Color(0xFFC2410C), // Deep Fiery Orange
              ],
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Subtle background watermark food sketches
              Positioned(
                top: 80,
                right: 30,
                child: Opacity(
                  opacity: 0.08,
                  child: const Icon(
                    Icons.local_pizza_outlined,
                    size: 130,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: 120,
                left: 20,
                child: Opacity(
                  opacity: 0.08,
                  child: const Icon(
                    Icons.lunch_dining_outlined,
                    size: 140,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 180,
                left: 40,
                child: Opacity(
                  opacity: 0.08,
                  child: const Icon(
                    Icons.local_cafe_outlined,
                    size: 90,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: 80,
                right: 30,
                child: Opacity(
                  opacity: 0.08,
                  child: const Icon(
                    Icons.cake_outlined,
                    size: 110,
                    color: Colors.white,
                  ),
                ),
              ),

              // Central Brand Cloche + "Bon Appétit" + Golden Brush Stroke
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // STEAM & CLOCHE COVER
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Transform.translate(
                                offset: Offset(0, _steamAnimation.value - 40),
                                child: Opacity(
                                  opacity: _controller.value > 0.4
                                      ? (_controller.value - 0.4) / 0.6
                                      : 0.0,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.air,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(22),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.15,
                                      ),
                                      blurRadius: 30,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                                child: CustomPaint(
                                  size: const Size(95, 75),
                                  painter: ClochePainter(),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // "Bon Appétit" Crisp White Typography
                          const Text(
                            'Bon\nAppétit',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 46,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.5,
                              height: 1.05,
                              fontStyle: FontStyle.italic,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Curved Golden Brush Underline
                          CustomPaint(
                            size: const Size(140, 16),
                            painter: GoldenBrushStrokePainter(),
                          ),

                          const SizedBox(height: 24),

                          // App Subtitle Tagline
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.auto_awesome,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'CRAVYY CELEBRATIONS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Bottom Tap Hint
              Positioned(
                bottom: 30,
                child: Opacity(
                  opacity: 0.85,
                  child: Row(
                    children: const [
                      Text(
                        'Tap to explore feast',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 14, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// CUSTOM PAINTER: RESTAURANT FOOD CLOCHE DOME WITH KNOB & SERVING BASE
// ----------------------------------------------------------------------------
class ClochePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final goldPaint = Paint()
      ..color = const Color(0xFFFFD166)
      ..style = PaintingStyle.fill;

    // Dome shape
    final path = Path();
    path.moveTo(8, size.height - 8);
    path.arcToPoint(
      Offset(size.width - 8, size.height - 8),
      radius: Radius.circular(size.width / 2.1),
      clockwise: true,
    );
    path.close();
    canvas.drawPath(path, paint);

    // Serving tray base rim
    final baseRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, size.height - 7, size.width, 6),
      const Radius.circular(3),
    );
    canvas.drawRRect(baseRect, paint);

    // Top knob (handle)
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.15),
      5.5,
      goldPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width / 2 - 2, size.height * 0.15, 4, 8),
      goldPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ----------------------------------------------------------------------------
// CUSTOM PAINTER: GOLDEN BRUSH STROKE UNDERLINE
// ----------------------------------------------------------------------------
class GoldenBrushStrokePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD166)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.5, 0, size.width, size.height * 0.4);
    path.quadraticBezierTo(
      size.width * 0.55,
      size.height * 0.9,
      0,
      size.height * 0.6,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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

  // Sequential order ID counter
  int _nextOrderNumber = 1004;

  // Live dynamic orders list (Newest order always placed at index 0 on top)
  final List<OrderItem> userOrders = [
    const OrderItem(
      id: '#1003',
      food: '1x Royal Pizza Party Combo (Tandoori Paneer Tikka Pizza)',
      status: 'Delivered',
      time: '12:00 PM',
      amount: 424,
    ),
    const OrderItem(
      id: '#1002',
      food: '2x Veggie Burger Deluxe + 1x Cold Coffee',
      status: 'Delivered',
      time: '11:15 AM',
      amount: 298,
    ),
    const OrderItem(
      id: '#1001',
      food: '1x Festive Burger Feast Combo (Peri-Peri Fries)',
      status: 'Delivered',
      time: '10:30 AM',
      amount: 319,
    ),
  ];

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

  int get totalCartCount =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  int get subtotalCartPrice =>
      cartItems.fold(0, (sum, item) => sum + (item.unitPrice * item.quantity));

  int get discountAmount {
    if (appliedCoupon == null || subtotalCartPrice == 0) return 0;

    int discount = 0;
    if (appliedCoupon!.percentageDiscount > 0) {
      discount = (subtotalCartPrice * appliedCoupon!.percentageDiscount)
          .round();
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

  void addFoodToCart(FoodItem item) {
    setState(() {
      int index = cartItems.indexWhere(
        (c) => c.title == item.name && c.customizations == null,
      );
      if (index != -1) {
        cartItems[index].quantity++;
      } else {
        cartItems.add(
          CartItem(
            title: item.name,
            unitPrice: item.rawPrice,
            icon: item.icon,
            quantity: 1,
          ),
        );
      }
    });
    _showAddedSnackBar(item.name);
  }

  void addCustomizedComboToCart({
    required ComboItem combo,
    required CustomOption selectedMain,
    required CustomOption selectedSide,
    required CustomOption selectedBev,
    required List<CustomOption> selectedAddons,
    required int totalPrice,
  }) {
    final addonsText = selectedAddons.map((a) => a.name).join(' • ');
    final customizations =
        '${selectedMain.name} • ${selectedSide.name} • ${selectedBev.name}'
        '${addonsText.isNotEmpty ? ' • $addonsText' : ''}';

    setState(() {
      cartItems.add(
        CartItem(
          title: combo.name,
          unitPrice: totalPrice,
          quantity: 1,
          icon: combo.icon,
          customizations: customizations,
        ),
      );
    });
    _showAddedSnackBar(combo.name);
  }

  void _showAddedSnackBar(String title) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: MyApp.brightOrange, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Added $title ($totalCartCount items in cart)',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: MyApp.slate900,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: MyApp.brightOrange,
          onPressed: openCartSheet,
        ),
      ),
    );
  }

  void incrementCartItem(int index) {
    setState(() {
      cartItems[index].quantity++;
    });
  }

  void decrementCartItem(int index) {
    setState(() {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      } else {
        cartItems.removeAt(index);
      }
    });
  }

  void clearCart() {
    setState(() {
      cartItems.clear();
      appliedCoupon = null;
    });
  }

  void placeCurrentOrder() {
    if (cartItems.isEmpty) return;

    final now = DateTime.now();
    final hour = now.hour > 12
        ? now.hour - 12
        : (now.hour == 0 ? 12 : now.hour);
    final period = now.hour >= 12 ? 'PM' : 'AM';
    final minuteStr = now.minute.toString().padLeft(2, '0');
    final formattedTime = '$hour:$minuteStr $period';

    final orderSummary = cartItems
        .map(
          (item) =>
              '${item.quantity}x ${item.title}'
              '${item.customizations != null ? ' (${item.customizations})' : ''}',
        )
        .join(', ');

    final newOrderId = '#$_nextOrderNumber';
    _nextOrderNumber++;
    final currentPaidAmount = finalPayablePrice;

    final newOrder = OrderItem(
      id: newOrderId,
      food: orderSummary,
      status: 'Preparing',
      time: formattedTime,
      amount: currentPaidAmount,
    );

    setState(() {
      userOrders.insert(0, newOrder);
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
          backgroundColor: Colors.red.shade700,
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
            const Icon(Icons.verified, color: MyApp.brightOrange, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Coupon "${coupon.code}" applied! You saved ₹$discountAmount!',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: MyApp.slate900,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
        backgroundColor: MyApp.slate900,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // MODERN SLATE & ORANGE CART SHEET
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
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: MyApp.slateBorder,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: MyApp.orangeLight,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.shopping_bag_outlined,
                                color: MyApp.brightOrange,
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
                                    color: MyApp.slate900,
                                  ),
                                ),
                                Text(
                                  '$totalCartCount items selected',
                                  style: const TextStyle(
                                    color: MyApp.slate600,
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
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: MyApp.slateBorder),
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
                                      color: MyApp.orangeLight,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.fastfood_outlined,
                                      size: 55,
                                      color: MyApp.brightOrange,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Your Cart is Empty',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: MyApp.slate900,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Explore our fresh menu or custom combos and add delicious items!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: MyApp.slate600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView(
                            padding: const EdgeInsets.all(16),
                            children: [
                              ...cartItems.asMap().entries.map((entry) {
                                int idx = entry.key;
                                CartItem item = entry.value;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: MyApp.slateBorder,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x08000000),
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.green,
                                                width: 1.2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: const Icon(
                                              Icons.circle,
                                              color: Colors.green,
                                              size: 8,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.title,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: MyApp.slate900,
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  '₹${item.unitPrice} each',
                                                  style: const TextStyle(
                                                    color: MyApp.slate600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: MyApp.slateBg,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: MyApp.slateBorder,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    decrementCartItem(idx);
                                                    setModalState(() {});
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    child: Icon(
                                                      Icons.remove,
                                                      size: 16,
                                                      color: Colors.redAccent,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  '${item.quantity}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: MyApp.brightOrange,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    incrementCartItem(idx);
                                                    setModalState(() {});
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    child: Icon(
                                                      Icons.add,
                                                      size: 16,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Text(
                                            '₹${item.unitPrice * item.quantity}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.5,
                                              color: MyApp.brightOrange,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (item.customizations != null) ...[
                                        const SizedBox(height: 8),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: MyApp.orangeLight,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: MyApp.orangeBorder,
                                            ),
                                          ),
                                          child: Text(
                                            'Customized: ${item.customizations}',
                                            style: const TextStyle(
                                              fontSize: 11.5,
                                              color: MyApp.slate700,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              }),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: appliedCoupon != null
                                        ? Colors.green
                                        : MyApp.slateBorder,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.local_offer_outlined,
                                          color: appliedCoupon != null
                                              ? Colors.green
                                              : MyApp.brightOrange,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          appliedCoupon != null
                                              ? 'Promo Code Applied 🎉'
                                              : 'Offers & Promo Codes',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: appliedCoupon != null
                                                ? Colors.green
                                                : MyApp.slate900,
                                            fontSize: 13.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    if (appliedCoupon != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: Colors.green,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${appliedCoupon!.code} (Saved ₹$discountAmount)',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                                fontSize: 13,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.close,
                                                color: Colors.redAccent,
                                                size: 18,
                                              ),
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
                                                color: MyApp.slateBg,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: MyApp.slateBorder,
                                                ),
                                              ),
                                              child: TextField(
                                                controller:
                                                    couponInputController,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .characters,
                                                style: const TextStyle(
                                                  color: MyApp.slate900,
                                                ),
                                                decoration: const InputDecoration(
                                                  hintText:
                                                      'Enter code (e.g. CELEBRATE50)',
                                                  hintStyle: TextStyle(
                                                    fontSize: 12,
                                                    color: MyApp.slate400,
                                                  ),
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 10,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  MyApp.brightOrange,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () {
                                              if (couponInputController
                                                  .text
                                                  .isNotEmpty) {
                                                applyCouponCode(
                                                  couponInputController.text,
                                                );
                                                setModalState(() {});
                                              }
                                            },
                                            child: const Text(
                                              'APPLY',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: availableCoupons.map((c) {
                                          return ActionChip(
                                            backgroundColor: MyApp.orangeLight,
                                            side: const BorderSide(
                                              color: MyApp.orangeBorder,
                                            ),
                                            avatar: const Icon(
                                              Icons.local_offer,
                                              size: 12,
                                              color: MyApp.brightOrange,
                                            ),
                                            label: Text(
                                              c.code,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: MyApp.brightOrange,
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
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: MyApp.slateBorder),
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Item Total',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: MyApp.slate600,
                                  ),
                                ),
                                Text(
                                  '₹$subtotalCartPrice',
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: MyApp.slate900,
                                  ),
                                ),
                              ],
                            ),
                            if (appliedCoupon != null) ...[
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Coupon Discount (${appliedCoupon!.code})',
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Text(
                                    '-₹$discountAmount',
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 4),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery Partner Fee',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: MyApp.slate600,
                                  ),
                                ),
                                Text(
                                  'FREE',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            Divider(height: 18, color: MyApp.slateBorder),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'To Pay',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: MyApp.slate900,
                                  ),
                                ),
                                Row(
                                  children: [
                                    if (appliedCoupon != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 6,
                                        ),
                                        child: Text(
                                          '₹$subtotalCartPrice',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ),
                                    Text(
                                      '₹$finalPayablePrice',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: MyApp.brightOrange,
                                      ),
                                    ),
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
                                  backgroundColor: MyApp.brightOrange,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () {
                                  final amountPaid = finalPayablePrice;
                                  placeCurrentOrder();
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(
                                          color: MyApp.brightOrange,
                                        ),
                                      ),
                                      title: const Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 26,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Order Placed!',
                                            style: TextStyle(
                                              color: MyApp.slate900,
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: Text(
                                        'Your feast of ₹$amountPaid has been placed and is now PREPARING in the kitchen!\n\nCheck the "Orders" page to track your order in real-time.',
                                        style: const TextStyle(
                                          color: MyApp.slate700,
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: MyApp.brightOrange,
                                            foregroundColor: Colors.white,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            setState(() {
                                              selectedNavIndex = 3;
                                            });
                                          },
                                          child: const Text(
                                            'Track in Orders',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Text(
                                  'Place Order • ₹$finalPayablePrice',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
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
        onAddToCart: addFoodToCart,
        onOpenCart: openCartSheet,
      ),
      CombosScreen(onCustomizeAndAdd: addCustomizedComboToCart),
      OffersScreen(
        onApplyCoupon: (code) {
          applyCouponCode(code);
          openCartSheet();
        },
      ),
      OrdersScreen(orders: userOrders),
      const CustomerProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: const BoxDecoration(
                color: MyApp.brightOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 18,
              ),
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
                    color: MyApp.slate900,
                    letterSpacing: -0.2,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 12,
                      color: MyApp.brightOrange,
                    ),
                    SizedBox(width: 2),
                    Text(
                      'Celebrations Food Hub, 25 mins',
                      style: TextStyle(fontSize: 11.5, color: MyApp.slate600),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: (selectedNavIndex == 0 || selectedNavIndex == 1)
          ? SizedBox(
              width: 66,
              height: 66,
              child: FloatingActionButton(
                onPressed: openCartSheet,
                backgroundColor: MyApp.brightOrange,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 34,
                    ),
                    if (totalCartCount > 0)
                      Positioned(
                        right: -6,
                        top: -8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: MyApp.slate900,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            '$totalCartCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )
          : null,
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
        ],
      ),
      bottomNavigationBar: isMobile
          ? Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: MyApp.slateBorder, width: 1),
                ),
              ),
              child: NavigationBar(
                selectedIndex: selectedNavIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    selectedNavIndex = index;
                  });
                },
                backgroundColor: Colors.white,
                elevation: 0,
                indicatorColor: MyApp.orangeLight,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.explore_outlined, color: MyApp.slate400),
                    selectedIcon: Icon(
                      Icons.explore,
                      color: MyApp.brightOrange,
                    ),
                    label: 'Explore',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.lunch_dining_outlined,
                      color: MyApp.slate400,
                    ),
                    selectedIcon: Icon(
                      Icons.lunch_dining,
                      color: MyApp.brightOrange,
                    ),
                    label: 'Combos',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.local_offer_outlined,
                      color: MyApp.slate400,
                    ),
                    selectedIcon: Icon(
                      Icons.local_offer,
                      color: MyApp.brightOrange,
                    ),
                    label: 'Offers',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.receipt_long_outlined,
                      color: MyApp.slate400,
                    ),
                    selectedIcon: Icon(
                      Icons.receipt_long,
                      color: MyApp.brightOrange,
                    ),
                    label: 'Orders',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_outline, color: MyApp.slate400),
                    selectedIcon: Icon(Icons.person, color: MyApp.brightOrange),
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
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: MyApp.slateBorder, width: 1)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF5E00), Color(0xFFFF8533)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: MyApp.brightOrange.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.restaurant_menu,
              size: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Cravyy Hub',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MyApp.slate900,
            ),
          ),
          const SizedBox(height: 20),
          Divider(height: 1, color: MyApp.slateBorder),
          const SizedBox(height: 10),
          MenuItem(
            icon: Icons.explore_outlined,
            title: 'Explore',
            isSelected: selectedIndex == 0,
            onTap: () => onSelect(0),
          ),
          MenuItem(
            icon: Icons.lunch_dining_outlined,
            title: 'Combos',
            isSelected: selectedIndex == 1,
            onTap: () => onSelect(1),
          ),
          MenuItem(
            icon: Icons.local_offer_outlined,
            title: 'Offers',
            isSelected: selectedIndex == 2,
            onTap: () => onSelect(2),
          ),
          MenuItem(
            icon: Icons.receipt_long_outlined,
            title: 'Orders',
            isSelected: selectedIndex == 3,
            onTap: () => onSelect(3),
          ),
          MenuItem(
            icon: Icons.person_outline,
            title: 'Profile',
            isSelected: selectedIndex == 4,
            onTap: () => onSelect(4),
          ),
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
        color: isSelected ? MyApp.brightOrange : MyApp.slate400,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? MyApp.brightOrange : MyApp.slate700,
        ),
      ),
      tileColor: isSelected ? MyApp.orangeLight : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      onTap: onTap,
    );
  }
}

// ============================================================================
// PAGE 0: DASHBOARD EXPLORE
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
      assetPath: 'assets/images/pizza_margherita.jpg',
      imageUrl:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500&auto=format&fit=crop&q=80',
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
      assetPath: 'assets/images/veggie_burger.jpg',
      imageUrl:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&auto=format&fit=crop&q=80',
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
      assetPath: 'assets/images/creamy_pasta.jpg',
      imageUrl:
          'https://images.unsplash.com/photo-1621996346565-e3d5d6281691?w=500&auto=format&fit=crop&q=80',
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
      assetPath: 'assets/images/club_sandwich.jpg',
      imageUrl:
          'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=500&auto=format&fit=crop&q=80',
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
      assetPath: 'assets/images/dum_biryani.jpg',
      imageUrl:
          'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=500&auto=format&fit=crop&q=80',
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
      assetPath: 'assets/images/hakka_noodles.jpg',
      imageUrl:
          'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=500&auto=format&fit=crop&q=80',
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
      assetPath: 'assets/images/paneer_tikka.jpg',
      imageUrl:
          'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?w=500&auto=format&fit=crop&q=80',
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
      assetPath: 'assets/images/choco_lava.jpg',
      imageUrl:
          'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=500&auto=format&fit=crop&q=80',
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
      assetPath: 'assets/images/cheese_pizza.jpg',
      imageUrl:
          'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=500&auto=format&fit=crop&q=80',
      rating: 4.9,
      reviewCount: 290,
      deliveryTime: '25-30 mins',
      isBestseller: true,
      isVeg: true,
    ),
  ];

  IconData getCategoryIcon(String cat) {
    switch (cat) {
      case 'All':
        return Icons.restaurant_menu;
      case 'Pizza':
        return Icons.local_pizza;
      case 'Burgers':
        return Icons.lunch_dining;
      case 'Pasta':
        return Icons.ramen_dining;
      case 'Biryani':
        return Icons.rice_bowl;
      case 'Starters':
        return Icons.outdoor_grill;
      case 'Chinese':
        return Icons.soup_kitchen;
      case 'Desserts':
        return Icons.cake;
      default:
        return Icons.fastfood;
    }
  }

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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: MyApp.slateBorder),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x06000000),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: MyApp.brightOrange, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        searchQuery = val;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search pizza, biryani, choco cake...',
                      hintStyle: TextStyle(
                        fontSize: 13.5,
                        color: MyApp.slate400,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                if (searchQuery.isNotEmpty)
                  IconButton(
                    icon: const Icon(
                      Icons.clear,
                      size: 18,
                      color: MyApp.slate400,
                    ),
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
                    decoration: const BoxDecoration(
                      color: MyApp.orangeLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.tune,
                      size: 16,
                      color: MyApp.brightOrange,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Festive Promo Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [MyApp.brightOrange, Color(0xFFFF8C38)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: MyApp.brightOrange.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'FESTIVE FEAST OFFER 🎉',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Flat ₹50 OFF + Free Delivery',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Use code CELEBRATE50 on checkout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.card_giftcard, size: 48, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((cat) {
                final isSelected = selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: FilterChip(
                    avatar: Icon(
                      getCategoryIcon(cat),
                      size: 16,
                      color: isSelected ? Colors.white : MyApp.brightOrange,
                    ),
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: MyApp.brightOrange,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : MyApp.slate700,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      fontSize: 13,
                    ),
                    checkmarkColor: Colors.white,
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected
                          ? MyApp.brightOrange
                          : MyApp.slateBorder,
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
          const SizedBox(height: 20),
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
                  color: MyApp.slate900,
                ),
              ),
              Text(
                '${filteredFoods.length} items',
                style: const TextStyle(color: MyApp.slate600, fontSize: 12.5),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (filteredFoods.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: MyApp.slateBorder),
              ),
              child: Column(
                children: const [
                  Icon(
                    Icons.search_off_rounded,
                    size: 55,
                    color: MyApp.slate400,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No Food Found',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: MyApp.slate900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Try another category or search term!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: MyApp.slate600, fontSize: 13),
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
                return VelvetFoodCard(
                  food: food,
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
// PAGE 1: INTERACTIVE COMBOS & MEAL CUSTOMIZER SCREEN
// ============================================================================
class CombosScreen extends StatelessWidget {
  final Function({
    required ComboItem combo,
    required CustomOption selectedMain,
    required CustomOption selectedSide,
    required CustomOption selectedBev,
    required List<CustomOption> selectedAddons,
    required int totalPrice,
  })
  onCustomizeAndAdd;

  const CombosScreen({super.key, required this.onCustomizeAndAdd});

  final List<ComboItem> combos = const [
    ComboItem(
      id: 'COMBO-1',
      name: 'Festive Burger Feast Combo',
      description:
          'Choice of Gourmet Burger + Crispy Side Fries + Refreshing Drink + Sweet Choco Lava Cake',
      basePrice: 299,
      icon: Icons.lunch_dining,
      assetPath: 'assets/images/combo_burger.jpg',
      imageUrl:
          'https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?w=500&auto=format&fit=crop&q=80',
      rating: 4.9,
      mainOptions: [
        CustomOption(name: 'Veggie Deluxe Burger', extraPrice: 0),
        CustomOption(name: 'Crispy Paneer Supreme Burger', extraPrice: 30),
        CustomOption(name: 'Double Cheese Loaded Burger', extraPrice: 45),
      ],
      sideOptions: [
        CustomOption(name: 'Classic Salted Fries', extraPrice: 0),
        CustomOption(name: 'Spicy Peri-Peri Fries', extraPrice: 20),
        CustomOption(name: 'Cheesy Melt Loaded Fries', extraPrice: 40),
        CustomOption(name: 'Crispy Onion Rings (4 pcs)', extraPrice: 25),
      ],
      beverageOptions: [
        CustomOption(name: 'Classic Coca-Cola (300ml)', extraPrice: 0),
        CustomOption(name: 'Chilled Pepsi Zero', extraPrice: 0),
        CustomOption(name: 'Fanta Orange Spark', extraPrice: 0),
        CustomOption(name: 'Thick Cold Coffee', extraPrice: 35),
        CustomOption(name: 'Fresh Mint Mojito', extraPrice: 40),
      ],
      addonOptions: [
        CustomOption(name: 'Warm Choco Lava Cake', extraPrice: 60),
        CustomOption(name: 'Extra Cheese Dip', extraPrice: 25),
        CustomOption(name: 'Peri-Peri Seasoning Dip', extraPrice: 15),
      ],
    ),
    ComboItem(
      id: 'COMBO-2',
      name: 'Royal Pizza Party Combo',
      description:
          'Fresh 8-Inch Pan Pizza + Stuffed Garlic Bread + Beverage + Creamy Cheese Dip',
      basePrice: 389,
      icon: Icons.local_pizza,
      assetPath: 'assets/images/combo_pizza.jpg',
      imageUrl:
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=500&auto=format&fit=crop&q=80',
      rating: 4.8,
      mainOptions: [
        CustomOption(name: 'Margherita Cheese Burst (8")', extraPrice: 0),
        CustomOption(name: 'Tandoori Paneer Tikka Pizza (8")', extraPrice: 40),
        CustomOption(name: 'Farmhouse Veggie Supreme (8")', extraPrice: 35),
      ],
      sideOptions: [
        CustomOption(name: 'Garlic Breadsticks (4 pcs)', extraPrice: 0),
        CustomOption(name: 'Cheese Stuffed Garlic Bread', extraPrice: 35),
        CustomOption(name: 'Peri-Peri Potato Wedges', extraPrice: 25),
      ],
      beverageOptions: [
        CustomOption(name: 'Classic Coca-Cola', extraPrice: 0),
        CustomOption(name: 'Fanta Fizz', extraPrice: 0),
        CustomOption(name: 'Cold Coffee with Ice Cream', extraPrice: 40),
        CustomOption(name: 'Iced Lemon Tea', extraPrice: 25),
      ],
      addonOptions: [
        CustomOption(name: 'Jalapeno Cheesy Dip', extraPrice: 25),
        CustomOption(name: 'Cadbury Celebrations Mini Box', extraPrice: 80),
      ],
    ),
    ComboItem(
      id: 'COMBO-3',
      name: 'Hyderabadi Biryani Royal Thali',
      description:
          'Aromatic Dum Biryani + Veg Starter + Raita & Salan + Cold Beverage + Gulab Jamun',
      basePrice: 349,
      icon: Icons.rice_bowl,
      assetPath: 'assets/images/combo_biryani.jpg',
      imageUrl:
          'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=500&auto=format&fit=crop&q=80',
      rating: 4.9,
      mainOptions: [
        CustomOption(name: 'Special Veg Dum Biryani', extraPrice: 0),
        CustomOption(name: 'Hyderabadi Paneer Biryani', extraPrice: 30),
      ],
      sideOptions: [
        CustomOption(name: 'Tandoori Paneer Tikka (3 pcs)', extraPrice: 0),
        CustomOption(name: 'Crispy Corn & Pepper Salt', extraPrice: 20),
        CustomOption(name: 'Hara Bhara Kebab (4 pcs)', extraPrice: 25),
      ],
      beverageOptions: [
        CustomOption(name: 'Masala Spiced Chaas (Buttermilk)', extraPrice: 0),
        CustomOption(name: 'Classic Thums Up / Coke', extraPrice: 0),
        CustomOption(name: 'Sweet Mango Lassi', extraPrice: 30),
      ],
      addonOptions: [
        CustomOption(name: 'Warm Gulab Jamun (2 pcs)', extraPrice: 35),
        CustomOption(name: 'Extra Boondi Raita', extraPrice: 20),
      ],
    ),
    ComboItem(
      id: 'COMBO-4',
      name: 'Sweet Tooth Celebration Box',
      description:
          'Choco Lava Cake + Belgian Dark Waffle + Cold Beverage + Nutty Brownie',
      basePrice: 259,
      icon: Icons.cake,
      assetPath: 'assets/images/combo_sweet.jpg',
      imageUrl:
          'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=500&auto=format&fit=crop&q=80',
      rating: 4.9,
      mainOptions: [
        CustomOption(name: 'Molten Choco Lava Cake', extraPrice: 0),
        CustomOption(name: 'Warm Cadbury Silk Fudge Brownie', extraPrice: 20),
      ],
      sideOptions: [
        CustomOption(name: 'Belgian Chocolate Waffle', extraPrice: 0),
        CustomOption(name: 'Nutella Stuffed Donut', extraPrice: 15),
      ],
      beverageOptions: [
        CustomOption(name: 'Thick Chocolate Milkshake', extraPrice: 0),
        CustomOption(name: 'Hazelnut Cold Coffee', extraPrice: 25),
        CustomOption(name: 'Hot Cadbury Hot Chocolate', extraPrice: 30),
      ],
      addonOptions: [
        CustomOption(name: 'Vanilla Ice Cream Scoop', extraPrice: 30),
        CustomOption(name: 'Sprinkles & Caramel Drizzle', extraPrice: 15),
      ],
    ),
  ];

  void _openCustomizerModal(BuildContext context, ComboItem combo) {
    CustomOption selectedMain = combo.mainOptions.first;
    CustomOption selectedSide = combo.sideOptions.first;
    CustomOption selectedBev = combo.beverageOptions.first;
    List<CustomOption> selectedAddons = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setCustomState) {
            int currentTotalPrice =
                combo.basePrice +
                selectedMain.extraPrice +
                selectedSide.extraPrice +
                selectedBev.extraPrice +
                selectedAddons.fold(0, (sum, a) => sum + a.extraPrice);

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: MyApp.orangeLight,
                                shape: BoxShape.circle,
                                border: Border.all(color: MyApp.orangeBorder),
                              ),
                              child: Icon(
                                combo.icon,
                                color: MyApp.brightOrange,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  combo.name,
                                  style: const TextStyle(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.bold,
                                    color: MyApp.slate900,
                                  ),
                                ),
                                const Text(
                                  'Customize Your Meal • Swap Sides & Drinks',
                                  style: TextStyle(
                                    color: MyApp.slate600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: MyApp.slate900),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: MyApp.slateBorder),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(18),
                      children: [
                        _buildSectionHeader(
                          '1. Choose Main Entrée',
                          'Required • Choose 1',
                        ),
                        ...combo.mainOptions.map((opt) {
                          bool isSel = selectedMain.name == opt.name;
                          return _buildRadioOptionTile(
                            title: opt.name,
                            extraPrice: opt.extraPrice,
                            isSelected: isSel,
                            onTap: () {
                              setCustomState(() {
                                selectedMain = opt;
                              });
                            },
                          );
                        }),
                        const SizedBox(height: 18),
                        _buildSectionHeader(
                          '2. Choose Side / Swap Fries',
                          'Required • Swap Any Side',
                        ),
                        ...combo.sideOptions.map((opt) {
                          bool isSel = selectedSide.name == opt.name;
                          return _buildRadioOptionTile(
                            title: opt.name,
                            extraPrice: opt.extraPrice,
                            isSelected: isSel,
                            onTap: () {
                              setCustomState(() {
                                selectedSide = opt;
                              });
                            },
                          );
                        }),
                        const SizedBox(height: 18),
                        _buildSectionHeader(
                          '3. Choose Beverage / Swap Drink',
                          'Required • Swap Beverage',
                        ),
                        ...combo.beverageOptions.map((opt) {
                          bool isSel = selectedBev.name == opt.name;
                          return _buildRadioOptionTile(
                            title: opt.name,
                            extraPrice: opt.extraPrice,
                            isSelected: isSel,
                            onTap: () {
                              setCustomState(() {
                                selectedBev = opt;
                              });
                            },
                          );
                        }),
                        if (combo.addonOptions.isNotEmpty) ...[
                          const SizedBox(height: 18),
                          _buildSectionHeader(
                            '4. Sweet Dips & Celebration Add-ons',
                            'Optional',
                          ),
                          ...combo.addonOptions.map((opt) {
                            bool isSel = selectedAddons.any(
                              (a) => a.name == opt.name,
                            );
                            return _buildCheckboxOptionTile(
                              title: opt.name,
                              extraPrice: opt.extraPrice,
                              isSelected: isSel,
                              onTap: () {
                                setCustomState(() {
                                  if (isSel) {
                                    selectedAddons.removeWhere(
                                      (a) => a.name == opt.name,
                                    );
                                  } else {
                                    selectedAddons.add(opt);
                                  }
                                });
                              },
                            );
                          }),
                        ],
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: MyApp.slateBorder)),
                    ),
                    child: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Customized Total',
                                style: TextStyle(
                                  color: MyApp.slate600,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '₹$currentTotalPrice',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: MyApp.brightOrange,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyApp.brightOrange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 13,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              onCustomizeAndAdd(
                                combo: combo,
                                selectedMain: selectedMain,
                                selectedSide: selectedSide,
                                selectedBev: selectedBev,
                                selectedAddons: selectedAddons,
                                totalPrice: currentTotalPrice,
                              );
                            },
                            icon: const Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Add Combo to Cart',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
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

  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.5,
              color: MyApp.slate900,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11.5,
              color: MyApp.brightOrange,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOptionTile({
    required String title,
    required int extraPrice,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? MyApp.orangeLight : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? MyApp.brightOrange : MyApp.slateBorder,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Icon(
          isSelected
              ? Icons.radio_button_checked
              : Icons.radio_button_unchecked,
          color: isSelected ? MyApp.brightOrange : MyApp.slate400,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? MyApp.slate900 : MyApp.slate700,
            fontSize: 13.5,
          ),
        ),
        trailing: extraPrice > 0
            ? Text(
                '+₹$extraPrice',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: MyApp.brightOrange,
                  fontSize: 13,
                ),
              )
            : const Text(
                'FREE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 12,
                ),
              ),
      ),
    );
  }

  Widget _buildCheckboxOptionTile({
    required String title,
    required int extraPrice,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? MyApp.orangeLight : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? MyApp.brightOrange : MyApp.slateBorder,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Icon(
          isSelected ? Icons.check_box : Icons.check_box_outline_blank,
          color: isSelected ? MyApp.brightOrange : MyApp.slate400,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? MyApp.slate900 : MyApp.slate700,
            fontSize: 13.5,
          ),
        ),
        trailing: Text(
          '+₹$extraPrice',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: MyApp.brightOrange,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [MyApp.brightOrange, Color(0xFFFF8533)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: MyApp.brightOrange.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'COMBO MEAL MAKER 🍟🥤',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Customize & Swap Any Item',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                    ],
                  ),
                ),
                const Icon(Icons.lunch_dining, size: 50, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Celebration Value Combos',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: MyApp.slate900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap "Customize & Add" on any meal to personalize your items!',
            style: TextStyle(color: MyApp.slate600, fontSize: 13),
          ),
          const SizedBox(height: 14),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: combos.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final combo = combos[index];

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: MyApp.slateBorder),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FoodImageWidget(
                          width: 76,
                          height: 76,
                          assetPath: combo.assetPath,
                          networkUrl: combo.imageUrl,
                          icon: combo.icon,
                          isOutOfStock: combo.isOutOfStock,
                          borderRadius: 14,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                combo.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: MyApp.slate900,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                combo.description,
                                style: const TextStyle(
                                  color: MyApp.slate600,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Divider(color: MyApp.slateBorder),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Starting from',
                              style: TextStyle(
                                color: MyApp.slate600,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              '₹${combo.basePrice}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: MyApp.brightOrange,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyApp.brightOrange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                          onPressed: () => _openCustomizerModal(context, combo),
                          icon: const Icon(
                            Icons.tune,
                            size: 16,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Customize & Add',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
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
                colors: [Color(0xFFFF5E00), Color(0xFFFF8533)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: MyApp.brightOrange.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_offer, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Festive Offers & Coupons',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  'Tap "Apply To Cart" on any coupon to apply instant savings directly to your cart bill!',
                  style: TextStyle(color: Colors.white, fontSize: 12.5),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: MyApp.slateBorder),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x08000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
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
                              color: MyApp.slate900,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: MyApp.orangeLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: MyApp.orangeBorder),
                          ),
                          child: Text(
                            offer['discount']!,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: MyApp.brightOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      offer['desc']!,
                      style: const TextStyle(
                        color: MyApp.slate600,
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
                            color: MyApp.slateBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: MyApp.slateBorder),
                          ),
                          child: Text(
                            'CODE: ${offer['code']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MyApp.brightOrange,
                              letterSpacing: 1,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyApp.brightOrange,
                            foregroundColor: Colors.white,
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
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Apply To Cart',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                            ),
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
// PAGE 3: ORDERS MANAGEMENT SCREEN
// ============================================================================
class OrdersScreen extends StatefulWidget {
  final List<OrderItem> orders;

  const OrdersScreen({super.key, required this.orders});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String selectedFilter = 'All';

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'preparing':
        return MyApp.brightOrange;
      case 'cancelled':
        return Colors.red;
      case 'on the way':
        return Colors.blue;
      case 'pending':
        return Colors.amber.shade800;
      default:
        return Colors.grey;
    }
  }

  IconData getOrderStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'all':
        return Icons.list_alt;
      case 'delivered':
        return Icons.check_circle_outline;
      case 'preparing':
        return Icons.soup_kitchen;
      case 'on the way':
        return Icons.delivery_dining;
      case 'pending':
        return Icons.timer_outlined;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.receipt_long;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = selectedFilter == 'All'
        ? widget.orders
        : widget.orders
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
                        avatar: Icon(
                          getOrderStatusIcon(status),
                          size: 15,
                          color: isSelected ? Colors.white : MyApp.brightOrange,
                        ),
                        label: Text(status),
                        selected: isSelected,
                        selectedColor: MyApp.brightOrange,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : MyApp.slate700,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                        checkmarkColor: Colors.white,
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: isSelected
                              ? MyApp.brightOrange
                              : MyApp.slateBorder,
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
            style: const TextStyle(color: MyApp.slate600, fontSize: 13),
          ),
          const SizedBox(height: 12),
          if (filteredOrders.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(36),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: MyApp.slateBorder),
              ),
              child: Column(
                children: const [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 50,
                    color: MyApp.slate400,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No Orders Found',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyApp.slate900,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Place an order from Explore or Combos to see it here live!',
                    style: TextStyle(color: MyApp.slate600, fontSize: 12.5),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredOrders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                final statusColor = getStatusColor(order.status);
                final bool isLiveOrder =
                    order.status == 'Preparing' || order.status == 'On The Way';

                return Card(
                  elevation: isLiveOrder ? 3 : 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isLiveOrder
                          ? MyApp.brightOrange
                          : MyApp.slateBorder,
                      width: isLiveOrder ? 1.5 : 1.0,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: isLiveOrder
                          ? MyApp.brightOrange
                          : MyApp.slateBg,
                      child: Text(
                        '#${index + 1}',
                        style: TextStyle(
                          color: isLiveOrder ? Colors.white : MyApp.slate900,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(
                          'Order ${order.id}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MyApp.slate900,
                            fontSize: 15,
                          ),
                        ),
                        if (index == 0 && isLiveOrder) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: MyApp.orangeLight,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: MyApp.brightOrange,
                                width: 0.8,
                              ),
                            ),
                            child: const Text(
                              '🔥 LATEST',
                              style: TextStyle(
                                color: MyApp.brightOrange,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                        const Spacer(),
                        Text(
                          '₹${order.amount}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MyApp.brightOrange,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${order.food}\nOrdered at ${order.time}',
                        style: const TextStyle(
                          color: MyApp.slate600,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                    isThreeLine: true,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor, width: 1.2),
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
                          builder: (context) =>
                              OrderDetailsScreen(order: order),
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
// PAGE 4: CUSTOMER PROFILE & PREFERENCES SCREEN
// ============================================================================
class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  bool pushNotifications = true;
  bool soundAlerts = true;
  bool vegOnlyMode = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CUSTOMER PROFILE HEADER CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF5E00), Color(0xFFFF8533)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: MyApp.brightOrange.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: const Text(
                    'P',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: MyApp.brightOrange,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text(
                            'Prince Vaviya',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.verified, color: Colors.white, size: 18),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'prince@example.com • Gold VIP Member',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '⭐ 450 Celebration Reward Points',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Dining Preferences & Alerts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MyApp.slate900,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: MyApp.slateBorder),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text(
                    'Pure Veg Mode Filter',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyApp.slate900,
                    ),
                  ),
                  subtitle: const Text(
                    'Show only vegetarian menu & combos',
                    style: TextStyle(color: MyApp.slate600),
                  ),
                  value: vegOnlyMode,
                  activeTrackColor: MyApp.orangeLight,
                  activeThumbColor: MyApp.brightOrange,
                  onChanged: (val) {
                    setState(() {
                      vegOnlyMode = val;
                    });
                  },
                ),
                Divider(height: 1, color: MyApp.slateBorder),
                SwitchListTile(
                  title: const Text(
                    'Order Status Updates',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyApp.slate900,
                    ),
                  ),
                  subtitle: const Text(
                    'Receive live tracking notifications',
                    style: TextStyle(color: MyApp.slate600),
                  ),
                  value: pushNotifications,
                  activeTrackColor: MyApp.orangeLight,
                  activeThumbColor: MyApp.brightOrange,
                  onChanged: (val) {
                    setState(() {
                      pushNotifications = val;
                    });
                  },
                ),
                Divider(height: 1, color: MyApp.slateBorder),
                SwitchListTile(
                  title: const Text(
                    'Sound Alerts & Chimes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyApp.slate900,
                    ),
                  ),
                  subtitle: const Text(
                    'Play pleasant sound when food is on the way',
                    style: TextStyle(color: MyApp.slate600),
                  ),
                  value: soundAlerts,
                  activeTrackColor: MyApp.orangeLight,
                  activeThumbColor: MyApp.brightOrange,
                  onChanged: (val) {
                    setState(() {
                      soundAlerts = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: MyApp.slateBorder),
            ),
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.home_outlined, color: MyApp.brightOrange),
                  title: Text(
                    'Saved Delivery Address',
                    style: TextStyle(
                      color: MyApp.slate900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Home • Surat, Gujarat',
                    style: TextStyle(color: MyApp.slate600),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: MyApp.slate400,
                  ),
                ),
                Divider(height: 1, color: MyApp.slateBorder),
                const ListTile(
                  leading: Icon(
                    Icons.payment_outlined,
                    color: MyApp.brightOrange,
                  ),
                  title: Text(
                    'Saved Payment Methods',
                    style: TextStyle(
                      color: MyApp.slate900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'UPI / Cards / Net Banking',
                    style: TextStyle(color: MyApp.slate600),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: MyApp.slate400,
                  ),
                ),
                Divider(height: 1, color: MyApp.slateBorder),
                const ListTile(
                  leading: Icon(Icons.help_outline, color: MyApp.brightOrange),
                  title: Text(
                    'Customer Care & Live Support',
                    style: TextStyle(
                      color: MyApp.slate900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '24x7 Help Center',
                    style: TextStyle(color: MyApp.slate600),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: MyApp.slate400,
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
                backgroundColor: MyApp.brightOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Preferences saved successfully!'),
                    backgroundColor: MyApp.slate900,
                  ),
                );
              },
              icon: const Icon(Icons.save, color: Colors.white),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isGold ? MyApp.brightOrange : MyApp.slateBorder,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: isGold ? MyApp.brightOrange : MyApp.slate600,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: isGold ? MyApp.brightOrange : MyApp.slate900,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: MyApp.slate600),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BRIGHT WHITE & SLATE FOOD CARD WITH ORANGE ACCENTS
// ============================================================================
class VelvetFoodCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onAddToCart;

  const VelvetFoodCard({
    super.key,
    required this.food,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MyApp.slateBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: MyApp.orangeLight,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: MyApp.orangeBorder),
                ),
                child: Text(
                  food.category,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: MyApp.brightOrange,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 1.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.circle, color: Colors.green, size: 6),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: FoodImageWidget(
                assetPath: food.assetPath,
                networkUrl: food.imageUrl,
                icon: food.icon,
                isOutOfStock: food.isOutOfStock,
                borderRadius: 14,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 1.2),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Icon(Icons.circle, color: Colors.green, size: 6),
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
                    color: MyApp.slate900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            food.deliveryTime,
            style: const TextStyle(color: MyApp.slate600, fontSize: 11.5),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                food.price,
                style: const TextStyle(
                  color: MyApp.slate900,
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
                    color: MyApp.brightOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '+ ADD',
                    style: TextStyle(
                      color: Colors.white,
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
// ORDER DETAILS SCREEN
// ============================================================================
class OrderDetailsScreen extends StatelessWidget {
  final OrderItem order;

  const OrderDetailsScreen({super.key, required this.order});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'preparing':
        return MyApp.brightOrange;
      case 'cancelled':
        return Colors.red;
      case 'on the way':
        return Colors.blue;
      case 'pending':
        return Colors.amber.shade800;
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
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(color: MyApp.slateBorder),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: MyApp.orangeLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.receipt_long,
                        size: 42,
                        color: MyApp.brightOrange,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: MyApp.slate900,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Divider(color: MyApp.slateBorder),
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
                          style: TextStyle(color: MyApp.slate600, fontSize: 14),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
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
                    Divider(color: MyApp.slateBorder),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyApp.brightOrange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
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
          style: const TextStyle(color: MyApp.slate600, fontSize: 14),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold ? MyApp.brightOrange : MyApp.slate900,
            ),
          ),
        ),
      ],
    );
  }
}
