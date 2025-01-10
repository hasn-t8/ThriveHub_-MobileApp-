import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thrive_hub/core/helper/time_helper.dart';
import 'package:thrive_hub/core/utils/thank_you.dart';
import 'package:thrive_hub/screens/business/widgets/description_bottom_sheet.dart';
import 'package:thrive_hub/screens/search_screens/filter_screen.dart';
import 'package:thrive_hub/services/company_services/company_services.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/widgets/review_card.dart';
import 'package:thrive_hub/widgets/sort.dart';
import 'package:thrive_hub/widgets/filter_sort_buttons.dart';

class BusinessReviewScreen extends StatefulWidget {
  @override
  _BusinessReviewScreenState createState() => _BusinessReviewScreenState();
}

class _BusinessReviewScreenState extends State<BusinessReviewScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final CompanyService _reviewService = CompanyService();

  String? _description;
  File? _selectedImage;
  bool _isLoading = true;
  List<Map<String, dynamic>> _reviews = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  void _fetchReviews() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      final reviews = await _reviewService.fetchAllReviews();
      setState(() {
        _reviews = reviews.map((e) => Map<String, dynamic>.from(e)).toList();
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Error fetching reviews: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _saveDescription(String description, File? selectedImage) {
    setState(() {
      _description = description;
      _selectedImage = selectedImage;
    });
    ThankYou.show(context);
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return ReusableBottomSheet(
          descriptionController: _descriptionController,
          onSave: _saveDescription,
          initialSelectedImage: _selectedImage,
          onClose: () => Navigator.pop(context),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Reviews',
        showBackButton: false,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 10.0),
          // Always show the filter and sort buttons
          FilterSortButtons(
            onFilter: (context) async {
              return await Navigator.push<List<String>>(
                context,
                MaterialPageRoute(builder: (context) => FilterScreen()),
              ) ??
                  [];
            },
            onSort: (context) async {
              return await showModalBottomSheet<String>(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => const SortBottomSheet(
                  title: 'Sort',
                  sortOptions: ['By Service', 'No answer', 'with answer', 'Newest'],
                ),
              );
            },
            onFiltersUpdated: (updatedFilters) {
              print("Filters updated: $updatedFilters");
            },
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : _reviews.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/no_review.png',
                    width: 254,
                    height: 256,
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                final review = _reviews[index];
                final hasReply = review['reply'] != null;

                return ReviewCard(
                  imageUrl: review['logo_url'] ??
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtuphMb4mq-EcVWhMVT8FCkv5dqZGgvn_QiA&s',
                  title: review['org_name'] ?? 'No Title',
                  rating: (double.tryParse(
                      review?['rating']?.toString() ?? '0.0') ??
                      0.0) /
                      2,
                  location: review['location'] ?? '',
                  timeAgo: calculateTimeAgo(review['created_at']),
                  reviewerName: review['customer_name'] ?? 'Anonymous',
                  reviewText:
                  review['feedback'] ?? 'No review text provided.',
                  likes: review['likes'] ?? 0,
                  isLiked: review['isLiked'] ?? false,
                  showReplyButton: !hasReply,
                  onReply: () {
                    _showBottomSheet(context);
                  },
                  isReplied: hasReply,
                  replyTitle:
                  hasReply ? review['reply']['replyTitle'] : null,
                  replyTimeAgo:
                  hasReply ? review['reply']['replyTimeAgo'] : null,
                  replyMessage:
                  hasReply ? review['reply']['replyMessage'] : null,
                  onTap: () {
                    print('ReviewCard tapped: ${review['title']}');
                  },
                  onLike: () {
                    setState(() {
                      if (review['isLiked']) {
                        review['likes'] -= 1;
                      } else {
                        review['likes'] += 1;
                      }
                      review['isLiked'] = !review['isLiked'];
                    });
                  },
                  onShare: () {
                    Share.share(
                      'Check out this review on Thrive Hub:\\n\\n\"${review['reviewText']}\"\\nRead more at: https://example.com/review/${review['title']}',
                      subject: 'Review of ${review['title']}',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
