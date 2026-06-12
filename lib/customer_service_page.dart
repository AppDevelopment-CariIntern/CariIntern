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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF311B92)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Customer Service',
            style: TextStyle(
              color: Color(0xFF311B92),
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
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF311B92),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'How can we help you today?\nWe\'re here to support you.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Illustration Placeholder
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.headset_mic_rounded,
                      size: 60,
                      color: Colors.deepPurple,
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
                const Color(0xFFE8EAF6),
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
                const Color(0xFFFCE4EC),
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
                const Color(0xFFE1F5FE),
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
                const Color(0xFFE8F5E9),
                Colors.teal,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactSupportPage(username: username)),
                  );
                },
              ),
              
              const SizedBox(height: 24),
              
              // Contact Information and Operating Hours
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
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
                          const Text(
                            'Contact Information',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF311B92),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildContactRow(Icons.email_outlined, 'support@cariintern.com'),
                          const SizedBox(height: 8),
                          _buildContactRow(Icons.phone_outlined, '03-1234 5678'),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 1,
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 18, color: Colors.deepPurple),
                              SizedBox(width: 8),
                              Text(
                                'Operating Hours',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color(0xFF311B92),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
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
              
              // Bottom Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEDE7F6), Color(0xFFF3E5F5)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
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
                              color: Color(0xFF311B92),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Your satisfaction is our priority. Let us know how we can assist you.',
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.support_agent_rounded, size: 50, color: Colors.deepPurple),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Color(0xFF311B92),
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

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.deepPurple),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }
}
