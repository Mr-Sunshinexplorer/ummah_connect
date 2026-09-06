import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/surah.dart';
import '../../services/quran_api_service.dart';
import '../../theme/colors.dart';

class SurahDetailScreen extends StatefulWidget {
  final int surahNumber;
  final String surahName;
  
  const SurahDetailScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
  });

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final QuranApiService _apiService = QuranApiService();
  SurahDetail? _arabicSurah;
  SurahDetail? _translatedSurah;
  bool _isLoading = true;
  bool _showTranslation = true;
  String _selectedTranslation = 'en.asad';

  final Map<String, String> _translations = {
    'en.asad': 'English',
    'ur.jalandhry': 'Urdu',
  };

  @override
  void initState() {
    super.initState();
    _loadSurah();
  }

  Future<void> _loadSurah() async {
    setState(() => _isLoading = true);
    try {
      final arabicSurah = await _apiService.getArabicSurah(widget.surahNumber);
      final translatedSurah = await _apiService.getSurahWithTranslation(
        surahNumber: widget.surahNumber,
        edition: _selectedTranslation,
      );
      
      setState(() {
        _arabicSurah = arabicSurah;
        _translatedSurah = translatedSurah;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surahName),
        actions: [
          // Translation selector
          PopupMenuButton<String>(
            icon: const Icon(Icons.translate, color: Colors.white),
            onSelected: (value) {
              setState(() {
                _selectedTranslation = value;
              });
              _loadSurah();
            },
            itemBuilder: (context) => _translations.entries.map((entry) {
              return PopupMenuItem(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
          ),
          // Show/hide translation
          IconButton(
            icon: Icon(
              _showTranslation ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _showTranslation = !_showTranslation;
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.islamicGold),
            )
          : _buildSurahContent(),
    );
  }

  Widget _buildSurahContent() {
    if (_arabicSurah == null) {
      return const Center(child: Text('No data'));
    }

    return Column(
      children: [
        // Surah header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.islamicGold.withOpacity(0.2),
                AppColors.secondaryDark,
              ],
            ),
          ),
          child: Column(
            children: [
              Text(
                _arabicSurah!.name,
                style: GoogleFonts.amiri(
                  fontSize: 28,
                  color: AppColors.islamicGold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${_arabicSurah!.englishName} • ${_arabicSurah!.englishNameTranslation}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${_arabicSurah!.revelationType} • ${_arabicSurah!.ayahs.length} Ayahs',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        
        // Ayahs list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: _arabicSurah!.ayahs.length,
            itemBuilder: (context, index) {
              final arabicAyah = _arabicSurah!.ayahs[index];
              final translatedAyah = _translatedSurah?.ayahs[index];
              
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.secondaryDark,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ayah number
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.islamicGold,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${arabicAyah.numberInSurah}',
                          style: const TextStyle(
                            color: AppColors.islamicGold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Arabic text
                    Text(
                      arabicAyah.text,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.amiri(
                        fontSize: 24,
                        color: Colors.white,
                        height: 2,
                      ),
                    ),
                    
                    // Translation
                    if (_showTranslation && translatedAyah != null) ...[
                      const SizedBox(height: 15),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 15),
                      Text(
                        translatedAyah.text,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          height: 1.6,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}