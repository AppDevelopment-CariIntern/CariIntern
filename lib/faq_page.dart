import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _faqData = [
    {
      'category': 'Application',
      'icon': Icons.assignment_outlined,
      'color': Colors.deepPurple,
      'items': [
        {
          'question': 'How do I apply for an internship?',
          'answer': 'Search for a company, open the company profile, and tap the "Apply Now" button.',
          'isInitiallyExpanded': true,
        },
        {
          'question': 'Can I apply to multiple companies?',
          'answer': 'Yes, you can apply to as many companies as you like. There is no limit to the number of applications you can submit.'
        },
        {
          'question': 'How can I check my application status?',
          'answer': 'Go to the "Status" tab in the bottom navigation bar to see all your active and past applications.'
        },
      ]
    },
    {
      'category': 'Company Information',
      'icon': Icons.business_outlined,
      'color': Colors.deepPurple,
      'items': [
        {
          'question': 'How do I save a company?',
          'answer': 'Tap the bookmark icon on the company details page to save it to your bookmarks.'
        },
        {
          'question': 'Why can\'t I find a company?',
          'answer': 'We are constantly adding new companies. If you can\'t find a specific one, it might not be registered in our database yet.'
        },
        {
          'question': 'How often is company information updated?',
          'answer': 'Company information is updated regularly. Use the "Force Overwrite" button in your profile to refresh local data.'
        },
      ]
    },
    {
      'category': 'Account & Profile',
      'icon': Icons.person_outline_rounded,
      'color': Colors.deepPurple,
      'items': [
        {
          'question': 'How do I edit my profile?',
          'answer': 'Go to your Profile tab and tap on "Edit Profile" to update your information.'
        },
        {
          'question': 'I forgot my password. What should I do?',
          'answer': 'On the login screen, tap "Forgot Password" to receive a password reset link via email.'
        },
        {
          'question': 'Can I change my email address?',
          'answer': 'Email addresses are currently fixed to your account. Please contact support for assistance with changes.'
        },
      ]
    },
    {
      'category': 'Technical Issues',
      'icon': Icons.error_outline_rounded,
      'color': Colors.redAccent,
      'items': [
        {
          'question': 'The application status is not updating.',
          'answer': 'Try refreshing the page. If the issue persists, ensure your internet connection is stable.'
        },
        {
          'question': 'The app is loading slowly.',
          'answer': 'This may occur on slower connections. Try clearing the app cache or restarting.'
        },
        {
          'question': 'I found incorrect company information.',
          'answer': 'Please report the inaccuracy through the "Report a Problem" section in Customer Service.'
        },
      ]
    },
  ];

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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : const Color(0xFF311B92)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'FAQ',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF311B92), 
              fontWeight: FontWeight.bold
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withAlpha(25),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.help_center_rounded, size: 40, color: theme.colorScheme.primary),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Frequently Asked Questions',
                                style: TextStyle(
                                  fontSize: 20, 
                                  fontWeight: FontWeight.bold, 
                                  color: isDark ? Colors.white : const Color(0xFF311B92)
                                ),
                              ),
                              Text(
                                'Find answers to common questions about CariIntern.',
                                style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDark ? 0 : 8), 
                            blurRadius: 10, 
                            offset: const Offset(0, 4)
                          )
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        decoration: InputDecoration(
                          hintText: 'Search questions...',
                          hintStyle: TextStyle(color: theme.colorScheme.onSurface.withAlpha(120)),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ..._faqData.map((section) => _buildFAQSection(section)),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection(Map<String, dynamic> section) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredItems = (section['items'] as List).where((item) {
      return item['question'].toString().toLowerCase().contains(_searchQuery) ||
             item['answer'].toString().toLowerCase().contains(_searchQuery);
    }).toList();

    if (filteredItems.isEmpty && _searchQuery.isNotEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (section['color'] as Color).withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(section['icon'], size: 20, color: section['color']),
            ),
            const SizedBox(width: 12),
            Text(
              section['category'],
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold, 
                color: isDark ? Colors.white : const Color(0xFF311B92)
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 0 : 5), 
                blurRadius: 8, 
                offset: const Offset(0, 2)
              )
            ],
          ),
          child: Column(
            children: filteredItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == filteredItems.length - 1;

              return Column(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                      unselectedWidgetColor: isDark ? Colors.white70 : Colors.black54,
                    ),
                    child: ExpansionTile(
                      initiallyExpanded: item['isInitiallyExpanded'] ?? false,
                      iconColor: theme.colorScheme.primary,
                      collapsedIconColor: isDark ? Colors.white70 : Colors.black54,
                      title: Text(
                        item['question'],
                        style: TextStyle(
                          fontSize: 14, 
                          fontWeight: FontWeight.w600, 
                          color: isDark ? Colors.white : Colors.black87
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[850] : const Color(0xFFF5F7FA),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item['answer'],
                              style: TextStyle(
                                fontSize: 13, 
                                color: isDark ? Colors.white70 : Colors.black54, 
                                height: 1.5
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast) Divider(height: 1, color: Colors.grey.withAlpha(25), indent: 16, endIndent: 16),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
