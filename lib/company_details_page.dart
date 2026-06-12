import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'apply_now_page.dart';
import 'login.dart';

class CompanyDetailsPage extends StatefulWidget {
  final String name;
  final String industry;
  final String rating;
  final String? imagePath;
  final String? location;
  final List<String> positions;
  final String? description;
  final String? allowance;
  final String? bannerPath;

  const CompanyDetailsPage({
    super.key,
    required this.name,
    required this.industry,
    required this.rating,
    this.imagePath,
    this.location,
    required this.positions,
    this.description,
    this.allowance,
    this.bannerPath,
  });

  @override
  State<CompanyDetailsPage> createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  late String _selectedPosition;
  bool _isSaved = false;
  final User? _user = FirebaseAuth.instance.currentUser;
  final TextEditingController _reviewController = TextEditingController();
  double _userRating = 5.0;

  @override
  void initState() {
    super.initState();
    _selectedPosition = widget.positions.isNotEmpty ? widget.positions.first : 'Intern';
    _checkIfSaved();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _checkIfSaved() async {
    if (_user == null) return;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .collection('saved')
          .doc(widget.name)
          .get();
      
      if (mounted) {
        setState(() {
          _isSaved = doc.exists;
        });
      }
    } catch (e) {
      debugPrint('Error checking saved status: $e');
    }
  }

  void _toggleSave() async {
    if (_user == null) {
      _showLoginPrompt('Please log in to save internships.');
      return;
    }

    final savedRef = FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .collection('saved')
        .doc(widget.name);

    try {
      if (_isSaved) {
        await savedRef.delete();
      } else {
        await savedRef.set({
          'name': widget.name,
          'industry': widget.industry,
          'rating': widget.rating,
          'imagePath': widget.imagePath,
          'location': widget.location,
          'positions': widget.positions,
          'description': widget.description,
          'allowance': widget.allowance,
          'bannerPath': widget.bannerPath,
          'savedAt': FieldValue.serverTimestamp(),
        });
      }

      if (mounted) {
        setState(() {
          _isSaved = !_isSaved;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isSaved ? 'Saved to bookmarks' : 'Removed from bookmarks'),
            backgroundColor: Colors.deepPurple,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e')),
        );
      }
    }
  }

  void _showLoginPrompt(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            child: const Text('Login', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _submitReview() async {
    if (_user == null) {
      _showLoginPrompt('Please log in to submit a review.');
      return;
    }

    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a comment.')),
      );
      return;
    }

    try {
      final companyRef = FirebaseFirestore.instance.collection('companies').doc(widget.name);
      final newReview = {
        'user': _user.displayName ?? _user.email?.split('@')[0] ?? 'Anonymous',
        'rating': _userRating,
        'comment': _reviewController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'isVerified': true, 
      };

      await companyRef.update({
        'reviews': FieldValue.arrayUnion([newReview])
      });

      _reviewController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting review: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildLogo() {
    final String? path = widget.imagePath?.trim();
    if (path == null || path.isEmpty) {
      return const Icon(Icons.business, size: 80, color: Colors.white38);
    }

    final String nameLower = widget.name.toLowerCase();
    final bool isPetronas = nameLower.contains('petronas');
    final bool isTargetLogo = nameLower.contains('bosch') || 
                              nameLower.contains('cimb') || 
                              nameLower.contains('deloitte') || 
                              nameLower.contains('ey') || 
                              nameLower.contains('grab') || 
                              nameLower.contains('kpmg') ||
                              nameLower.contains('maybank') ||
                              nameLower.contains('honeywell');

    return Padding(
      padding: EdgeInsets.all((isPetronas || isTargetLogo) ? 0.0 : 20.0),
      child: Builder(
        builder: (context) {
          Widget image = path.startsWith('http')
              ? Image.network(
                  path,
                  height: (isPetronas || isTargetLogo) ? 160 : 120,
                  width: (isPetronas || isTargetLogo) ? 300 : 120,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.business, size: 80, color: Colors.white38),
                )
              : Image.asset(
                  path,
                  height: (isPetronas || isTargetLogo) ? 160 : 120,
                  width: (isPetronas || isTargetLogo) ? 300 : 120,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.business, size: 80, color: Colors.white38),
                );
          
          double scale = 1.0;
          if (nameLower.contains('bosch')) scale = 1.5;
          else if (nameLower.contains('cimb')) scale = 1.2;
          else if (nameLower.contains('grab')) scale = 1.4;
          else if (nameLower.contains('deloitte') || nameLower.contains('ey')) scale = 1.3;
          else if (nameLower.contains('kpmg')) scale = 1.4; 
          else if (nameLower.contains('maybank')) scale = 4.5; // Upscaled further
          else if (nameLower.contains('honeywell')) scale = 0.2; // Descaled further

          return scale != 1.0 ? Transform.scale(scale: scale, child: image) : image;
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: Colors.deepPurple,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                ),
                onPressed: _toggleSave,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: widget.bannerPath != null && widget.bannerPath!.isNotEmpty
                  ? Image.asset(
                      widget.bannerPath!,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.deepPurple, Color(0xFF7C4DFF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(child: _buildLogo()),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8F7FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.name,
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF311B92)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.industry,
                                style: const TextStyle(fontSize: 16, color: Colors.deepPurple, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF9C4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                              const SizedBox(width: 4),
                              Text(widget.rating, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFF57F17))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text('Available Positions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF311B92))),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: widget.positions.map((pos) {
                        final isSelected = _selectedPosition == pos;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedPosition = pos),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.deepPurple : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: isSelected ? Colors.deepPurple : Colors.transparent),
                              boxShadow: [if (!isSelected) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
                            ),
                            child: Text(pos, style: TextStyle(color: isSelected ? Colors.white : Colors.deepPurple, fontWeight: FontWeight.w600)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                    _sectionCard('About Company', widget.description ?? 'A leading company in the industry.'),
                    const SizedBox(height: 32),
                    const Text('Internship Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF311B92))),
                    const SizedBox(height: 16),
                    _buildDetailItem(Icons.work_outline_rounded, 'Position', _selectedPosition),
                    _buildDetailItem(Icons.location_on_outlined, 'Location', widget.location ?? 'Kuala Lumpur, Malaysia'),
                    _buildDetailItem(Icons.payments_outlined, 'Allowance', widget.allowance ?? 'RM1,000 - RM1,500'),
                    _buildDetailItem(Icons.calendar_today_outlined, 'Duration', '3 - 6 Months'),
                    
                    const SizedBox(height: 40),
                    SliverToBoxAdapter(child: const SizedBox.shrink()), // placeholder
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_user == null) {
                            _showLoginPrompt('Please log in to apply for this internship.');
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApplyNowPage(companyName: widget.name, position: _selectedPosition),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        child: const Text('Apply Now', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),

                    const SizedBox(height: 40),
                    const Text('User Reviews', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF311B92))),
                    const SizedBox(height: 16),
                    
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance.collection('companies').doc(widget.name).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) return const CircularProgressIndicator();
                        if (!snapshot.hasData || !snapshot.data!.exists) return const Text('No reviews yet.');
                        
                        final data = snapshot.data!.data() as Map<String, dynamic>;
                        final reviews = (data['reviews'] as List?)?.reversed.toList() ?? [];
                        
                        if (reviews.isEmpty) return const Text('No reviews yet. Be the first to share your experience!');

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            final review = reviews[index] as Map<String, dynamic>;
                            return _buildReviewItem(
                              review['user'], 
                              review['rating'].toDouble(), 
                              review['comment'],
                              isVerified: review['isVerified'] ?? false,
                              isSample: review['isSample'] ?? false,
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                    const Text('Write a Review', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF311B92))),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('Rating: ', style: TextStyle(fontWeight: FontWeight.w600)),
                              ...List.generate(5, (index) => GestureDetector(
                                onTap: () => setState(() => _userRating = index + 1.0),
                                child: Icon(
                                  Icons.star_rounded,
                                  color: index < _userRating ? Colors.amber : Colors.grey[300],
                                  size: 28,
                                ),
                              )),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _reviewController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Share your internship experience...',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                              filled: true,
                              fillColor: const Color(0xFFF5F7FA),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submitReview,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Submit Review'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF311B92))),
          const SizedBox(height: 12),
          Text(content, style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.6), textAlign: TextAlign.justify),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String user, double rating, String comment, {bool isVerified = false, bool isSample = false}) {
    Color badgeColor = Colors.grey;
    String badgeText = "Unverified";
    IconData badgeIcon = Icons.info_outline;

    if (isVerified) {
      badgeColor = Colors.blue;
      badgeText = "Verified";
      badgeIcon = Icons.verified;
    } else if (isSample) {
      badgeColor = Colors.orange;
      badgeText = "Sample";
      badgeIcon = Icons.science_outlined;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(user, 
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF311B92)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(badgeIcon, size: 12, color: badgeColor),
                          const SizedBox(width: 2),
                          Text(badgeText, style: TextStyle(fontSize: 10, color: badgeColor, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                  Text(' $rating', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFF3E5F5), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.deepPurple, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF311B92))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
