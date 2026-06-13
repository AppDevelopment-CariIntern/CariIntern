import 'package:flutter/material.dart';
import 'faq_page.dart';
import 'report_problem_page.dart';

class ContactSupportPage extends StatefulWidget {
  final String username;
  const ContactSupportPage({super.key, required this.username});

  @override
  State<ContactSupportPage> createState() => _ContactSupportPageState();
}

class _ContactSupportPageState extends State<ContactSupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.username;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : const Color(0xFF311B92)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Contact Support',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF311B92), 
              fontWeight: FontWeight.bold
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                          'We\'re here to help!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Reach out to us\nif you need any assistance.',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white70 : Colors.black54,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.support_agent_rounded,
                      size: 60,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              Row(
                children: [
                  Icon(Icons.headset_mic_outlined, size: 20, color: theme.colorScheme.primary.withAlpha(150)),
                  const SizedBox(width: 12),
                  Text(
                    'Our Support Channels',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF311B92),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _buildChannelCard(
                    'Email Support',
                    'support@cariintern.com',
                    Icons.email_outlined,
                    isDark ? Colors.indigo.withAlpha(50) : const Color(0xFFE8EAF6),
                    Colors.indigo,
                    badge: '24 hours',
                  ),
                  _buildChannelCard(
                    'Phone Support',
                    '+60 11-1234 5678',
                    Icons.phone_outlined,
                    isDark ? Colors.teal.withAlpha(50) : const Color(0xFFE8F5E9),
                    Colors.teal,
                    subtitle2: 'Mon - Fri, 9:00 AM - 6:00 PM\n(MYT)',
                  ),
                  _buildChannelCard(
                    'Operating Hours',
                    'Monday - Friday\n9:00 AM - 6:00 PM (MYT)',
                    Icons.access_time_rounded,
                    isDark ? Colors.orange.withAlpha(50) : const Color(0xFFFFF3E0),
                    Colors.orange,
                    subtitle2: 'Closed on weekends\n& public holidays',
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withAlpha(isDark ? 0 : 8), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withAlpha(25),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.send_rounded, size: 20, color: theme.colorScheme.primary),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Send us a message',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 16, 
                                  color: isDark ? Colors.white : const Color(0xFF311B92)
                                ),
                              ),
                              const Text(
                                'Fill in the form below and we\'ll get back to you.',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              context,
                              'Your Name',
                              _nameController,
                              Icons.person_outline_rounded,
                              'Enter your name',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInputField(
                              context,
                              'Your Email',
                              _emailController,
                              Icons.email_outlined,
                              'Enter your email',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        context,
                        'Subject',
                        _subjectController,
                        Icons.chat_bubble_outline_rounded,
                        'What is your message about?',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Message',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 13, 
                          color: isDark ? Colors.white : const Color(0xFF311B92)
                        ),
                      ),
                      const SizedBox(height: 8),
                      Stack(
                        children: [
                          TextFormField(
                            controller: _messageController,
                            maxLines: 4,
                            style: TextStyle(color: theme.colorScheme.onSurface),
                            decoration: InputDecoration(
                              hintText: 'Describe your issue or question...',
                              hintStyle: TextStyle(color: theme.colorScheme.onSurface.withAlpha(120), fontSize: 13),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(bottom: 60),
                                child: Icon(Icons.edit_outlined, color: theme.colorScheme.primary.withAlpha(150), size: 20),
                              ),
                              filled: true,
                              fillColor: isDark ? Colors.grey[850] : const Color(0xFFF5F7FA),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _messageController,
                              builder: (context, value, child) {
                                return Text(
                                  '${value.text.length}/500',
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Message sent! We\'ll get back to you soon.'), backgroundColor: Colors.green),
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          icon: const Icon(Icons.send_rounded),
                          label: const Text('Send Message', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              Row(
                children: [
                  Icon(Icons.link_rounded, size: 20, color: theme.colorScheme.primary.withAlpha(150)),
                  const SizedBox(width: 12),
                  Text(
                    'Helpful Links',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF311B92),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildHelpfulLink(
                      context,
                      'FAQ',
                      'View common\nquestions',
                      Icons.help_center_rounded,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FAQPage())),
                    ),
                    const SizedBox(width: 12),
                    _buildHelpfulLink(
                      context,
                      'Report a Problem',
                      'Report bugs or\ntechnical issues',
                      Icons.error_outline_rounded,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportProblemPage())),
                    ),
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

  Widget _buildChannelCard(String title, String subtitle, IconData icon, Color bgColor, Color iconColor, {String? badge, String? subtitle2}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(isDark ? 0 : 5), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title, 
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 13, 
              color: isDark ? Colors.white : const Color(0xFF311B92)
            )
          ),
          Text(
            subtitle, 
            style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.black87), 
            maxLines: 1, 
            overflow: TextOverflow.ellipsis
          ),
          if (subtitle2 != null) Text(subtitle2, style: const TextStyle(fontSize: 10, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
          if (badge != null)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: iconColor.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badge,
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: iconColor),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInputField(BuildContext context, String label, TextEditingController controller, IconData icon, String hint) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 13, 
            color: isDark ? Colors.white : const Color(0xFF311B92)
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: theme.colorScheme.onSurface.withAlpha(120), fontSize: 13),
            prefixIcon: Icon(icon, color: theme.colorScheme.primary.withAlpha(150), size: 20),
            filled: true,
            fillColor: isDark ? Colors.grey[850] : const Color(0xFFF5F7FA),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildHelpfulLink(BuildContext context, String title, String subtitle, IconData icon, {VoidCallback? onTap}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(isDark ? 0 : 5), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: theme.colorScheme.primary, size: 18),
                ),
                const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title, 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 13, 
                color: isDark ? Colors.white : const Color(0xFF311B92)
              )
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
