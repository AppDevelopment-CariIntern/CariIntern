import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'company_details_page.dart';
import 'search_page.dart';
import 'company_service.dart';
import 'saved_page.dart';
import 'applications_page.dart';
import 'customer_service_page.dart';
import 'edit_profile_page.dart';
import 'settings_page.dart';

class Dashboard2 extends StatefulWidget {
  final String username;
  const Dashboard2({super.key, required this.username});

  @override
  State<Dashboard2> createState() => _Dashboard2State();
}

class _Dashboard2State extends State<Dashboard2> {
  int _selectedIndex = 2; // Default to Home in the middle
  late User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _handleLogout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Notifications',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Sample Data',
                          style: TextStyle(fontSize: 10, color: Colors.deepPurple, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _notificationItem('Application Received', 'Your application to Microsoft has been received.', '2 mins ago'),
                    _notificationItem('New Internship', 'New Software Engineer intern position at Tesla.', '1 hour ago'),
                    _notificationItem('Review Approved', 'Your review for Maybank has been published.', 'Yesterday'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _notificationItem(String title, String subtitle, String time) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.deepPurple.withAlpha(25),
        child: const Icon(Icons.notifications_outlined, color: Colors.deepPurple, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 13)),
      trailing: Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget currentBody;
    if (_selectedIndex == 0) {
      currentBody = const ApplicationsPage();
    } else if (_selectedIndex == 1) {
      currentBody = const SearchPage();
    } else if (_selectedIndex == 2) {
      currentBody = _buildHomeView();
    } else if (_selectedIndex == 3) {
      currentBody = const SavedPage();
    } else if (_selectedIndex == 4) {
      currentBody = _buildProfileView();
    } else {
      currentBody = _buildHomeView();
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
        appBar: _selectedIndex != 2 ? null : AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          title: Text.rich(
            TextSpan(
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              children: [
                const TextSpan(text: 'Cari', style: TextStyle(color: Colors.black)),
                const TextSpan(text: 'Intern', style: TextStyle(color: Colors.deepPurple)),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined, color: Colors.deepPurple),
              onPressed: _showNotifications,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = 4;
                  });
                },
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').doc(_user?.uid).snapshots(),
                  builder: (context, snapshot) {
                    String? photoUrl;
                    if (snapshot.hasData && snapshot.data!.exists) {
                      photoUrl = (snapshot.data!.data() as Map<String, dynamic>)['photoUrl'];
                    }
                    return CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFFEDE7F6),
                      backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                      child: photoUrl == null ? const Icon(Icons.person_outline, color: Colors.deepPurple) : null,
                    );
                  }
                ),
              ),
            ),
          ],
        ),
        body: currentBody,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.deepPurple.withAlpha(102),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: (index) {
            setState(() => _selectedIndex = index);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Status'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
              icon: CircleAvatar(
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.home_filled, color: Colors.white),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: 'Saved'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'Hi, ${widget.username} 👋',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF311B92)),
          ),
          const Text(
            'Find the right place to grow your career.',
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
          const SizedBox(height: 24),
          
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withAlpha(13),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Search company, position or keyword...',
                prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.deepPurple, Color(0xFF7C4DFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withAlpha(76),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Share your experience,\nhelp other students.',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, height: 1.3),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.deepPurple,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Write a Review', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.auto_awesome, size: 60, color: Colors.white30),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Top-Rated Companies', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF311B92))),
              TextButton(
                onPressed: () {
                  setState(() => _selectedIndex = 1);
                }, 
                child: const Text('See All', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold))
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: CompanyService().getCompanies(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final companies = snapshot.data ?? [];
                companies.sort((a, b) => b['rating'].toString().compareTo(a['rating'].toString()));
                
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: companies.length > 5 ? 5 : companies.length,
                  itemBuilder: (context, index) {
                    final company = companies[index];
                    return _buildCompanyCard(company);
                  },
                );
              }
            ),
          ),
          const SizedBox(height: 32),
          
          const Text('Recent Reviews', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF311B92))),
          const SizedBox(height: 16),
          _buildReviewCard('Microsoft Malaysia', 'Software Dev Intern', 'Aug 2026 - Jan 2027', 4.8),
          _buildReviewCard('Tesla', 'AI Engineer Intern', 'Jan 2026 - July 2026', 4.9),
          _buildReviewCard('Shell', 'Sustainability Intern', 'May 2025 - Nov 2025', 4.6),
          _buildReviewCard('Intel Malaysia', 'Hardware Designer Intern', 'Feb 2025 - Aug 2025', 4.7),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return SafeArea(
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(_user?.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          String name = widget.username;
          String email = _user?.email ?? 'No email';
          String phone = 'No phone number';
          String? photoUrl;
          
          if (snapshot.hasData && snapshot.data!.exists) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            name = data['name'] ?? name;
            email = data['email'] ?? email;
            phone = data['phone'] ?? phone;
            photoUrl = data['photoUrl'];
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.deepPurple, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 50, 
                    backgroundColor: const Color(0xFFEDE7F6), 
                    backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                    child: photoUrl == null ? const Icon(Icons.person, size: 60, color: Colors.deepPurple) : null,
                  ),
                ),
                const SizedBox(height: 16),
                Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF311B92))),
                Text(email, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(phone, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 40),
                _profileItem(Icons.edit_outlined, 'Edit Profile', onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                        currentName: name,
                        currentPhone: phone,
                        currentPhotoUrl: photoUrl,
                      ),
                    ),
                  );
                  if (result == true) {
                    setState(() {});
                  }
                }),
                _profileItem(Icons.settings_outlined, 'Settings', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                }),
                _profileItem(Icons.headset_mic_outlined, 'Customer Service', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomerServicePage(username: name.split(' ')[0])),
                  );
                }),
                const Spacer(),
                ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _handleLogout();
                            },
                            child: const Text('Logout', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Log Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _profileItem(IconData icon, String title, {String? subtitle, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      ),
    );
  }

  Widget _buildCompanyCard(Map<String, dynamic> company) {
    final String name = company['name']?.toString() ?? 'Unknown';
    final String industry = company['industry']?.toString() ?? 'Technology';
    final String rating = company['rating']?.toString() ?? '0.0';
    final String? imagePath = company['imagePath']?.toString();
    final String? bannerPath = company['bannerPath']?.toString();

    final String nameLower = name.toLowerCase();
    final bool isWideLogo = nameLower.contains('petronas') || 
                           nameLower.contains('bosch') || 
                           nameLower.contains('iprice') || 
                           nameLower.contains('deloitte') || 
                           nameLower.contains('ey') || 
                           nameLower.contains('cimb') ||
                           nameLower.contains('grab') ||
                           nameLower.contains('kpmg') ||
                           nameLower.contains('honeywell');
                           
    final bool needsZoom = nameLower.contains('bosch') || 
                           nameLower.contains('cimb') ||
                           nameLower.contains('deloitte') ||
                           nameLower.contains('ey') ||
                           nameLower.contains('grab') ||
                           nameLower.contains('kpmg') ||
                           nameLower.contains('iprice') ||
                           nameLower.contains('maybank') ||
                           nameLower.contains('honeywell');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompanyDetailsPage(
              name: name,
              industry: industry,
              rating: rating,
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
        width: 160,
        margin: const EdgeInsets.only(right: 16, bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 75,
              width: 75, // Standard square frame
              // Reduce padding for specific logos to upscale the image within the frame
              padding: EdgeInsets.all(isWideLogo ? 0 : 8),
              decoration: BoxDecoration(
                color: (name == 'Maybank') ? const Color(0xFFFFD100) : const Color(0xFFF5F7FA), 
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Builder(
                builder: (context) {
                  Widget image;
                  if (imagePath != null && imagePath.trim().isNotEmpty) {
                    if (imagePath.trim().startsWith('http')) {
                      image = Image.network(
                        imagePath.trim(),
                        width: 75,
                        height: 75,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.business, size: 30, color: Colors.deepPurple)),
                      );
                    } else {
                      image = Image.asset(
                        imagePath.trim(), 
                        width: 75,
                        height: 75,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.business, size: 30, color: Colors.deepPurple)),
                      );
                    }
                  } else {
                    image = const Center(child: Icon(Icons.business, size: 30, color: Colors.deepPurple));
                  }
                  
                  double scale = 1.0;
                  if (nameLower.contains('bosch')) {
                    scale = 1.5; 
                  } else if (nameLower.contains('cimb')) {
                    scale = 3.2; 
                  } else if (nameLower.contains('grab')) {
                    scale = 1.4;
                  } else if (nameLower.contains('deloitte')) {
                    scale = 0.5; 
                  } else if (nameLower.contains('ey')) {
                    scale = 1.3;
                  } else if (nameLower.contains('kpmg')) {
                    scale = 1.4; 
                  } else if (nameLower.contains('iprice')) {
                    scale = 3.2; 
                  } else if (nameLower.contains('maybank')) {
                    scale = 2.0; // Descaled from 3.5 to 2.0
                  } else if (nameLower.contains('honeywell')) {
                    scale = 0.04; // Descaled from 0.05 to 0.04
                  } else if (needsZoom) {
                    scale = 1.1;
                  }
                  
                  return scale != 1.0 ? Transform.scale(scale: scale, child: image) : image;
                }
              ),
            ),
            const Spacer(),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(industry, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                Text(' $rating', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(String companyName, String position, String duration, double rating) {
    final String nameLower = companyName.toLowerCase();
    final bool isReducedPadding = nameLower.contains('bosch') || 
                                 nameLower.contains('iprice') || 
                                 nameLower.contains('petronas') || 
                                 nameLower.contains('deloitte') || 
                                 nameLower.contains('ey') || 
                                 nameLower.contains('cimb') ||
                                 nameLower.contains('grab') ||
                                 nameLower.contains('kpmg') ||
                                 nameLower.contains('honeywell');
    
    return GestureDetector(
      onTap: () async {
        // We attempt to find the company data in our local list first
        final localData = CompanyService().companiesData.firstWhere(
          (c) => c['name'] == companyName || companyName.contains(c['name'].toString()),
          orElse: () => <String, dynamic>{},
        );

        // If it's empty, we fetch from Firestore but specifically for details
        Map<String, dynamic> data = localData;
        if (data.isEmpty) {
          final doc = await FirebaseFirestore.instance.collection('companies').doc(companyName).get();
          if (doc.exists) data = doc.data()!;
        }

        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompanyDetailsPage(
              name: data['name'] ?? companyName,
              industry: data['industry'] ?? 'Technology',
              rating: data['rating']?.toString() ?? rating.toString(),
              allowance: data['allowance']?.toString(),
              location: data['location']?.toString(),
              positions: List<String>.from(data['positions'] ?? [position]),
              description: data['description']?.toString(),
              imagePath: data['imagePath']?.toString(),
              bannerPath: data['bannerPath']?.toString(),
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
              color: Colors.deepPurple.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 52,
              width: 52, // Standard square frame
              // Reduce padding for specific logos to upscale image
              padding: EdgeInsets.all(isReducedPadding ? 0 : 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(14),
              ),
              clipBehavior: Clip.antiAlias,
              child: _buildReviewLogo(companyName),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(companyName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(position, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                  Text(duration, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                  Text(' $rating', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewLogo(String companyName) {
    final company = CompanyService().companiesData.firstWhere(
      (c) {
        final name = c['name']?.toString() ?? '';
        return name == companyName || companyName.contains(name);
      },
      orElse: () => {},
    );

    final String? path = company['imagePath']?.toString().trim();
    final String nameLower = companyName.toLowerCase();
    final bool needsZoom = nameLower.contains('bosch') || 
                           nameLower.contains('cimb') ||
                           nameLower.contains('deloitte') ||
                           nameLower.contains('ey') ||
                           nameLower.contains('grab') ||
                           nameLower.contains('kpmg') ||
                           nameLower.contains('iprice') ||
                           nameLower.contains('maybank') ||
                           nameLower.contains('honeywell');

    if (path == null || path.isEmpty) {
      return const Center(child: Icon(Icons.business, color: Colors.deepPurple, size: 24));
    }

    Widget image;
    if (path.startsWith('http')) {
      image = Image.network(
        path,
        width: 52,
        height: 52,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.business, color: Colors.deepPurple, size: 24)),
      );
    } else {
      image = Image.asset(
        path,
        width: 52,
        height: 52,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.business, color: Colors.deepPurple, size: 24)),
      );
    }

    double scale = 1.0;
    if (nameLower.contains('bosch')) {
      scale = 1.5;
    } else if (nameLower.contains('cimb')) {
      scale = 3.2; 
    } else if (nameLower.contains('grab')) {
      scale = 1.4;
    } else if (nameLower.contains('deloitte')) {
      scale = 0.5; 
    } else if (nameLower.contains('ey')) {
      scale = 1.3;
    } else if (nameLower.contains('kpmg')) {
      scale = 1.4; 
    } else if (nameLower.contains('iprice')) {
      scale = 2.5; 
    } else if (nameLower.contains('maybank')) {
      scale = 2.0; // Descaled from 3.5 to 2.0
    } else if (nameLower.contains('honeywell')) {
      scale = 0.04; // Descaled from 0.05 to 0.04
    } else if (needsZoom) {
      scale = 1.1;
    }
    
    return scale != 1.0 ? Transform.scale(scale: scale, child: image) : image;
  }
}
