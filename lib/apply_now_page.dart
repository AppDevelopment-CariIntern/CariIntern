import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApplyNowPage extends StatefulWidget {
  final String companyName;
  final String position;

  const ApplyNowPage({
    super.key,
    required this.companyName,
    required this.position,
  });

  @override
  State<ApplyNowPage> createState() => _ApplyNowPageState();
}

class _ApplyNowPageState extends State<ApplyNowPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _portfolioController = TextEditingController();
  
  bool _isUploading = false;
  String _cvFileName = "No file selected";

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _nameController.text = user.displayName ?? "";
      _emailController.text = user.email ?? "";
    }
  }

  Future<void> _handleSubmit() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User session expired. Please log in again.')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() => _isUploading = true);
      
      try {
        // Save application to Firestore
        await FirebaseFirestore.instance.collection('applications').add({
          'companyName': widget.companyName,
          'position': widget.position,
          'fullName': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'portfolio': _portfolioController.text.trim(),
          'status': 'Pending',
          'appliedAt': FieldValue.serverTimestamp(),
          'userId': user.uid,
        });

        if (!mounted) return;
        setState(() => _isUploading = false);
        
        final theme = Theme.of(context);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 28),
                const SizedBox(width: 12),
                Text('Success!', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
              ],
            ),
            content: Text('Your application for ${widget.position} at ${widget.companyName} has been submitted successfully.', 
              style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurface)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to details page
                },
                child: Text('OK', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary, fontSize: 16)),
              ),
            ],
          ),
        );
      } catch (e) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Apply Now',
          style: TextStyle(color: isDark ? Colors.white : const Color(0xFF311B92), fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark 
                        ? [theme.colorScheme.primary, theme.colorScheme.primary.withAlpha(180)]
                        : [Colors.deepPurple, const Color(0xFF7C4DFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withAlpha(isDark ? 50 : 76),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.work_outline, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.position,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            widget.companyName,
                            style: const TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              _buildLabel('Full Name'),
              TextFormField(
                controller: _nameController,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: _inputDecoration('Enter your full name', Icons.person_outline),
                validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 20),
              
              _buildLabel('Email Address'),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: _inputDecoration('Enter your email', Icons.email_outlined),
                validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
              ),
              const SizedBox(height: 20),
              
              _buildLabel('Phone Number'),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: _inputDecoration('Enter your phone number', Icons.phone_outlined),
                validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
              ),
              const SizedBox(height: 20),
              
              _buildLabel('Portfolio/LinkedIn URL (Optional)'),
              TextFormField(
                controller: _portfolioController,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: _inputDecoration('https://linkedin.com/in/yourprofile', Icons.link),
              ),
              const SizedBox(height: 32),
              
              _buildLabel('Upload Resume/CV (PDF)'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? theme.colorScheme.primary.withAlpha(51) : const Color(0xFFF3E5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.description_outlined, color: theme.colorScheme.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        _cvFileName,
                        style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade600, fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() => _cvFileName = "resume_final.pdf");
                      },
                      style: TextButton.styleFrom(foregroundColor: theme.colorScheme.primary),
                      child: const Text('Select File', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 6,
                    shadowColor: theme.colorScheme.primary.withAlpha(102),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: _isUploading 
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Submit Application', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 4),
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF311B92), fontSize: 14),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: theme.colorScheme.onSurface.withAlpha(120), fontSize: 14),
      prefixIcon: Icon(icon, color: theme.colorScheme.primary, size: 22),
      filled: true,
      fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    );
  }
}
