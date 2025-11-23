import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/common/empty_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = [
    'Paracetamol',
    'Vitamin C',
    'Obat batuk',
    'Masker',
  ];
  final List<String> _popularSearches = [
    'Paracetamol',
    'Amoxicillin',
    'Vitamin D',
    'Antasida',
    'Obat flu',
  ];
  bool _isSearching = false;
  List<String> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
      // Simulate search results
      _searchResults = List.generate(
        5,
        (index) => 'Hasil: $query ${index + 1}',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Cari produk, obat, vitamin...',
            border: InputBorder.none,
          ),
          onChanged: _performSearch,
          onSubmitted: _performSearch,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _performSearch('');
              },
            ),
        ],
      ),
      body: _isSearching ? _buildSearchResults() : _buildSearchSuggestions(),
    );
  }

  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pencarian Terakhir',
                  style: AppTextStyles.heading4,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _recentSearches.clear();
                    });
                  },
                  child: const Text('Hapus Semua'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...List.generate(
              _recentSearches.length,
              (index) => ListTile(
                leading: const Icon(Icons.history),
                title: Text(_recentSearches[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _recentSearches.removeAt(index);
                    });
                  },
                ),
                onTap: () {
                  _searchController.text = _recentSearches[index];
                  _performSearch(_recentSearches[index]);
                },
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Popular searches
          const Text(
            'Pencarian Populer',
            style: AppTextStyles.heading4,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _popularSearches
                .map(
                  (search) => ActionChip(
                    avatar: const Icon(Icons.trending_up, size: 18),
                    label: Text(search),
                    onPressed: () {
                      _searchController.text = search;
                      _performSearch(search);
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return EmptyState(
        message: 'Produk tidak ditemukan',
        description: 'Coba kata kunci lain',
        icon: Icons.search_off,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.medical_services,
                color: AppColors.textSecondary,
              ),
            ),
            title: Text(_searchResults[index]),
            subtitle: Text(
              'Rp ${(index + 1) * 25000}',
              style: AppTextStyles.priceSmall,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push('/products/$index');
            },
          ),
        );
      },
    );
  }
}
