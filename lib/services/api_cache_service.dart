import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/archive_entry.dart';

class ApiCacheService {
  static const String _cacheKeyData = 'cached_archive_json_data';
  static const String _cacheKeyTimestamp = 'cached_archive_sync_time';

  // Thematic curated mock datasets for Space, Dinosaur, and Solarpunk
  static final List<Map<String, dynamic>> _mockDataset = [
    // 🚀 SPACE EXPLORATION ENTRIES
    {
      'id': 101,
      'title': 'James Webb Deep Field Nebula Telemetry',
      'era': 'Cosmic Epoch • 2026',
      'summary': 'Infrared spectroscopic analysis revealing primitive proto-galaxies formed 300 million years after the Big Bang with heavy metal signatures.',
      'tag': 'DEEP SPACE INFRARED',
      'metric': '13.5 Billion Light-Years',
      'author': 'Deep Space Astronomical Network',
      'category': 'space',
      'likesCount': 428,
    },
    {
      'id': 102,
      'title': 'Europa Clipper Subsurface Ocean Probe',
      'era': 'Jovian Orbit • 2030',
      'summary': 'Sub-surface radar sounding through 15km ice crust detecting hydrothermal vent plumes with high methane and salinity indicators.',
      'tag': 'ASTRO-BIOLOGY PROBE',
      'metric': '98.4% Salinity Match',
      'author': 'Outer Planets Exploration Division',
      'category': 'space',
      'likesCount': 312,
    },
    {
      'id': 103,
      'title': 'Dyson Swarm Orbital Solar Harvester',
      'era': 'Stellar Engineering • 2045',
      'summary': 'Constellation of 10,000 ultralight graphene solar mirrors beaming terawatt microwave power directly to orbital lunar relay stations.',
      'tag': 'SOLAR TELEMETRY',
      'metric': '4.2 Terawatts Peak',
      'author': 'Interplanetary Energy Guild',
      'category': 'space',
      'likesCount': 560,
    },

    // 🦖 DINOSAUR & PALEO-BIOLOGY ENTRIES
    {
      'id': 201,
      'title': 'Spinosaurus Aegyptiacus Aquatic Biome',
      'era': 'Late Cretaceous • 95 Mya',
      'summary': 'High-density bone compaction and paddle-tail fossil reconstructions proving predatory river hunting capabilities in prehistoric North Africa.',
      'tag': 'PALEONTOLOGY DISCOVERY',
      'metric': '15.2m Apex Specimen',
      'author': 'Kem Kem Paleobiological Institute',
      'category': 'dinosaur',
      'likesCount': 389,
    },
    {
      'id': 202,
      'title': 'Patagotitan Mayorum Fossil Density Scan',
      'era': 'Cenomanian Stage • 100 Mya',
      'summary': 'Femur micro-CT scan analysis showcasing cellular vascularization supporting 70-metric-ton sauropod biomechanics and weight dispersion.',
      'tag': 'TITANOSAUR SKELETAL',
      'metric': '69 Metric Tons Mass',
      'author': 'Patagonia Mesozoic Center',
      'category': 'dinosaur',
      'likesCount': 295,
    },
    {
      'id': 203,
      'title': 'Amber-Preserved Theropod Plumage Resonance',
      'era': 'Early Cretaceous • 120 Mya',
      'summary': 'Synchrotron X-ray fluorescence mapping melanosome structures, revealing iridescent structural coloration in winged Microraptor fossils.',
      'tag': 'FEATHER MORPHOLOGY',
      'metric': '99.8% Pigment Integrity',
      'author': 'Institute of Vertebrate Paleontology',
      'category': 'dinosaur',
      'likesCount': 410,
    },

    // 🌿 SOLARPUNK & CLEAN FUTURE ENTRIES
    {
      'id': 301,
      'title': 'Algae Bioreactor Vertical Canopy Skyscrapers',
      'era': 'Solarpunk Sol-Cycle • 2085',
      'summary': 'Bio-integrated architectural facades filtering municipal CO2 through micro-algae photobioreactors producing clean bio-methane and oxygen.',
      'tag': 'ECO-ARCHITECTURE',
      'metric': '8.6 Tons CO2 Fixed/Day',
      'author': 'Neo-Kyoto Sol Collective',
      'category': 'solarpunk',
      'likesCount': 620,
    },
    {
      'id': 302,
      'title': 'Mycelium Organic Insulation & Carbon Sinks',
      'era': 'Circular Biome • 2078',
      'summary': 'Self-healing architectural mycelium composites grown from agricultural byproducts, achieving negative net carbon footprint with zero plastics.',
      'tag': 'BIOMATERIAL SYNTHESIS',
      'metric': '-120kg CO2/m³ Net',
      'author': 'Bio-Harmonic Habitat Guild',
      'category': 'solarpunk',
      'likesCount': 375,
    },
    {
      'id': 303,
      'title': 'Superconducting Maglev Community Rail',
      'era': 'Zero-Emission Grid • 2090',
      'summary': 'Solar-powered ambient temperature magnetic levitation transport lines connecting regional permaculture villages at zero kinetic loss.',
      'tag': 'CLEAN MOBILITY',
      'metric': '0.0g Carbon Emissions',
      'author': 'Solaris Infrastructure Alliance',
      'category': 'solarpunk',
      'likesCount': 510,
    },
  ];

  /// Fetches data from Public REST API (or network simulated) and caches in SharedPreferences
  static Future<List<ArchiveEntry>> fetchArchiveEntries({
    bool forceRefresh = false,
    bool simulateOffline = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. If simulating offline mode, try reading from SharedPreferences Cache
    if (simulateOffline) {
      final cachedJson = prefs.getString(_cacheKeyData);
      if (cachedJson != null && cachedJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(cachedJson) as List<dynamic>;
        return decoded
            .map((item) => ArchiveEntry.fromJson(item as Map<String, dynamic>, isCached: true))
            .toList();
      } else {
        throw Exception('Offline Mode: No cached data found in SharedPreferences.');
      }
    }

    // 2. If not forcing refresh, check if valid cache exists in SharedPreferences
    if (!forceRefresh) {
      final cachedJson = prefs.getString(_cacheKeyData);
      if (cachedJson != null && cachedJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(cachedJson) as List<dynamic>;
        return decoded
            .map((item) => ArchiveEntry.fromJson(item as Map<String, dynamic>, isCached: true))
            .toList();
      }
    }

    // 3. Perform live HTTP REST API network request
    try {
      // Connect to public REST API to verify live network connectivity & headers
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=1'))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('REST API returned status code ${response.statusCode}');
      }

      // Simulate network latency for demonstration of FutureBuilder loading state
      await Future.delayed(const Duration(milliseconds: 650));

      // 4. Cache the fresh result into SharedPreferences
      final String jsonToCache = jsonEncode(_mockDataset);
      await prefs.setString(_cacheKeyData, jsonToCache);
      await prefs.setString(_cacheKeyTimestamp, DateTime.now().toIso8601String());

      // 5. Parse and return fresh data (isCached: false)
      return _mockDataset
          .map((item) => ArchiveEntry.fromJson(item, isCached: false))
          .toList();
    } catch (e) {
      // 6. Network failover: If network fails, fallback gracefully to SharedPreferences cache
      final cachedJson = prefs.getString(_cacheKeyData);
      if (cachedJson != null && cachedJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(cachedJson) as List<dynamic>;
        return decoded
            .map((item) => ArchiveEntry.fromJson(item as Map<String, dynamic>, isCached: true))
            .toList();
      }
      // If network failed and no cache existed, save mock dataset as offline fallback
      final String jsonToCache = jsonEncode(_mockDataset);
      await prefs.setString(_cacheKeyData, jsonToCache);
      await prefs.setString(_cacheKeyTimestamp, DateTime.now().toIso8601String());

      return _mockDataset
          .map((item) => ArchiveEntry.fromJson(item, isCached: true))
          .toList();
    }
  }

  /// Check last cache sync timestamp from SharedPreferences
  static Future<DateTime?> getLastSyncTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    final String? timestampStr = prefs.getString(_cacheKeyTimestamp);
    if (timestampStr != null) {
      return DateTime.tryParse(timestampStr);
    }
    return null;
  }

  /// Clear SharedPreferences cache
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKeyData);
    await prefs.remove(_cacheKeyTimestamp);
  }
}
