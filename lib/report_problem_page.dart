import 'package:flutter/material.dart';
import 'company_service.dart';

class ReportProblemPage extends StatefulWidget {
  const ReportProblemPage({super.key});

  @override
  State<ReportProblemPage> createState() => _ReportProblemPageState();
}

class _ReportProblemPageState extends State<ReportProblemPage> {
  String? _selectedCategory;
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _priority = 'Medium';
  List<String> _allCompanyNames = [];
  bool _showSuggestions = false;

  final List<String> _categories = [
    'Bug / Error',
    'UI / Design Issue',
    'Account / Login Issue',
    'Company Information Issue',
    'Feature Request',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    // Pre-load company names from the service
    _allCompanyNames = CompanyService().companiesData
        .map((c) => c['name'].toString())
        .toList();
    
    _companyController.addListener(() {
      setState(() {
        _showSuggestions = _companyController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _companyController.dispose();
    _descriptionController.dispose();
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
            'Report a Problem',
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
            children: [
              Text(
                'Help us improve CariIntern by reporting any issues you encounter.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.black54),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(isDark ? 0 : 8),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Issue Category', isRequired: true),
                    const SizedBox(height: 8),
                    _buildDropdownField(),
                    const SizedBox(height: 8),
                    const Text('Choose the category that best describes the issue.',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 24),
                    
                    _buildLabel('Company (Optional)'),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        _buildTextField(
                          controller: _companyController,
                          hint: 'Search company...',
                          prefixIcon: Icons.business_outlined,
                          suffixIcon: Icons.search,
                        ),
                        if (_showSuggestions) _buildSuggestionsList(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Select a company if the issue is related to a specific company.',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 24),
                    
                    _buildLabel('Problem Description', isRequired: true),
                    const SizedBox(height: 8),
                    _buildDescriptionField(),
                    const SizedBox(height: 8),
                    const Text('Please provide as much detail as possible so we can understand and resolve the issue faster.',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 24),
                    
                    _buildLabel('Upload Screenshot (Optional)'),
                    const SizedBox(height: 8),
                    _buildUploadBox(),
                    const SizedBox(height: 24),
                    
                    _buildLabel('Priority Level', isRequired: true),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildPriorityCard('Low', 'General issue', Colors.teal)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildPriorityCard('Medium', 'Moderate impact', Colors.orange)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildPriorityCard('High', 'Major impact', Colors.red)),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Report submitted successfully!'), backgroundColor: Colors.green),
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        icon: const Icon(Icons.send_rounded),
                        label: const Text('Submit Report', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline_rounded, size: 14, color: Colors.grey.shade400),
                        const SizedBox(width: 4),
                        Text(
                          'Your report is private and will only be visible to our support team.',
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
      ),
    );
  }

  Widget _buildLabel(String label, {bool isRequired = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Text(
          label, 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 15, 
            color: isDark ? Colors.white : const Color(0xFF311B92)
          )
        ),
        if (isRequired) const Text(' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDropdownField() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          hint: Row(
            children: [
              Icon(Icons.assignment_outlined, color: theme.colorScheme.primary.withAlpha(150), size: 20),
              const SizedBox(width: 12),
              const Text('Select Issue Type', style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
          isExpanded: true,
          items: _categories.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface)),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedCategory = newValue;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData prefixIcon, IconData? suffixIcon}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextField(
      controller: controller,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: theme.colorScheme.onSurface.withAlpha(120), fontSize: 14),
        prefixIcon: Icon(prefixIcon, color: theme.colorScheme.primary.withAlpha(150), size: 20),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.grey, size: 20) : null,
        filled: true,
        fillColor: isDark ? Colors.grey[850] : const Color(0xFFF5F7FA),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildSuggestionsList() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final query = _companyController.text.toLowerCase();
    final matches = _allCompanyNames.where((name) => name.toLowerCase().contains(query)).toList();

    if (matches.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 4),
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(isDark ? 0 : 13), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: matches.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: isDark ? Colors.white12 : Colors.grey.shade100),
        itemBuilder: (context, index) {
          final name = matches[index];
          return ListTile(
            dense: true,
            leading: Icon(Icons.business_rounded, size: 18, color: theme.colorScheme.primary),
            title: Text(name, style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface)),
            onTap: () {
              _companyController.text = name;
              _companyController.selection = TextSelection.fromPosition(TextPosition(offset: name.length));
              setState(() {
                _showSuggestions = false;
              });
              FocusScope.of(context).unfocus();
            },
          );
        },
      ),
    );
  }

  Widget _buildDescriptionField() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        TextField(
          controller: _descriptionController,
          maxLines: 5,
          onChanged: (v) => setState(() {}),
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: 'Describe your issue in detail...',
            hintStyle: TextStyle(color: theme.colorScheme.onSurface.withAlpha(120), fontSize: 14),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Icon(Icons.edit_outlined, color: theme.colorScheme.primary.withAlpha(150), size: 20),
            ),
            filled: true,
            fillColor: isDark ? Colors.grey[850] : const Color(0xFFF5F7FA),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5)),
          ),
        ),
        Positioned(
          bottom: 12,
          right: 12,
          child: Text('${_descriptionController.text.length}/500', style: const TextStyle(fontSize: 11, color: Colors.grey)),
        )
      ],
    );
  }

  Widget _buildUploadBox() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CustomPaint(
        painter: DashedRectPainter(color: isDark ? Colors.white24 : Colors.deepPurple.shade200),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: theme.colorScheme.primary.withAlpha(25), borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.camera_alt_rounded, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 12),
              Text(
                'Add Screenshot', 
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: isDark ? Colors.white : const Color(0xFF311B92)
                )
              ),
              const Text('JPG, PNG up to 5MB', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityCard(String title, String subtitle, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    bool isSelected = _priority == title;

    return GestureDetector(
      onTap: () => setState(() => _priority = title),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? theme.colorScheme.primary : (isDark ? Colors.white12 : Colors.grey.shade200), width: 1.5),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: isSelected ? theme.colorScheme.primary : Colors.grey.shade400, width: 2),
                  ),
                  child: Center(
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: isSelected ? theme.colorScheme.primary : Colors.transparent),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
                const SizedBox(width: 4),
                Text(
                  title, 
                  style: TextStyle(
                    fontSize: 13, 
                    fontWeight: FontWeight.bold, 
                    color: isSelected ? theme.colorScheme.onSurface : Colors.grey.shade600
                  )
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  DashedRectPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5, dashSpace = 3, startX = 0;
    final paint = Paint()..color = color..strokeWidth = 1..style = PaintingStyle.stroke;
    
    // Top
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
    // Bottom
    startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height), Offset(startX + dashWidth, size.height), paint);
      startX += dashWidth + dashSpace;
    }
    // Left
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
    // Right
    startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(size.width, startY), Offset(size.width, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
