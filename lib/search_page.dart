import 'package:flutter/material.dart';
import 'company_details_page.dart';
import 'company_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _searchQuery = '';

  void _runFilter(String enteredKeyword) {
    setState(() {
      _searchQuery = enteredKeyword.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark 
            ? [const Color(0xFF121212), const Color(0xFF1E1E1E)]
            : [const Color(0xFFF8F7FF), const Color(0xFFEEEBFF)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF311B92),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withAlpha(isDark ? 0 : 13),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => _runFilter(value),
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      hintText: 'Search companies or industries...',
                      hintStyle: TextStyle(color: theme.colorScheme.onSurface.withAlpha(120)),
                      prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: theme.colorScheme.primary),
                              onPressed: () {
                                _searchController.clear();
                                _runFilter('');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _filterChip('All'),
                      const SizedBox(width: 8),
                      _filterChip('Technology'),
                      const SizedBox(width: 8),
                      _filterChip('Telecommunications'),
                      const SizedBox(width: 8),
                      _filterChip('Banking'),
                      const SizedBox(width: 8),
                      _filterChip('Engineering'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: CompanyService().getCompanies(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final allCompanies = snapshot.data ?? [];
                      
                      final filteredCompanies = allCompanies.where((company) {
                        final name = (company['name'] ?? '').toString().toLowerCase();
                        final industry = (company['industry'] ?? '').toString().toLowerCase();
                        
                        final matchesKeyword = name.contains(_searchQuery) || industry.contains(_searchQuery);
                        
                        bool matchesFilter = _selectedFilter == 'All';
                        if (!matchesFilter) {
                          if (_selectedFilter == 'Technology') {
                            matchesFilter = industry.contains('technology') || industry.contains('software');
                          } else if (_selectedFilter == 'Banking') {
                            matchesFilter = industry.contains('banking') || industry.contains('finance');
                          } else {
                            matchesFilter = industry.contains(_selectedFilter.toLowerCase());
                          }
                        }
                        
                        return matchesKeyword && matchesFilter;
                      }).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${filteredCompanies.length} results found',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: filteredCompanies.isNotEmpty
                                ? ListView.builder(
                                    itemCount: filteredCompanies.length,
                                    itemBuilder: (context, index) => _buildSearchResultItem(filteredCompanies[index]),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.search_off, size: 64, color: theme.colorScheme.primary),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'No results found',
                                          style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _filterChip(String label) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    bool isSelected = _selectedFilter == label;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : (isDark ? const Color(0xFF2C2C2C) : Colors.white),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: isSelected ? theme.colorScheme.primary.withAlpha(51) : Colors.black.withAlpha(isDark ? 0 : 13),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text( label,
          style: TextStyle(
            color: isSelected ? Colors.white : theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResultItem(Map<String, dynamic> company) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final String name = company['name'].toString();
    final String? imagePath = company['imagePath']?.toString().trim();
    final String? bannerPath = company['bannerPath']?.toString().trim();
    final String nameLower = name.toLowerCase();
    
    final bool isSpecialLogo = nameLower.contains('petronas') || 
                               nameLower.contains('bosch') || 
                               nameLower.contains('cimb') || 
                               nameLower.contains('grab') || 
                               nameLower.contains('deloitte') || 
                               nameLower.contains('ey') ||
                               nameLower.contains('kpmg') ||
                               nameLower.contains('maybank') ||
                               nameLower.contains('honeywell');
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompanyDetailsPage(
              name: name,
              industry: company['industry'].toString(),
              rating: company['rating'].toString(),
              imagePath: imagePath,
              bannerPath: bannerPath,
              location: company['location']?.toString(),
              positions: List<String>.from(company['positions'] ?? ['Intern']),
              description: company['description']?.toString(),
              allowance: company['allowance']?.toString(),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 0 : 13),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 56,
              width: 56, 
              padding: EdgeInsets.all(isSpecialLogo ? 0 : 4), 
              decoration: BoxDecoration(
                color: (name == 'Maybank') ? const Color(0xFFFFD100) : (isDark ? Colors.grey[800] : const Color(0xFFF5F7FA)),
                borderRadius: BorderRadius.circular(14),
              ),
              clipBehavior: Clip.antiAlias,
              child: Builder(
                builder: (context) {
                  if (imagePath == null || imagePath.isEmpty) {
                    return Center(child: Icon(Icons.business, size: 28, color: theme.colorScheme.primary));
                  }

                  Widget image = imagePath.startsWith('http')
                      ? Image.network(
                          imagePath,
                          width: 56,
                          height: 56,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Center(child: Icon(Icons.business, size: 28, color: theme.colorScheme.primary)),
                        )
                      : Image.asset(
                          imagePath,
                          width: 56,
                          height: 56,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Center(child: Icon(Icons.business, size: 28, color: theme.colorScheme.primary)),
                        );

                  double scale = 1.0;
                  if (nameLower.contains('bosch')) {
                    scale = 1.5;
                  } else if (nameLower.contains('cimb')) {
                    scale = 1.4;
                  } else if (nameLower.contains('grab')) {
                    scale = 1.4;
                  } else if (nameLower.contains('deloitte')) {
                    scale = 1.1;
                  } else if (nameLower.contains('ey')) {
                    scale = 1.3;
                  } else if (nameLower.contains('kpmg')) {
                    scale = 1.4;
                  } else if (nameLower.contains('maybank')) {
                    scale = 1.8;
                  } else if (nameLower.contains('honeywell')) {
                    scale = 0.05;
                  }
                  
                  return scale != 1.0 ? Transform.scale(scale: scale, child: image) : image;
                }
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 17, 
                      color: isDark ? Colors.white : const Color(0xFF311B92)
                    ),
                  ),
                  Text(
                    company['industry'].toString(),
                    style: TextStyle(color: isDark ? Colors.white60 : Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? theme.colorScheme.primary.withAlpha(51) : const Color(0xFFF3E5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                  Text(
                    ' ${company['rating']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: isDark ? Colors.white : Colors.deepPurple
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
