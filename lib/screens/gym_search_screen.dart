import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum GymCategoryType {
  all,
  openGym,
  commercial,
  crossfit,
  powerlifting,
}

class GymPlaceItem {
  final String id;
  final String name;
  final String categoryName;
  final GymCategoryType type;
  final double distanceKm;
  final String address;
  final double rating;
  final int reviewsCount;
  final String timing;
  final bool isOpenNow;
  final String membershipPrice;
  final String priceSubtitle;
  final bool isFree;
  final List<String> amenities;
  final String crowdStatus;
  final Color crowdColor;
  final List<Color> cardGradient;
  final IconData typeIcon;

  const GymPlaceItem({
    required this.id,
    required this.name,
    required this.categoryName,
    required this.type,
    required this.distanceKm,
    required this.address,
    required this.rating,
    required this.reviewsCount,
    required this.timing,
    required this.isOpenNow,
    required this.membershipPrice,
    required this.priceSubtitle,
    required this.isFree,
    required this.amenities,
    required this.crowdStatus,
    required this.crowdColor,
    required this.cardGradient,
    required this.typeIcon,
  });
}

class GymSearchScreen extends StatefulWidget {
  const GymSearchScreen({super.key});

  @override
  State<GymSearchScreen> createState() => _GymSearchScreenState();
}

class _GymSearchScreenState extends State<GymSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  GymCategoryType _selectedType = GymCategoryType.all;
  String _sortBy = 'Distance'; // 'Distance', 'Rating', 'Price'

  static const List<GymPlaceItem> _allGyms = [
    GymPlaceItem(
      id: 'gym_1',
      name: 'Sunset Green Park Open Gym',
      categoryName: 'Open Air Public Gym',
      type: GymCategoryType.openGym,
      distanceKm: 0.4,
      address: 'Sunset Lake Boulevard, Sector 4',
      rating: 4.8,
      reviewsCount: 342,
      timing: 'Open 24/7 (Best at 6 AM - 10 AM)',
      isOpenNow: true,
      membershipPrice: 'FREE',
      priceSubtitle: 'Public Park Access',
      isFree: true,
      amenities: [
        'Calisthenics Rig',
        'Parallel Bars',
        'Pull-Up Ladders',
        'Ab Benches',
        'Jogging Track',
        'Open Air',
      ],
      crowdStatus: 'Moderate Crowd 🟡',
      crowdColor: Color(0xFFFBBF24),
      cardGradient: [Color(0xFF0F291E), Color(0xFF134E4A)],
      typeIcon: Icons.nature_people_rounded,
    ),
    GymPlaceItem(
      id: 'gym_2',
      name: 'Iron Forge Fitness Club',
      categoryName: 'Premium Commercial Gym',
      type: GymCategoryType.commercial,
      distanceKm: 1.1,
      address: '88 Apex Tower, 3rd Floor, Central Avenue',
      rating: 4.9,
      reviewsCount: 890,
      timing: '6:00 AM - 11:00 PM',
      isOpenNow: true,
      membershipPrice: '₹1,499 / mo',
      priceSubtitle: 'Day pass: ₹200',
      isFree: false,
      amenities: [
        'Full Hammer Strength Rigs',
        'Dumbbells up to 60kg',
        'Steam & Sauna',
        'AC & Lockers',
        'Protein Smoothie Bar',
        'Certified Trainers',
      ],
      crowdStatus: 'Low Crowd 🟢',
      crowdColor: Color(0xFF4ADE80),
      cardGradient: [Color(0xFF1E1035), Color(0xFF3B0764)],
      typeIcon: Icons.fitness_center_rounded,
    ),
    GymPlaceItem(
      id: 'gym_3',
      name: 'City Sports Complex Outdoor Arena',
      categoryName: 'Open Air Calisthenics Park',
      type: GymCategoryType.openGym,
      distanceKm: 1.6,
      address: 'Municipal Sports Ground, North Gate',
      rating: 4.7,
      reviewsCount: 215,
      timing: '5:00 AM - 9:00 PM',
      isOpenNow: true,
      membershipPrice: 'FREE',
      priceSubtitle: 'Govt. Fitness Facility',
      isFree: true,
      amenities: [
        'High Monkey Bars',
        'Dip Stations',
        'Squat Post Stations',
        'Stretching Mats',
        'Water Fountain',
      ],
      crowdStatus: 'Busy Now 🔴',
      crowdColor: Color(0xFFEF4444),
      cardGradient: [Color(0xFF1C1917), Color(0xFF292524)],
      typeIcon: Icons.park_rounded,
    ),
    GymPlaceItem(
      id: 'gym_4',
      name: 'Vanguard CrossFit & Functional Box',
      categoryName: 'CrossFit & Functional Box',
      type: GymCategoryType.crossfit,
      distanceKm: 2.3,
      address: 'Warehouse #12, Industrial Hub Lane',
      rating: 4.9,
      reviewsCount: 420,
      timing: '5:30 AM - 10:00 PM',
      isOpenNow: true,
      membershipPrice: '₹2,499 / mo',
      priceSubtitle: 'Unlimited WOD classes',
      isFree: false,
      amenities: [
        'Olympic Lifting Platforms',
        'Rogue Bumper Plates',
        'Concept2 Rowers & SkiErgs',
        'Climbing Ropes',
        'Kettlebell Arsenal',
      ],
      crowdStatus: 'Moderate Crowd 🟡',
      crowdColor: Color(0xFFFBBF24),
      cardGradient: [Color(0xFF331400), Color(0xFF7C2D12)],
      typeIcon: Icons.sports_mma_rounded,
    ),
    GymPlaceItem(
      id: 'gym_5',
      name: 'Titan Powerlifting Dungeon',
      categoryName: 'Hardcore Powerlifting & Strongman',
      type: GymCategoryType.powerlifting,
      distanceKm: 3.1,
      address: 'Basement Level, Old Market Complex',
      rating: 4.8,
      reviewsCount: 560,
      timing: '24/7 Access for Members',
      isOpenNow: true,
      membershipPrice: '₹1,899 / mo',
      priceSubtitle: 'Chalk friendly & Monolifts',
      isFree: false,
      amenities: [
        'Eleiko Calibrated Steel Plates',
        '4 Competition Combo Racks',
        'Specialty Barbells (SSB, Deadlift Bar)',
        'Heavy Dumbbells up to 80kg',
        'Chalk Permitted',
      ],
      crowdStatus: 'Low Crowd 🟢',
      crowdColor: Color(0xFF4ADE80),
      cardGradient: [Color(0xFF1E1E1E), Color(0xFF111827)],
      typeIcon: Icons.sports_gymnastics_rounded,
    ),
    GymPlaceItem(
      id: 'gym_6',
      name: 'Pulse 24/7 Elite Fitness',
      categoryName: 'Commercial Multi-Tier Gym',
      type: GymCategoryType.commercial,
      distanceKm: 3.8,
      address: 'Grand Promenade Mall, 5th Level',
      rating: 4.6,
      reviewsCount: 1120,
      timing: 'Open 24 Hours • 7 Days',
      isOpenNow: true,
      membershipPrice: '₹2,199 / mo',
      priceSubtitle: 'All-access pass',
      isFree: false,
      amenities: [
        '24/7 Keycard Entry',
        'Cardio Cinema Zone',
        'Personal Training Suites',
        'Juice & Supplement Kiosk',
        'Dedicated Stretching Area',
      ],
      crowdStatus: 'Moderate Crowd 🟡',
      crowdColor: Color(0xFFFBBF24),
      cardGradient: [Color(0xFF0C2036), Color(0xFF0369A1)],
      typeIcon: Icons.watch_later_rounded,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<GymPlaceItem> _getFilteredGyms() {
    final query = _searchController.text.toLowerCase().trim();

    return _allGyms.where((gym) {
      // Category filter
      if (_selectedType == GymCategoryType.openGym && gym.type != GymCategoryType.openGym) {
        return false;
      }
      if (_selectedType == GymCategoryType.commercial && gym.type != GymCategoryType.commercial) {
        return false;
      }
      if (_selectedType == GymCategoryType.crossfit && gym.type != GymCategoryType.crossfit) {
        return false;
      }
      if (_selectedType == GymCategoryType.powerlifting && gym.type != GymCategoryType.powerlifting) {
        return false;
      }

      // Search query filter
      if (query.isNotEmpty) {
        final matchesName = gym.name.toLowerCase().contains(query);
        final matchesAddress = gym.address.toLowerCase().contains(query);
        final matchesCategory = gym.categoryName.toLowerCase().contains(query);
        final matchesAmenities = gym.amenities.any((a) => a.toLowerCase().contains(query));
        final matchesPrice = gym.membershipPrice.toLowerCase().contains(query);

        return matchesName || matchesAddress || matchesCategory || matchesAmenities || matchesPrice;
      }

      return true;
    }).toList()
      ..sort((a, b) {
        if (_sortBy == 'Distance') {
          return a.distanceKm.compareTo(b.distanceKm);
        } else if (_sortBy == 'Rating') {
          return b.rating.compareTo(a.rating);
        } else if (_sortBy == 'Price') {
          // Free first, then ascending cost
          if (a.isFree && !b.isFree) return -1;
          if (!a.isFree && b.isFree) return 1;
          return a.name.compareTo(b.name);
        }
        return 0;
      });
  }

  void _showGymDetails(GymPlaceItem gym) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.78,
          decoration: const BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: AppTheme.primary, width: 2),
            ),
          ),
          child: Column(
            children: [
              // Top drag bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Header tag & Price highlight
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: gym.isFree
                                ? const Color(0xFF10B981).withValues(alpha: 0.2)
                                : AppTheme.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: gym.isFree ? const Color(0xFF10B981) : AppTheme.primary,
                            ),
                          ),
                          child: Text(
                            gym.categoryName.toUpperCase(),
                            style: TextStyle(
                              color: gym.isFree ? const Color(0xFF10B981) : AppTheme.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: gym.isFree ? const Color(0xFF10B981) : AppTheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            gym.membershipPrice,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Gym Name
                    Text(
                      gym.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Location and Distance
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 16, color: AppTheme.primary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${gym.address} • ${gym.distanceKm} km away',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Rating & Crowd Info Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 20),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${gym.rating}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '(${gym.reviewsCount} reviews)',
                                style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                          Container(width: 1, height: 36, color: AppTheme.border),
                          Column(
                            children: [
                              Text(
                                gym.crowdStatus,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const Text(
                                'Live Crowd Density',
                                style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Timings Section
                    const Text(
                      'Operating Hours',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.access_time_filled_rounded, size: 16, color: AppTheme.primary),
                        const SizedBox(width: 6),
                        Text(
                          gym.timing,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Amenities / Equipment List
                    const Text(
                      'Equipment & Amenities',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: gym.amenities.map((item) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_rounded, size: 14, color: AppTheme.primary),
                              const SizedBox(width: 6),
                              Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Action Buttons (Get Directions & Book Day Pass / Contact)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Opening GPS Route to "${gym.name}" 📍'),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppTheme.surface,
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: AppTheme.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.navigation_rounded, color: AppTheme.primary),
                            label: const Text(
                              'Directions',
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    gym.isFree
                                        ? 'Public gym saved to your favorites!'
                                        : 'Membership inquiry sent to ${gym.name}!',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppTheme.surface,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: gym.isFree ? const Color(0xFF10B981) : AppTheme.primary,
                              foregroundColor: const Color(0xFF000000),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: Icon(gym.isFree ? Icons.check : Icons.call),
                            label: Text(
                              gym.isFree ? 'Free Visit' : 'Membership',
                              style: const TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredGyms = _getFilteredGyms();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // Header & Search Box
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Explore Nearby Gyms',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.2,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Discover open-air calisthenics parks, commercial gyms & membership costs',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Search Bar
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search gym name, area, amenities (e.g., sauna, free)...',
                      prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primary),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, color: AppTheme.textSecondary),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Category Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All Nearby', GymCategoryType.all),
                        _buildFilterChip('🌿 Open Air (Free)', GymCategoryType.openGym),
                        _buildFilterChip('🏢 Commercial Gyms', GymCategoryType.commercial),
                        _buildFilterChip('⚡ CrossFit Boxes', GymCategoryType.crossfit),
                        _buildFilterChip('🏋️ Powerlifting', GymCategoryType.powerlifting),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Result count & Sort Dropdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${filteredGyms.length} gyms found',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.sort_rounded, size: 16, color: AppTheme.primary),
                          const SizedBox(width: 4),
                          DropdownButton<String>(
                            value: _sortBy,
                            dropdownColor: AppTheme.surfaceVariant,
                            underline: const SizedBox(),
                            style: const TextStyle(
                              color: AppTheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                            icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primary),
                            items: ['Distance', 'Rating', 'Price'].map((val) {
                              return DropdownMenuItem(
                                value: val,
                                child: Text('Sort: $val'),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              if (newVal != null) {
                                setState(() {
                                  _sortBy = newVal;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Gym Cards List
          if (filteredGyms.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_off_rounded,
                      size: 56,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No gyms match your search',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _selectedType = GymCategoryType.all;
                        });
                      },
                      child: const Text('Reset Filters'),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final gym = filteredGyms[index];
                    return _buildGymCard(gym);
                  },
                  childCount: filteredGyms.length,
                ),
              ),
            ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, GymCategoryType type) {
    final isSelected = _selectedType == type;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            _selectedType = type;
          });
        },
        selectedColor: AppTheme.primary,
        checkmarkColor: const Color(0xFF000000),
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFF000000) : AppTheme.textSecondary,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
          fontSize: 12,
        ),
        backgroundColor: AppTheme.surfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isSelected ? AppTheme.primary : AppTheme.border,
          ),
        ),
      ),
    );
  }

  Widget _buildGymCard(GymPlaceItem gym) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _showGymDetails(gym),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Banner Row (Type Tag + Distance & Price Badge)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: gym.isFree
                              ? const Color(0xFF10B981).withValues(alpha: 0.15)
                              : AppTheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          gym.typeIcon,
                          size: 16,
                          color: gym.isFree ? const Color(0xFF10B981) : AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        gym.categoryName,
                        style: TextStyle(
                          color: gym.isFree ? const Color(0xFF10B981) : AppTheme.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),

                  // Membership Cost Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: gym.isFree
                          ? const Color(0xFF10B981).withValues(alpha: 0.2)
                          : AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: gym.isFree
                            ? const Color(0xFF10B981)
                            : AppTheme.borderLight,
                      ),
                    ),
                    child: Text(
                      gym.membershipPrice,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: gym.isFree ? const Color(0xFF34D399) : AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Gym Name
              Text(
                gym.name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),

              const SizedBox(height: 4),

              // Address & Distance
              Row(
                children: [
                  const Icon(Icons.near_me_rounded, size: 13, color: AppTheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    '${gym.distanceKm} km away',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('•', style: TextStyle(color: AppTheme.textSecondary)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      gym.address,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Amenities Pills Preview
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: gym.amenities.take(3).map((a) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      a,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList()
                  ..add(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '+${gym.amenities.length - 3} more',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ),

              const SizedBox(height: 12),

              // Bottom Info Row (Star Rating, Timing & View Details)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFB300)),
                      const SizedBox(width: 4),
                      Text(
                        '${gym.rating}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${gym.reviewsCount})',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        gym.priceSubtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 11,
                        color: AppTheme.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
