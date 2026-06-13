import 'package:flutter/material.dart';
import 'faq_page.dart';
import 'report_problem_page.dart';
import 'send_feedback_page.dart';
import 'contact_support_page.dart';

class CustomerServicePage extends StatelessWidget {
  final String username;
  const CustomerServicePage({super.key, required this.username});

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
            'Customer Service',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF311B92),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi $username! 👋',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF311B92),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'How can we help you today?\nWe\'re here to support you.',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white70 : Colors.black54,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.headset_mic_rounded,
                      size: 60,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              _buildServiceCard(
                context,
                Icons.help_outline_rounded,
                'Frequently Asked Questions (FAQ)',
                'Find answers to common questions about CariIntern.',
                isDark ? Colors.indigo.withAlpha(50) : const Color(0xFFE8EAF6),
                Colors.indigo,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FAQPage()),
                  );
                },
              ),
              _buildServiceCard(
                context,
                Icons.warning_amber_rounded,
                'Report a Problem',
                'Report bugs, errors or any issues you encounter.',
                isDark ? Colors.redAccent.withAlpha(50) : const Color(0xFFFCE4EC),
                Colors.redAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReportProblemPage()),
                  );
                },
              ),
              _buildServiceCard(
                context,
                Icons.chat_bubble_outline_rounded,
                'Send Feedback',
                'Share your feedback or suggestions to help us improve.',
                isDark ? Colors.blue.withAlpha(50) : const Color(0xFFE1F5FE),
                Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SendFeedbackPage()),
                  );
                },
              ),
              _buildServiceCard(
                context,
                Icons.mail_outline_rounded,
                'Contact Support',
                'Get in touch with our support team via email.',
                isDark ? Colors.teal.withAlpha(50) : const Color(0xFFE8F5E9),
                Colors.teal,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactSupportPage(username: username)),
                  );
                },
              ),
              
              const SizedBox(height: 24),
              
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(isDark ? 0 : 8),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact Information',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDark ? Colors.white : const Color(0xFF311B92),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildContactRow(context, Icons.email_outlined, 'support@cariintern.com'),
                          const SizedBox(height: 8),
                          _buildContactRow(context, Icons.phone_outlined, '03-1234 5678'),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 1,
                      color: Colors.grey.withAlpha(50),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 18, color: theme.colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                'Operating Hours',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: isDark ? Colors.white : const Color(0xFF311B92),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Monday - Friday\n9:00 AM - 6:00 PM',
                            style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark 
                      ? [const Color(0xFF311B92).withAlpha(100), const Color(0xFF311B92).withAlpha(50)]
                      : [const Color(0xFFEDE7F6), const Color(0xFFF3E5F5)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'We\'re here for you!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: isDark ? Colors.white : const Color(0xFF311B92),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your satisfaction is our priority. Let us know how we can assist you.',
                            style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.support_agent_rounded, size: 50, color: theme.colorScheme.primary),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, IconData icon, String title, String subtitle, Color bgColor, Color iconColor, {VoidCallback? onTap}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 0 : 5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: isDark ? Colors.white : const Color(0xFF311B92),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildContactRow(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black87),
        ),
      ],
    );
  }
}
