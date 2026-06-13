import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'company_details_page.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_user == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Text(
            'Please log in to see saved internships.',
            style: TextStyle(color: isDark ? Colors.white70 : Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

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
                  'Saved',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF311B92),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(_user.uid)
                        .collection('saved')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.primary.withAlpha(isDark ? 0 : 25),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Icon(Icons.bookmark_outline_rounded, size: 64, color: theme.colorScheme.primary),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'No saved internships yet.',
                                style: TextStyle(
                                  fontSize: 18, 
                                  color: isDark ? Colors.white70 : Colors.grey, 
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final savedDocs = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: savedDocs.length,
                        itemBuilder: (context, index) {
                          final data = savedDocs[index].data() as Map<String, dynamic>;
                          return _buildSavedItem(data);
                        },
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

  Widget _buildSavedItem(Map<String, dynamic> company) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final String name = company['name'].toString();
    final String? imagePath = company['imagePath']?.toString().trim();
    final String? bannerPath = company['bannerPath']?.toString().trim();
    final String nameLower = name.toLowerCase();
    
    final bool isTargetLogo = nameLower.contains('bosch') || 
                              nameLower.contains('cimb') || 
                              nameLower.contains('deloitte') || 
                              nameLower.contains('ey') || 
                              nameLower.contains('grab') || 
                              nameLower.contains('kpmg') || 
                              nameLower.contains('maybank') ||
                              nameLower.contains('honeywell');
    
    final bool isPetronas = nameLower.contains('petronas');

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
              location: company['location']?.toString(),
              positions: List<String>.from(company['positions'] ?? ['Intern']),
              description: company['description']?.toString(),
              allowance: company['allowance']?.toString(),
              bannerPath: bannerPath,
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
              padding: EdgeInsets.all(isTargetLogo || isPetronas ? 0 : 4),
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
                    scale = 1.2;
                  } else if (nameLower.contains('grab')) {
                    scale = 1.4;
                  } else if (nameLower.contains('deloitte') || nameLower.contains('ey')) {
                    scale = 1.3;
                  } else if (nameLower.contains('kpmg')) {
                    scale = 1.4; 
                  } else if (nameLower.contains('maybank')) {
                    scale = 2.0;
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
            IconButton(
              icon: Icon(Icons.bookmark_rounded, color: theme.colorScheme.primary),
              onPressed: () {
                _unsaveCompany(name);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _unsaveCompany(String companyName) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .collection('saved')
        .doc(companyName)
        .delete();
  }
}
