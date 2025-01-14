import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final double? rating;
  final String? location;
  final String? timeAgo;
  final String? reviewerName;
  final String? reviewText;
  final int? likes;
  final bool isLiked;
  final VoidCallback? onLike;
  final VoidCallback? onShare;
  final VoidCallback? onTap;

  // Visibility toggles for all elements
  final bool showImage;
  final bool showTitle;
  final bool showRating;
  final bool showLocation;
  final bool showTimeAgo;
  final bool showReviewerName;
  final bool showReviewText;
  final bool showLikeButton;
  final bool showShareButton;
  final bool showDivider;
  final bool showReplyButton;
  final VoidCallback? onReply;
  final bool isReplied;
  final String? replyTitle;
  final String? replyTimeAgo;
  final String? replyMessage;

  const ReviewCard({
    this.imageUrl,
    this.title,
    this.rating,
    this.location,
    this.timeAgo,
    this.reviewerName,
    this.reviewText,
    this.likes,
    this.isLiked = false,
    this.onLike,
    this.onShare,
    this.onTap,
    this.showImage = false,
    this.showTitle = true,
    this.showRating = true,
    this.showLocation = true,
    this.showTimeAgo = true,
    this.showReviewerName = false,
    this.showReviewText = true,
    this.showLikeButton = false,
    this.showShareButton = false,
    this.showDivider = true,
    this.showReplyButton = false,
    this.onReply,
    this.isReplied = false,
    this.replyTitle,
    this.replyTimeAgo,
    this.replyMessage,

  });

  @override
  Widget build(BuildContext context) {
    final title = this.reviewerName;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        shadowColor: Colors.grey.withOpacity(0.5),
        elevation: 4,
        color: const Color(0xFFF1F3F4),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (showImage && imageUrl != null)
                    CircleAvatar(
                      backgroundColor: const Color(0xFFD9D9D9),
                      radius: 20.0,
                      backgroundImage: NetworkImage(imageUrl!),
                    ),
                  if (showImage && imageUrl != null) const SizedBox(width: 8.0),
                  if ((showTitle && title != null) || (showRating && rating != null))
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showTitle && title != null)
                            Text(
                              title!,
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'SF Pro Display',
                                height: 1.2,
                              ),
                            ),
                          if (showRating && rating != null)
                            Row(
                              children: [
                                Text(
                                  rating!.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    color: Color(0xFF555555),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'SF Pro Display',
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                const Icon(Icons.star, color: Color(0xFF4D4D4D), size: 18.0),
                              ],
                            ),
                        ],
                      ),
                    ),
                  if ((showLocation && location?.isNotEmpty == true) || (showTimeAgo && timeAgo != null))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (showLocation && location?.isNotEmpty == true)
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, color: Color(0xFF4D4D4D), size: 16.0),
                              const SizedBox(width: 4.0),
                              Text(
                                location!,
                                style: const TextStyle(
                                  fontSize: 13.0,
                                  color: Color(0xFF777777),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'SF Pro Display',
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        if (showTimeAgo && timeAgo != null)
                          Text(
                            timeAgo!,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Color(0xFF79747E),
                              fontWeight: FontWeight.w400,
                              fontFamily: 'SF Pro Display',
                              height: 1.4,
                            ),
                          ),
                      ],
                    ),
                ],
              ),
              if (showDivider) const Divider(thickness: 1.2, color: Color(0xFFE9E8E8)),
              if (showReviewerName && reviewerName != null)
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    reviewerName!,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              if (showReviewText && reviewText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    reviewText!,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFF777777),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'SF Pro Display',
                      height: 1.5,
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (showLikeButton && onLike != null)
                    GestureDetector(
                      onTap: onLike,
                      child: Row(
                        children: [
                          Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: const Color(0xFF434242),
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            likes?.toString() ?? '0',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF434242),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (showShareButton && onShare != null)
                    GestureDetector(
                      onTap: onShare,
                      child: const Icon(
                        Icons.share_outlined,
                        color: Color(0xFF434242),
                      ),
                    ),
                ],
              ),
              if (showReplyButton && onReply != null)
                Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextButton(
                    onPressed: onReply,
                    child: const Text(
                      'Reply',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              if (isReplied)
                Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.circular(8.0),
                    border: const Border(
                      left: BorderSide(
                        color: Color(0xFF888888),
                        width: 6.0,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.reply_all_outlined, size: 18.0, color: Colors.grey),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              replyTitle ?? "",
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            replyTimeAgo ?? "",
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        replyMessage ?? "",
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
