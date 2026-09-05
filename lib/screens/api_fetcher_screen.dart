import 'package:flutter/material.dart';
import '../models/archive_entry.dart';
import '../services/api_cache_service.dart';
import '../theme/neo_brutalist_pastel_theme.dart';

class ApiFetcherScreen extends StatefulWidget {
  const ApiFetcherScreen({super.key});

  @override
  State<ApiFetcherScreen> createState() => _ApiFetcherScreenState();
}

class _ApiFetcherScreenState extends State<ApiFetcherScreen> {
  // Future instance for FutureBuilder
  late Future<List<ArchiveEntry>> _archiveFuture;

  // Search & Filter State variables
  String _searchQuery = '';
  String _selectedCategory = 'All'; // 'All', 'Space', 'Dinosaur', 'Solarpunk'
  bool _simulateOffline = false;
  DateTime? _lastSyncTime;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    _archiveFuture = ApiCacheService.fetchArchiveEntries(
      forceRefresh: false,
      simulateOffline: _simulateOffline,
    );
    _refreshSyncTimestamp();
  }

  Future<void> _refreshSyncTimestamp() async {
    final timestamp = await ApiCacheService.getLastSyncTimestamp();
    if (mounted) {
      setState(() {
        _lastSyncTime = timestamp;
      });
    }
  }

  // Force REST API fetch & update cache
  void _forceApiRefresh() {
    setState(() {
      _archiveFuture = ApiCacheService.fetchArchiveEntries(
        forceRefresh: true,
        simulateOffline: _simulateOffline,
      );
    });
    _refreshSyncTimestamp();

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: NeoTheme.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: NeoTheme.pastelMint, width: 2),
        ),
        content: const Row(
          children: [
            Icon(Icons.cloud_sync_rounded, color: NeoTheme.pastelMint, size: 20),
            SizedBox(width: 8),
            Text(
              'Fetching fresh data from REST API...',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Clear SharedPreferences cache
  Future<void> _clearSharedPreferencesCache() async {
    await ApiCacheService.clearCache();
    await _refreshSyncTimestamp();
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: NeoTheme.black,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: NeoTheme.pastelRose, width: 2),
          ),
          content: const Row(
            children: [
              Icon(Icons.delete_sweep_rounded, color: NeoTheme.pastelRose, size: 20),
              SizedBox(width: 8),
              Text(
                'SharedPreferences Cache Cleared!',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Filter helper
  List<ArchiveEntry> _filterEntries(List<ArchiveEntry> list) {
    return list.where((item) {
      final matchesSearch = _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.summary.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.author.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.tag.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == 'All' ||
          item.category.label.toLowerCase() == _selectedCategory.toLowerCase();

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // Open detail modal on card click
  void _openDetailModal(ArchiveEntry item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(22),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(color: NeoTheme.black, width: 3),
              left: BorderSide(color: NeoTheme.black, width: 3),
              right: BorderSide(color: NeoTheme.black, width: 3),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: NeoTheme.black,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Category Badge & Era
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.category.pastelBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: NeoTheme.black, width: 1.8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item.category.emoji, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          item.category.label.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: item.category.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: NeoTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: NeoTheme.black, width: 1.5),
                    ),
                    child: Text(
                      item.era,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: NeoTheme.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Title
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: NeoTheme.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Author & Tag
              Row(
                children: [
                  const Icon(Icons.account_circle_outlined, size: 16, color: Color(0xFF555555)),
                  const SizedBox(width: 4),
                  Text(
                    item.author,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF555555)),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Summary
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: NeoTheme.neoBox(
                  color: item.category.pastelBg.withValues(alpha: 0.35),
                  radius: 14,
                  borderWidth: 2,
                  shadowOffset: 3,
                ),
                child: Text(
                  item.summary,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF222222),
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Metric Highlight
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: NeoTheme.pastelButter,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: NeoTheme.black, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'KEY TELEMETRY / METRIC',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: NeoTheme.black),
                    ),
                    Text(
                      item.metric,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: NeoTheme.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Close Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NeoTheme.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Dismiss Modal', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoTheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: NeoTheme.neoBox(
                color: NeoTheme.pastelLime,
                radius: 10,
                borderWidth: 2,
                shadowOffset: 2.5,
              ),
              child: const Text(
                'REST API',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: NeoTheme.black,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('ARCHIVE 🛰️'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: NeoTheme.black, size: 24),
            tooltip: 'Force REST API Fetch',
            onPressed: _forceApiRefresh,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: NeoTheme.black, size: 22),
            tooltip: 'Clear SharedPreferences Cache',
            onPressed: _clearSharedPreferencesCache,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          // ==========================================
          // 1. CACHE & OFFLINE CONTROL PANEL
          // ==========================================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: NeoTheme.neoBox(
                color: _simulateOffline ? NeoTheme.pastelRose : NeoTheme.pastelMint,
                radius: 14,
                borderWidth: 2.2,
                shadowOffset: 3.5,
              ),
              child: Row(
                children: [
                  Icon(
                    _simulateOffline ? Icons.wifi_off_rounded : Icons.cloud_done_rounded,
                    size: 22,
                    color: NeoTheme.black,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _simulateOffline
                              ? 'OFFLINE SIMULATION ACTIVE'
                              : 'SHARED_PREFERENCES CACHING',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w900,
                            color: NeoTheme.black,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          _lastSyncTime != null
                              ? 'Last Synced: ${_lastSyncTime!.hour.toString().padLeft(2, '0')}:${_lastSyncTime!.minute.toString().padLeft(2, '0')}:${_lastSyncTime!.second.toString().padLeft(2, '0')}'
                              : 'No cache record in SharedPreferences',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Offline Toggle Switch
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Offline',
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(width: 4),
                      Switch(
                        value: _simulateOffline,
                        activeThumbColor: NeoTheme.black,
                        activeTrackColor: Colors.white,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: NeoTheme.black.withValues(alpha: 0.2),
                        onChanged: (val) {
                          setState(() {
                            _simulateOffline = val;
                          });
                          _loadInitialData();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ==========================================
          // 2. SEARCH BAR
          // ==========================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Container(
              height: 46,
              decoration: NeoTheme.neoBox(
                color: Colors.white,
                radius: 12,
                borderWidth: 2.2,
                shadowOffset: 3.0,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.search_rounded, size: 20, color: NeoTheme.black),
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
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: NeoTheme.black,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Search Space, Dinosaurs, Solarpunk...',
                        hintStyle: TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 12.5,
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
                      icon: const Icon(Icons.close_rounded, size: 16, color: NeoTheme.black),
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

          const SizedBox(height: 8),

          // ==========================================
          // 3. THEME CATEGORY FILTER CHIPS
          // ==========================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildCategoryChip('All', '🌐'),
                const SizedBox(width: 6),
                _buildCategoryChip('Space', '🚀'),
                const SizedBox(width: 6),
                _buildCategoryChip('Dinosaur', '🦖'),
                const SizedBox(width: 6),
                _buildCategoryChip('Solarpunk', '🌿'),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ==========================================
          // 4. FUTUREBUILDER COMPONENT
          // ==========================================
          Expanded(
            child: FutureBuilder<List<ArchiveEntry>>(
              future: _archiveFuture,
              builder: (context, snapshot) {
                // State 1: ConnectionState.waiting -> Loading Skeleton
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingSkeleton();
                }

                // State 2: snapshot.hasError -> Neo-Brutalist Error Card
                if (snapshot.hasError) {
                  return _buildErrorState(snapshot.error.toString());
                }

                // State 3: snapshot.hasData -> Render Filtered Catalog
                if (snapshot.hasData) {
                  final filteredList = _filterEntries(snapshot.data!);

                  if (filteredList.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      _forceApiRefresh();
                    },
                    color: NeoTheme.black,
                    backgroundColor: NeoTheme.pastelMint,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final entry = filteredList[index];
                        return _buildArchiveCard(entry);
                      },
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String emoji) {
    final isSelected = _selectedCategory.toLowerCase() == label.toLowerCase();
    Color activeColor = NeoTheme.pastelButter;
    if (label == 'Space') activeColor = NeoTheme.pastelLilac;
    if (label == 'Dinosaur') activeColor = NeoTheme.pastelPeach;
    if (label == 'Solarpunk') activeColor = NeoTheme.pastelMint;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedCategory = label;
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 6),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: NeoTheme.black, width: isSelected ? 2.2 : 1.6),
            boxShadow: isSelected ? NeoTheme.hardShadow(x: 2, y: 2) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                  color: NeoTheme.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Neo-Brutalist Archive Entry Card
  Widget _buildArchiveCard(ArchiveEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: NeoTheme.neoBox(
        color: Colors.white,
        radius: 16,
        borderWidth: 2.2,
        shadowOffset: 3.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header: Category Chip + Era + Cache indicator
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
            decoration: BoxDecoration(
              color: entry.category.pastelBg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              border: const Border(bottom: BorderSide(color: NeoTheme.black, width: 1.8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(entry.category.emoji, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      entry.category.label.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                        color: entry.category.textDark,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                // Cache Status Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: NeoTheme.black, width: 1.2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        entry.isCached ? Icons.inventory_2_outlined : Icons.wifi_tethering_rounded,
                        size: 11,
                        color: entry.isCached ? const Color(0xFFC2410C) : const Color(0xFF047857),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        entry.isCached ? 'CACHED' : 'LIVE API',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: entry.isCached ? const Color(0xFFC2410C) : const Color(0xFF047857),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Card Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: NeoTheme.surfaceElevated,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: NeoTheme.black, width: 1.2),
                      ),
                      child: Text(
                        entry.era,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF444444)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: NeoTheme.pastelButter,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: NeoTheme.black, width: 1.2),
                      ),
                      child: Text(
                        entry.tag,
                        style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900, color: NeoTheme.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Text(
                  entry.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: NeoTheme.black,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),

                Text(
                  entry.summary,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF555555),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Bottom Row: Metric badge & View specs button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.insights_rounded, size: 14, color: NeoTheme.black),
                        const SizedBox(width: 4),
                        Text(
                          entry.metric,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: NeoTheme.black),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => _openDetailModal(entry),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: entry.category.pastelBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: NeoTheme.black, width: 1.5),
                        ),
                        child: const Text(
                          'View Specs ➔',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: NeoTheme.black),
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
  }

  // Loading skeleton placeholder for FutureBuilder ConnectionState.waiting
  Widget _buildLoadingSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: NeoTheme.neoBox(
            color: Colors.white,
            radius: 16,
            borderWidth: 2,
            shadowOffset: 3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 80, height: 16, decoration: BoxDecoration(color: NeoTheme.surfaceElevated, borderRadius: BorderRadius.circular(6))),
                  const Spacer(),
                  Container(width: 60, height: 16, decoration: BoxDecoration(color: NeoTheme.surfaceElevated, borderRadius: BorderRadius.circular(6))),
                ],
              ),
              const SizedBox(height: 12),
              Container(width: double.infinity, height: 18, decoration: BoxDecoration(color: NeoTheme.surfaceElevated, borderRadius: BorderRadius.circular(6))),
              const SizedBox(height: 8),
              Container(width: 180, height: 14, decoration: BoxDecoration(color: NeoTheme.surfaceElevated, borderRadius: BorderRadius.circular(6))),
            ],
          ),
        );
      },
    );
  }

  // Error State Widget
  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: NeoTheme.neoBox(
            color: NeoTheme.pastelRose,
            radius: 20,
            borderWidth: 2.5,
            shadowOffset: 4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 40, color: NeoTheme.black),
              const SizedBox(height: 10),
              const Text(
                'Network Fetch Failed!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: NeoTheme.black),
              ),
              const SizedBox(height: 6),
              Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF444444)),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _forceApiRefresh,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Retry Fetch', style: TextStyle(fontWeight: FontWeight.w900)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: NeoTheme.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Empty State Widget when no records match filter
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: NeoTheme.neoBox(
                color: NeoTheme.pastelButter,
                radius: 20,
                borderWidth: 2.5,
                shadowOffset: 4,
              ),
              child: const Icon(Icons.travel_explore_rounded, size: 38, color: NeoTheme.black),
            ),
            const SizedBox(height: 16),
            const Text(
              'No Archive Entries Found',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: NeoTheme.black),
            ),
            const SizedBox(height: 4),
            const Text(
              'Try changing your category tab or search query.',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _searchController.clear();
                  _selectedCategory = 'All';
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: NeoTheme.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Reset Filters ⚡', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }
}
