import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Required for links
import 'package:file_picker/file_picker.dart';
import 'dart:io';

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
  PlatformFile? _pickedFile;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _nameController.text = user.displayName ?? "";
      _emailController.text = user.email ?? "";
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() {
          _pickedFile = result.files.first;
          _cvFileName = _pickedFile!.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  // This function uploads the file and returns the LINK (URL)
  Future<String?> _uploadFileAndGetLink(String userId) async {
    if (_pickedFile == null) return null;

    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${_pickedFile!.name}';
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('applications')
          .child(userId)
          .child(fileName);

      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = storageRef.putData(_pickedFile!.bytes!);
      } else {
        uploadTask = storageRef.putFile(File(_pickedFile!.path!));
      }

      final snapshot = await uploadTask;
      // This is the LINK that goes to Firestore
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint("Upload error: $e");
      return null;
    }
  }

  Future<void> _handleSubmit() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (_formKey.currentState!.validate()) {
      if (_pickedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your Resume/CV file')),
        );
        return;
      }

      setState(() => _isUploading = true);
      
      try {
        // 1. Upload to Storage and get the LINK
        final cvUrlLink = await _uploadFileAndGetLink(user.uid);
        
        if (cvUrlLink == null) {
          throw Exception("Failed to get download link. Make sure Storage is enabled.");
        }

        // 2. Save the LINK to Firestore
        await FirebaseFirestore.instance.collection('applications').add({
          'companyName': widget.companyName,
          'position': widget.position,
          'fullName': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'portfolio': _portfolioController.text.trim(),
          'cvUrl': cvUrlLink, // Storing the link here
          'cvFileName': _pickedFile!.name,
          'status': 'Pending',
          'appliedAt': FieldValue.serverTimestamp(),
          'userId': user.uid,
        });

        if (!mounted) return;
        setState(() => _isUploading = false);
        _showSuccessDialog();
        
      } catch (e) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  void _showSuccessDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Success!'),
        content: const Text('Your application and resume link have been submitted.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply Now'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.primary, theme.colorScheme.primary.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.work_outline, color: Colors.white, size: 30),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.position, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        Text(widget.companyName, style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              _buildTextField(_nameController, 'Full Name', Icons.person_outline),
              const SizedBox(height: 20),
              _buildTextField(_emailController, 'Email', Icons.email_outlined),
              const SizedBox(height: 20),
              _buildTextField(_phoneController, 'Phone Number', Icons.phone_outlined),
              const SizedBox(height: 20),
              _buildTextField(_portfolioController, 'Portfolio Link (Optional)', Icons.link),
              const SizedBox(height: 32),

              // File Selection UI
              const Text('Upload Resume/CV (PDF)', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.description, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(child: Text(_cvFileName, overflow: TextOverflow.ellipsis)),
                    TextButton(
                      onPressed: _pickFile,
                      child: const Text('Select File'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: _isUploading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit Application', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) => (label.contains('Optional') || (value != null && value.isNotEmpty)) ? null : 'Required',
    );
  }
}
