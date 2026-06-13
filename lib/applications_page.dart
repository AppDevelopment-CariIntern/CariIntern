import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({super.key});

  Future<void> _deleteApplication(BuildContext context, String docId) async {
    final theme = Theme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remove Application', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to remove this application? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await FirebaseFirestore.instance.collection('applications').doc(docId).delete();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Application removed successfully'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Text(
            'Please log in to view your applications.',
            style: TextStyle(color: isDark ? Colors.white70 : Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Applications',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF311B92),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('applications')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: theme.colorScheme.error)));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState(context, user.email);
          }

          final docs = snapshot.data!.docs.toList();
          docs.sort((a, b) {
            final aData = a.data() as Map<String, dynamic>;
            final bData = b.data() as Map<String, dynamic>;
            final aTime = aData['appliedAt'] as Timestamp?;
            final bTime = bData['appliedAt'] as Timestamp?;
            
            if (aTime == null && bTime == null) return 0;
            if (aTime == null) return -1;
            if (bTime == null) return 1;
            return bTime.compareTo(aTime);
          });

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final application = doc.data() as Map<String, dynamic>;
              return _buildApplicationCard(context, application, doc.id);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String? email) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined, 
            size: 80, 
            color: theme.colorScheme.primary.withAlpha(isDark ? 50 : 25)
          ),
          const SizedBox(height: 16),
          Text(
            'No applications yet',
            style: TextStyle(
              fontSize: 18, 
              color: isDark ? Colors.white70 : Colors.grey, 
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Logged in as: $email',
            style: TextStyle(color: isDark ? Colors.white54 : Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            'Your applied internships will appear here.',
            style: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(BuildContext context, Map<String, dynamic> app, String docId) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final String company = app['companyName'] ?? 'Unknown Company';
    final String position = app['position'] ?? 'Unknown Position';
    final String status = app['status'] ?? 'Pending';
    final Timestamp? timestamp = app['appliedAt'];
    final String date = timestamp != null 
        ? DateFormat('dd MMM yyyy').format(timestamp.toDate()) 
        : 'Processing...';

    Color statusColor;
    IconData statusIcon;
    
    switch (status.toLowerCase()) {
      case 'accepted':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case 'reviewed':
        statusColor = Colors.blue;
        statusIcon = Icons.visibility;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.access_time_filled;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
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
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.business, color: theme.colorScheme.primary, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position,
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 16, 
                    color: isDark ? Colors.white : const Color(0xFF311B92)
                  ),
                ),
                Text(
                  company,
                  style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  'Applied on $date',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 14, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              IconButton(
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 22),
                onPressed: () => _deleteApplication(context, docId),
                tooltip: 'Remove Application',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
