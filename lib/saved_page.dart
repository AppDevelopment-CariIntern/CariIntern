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
    if (_user == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to see saved internships.')),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8F7FF), Color(0xFFEEEBFF)],
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
                const Text(
                  'Saved',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF311B92),
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
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.deepPurple.withValues(alpha: 0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.bookmark_outline_rounded, size: 64, color: Colors.deepPurple),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'No saved internships yet.',
                                style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
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
    final String name = company['name'].toString();
    final String? imagePath = company['imagePath']?.toString().trim();
    final String? bannerPath = company['bannerPath']?.toString().trim();
    final String nameLower = name.toLowerCase();
    
    // Check if it's one of the target logos
    final bool isTargetLogo = nameLower.contains('bosch') || 
                              nameLower.contains('cimb') || 
                              nameLower.contains('deloitte') || 
                              nameLower.contains('ey') || 
                              nameLower.contains('grab') || 
                              nameLower.contains('kpmg') || 
                              nameLower.contains('maybank') ||
                              nameLower.contains('honeywell');
    
    // Existing logic for Petronas
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withValues(alpha: 0.05),
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
                color: (name == 'Maybank') ? const Color(0xFFFFD100) : const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(14),
              ),
              clipBehavior: Clip.antiAlias,
              child: Builder(
                builder: (context) {
                  if (imagePath == null || imagePath.isEmpty) {
                    return const Center(child: Icon(Icons.business, size: 28, color: Colors.deepPurple));
                  }

                  Widget image = imagePath.startsWith('http')
                      ? Image.network(
                          imagePath,
                          width: 56,
                          height: 56,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.business, size: 28, color: Colors.deepPurple),
                        )
                      : Image.asset(
                          imagePath,
                          width: 56,
                          height: 56,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.business, size: 28, color: Colors.deepPurple),
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
                    scale = 4.5; // Upscaled further
                  } else if (nameLower.contains('honeywell')) {
                    scale = 0.2; // Descaled further
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
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF311B92)),
                  ),
                  Text(
                    company['industry'].toString(),
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_rounded, color: Colors.deepPurple),
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
