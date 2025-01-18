import 'package:flutter/material.dart';

class ProfileSection extends StatefulWidget {
  final String fullName;
  final String email;
  final String profileImagePath;
  final Future<void> Function(String newName) onSaveName; // Callback for saving name
  final VoidCallback onEditImage; // Callback for image click
  final bool showInfoBoxes;
  final List<Map<String, String>> infoBoxes;

  const ProfileSection({
    Key? key,
    required this.fullName,
    required this.email,
    required this.profileImagePath,
    required this.onSaveName,
    required this.onEditImage,
    this.showInfoBoxes = false,
    required this.infoBoxes,
  }) : super(key: key);

  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  bool _isEditingName = false;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.fullName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    final newName = _nameController.text.trim();
    if (newName.isNotEmpty && newName != widget.fullName) {
      await widget.onSaveName(newName);
    }
    setState(() {
      _isEditingName = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: widget.onEditImage,
              child: Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: widget.profileImagePath.startsWith('http')
                            ? NetworkImage(widget.profileImagePath)
                            : AssetImage(widget.profileImagePath) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: widget.onEditImage,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: const Color(0xFFD9D9D9),
                        child: Icon(Icons.edit, size: 16, color: Colors.black),
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
                  _isEditingName
                      ? TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onSubmitted: (_) => _saveName(),
                  )
                      : GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEditingName = true;
                      });
                    },
                    child: Text(
                      widget.fullName.isNotEmpty
                          ? widget.fullName
                          : 'Your Name',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.email, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.email.isNotEmpty ? widget.email : 'example@gmail.com',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_isEditingName)
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: _saveName,
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (widget.showInfoBoxes)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F4),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.infoBoxes.map((box) {
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
