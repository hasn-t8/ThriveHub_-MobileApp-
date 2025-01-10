import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  final String fullName;
  final String email;
  final String profileImagePath;
  final VoidCallback onEditProfile;
  final VoidCallback onEditImage; // Callback for image or icon click
  final bool showInfoBoxes;
  final List<Map<String, String>> infoBoxes;

  const ProfileSection({
    Key? key,
    required this.fullName,
    required this.email,
    required this.profileImagePath,
    required this.onEditProfile,
    required this.onEditImage, // New callback
    this.showInfoBoxes=false,
    required this.infoBoxes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Header
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onEditImage, // Handle image click
              child: Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(profileImagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Color(0xFFD9D9D9),
                        child: Image.asset(
                          'assets/edit_profile.png', // Replace with your image icon
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName.isNotEmpty
                        ? '$fullName'
                        : 'Your Name',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.email, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        email.isNotEmpty ? email : 'gmail@example.com',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: onEditProfile,
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (showInfoBoxes)
        // Info Boxes
        Container(
          width: double.infinity,
          height: 90,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: infoBoxes.map((box) {
              return _buildInfoBox(box['title']!, box['subtitle']!);
            }).toList(),
          ),
        ),
      ],
    );
  }
  Widget _buildInfoBox(String title, String subtitle) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
