import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/neo_brutalist_theme.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // Master list of products managed via setState
  final List<Product> _allProducts = [
    Product(
      id: 'p1',
      name: 'SonicWave Wireless ANC Headphones',
      brand: 'Acoustix Labs',
      description: '40mm custom drivers with hybrid active noise cancellation & 45h battery.',
      price: 129.99,
      originalPrice: 179.99,
      rating: 4.8,
      reviewCount: 342,
      category: ProductCategory.audio,
      pastelColor: NeoBrutalistTheme.pastelLilac,
      icon: Icons.headphones_rounded,
      badge: 'HOT DEAL 🔥',
    ),
    Product(
      id: 'p2',
      name: 'Retro Mechanical Gaming Keyboard',
      brand: 'KeyCrafters',
      description: 'Hot-swappable tactile yellow switches, RGB backlighting & rotary knob.',
      price: 89.50,
      originalPrice: 110.00,
      rating: 4.9,
      reviewCount: 520,
      category: ProductCategory.electronics,
      pastelColor: NeoBrutalistTheme.pastelMint,
      icon: Icons.keyboard_rounded,
      badge: 'BESTSELLER ⚡',
    ),
    Product(
      id: 'p3',
      name: 'AeroGlide Cloud Foam Sneakers',
      brand: 'Stride & Co.',
      description: 'Ultra-lightweight breathable mesh with responsive cushion technology.',
      price: 74.99,
      originalPrice: 95.00,
      rating: 4.6,
      reviewCount: 188,
      category: ProductCategory.footwear,
      pastelColor: NeoBrutalistTheme.pastelPeach,
      icon: Icons.roller_skating_rounded,
      badge: 'NEW DROP 👟',
    ),
    Product(
      id: 'p4',
      name: 'Minimalist Matte Smart Flask 750ml',
      brand: 'HydroPulse',
      description: 'Double-wall vacuum insulation keeps drinks 24h cold / 12h hot.',
      price: 34.00,
      originalPrice: 42.00,
      rating: 4.7,
      reviewCount: 215,
      category: ProductCategory.lifestyle,
      pastelColor: NeoBrutalistTheme.pastelButter,
      icon: Icons.water_drop_rounded,
      badge: 'ECO FRIENDLY 🌿',
    ),
    Product(
      id: 'p5',
      name: 'CyberPunk Optical Pro Gaming Mouse',
      brand: 'PixelForge',
      description: '26K DPI optical sensor, honeycomb lightweight shell & PTFE skates.',
      price: 59.99,
      originalPrice: 79.99,
      rating: 4.5,
      reviewCount: 160,
      category: ProductCategory.electronics,
      pastelColor: NeoBrutalistTheme.pastelSky,
      icon: Icons.mouse_rounded,
      badge: 'SALE 25% OFF',
    ),
    Product(
      id: 'p6',
      name: 'Titanium Dual-Time Minimal Watch',
      brand: 'Kronos Studios',
      description: 'Sapphire crystal glass, Japanese quartz movement & Italian leather strap.',
      price: 145.00,
      originalPrice: 195.00,
      rating: 4.9,
      reviewCount: 94,
      category: ProductCategory.accessories,
      pastelColor: NeoBrutalistTheme.pastelRose,
      icon: Icons.watch_rounded,
      badge: 'LIMITED 💎',
    ),
    Product(
      id: 'p7',
      name: 'Hi-Fi Portable Bluetooth Boombox',
      brand: 'Acoustix Labs',
      description: '360° surround audio with deep bass radiator & IPX7 waterproof rating.',
      price: 68.00,
      originalPrice: 85.00,
      rating: 4.6,
      reviewCount: 230,
      category: ProductCategory.audio,
      pastelColor: NeoBrutalistTheme.pastelLime,
      icon: Icons.speaker_rounded,
    ),
    Product(
      id: 'p8',
      name: 'Ergonomic Memory Foam Laptop Stand',
      brand: 'DeskFlow',
      description: 'Anodized aluminum alloy with adjustable 6-level tilt angles.',
      price: 39.99,
      originalPrice: 49.99,
      rating: 4.4,
      reviewCount: 140,
      category: ProductCategory.lifestyle,
      pastelColor: NeoBrutalistTheme.pastelLilac,
      icon: Icons.laptop_chromebook_rounded,
    ),
  ];

  // Search & Filter State variables
  String _searchQuery = '';
  ProductCategory _selectedCategory = ProductCategory.all;
  String _selectedSort = 'Featured'; // 'Featured', 'Price: Low to High', 'Price: High to Low', 'Top Rated'
  bool _onlyOnSale = false;
  bool _onlyFavorites = false;
  int _cartItemCount = 0;
  final TextEditingController _searchController = TextEditingController();

  // Filtered and Sorted products getter using setState
  List<Product> get _filteredProducts {
    List<Product> list = _allProducts.where((product) {
      // Search query filter
      final matchesSearch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(_searchQuery.toLowerCase());

      // Category filter
      final matchesCategory = _selectedCategory == ProductCategory.all ||
          product.category == _selectedCategory;

      // On Sale filter
      final matchesSale = !_onlyOnSale || product.originalPrice > product.price;

      // Favorites filter
      final matchesFav = !_onlyFavorites || product.isFavorite;

      return matchesSearch && matchesCategory && matchesSale && matchesFav;
    }).toList();

    // Sorting logic
    switch (_selectedSort) {
      case 'Price: Low to High':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Top Rated':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      default:
        // Featured keeps original order
        break;
    }

    return list;
  }

  // Toggle Favorite using setState
  void _toggleFavorite(String id) {
    setState(() {
      final index = _allProducts.indexWhere((p) => p.id == id);
      if (index != -1) {
        _allProducts[index].isFavorite = !_allProducts[index].isFavorite;
      }
    });
  }

  // Add to Cart using setState
  void _addToCart(Product product) {
    setState(() {
      _cartItemCount++;
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: NeoBrutalistTheme.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: NeoBrutalistTheme.pastelMint, width: 2),
        ),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: NeoBrutalistTheme.pastelMint, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Added "${product.name}" to cart!',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Reset all filters using setState
  void _resetFilters() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
      _selectedCategory = ProductCategory.all;
      _selectedSort = 'Featured';
      _onlyOnSale = false;
      _onlyFavorites = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts;

    return Scaffold(
      backgroundColor: NeoBrutalistTheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: NeoBrutalistTheme.neoBox(
                color: NeoBrutalistTheme.pastelLime,
                radius: 10,
                borderWidth: 2,
                shadowOffset: 2.5,
              ),
              child: const Text(
                'NEO',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: NeoBrutalistTheme.black,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('MART ⚡'),
          ],
        ),
        actions: [
          // Cart Action Badge
          Container(
            margin: const EdgeInsets.only(right: 14),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: NeoBrutalistTheme.neoBox(
                    color: NeoBrutalistTheme.pastelPeach,
                    radius: 12,
                    borderWidth: 2,
                    shadowOffset: 2.5,
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: NeoBrutalistTheme.black,
                    size: 22,
                  ),
                ),
                if (_cartItemCount > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: NeoBrutalistTheme.black,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Text(
                        '$_cartItemCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================================
          // 1. NEO-BRUTALIST SEARCH BAR
          // ==========================================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
            child: Container(
              height: 48,
              decoration: NeoBrutalistTheme.neoBox(
                color: Colors.white,
                radius: 14,
                borderWidth: 2.5,
                shadowOffset: 3.5,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.search_rounded, size: 22, color: NeoBrutalistTheme.black),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: NeoBrutalistTheme.black,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Search products, brands, gear...',
                        hintStyle: TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18, color: NeoBrutalistTheme.black),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    ),
                ],
              ),
            ),
          ),

          // ==========================================
          // 2. CATEGORY FILTER CHIPS (Horizontal Scroll)
          // ==========================================
          SizedBox(
            height: 40,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: ProductCategory.values.length,
              itemBuilder: (context, index) {
                final category = ProductCategory.values[index];
                final isSelected = _selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? NeoBrutalistTheme.pastelMint
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: NeoBrutalistTheme.black, width: 2),
                        boxShadow: isSelected
                            ? NeoBrutalistTheme.hardShadow(x: 2.5, y: 2.5)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          category.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                            color: NeoBrutalistTheme.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // ==========================================
          // 3. QUICK FILTER TOGGLES & SORT HEADER
          // ==========================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // "On Sale" Quick Filter Chip
                InkWell(
                  onTap: () => setState(() => _onlyOnSale = !_onlyOnSale),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _onlyOnSale
                          ? NeoBrutalistTheme.pastelRose
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: NeoBrutalistTheme.black, width: 1.8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _onlyOnSale ? Icons.check_box_rounded : Icons.local_offer_outlined,
                          size: 13,
                          color: NeoBrutalistTheme.black,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'On Sale',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: NeoBrutalistTheme.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                // "Saved" Favorites Quick Filter Chip
                InkWell(
                  onTap: () => setState(() => _onlyFavorites = !_onlyFavorites),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _onlyFavorites
                          ? NeoBrutalistTheme.pastelLilac
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: NeoBrutalistTheme.black, width: 1.8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _onlyFavorites ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 13,
                          color: _onlyFavorites ? Colors.red : NeoBrutalistTheme.black,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Saved',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: NeoBrutalistTheme.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),

                // Sorting Menu
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: NeoBrutalistTheme.black, width: 1.8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedSort,
                      icon: const Icon(Icons.arrow_drop_down_rounded, color: NeoBrutalistTheme.black, size: 20),
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: NeoBrutalistTheme.black,
                      ),
                      onChanged: (String? val) {
                        if (val != null) {
                          setState(() {
                            _selectedSort = val;
                          });
                        }
                      },
                      items: const [
                        DropdownMenuItem(value: 'Featured', child: Text('✨ Featured')),
                        DropdownMenuItem(value: 'Price: Low to High', child: Text('💵 Price: Low ➔ High')),
                        DropdownMenuItem(value: 'Price: High to Low', child: Text('💎 Price: High ➔ Low')),
                        DropdownMenuItem(value: 'Top Rated', child: Text('⭐ Top Rated')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Count & Result Label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${products.length} PRODUCTS FOUND',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    color: Color(0xFF666666),
                  ),
                ),
                if (_searchQuery.isNotEmpty || _selectedCategory != ProductCategory.all || _onlyOnSale || _onlyFavorites)
                  InkWell(
                    onTap: _resetFilters,
                    child: const Text(
                      'Clear Filters ✕',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ==========================================
          // 4. DYNAMIC PRODUCT LISTVIEW (ListView.builder)
          // ==========================================
          Expanded(
            child: products.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                    physics: const BouncingScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _buildProductCard(product);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Neo-Brutalist Product Card Widget
  Widget _buildProductCard(Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: NeoBrutalistTheme.neoBox(
        color: Colors.white,
        radius: 18,
        borderWidth: 2.5,
        shadowOffset: 4.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Category tag + Badge + Favorite button
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: NeoBrutalistTheme.surfaceElevated,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: NeoBrutalistTheme.black, width: 1.5),
                      ),
                      child: Text(
                        product.category.label.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          color: NeoBrutalistTheme.black,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    if (product.badge.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: product.pastelColor,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: NeoBrutalistTheme.black, width: 1.5),
                        ),
                        child: Text(
                          product.badge,
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                            color: NeoBrutalistTheme.black,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                // Favorite Heart Button using setState
                InkWell(
                  onTap: () => _toggleFavorite(product.id),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: product.isFavorite ? NeoBrutalistTheme.pastelRose : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: NeoBrutalistTheme.black, width: 1.5),
                    ),
                    child: Icon(
                      product.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      size: 17,
                      color: product.isFavorite ? Colors.red : NeoBrutalistTheme.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Content: Pastel Product Icon Illustration & Details
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pastel Product Illustration Box
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: product.pastelColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: NeoBrutalistTheme.black, width: 2.2),
                    boxShadow: NeoBrutalistTheme.hardShadow(x: 3, y: 3),
                  ),
                  child: Center(
                    child: Icon(
                      product.icon,
                      size: 40,
                      color: NeoBrutalistTheme.black,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Title, Brand & Ratings (Flexible / Expanded)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.brand,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: NeoBrutalistTheme.black,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Rating & Reviews Pill
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: NeoBrutalistTheme.pastelButter,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: NeoBrutalistTheme.black, width: 1.2),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star_rounded, size: 12, color: NeoBrutalistTheme.black),
                                const SizedBox(width: 2),
                                Text(
                                  '${product.rating}',
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w900,
                                    color: NeoBrutalistTheme.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(${product.reviewCount} reviews)',
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF777777),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Bar: Price & Add to Cart Button
          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            decoration: const BoxDecoration(
              color: NeoBrutalistTheme.surfaceElevated,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              border: Border(top: BorderSide(color: NeoBrutalistTheme.black, width: 2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Pricing
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: NeoBrutalistTheme.black,
                          ),
                        ),
                        if (product.originalPrice > product.price) ...[
                          const SizedBox(width: 6),
                          Text(
                            '\$${product.originalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF999999),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (product.discountPercent > 0)
                      Text(
                        'Save ${product.discountPercent.toInt()}% Today',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF047857),
                        ),
                      ),
                  ],
                ),

                // Neo-Brutalist Add to Cart Button
                InkWell(
                  onTap: () => _addToCart(product),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: NeoBrutalistTheme.neoBox(
                      color: NeoBrutalistTheme.pastelMint,
                      radius: 10,
                      borderWidth: 2,
                      shadowOffset: 2.5,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_shopping_cart_rounded, size: 16, color: NeoBrutalistTheme.black),
                        SizedBox(width: 5),
                        Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w900,
                            color: NeoBrutalistTheme.black,
                          ),
                        ),
                      ],
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

  // Empty State Widget when no products match filters
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: NeoBrutalistTheme.neoBox(
                color: NeoBrutalistTheme.pastelRose,
                radius: 24,
                borderWidth: 2.5,
                shadowOffset: 4,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 44,
                color: NeoBrutalistTheme.black,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No Products Found! 📦',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: NeoBrutalistTheme.black,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try tweaking your search keywords or active category filters.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 18),
            InkWell(
              onTap: _resetFilters,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: NeoBrutalistTheme.neoBox(
                  color: NeoBrutalistTheme.pastelButter,
                  radius: 12,
                  borderWidth: 2,
                  shadowOffset: 3,
                ),
                child: const Text(
                  'Reset All Filters ⚡',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: NeoBrutalistTheme.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
