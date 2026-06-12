import 'package:flutter/material.dart';

class SendFeedbackPage extends StatefulWidget {
  const SendFeedbackPage({super.key});

  @override
  State<SendFeedbackPage> createState() => _SendFeedbackPageState();
}

class _SendFeedbackPageState extends State<SendFeedbackPage> {
  String? _selectedFeedbackType;
  int _selectedRating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _likedController = TextEditingController();
  final TextEditingController _improveController = TextEditingController();
  bool _contactPermission = false;

  final List<String> _feedbackTypes = [
    'App Functionality',
    'User Interface',
    'Company Information',
    'Application Process',
    'Other'
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    _likedController.dispose();
    _improveController.dispose();
    super.dispose();
  }

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
            'Send Feedback',
            style: TextStyle(color: Color(0xFF311B92), fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Text(
                'We value your opinion! Your feedback helps us improve CariIntern.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('What do you want to give feedback about?', isRequired: true),
                    const SizedBox(height: 8),
                    _buildDropdownField(),
                    const SizedBox(height: 8),
                    const Text('Choose the area related to your feedback.',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 24),
                    
                    _buildLabel('Rate your overall experience', isRequired: true),
                    const SizedBox(height: 12),
                    _buildRatingStars(),
                    const SizedBox(height: 24),
                    
                    _buildLabel('Your Feedback', isRequired: true),
                    const SizedBox(height: 8),
                    _buildFeedbackField(),
                    const SizedBox(height: 8),
                    const Text('Share your thoughts, suggestions or ideas to help us improve CariIntern.',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 24),

                    _buildLabel('What did you like? (Optional)'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _likedController,
                      hint: 'Share what you liked most...',
                      prefixIcon: Icons.favorite_border_rounded,
                    ),
                    const SizedBox(height: 24),

                    _buildLabel('What can we improve? (Optional)'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _improveController,
                      hint: 'Share how we can do better...',
                      prefixIcon: Icons.trending_up_rounded,
                    ),
                    const SizedBox(height: 24),

                    _buildLabel('Would you like us to contact you? (Optional)'),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _contactPermission,
                            onChanged: (val) => setState(() => _contactPermission = val ?? false),
                            activeColor: const Color(0xFF311B92),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Yes, you may contact me for more details.', 
                                style: TextStyle(fontSize: 14, color: Colors.black87)),
                              SizedBox(height: 4),
                              Text('If checked, please make sure your email is updated in your profile.',
                                style: TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Feedback submitted! Thank you.'), backgroundColor: Colors.green),
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF311B92),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        icon: const Icon(Icons.send_rounded),
                        label: const Text('Submit Feedback', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline_rounded, size: 14, color: Colors.grey.shade400),
                        const SizedBox(width: 4),
                        Text(
                          'Your feedback is private and will only be used to improve our services.',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 2,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.deepPurple.withValues(alpha: 0.4),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
              icon: CircleAvatar(
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.assignment_outlined, color: Colors.white),
              ),
              label: 'Status',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: 'Saved'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label, {bool isRequired = false}) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF311B92), fontFamily: 'Inter'),
              children: [
                if (isRequired) const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedFeedbackType,
          hint: Row(
            children: [
              Icon(Icons.list_alt_rounded, color: Colors.deepPurple.shade300, size: 20),
              const SizedBox(width: 12),
              const Text('Select Feedback Type', style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
          isExpanded: true,
          items: _feedbackTypes.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: (newValue) => setState(() => _selectedFeedbackType = newValue),
        ),
      ),
    );
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStar(1, 'Very Poor'),
        _buildStar(2, ''),
        _buildStar(3, ''),
        _buildStar(4, ''),
        _buildStar(5, 'Excellent'),
      ],
    );
  }

  Widget _buildStar(int index, String label) {
    bool isSelected = _selectedRating >= index;
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _selectedRating = index),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? Colors.deepPurple : Colors.grey.shade200),
            ),
            child: Icon(
              isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
              color: isSelected ? Colors.amber : Colors.grey.shade400,
              size: 28,
            ),
          ),
        ),
        if (label.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ]
      ],
    );
  }

  Widget _buildFeedbackField() {
    return Stack(
      children: [
        TextField(
          controller: _feedbackController,
          maxLines: 4,
          onChanged: (v) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Tell us what you think...',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Icon(Icons.edit_outlined, color: Colors.deepPurple.shade300, size: 20),
            ),
            filled: true,
            fillColor: const Color(0xFFF5F7FA),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5)),
          ),
        ),
        Positioned(
          bottom: 12,
          right: 12,
          child: Text('${_feedbackController.text.length}/500', style: const TextStyle(fontSize: 11, color: Colors.grey)),
        )
      ],
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData prefixIcon}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: Icon(prefixIcon, color: Colors.deepPurple.shade300, size: 20),
        filled: true,
        fillColor: const Color(0xFFF5F7FA),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}
