import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String time;
  final String message;
  final VoidCallback onViewTap;
  final bool hasRedDot;
  final Color backgroundColor;
  final bool isBusinessProfile; // Flag for business profile
  final VoidCallback? onReplyTap; // Callback for the reply button

  const NotificationCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.time,
    required this.message,
    required this.onViewTap,
    this.hasRedDot = false,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.isBusinessProfile = false,
    this.onReplyTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onViewTap,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            color: hasRedDot ? const Color(0xFFF2F2F2) : backgroundColor,
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: hasRedDot ? const Color(0xFFF2F2F2) : backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 27.0,
                          height: 27.0,
                          child: CircleAvatar(
                            backgroundColor: const Color(0xFFD9D9D9),
                            backgroundImage: NetworkImage(imageUrl),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'SF Pro Display',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF79747E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF828282),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: onViewTap,
                        child: const Text(
                          'View',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Color(0xFFA5A5A5),
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFFA5A5A5),
                            decorationThickness: 2,
                          ),
                        ),
                      ),
                    ),
                    if (isBusinessProfile)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SizedBox(
                          width: 345,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: onReplyTap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              hasRedDot ? Colors.white: Color(0xFFF4F5F6),
                              side: BorderSide(
                                color: hasRedDot
                                    ? Color(0xFFB3B3B3)
                                    : const Color(0xFFB3B3B3),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              hasRedDot ? 'Reply' : 'Replied',
                              style: TextStyle(
                                color: hasRedDot
                                    ? Colors.black
                                    : const Color(0xFFB3B3B3),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (hasRedDot)
            Positioned(
              top: 30,
              left: 8,
              child: Container(
                width: 8.0,
                height: 8.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFD41212),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
