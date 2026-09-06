import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/surah.dart';
import '../../services/quran_api_service.dart';
import '../../theme/colors.dart';
import 'surah_detail_screen.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  final QuranApiService _apiService = QuranApiService();
  List<Surah> _surahs = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }

  Future<void> _loadSurahs() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final surahs = await _apiService.getAllSurahs();
      setState(() {
        _surahs = surahs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<Surah> get _filteredSurahs {
    if (_searchQuery.isEmpty) return _surahs;
    return _surahs.where((surah) {
      return surah.englishName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          surah.name.contains(_searchQuery) ||
          surah.number.toString() == _searchQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SurahSearchDelegate(_surahs),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search surah...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: AppColors.secondaryDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          
          // Surah list
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.islamicGold),
                  )
                : _error != null
                    ? _buildErrorWidget()
                    : ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: _filteredSurahs.length,
                        itemBuilder: (context, index) {
                          return _buildSurahCard(_filteredSurahs[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 60),
          const SizedBox(height: 20),
          const Text(
            'Failed to load Quran',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _loadSurahs,
            child: const Text('RETRY'),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahCard(Surah surah) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.secondaryDark,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.islamicGold.withOpacity(0.1),
            border: Border.all(color: AppColors.islamicGold, width: 1),
          ),
          child: Center(
            child: Text(
              '${surah.number}',
              style: const TextStyle(
                color: AppColors.islamicGold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                surah.englishName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              surah.name,
              style: GoogleFonts.amiri(
                fontSize: 18,
                color: AppColors.islamicGold,
              ),
            ),
          ],
        ),
        subtitle: Text(
          '${surah.englishNameTranslation} • ${surah.numberOfAyahs} Ayahs',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SurahDetailScreen(
                surahNumber: surah.number,
                surahName: surah.englishName,
              ),
            ),
          );
        },
      ),
    );
  }
}

class SurahSearchDelegate extends SearchDelegate {
  final List<Surah> surahs;
  
  SurahSearchDelegate(this.surahs);
  
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }
  
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }
  
  @override
  Widget buildResults(BuildContext context) {
    final results = surahs.where((surah) {
      return surah.englishName.toLowerCase().contains(query.toLowerCase()) ||
          surah.name.contains(query) ||
          surah.number.toString() == query;
    }).toList();
    
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final surah = results[index];
        return ListTile(
          title: Text(surah.englishName),
          subtitle: Text('${surah.number} - ${surah.numberOfAyahs} Ayahs'),
          onTap: () {
            close(context, null);
            // Navigate to surah detail
          },
        );
      },
    );
  }
  
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = surahs.where((surah) {
      return surah.englishName.toLowerCase().contains(query.toLowerCase());
    }).toList();
    
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final surah = suggestions[index];
        return ListTile(
          title: Text(surah.englishName),
          subtitle: Text(surah.englishNameTranslation),
        );
      },
    );
  }
}